module app;
import std, markusdownus, sdlite, jcli, mir.ion.ser.json, dateparser;

alias Markdown = MarkdownAst!(
    MarkdownAstGroup!(MARKDOWN_DEFAULT_CONTAINER_PARSERS),
    MarkdownAstGroup!(MARKDOWN_DEFAULT_LEAF_PARSERS, MetadataParser),
    MarkdownAstGroup!(MARKDOWN_DEFAULT_INLINE_PARSERS),
);

alias Renderer = MarkdownRenderer!(Markdown,
    MarkdownAstGroup!(MARKDOWN_DEFAULT_CONTAINER_HTML_RENDERERS),
    MarkdownAstGroup!(MARKDOWN_DEFAULT_LEAF_HTML_RENDERERS, MetadataRenderer),
    MarkdownAstGroup!(MARKDOWN_DEFAULT_INLINE_HTML_RENDERERS),
);

struct Metadata
{
    SDLNode[] tags;
}

@MarkdownLeafParser('@', 20, false)
struct MetadataParser
{
    alias Targets = Metadata;

    static MarkdownBlockPassResult tryParse(AstT)(ref AstT.Context ctx)
    {
        if(!ctx.chars.atStartOfLine)
            return MarkdownBlockPassResult.didNothing;
        ctx.chars.advance(1);

        string sdl;
        const found = ctx.chars.eatUntil('@', sdl);
        if(!found)
            return MarkdownBlockPassResult.didNothing;
        ctx.chars.advance(1);

        SDLNode[] result;
		parseSDLDocument!((n) { result ~= n; })(sdl, "blog");
        ctx.push(Metadata(result), 20);
        return MarkdownBlockPassResult.foundLeaf;
    }
}

struct MetadataRenderer
{
    alias Target = Metadata;
    alias States = Metadata;
    
    static void begin(Renderer)(Target target, ref Appender!(char[]) output, ref Renderer rnd)
    {
        scope state = &rnd.getState!Metadata();
        state.tags ~= target.tags;
    }

    static void end(Renderer)(Target target, ref Appender!(char[]) output, ref Renderer rnd)
    {
    }
}

int main(string[] args)
{
    return new CommandLineInterface!app().parseAndExecute(args);
}

Result!void fileExists(string file)
{
    return Result!void.failureIf(!file.exists, "File does not exist: "~file);
}

struct OutputDocument
{
    static struct Header
    {
        string text;
        string slug;
        int level;
    }

    string html;
    string[string] metadata;
    Header[] headers;
}

struct Manifest
{
    static struct Post
    {
        string filepath;
        string uid;
        string title;
        string seoTag;
        string seoUrl;
        SysTime created;
        SysTime updated;
    }

    static struct Series
    {
        string uid;
        string title;
        string description;
        string status;
        string[] tags;
        string[] postUids;
        int order;
    }

    Post[] posts;
    Series[] series;
}

@CommandDefault
struct DefaultCommand
{
    @CommandPositionalArg(0, "input")
    @PostValidate!fileExists
    string markdown;

    @CommandPositionalArg(1, "outdir")
    string outdir;

    void onExecute()
    {
        const doc = parseOutputDocument(readText(this.markdown));
        
        writeln(doc.metadata);
        const outDir = buildPath(this.outdir, doc.metadata["uid"]~".json");
        writeln("Compiling ", this.markdown, " into ", outDir);
        std.file.write(outDir, serializeJson(doc));
    }
}

@Command("build manifest")
struct BuildManifestCommand
{
    @CommandPositionalArg(0)
    @PostValidate!fileExists
    string manifest;

    @CommandPositionalArg(1)
    string outfile;

    void onExecute()
    {
        SDLNode[] result;
		parseSDLDocument!((n) { result ~= n; })(readText(this.manifest), "manifest");
        
        auto posts  = result.filter!(n => n.name == "posts").front;
        auto series = result.filter!(n => n.name == "series");

        Manifest manifest;
        const manifestDir = dirName(this.manifest);

        foreach(node; posts.children)
        {
            if(node.name == "dir")
            {
                const path = buildNormalizedPath(manifestDir, node.values[0].textValue);
                foreach(file; dirEntries(path, "*.md", SpanMode.breadth))
                {
                    Manifest.Post post;
                    const filePath = buildPath(path, file);
                    writeln("Found post: ", filePath);

                    const doc = parseOutputDocument(readText(filePath));

                    post.filepath   = filePath;
                    post.seoTag     = doc.metadata.get("seo-tag", "NO SEO TAG");
                    post.seoUrl     = doc.metadata.get("seo-url", null);
                    post.title      = doc.metadata.get("title", "NO TITLE");
                    post.uid        = doc.metadata.get("uid", "NO UID");
                    post.created    = doc.metadata.get("date-created", "01/01/2000").parse(No.ignoreTimezone, null, Yes.dayFirst);
                    post.updated    = doc.metadata.get("date-updated", "01/01/2000").parse(No.ignoreTimezone, null, Yes.dayFirst);

                    manifest.posts ~= post;
                }
            }
        }

        foreach(i, s; series.enumerate)
        {
            Manifest.Series newSeries;
            newSeries.uid = s.values[0].textValue;
            newSeries.order = cast(int)i;

            foreach(child; s.children)
            {
                switch(child.name)
                {
                    case "title":       newSeries.title = child.values[0].textValue; break;
                    case "description": newSeries.description = child.values[0].textValue; break;
                    case "status":      newSeries.status = child.values[0].textValue; break;
                    case "tags": 
                        foreach(value; child.values)
                            newSeries.tags ~= value.textValue; 
                        break;
                    case "posts": 
                        foreach(value; child.values)
                            newSeries.postUids ~= value.textValue; 
                        break;
                    case "order": newSeries.order = child.values[0].intValue; break;

                    default: break;
                }
            }
            
            writeln("Found series: ", newSeries.uid);
            manifest.series ~= newSeries;
        }

        std.file.write(this.outfile, serializeJson(manifest));
    }
}

