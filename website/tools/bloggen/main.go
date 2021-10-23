package main

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"path"
	"time"

	"github.com/go-yaml/yaml"
	"github.com/yuin/goldmark"
	mdast "github.com/yuin/goldmark/ast"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer"
	"github.com/yuin/goldmark/text"
	"github.com/yuin/goldmark/util"
)

type OutPost struct {
	Id             string    `json:"uid"`
	Html           string    `json:"html"`
	Title          string    `json:"title"`
	Created        time.Time `json:"created"`
	Updated        time.Time `json:"updated"`
	SeoUrl         string    `json:"seoUrl"`
	SeoTitle       string    `json:"seoTitle"`
	SeoDescription string    `json:"seoDescription"`
}

type OutManifestPost struct {
	Id             string    `json:"uid"`
	Title          string    `json:"title"`
	Created        time.Time `json:"created"`
	Updated        time.Time `json:"updated"`
	SeoUrl         string    `json:"seoUrl"`
	SeoTitle       string    `json:"seoTitle"`
	SeoDescription string    `json:"seoDescription"`
}

type OutManifestSeries struct {
	Description string   `json:"description"`
	Tags        []string `json:"tags"`
	PostIds     []string `json:"postUids"`
	Title       string   `json:"title"`
	Status      string   `json:"status"`
}

type OutManifest struct {
	Posts  []OutManifestPost   `json:"posts"`
	Series []OutManifestSeries `json:"series"`
}

type InPost struct {
	Id             string
	Title          string
	Created        time.Time
	Updated        time.Time
	SeoTitle       string
	SeoUrl         string
	SeoDescription string
	Html           string
}

type InManifestSeries struct {
	Id          string
	Title       string
	Description string
	Tags        []string
	Status      string
	Posts       []string
}

type InManifest struct {
	Dirs   []string
	Series []InManifestSeries
}

type PostMetadata struct {
	Id             string
	DateCreated    time.Time
	DateUpdated    time.Time
	Title          string
	SeoTitle       string
	SeoTag         string
	SeoUrl         string
	SeoDescription string
}

type MetadataInline struct {
	mdast.BaseInline
	Meta PostMetadata
}

type MetadataInlineParser struct {
	parser.InlineParser
}

type NullRenderer struct {
	renderer.NodeRenderer
}

type MdExtender struct {
	goldmark.Extender
}

var KindMetadata = mdast.NewNodeKind("Metadata")

func main() {
	generate()
}

func generate() {
	os.RemoveAll("../../content/blog")
	os.Mkdir("../../content/blog", 0777)

	var outManifest OutManifest

	inManifest := readInManifest()
	inPosts := readInPosts(inManifest)

	for _, post := range inPosts {
		writeOutPost(OutPost{
			Id:             post.Id,
			Html:           post.Html,
			Title:          post.Title,
			Created:        post.Created,
			Updated:        post.Updated,
			SeoUrl:         post.SeoUrl,
			SeoTitle:       post.SeoTitle,
			SeoDescription: post.SeoDescription,
		})
		outManifest.Posts = append(outManifest.Posts, OutManifestPost{
			Id:             post.Id,
			Title:          post.Title,
			Created:        post.Created,
			Updated:        post.Updated,
			SeoUrl:         post.SeoUrl,
			SeoTitle:       post.SeoTitle,
			SeoDescription: post.SeoDescription,
		})
	}

	for _, series := range inManifest.Series {
		outManifest.Series = append(outManifest.Series, OutManifestSeries{
			Description: series.Description,
			Tags:        series.Tags,
			PostIds:     series.Posts,
			Title:       series.Title,
			Status:      series.Status,
		})
	}

	writeOutManifest(outManifest)
}

func writeOutManifest(manifest OutManifest) {
	log.Printf("Emitting Manifest")

	outPath := path.Join("../../content/blog/", "manifest.json")
	outJson, err := json.Marshal(manifest)
	if err != nil {
		log.Fatal(err)
	}

	err = os.WriteFile(outPath, outJson, 0777)
	if err != nil {
		log.Fatal(err)
	}
}