@Command("watch")
struct WatchCommand
{
    @CommandPositionalArg(0, "watchdir")
    string watchdir;

    @CommandPositionalArg(1, "outdir")
    string outdir;

    ICommandLineInterface cli;

    this(ICommandLineInterface cli)
    {
        this.cli = cli;
    }

    void onExecute()
    {
        this.watchdir = this.watchdir.absolutePath.buildNormalizedPath();
        this.outdir = this.outdir.absolutePath.buildNormalizedPath();

        assert(cli !is null);
        version(Windows)
        {
            import core.sys.windows.windows;

            auto dir = CreateFileA(
                this.watchdir.toStringz,
                FILE_LIST_DIRECTORY,
                FILE_SHARE_DELETE | FILE_SHARE_READ | FILE_SHARE_WRITE,
                null,
                OPEN_EXISTING,
                FILE_FLAG_BACKUP_SEMANTICS,
                null
            );
            if(dir is INVALID_HANDLE_VALUE)
                throw new Exception("CreateFileA failed with error code: "~GetLastError().to!string);

            ubyte[1024] changeInfo;
            uint bytesWritten;

            while(true)
            {
                const result = ReadDirectoryChangesW(
                    dir,
                    &changeInfo,
                    changeInfo.length,
                    true,
                    FILE_NOTIFY_CHANGE_LAST_WRITE,
                    &bytesWritten,
                    null,
                    null
                );
                if(!result)
                    throw new Exception("ReadDirectoryChangesW failed with error code: "~GetLastError().to!string);

                auto info = cast(FILE_NOTIFY_INFORMATION*)(changeInfo.ptr);
                if(info.Action != FILE_ACTION_MODIFIED)
                    continue;
                const name = info.FileName[0..info.FileNameLength].toUTF8;
                writeln("Recompiling: ", name, " ", info.FileNameLength, " ", bytesWritten);

                if(name.canFind(".md"))
                {
                    this.cli.parseAndExecute([
                        this.watchdir.buildPath(name),
                        this.outdir
                    ], IgnoreFirstArg.no);
                }
                else if(name.canFind("manifest.sdl"))
                {
                    this.cli.parseAndExecute([
                        "build", "manifest",
                        this.watchdir.buildPath(name),
                        this.outdir.buildPath(name.setExtension(".json"))
                    ], IgnoreFirstArg.no);
                }

                changeInfo[] = 0;
            }
        }
        else throw new Exception("This command is windows only.");
    }
}

OutputDocument parseOutputDocument(string text)
{
    import std.ascii : asciiLower = toLower, asciiAlpha = isAlphaNum;

    Markdown.Context context;
    Renderer renderer;
    const html = render!(Markdown, Renderer)(text, context, renderer);

    OutputDocument doc;
    doc.html = html;

    // For now everything needs to be: NAME "VALUE".
    const state = renderer.getState!Metadata;
    foreach(tag; state.tags)
        doc.metadata[tag.name] = tag.values[0].textValue;

    // We also want to know what all the headers are.
    foreach(child; context.root.children)
    {
        if(child.isLeaf)
        {
            auto leaf = child.getLeaf();
            if(leaf.isMarkdownHeaderLeaf)
            {
                auto header = leaf.getMarkdownHeaderLeaf;
                doc.headers ~= OutputDocument.Header(
                    header.text, 
                    header.text.map!(ch => ch.asciiAlpha ? ch.asciiLower : '-').fold!((a, b) => a ~ cast(char)b)(""),
                    header.level,
                );
            }
        }
    }

    // doc.html = doc.html.substitute!(
    //     "<a ", "<nuxt-link ",
    //     "</a>", "</nuxt-link>"
    // ).array.idup.toUTF8;

    return doc;
}