func writeOutPost(post OutPost) {
	log.Printf("Emitting %s", post.Id)

	outPath := path.Join("../../content/blog/", post.Id+".json")
	outJson, err := json.Marshal(post)
	if err != nil {
		log.Fatal(err)
	}

	err = os.WriteFile(outPath, outJson, 0777)
	if err != nil {
		log.Fatal(err)
	}
}

func readInPosts(inManifest InManifest) []InPost {
	posts := make([]InPost, 0, 10)
	for _, dir := range inManifest.Dirs {
		log.Printf("Handling directory %s", dir)
		files, err := ioutil.ReadDir(path.Join("../../assets/blog/", dir))
		if err != nil {
			log.Fatal(err)
		}

		for _, file := range files {
			posts = append(posts, handlePostFile(path.Join("../../assets/blog/", dir, file.Name())))
		}
	}

	return posts
}

func handlePostFile(file string) InPost {
	var post InPost
	log.Printf("Handling file %s", file)

	md := goldmark.New(
		goldmark.WithExtensions(
			extension.Linkify,
			extension.Strikethrough,
			MdExtender{},
		),
		goldmark.WithParserOptions(
			parser.WithAutoHeadingID(),
		),
	)

	fileBytes, err := os.ReadFile(file)
	if err != nil {
		log.Fatal(err)
	}

	var buf bytes.Buffer
	err = md.Convert(fileBytes, &buf)
	if err != nil {
		log.Fatal(err)
	}

	root := md.Parser().Parse(text.NewReader(fileBytes))
	mdNode := root.FirstChild().FirstChild()
	if mdNode.Kind() == KindMetadata {
		meta, ok := mdNode.(*MetadataInline)
		if !ok {
			log.Fatal("Failed cast")
		}
		post.Created = meta.Meta.DateCreated
		post.Id = meta.Meta.Id
		post.SeoUrl = meta.Meta.SeoUrl
		post.SeoTitle = meta.Meta.SeoTitle
		post.Title = meta.Meta.Title
		post.Updated = meta.Meta.DateUpdated
		post.SeoDescription = meta.Meta.SeoDescription
	} else {
		log.Print("Warning: Document has no metadata.")
	}

	post.Html = buf.String()

	return post
}

func readInManifest() InManifest {
	var manifest InManifest
	bytes, err := os.ReadFile("../../assets/blog/manifest.yml")
	if err != nil {
		log.Fatal(err)
	}
	err = yaml.Unmarshal(bytes, &manifest)
	if err != nil {
		log.Fatal(err)
	}
	return manifest
}

func (ext MdExtender) Extend(m goldmark.Markdown) {
	m.Parser().AddOptions(
		parser.WithInlineParsers(util.Prioritized(&MetadataInlineParser{}, 999)),
	)
	m.Renderer().AddOptions(
		renderer.WithNodeRenderers(util.Prioritized(&NullRenderer{}, 999)),
	)
}

func (p MetadataInlineParser) Trigger() []byte {
	return []byte{'@'}
}

func (p MetadataInlineParser) Parse(parent mdast.Node, block text.Reader, pc parser.Context) mdast.Node {
	line, _ := block.PeekLine()
	if !bytes.HasPrefix(line, []byte{'@', '@', '@'}) {
		return nil
	}
	block.AdvanceLine()

	var yamlBytes []byte
	for {
		l, _ := block.PeekLine()
		block.AdvanceLine()
		if bytes.HasPrefix(l, []byte{'@', '@', '@'}) {
			break
		}
		yamlBytes = append(yamlBytes, l...)
	}

	md := new(MetadataInline)
	err := yaml.Unmarshal(yamlBytes, &md.Meta)
	if err != nil {
		log.Fatal(err)
	}

	return md
}

func (p *MetadataInline) Kind() mdast.NodeKind {
	return KindMetadata
}

func (p *MetadataInline) Dump([]byte, int) {
}

func (p *MetadataInline) IsRaw() bool {
	return true
}

func (r *NullRenderer) RegisterFuncs(reg renderer.NodeRendererFuncRegisterer) {
	reg.Register(KindMetadata, nil)
}
