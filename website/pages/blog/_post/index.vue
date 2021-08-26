<template>
    <div>
        <div class="grid">
            <aside class="post list">
                <ol>
                    <header>{{ ourSeries.title }}</header>
                    <li v-for="post in ourSeriesPosts" :key="post.title">
                        <nuxt-link :to="postUrl(post)">
                            {{ post.title }}
                        </nuxt-link>
                    </li>
                </ol>
            </aside>
            <section>
                <div class="post wrapper">
                    <div ref="contents" class="post contents">
                        <h1>{{ ourPost.title }}</h1>
                        <div class="metadata">
                            Created {{ ourPost.created.split('T')[0] }} |
                            Updated
                            {{ ourPost.updated.split('T')[0] }}
                        </div>
                        <div class="markdown" v-html="json.html"></div>
                    </div>
                </div>
            </section>
            <aside class="header list">
                <ul ref="headlinks">
                    <header>Sections</header>
                    <li
                        v-for="(header, i) in json.headers"
                        :key="header.text"
                        :class="
                            ['zero', 'one', 'two', 'three', 'four'][
                                header.level
                            ]
                        "
                    >
                        <a :href="'#' + header.slug" :data-hindex="i">{{
                            header.text
                        }}</a>
                    </li>
                </ul>
            </aside>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import hljs from 'highlight.js/lib/core'
import d from 'highlight.js/lib/languages/d'
import { getPostUrl } from '~/lib/links'

hljs.registerLanguage('d', d)

export default Vue.extend({
    async asyncData({ params, $content }) {
        const json = (await $content('blog/' + params.post).fetch()) as any
        const manifest = (await $content('blog/manifest').fetch()) as any

        // Find our post manifest and the series that has us.
        const posts = manifest.posts as {
            uid: string
            title: string
            seoUrl: string | null | undefined
        }[]
        const ourPost = posts.find(
            (p) => !!json.metadata.find((m: string) => m === p.uid)
        )
        const series = manifest.series as { postUids: string[] }[]
        const ourSeries = series.find(
            (s) => !!s.postUids.find((uid) => uid === ourPost?.uid)
        )

        let index = 0
        for (const uid of ourSeries!.postUids) {
            if (uid !== ourPost?.uid) {
                index++
                continue
            }
            break
        }

        // Find all the titles for the series' posts
        const ourSeriesPosts = ourSeries?.postUids.map((uid) => ({
            title: posts.find((p) => p.uid === uid)?.title,
            uid: posts.find((p) => p.uid === uid)?.uid,
        }))

        return { json, ourPost, ourSeries, ourIndex: index, ourSeriesPosts }
    },
    head() {
        return {
            title: (this as any).ourPost.title + ' - Bradley Chatha',
        }
    },
    mounted() {
        hljs.highlightAll()

        const observer = new IntersectionObserver((entries, _) => {
            entries.forEach((e) => {
                if (!e.isIntersecting) return
                const index = (e.target as any).dataset.index as number
                const link = (this.$refs.headlinks as any).querySelector(
                    `a[data-hindex='${index}']`
                ) as HTMLLinkElement
                link.classList.add('bold')
                ;(this.$refs.headlinks as any)
                    .querySelectorAll(`a:not([data-hindex='${index}'])`)
                    .forEach((element: HTMLLinkElement) => {
                        element.classList.remove('bold')
                    })
            })
        })
        const headers = (this.$refs.contents as Element).querySelectorAll(
            'h2,h3'
        )
        let index = 0
        headers.forEach((h) => {
            // The formatter makes some *interesting* decisions sometimes
            // wtf is that semi-colon
            ;(h as any).dataset.index = index++
            observer.observe(h)
        })
    },
    methods: {
        postUrl(post: any) {
            return getPostUrl(post.uid)
        },
    },
})
</script>

<style scoped>
.contents >>> p {
    text-align: left;
    line-height: 2rem;
}

.contents >>> li p {
    text-align: left;
    margin: 0;
}

.contents >>> pre code {
    display: inline-block;
    width: 100%;
    overflow: auto;
}
</style>

<style lang="scss" scoped>
.page-enter-active,
.page-leave-active {
    transition: all 0.5s;
    opacity: 1;
}
.page-enter,
.page-leave-to {
    opacity: 0;
}
.header.list {
    animation: header-list-anim 2s cubic-bezier(0.215, 0.61, 0.355, 1);
}
@keyframes header-list-anim {
    0% {
        opacity: 0;
    }

    100% {
        opacity: 1;
    }
}

h1 {
    text-align: center;
    margin: 0;
    padding-top: 2rem;
    font-size: 42px;
}

.bold {
    font-weight: bold;
}

.metadata {
    text-align: center;
    font-size: 16px;
    padding-top: 0.5rem;
}

.grid {
    display: grid;
    grid-template-columns: 20% 60% 20%;
    padding-top: 2rem;

    @media screen and(max-width: 1500px) {
        grid-template-columns: 80% 10% 10%;
    }

    @media screen and (max-width: 1260px) {
        grid-template-columns: 100%;
    }
}

.post.list {
    @media screen and(max-width: 1500px) {
        display: none;
    }
}

.post.contents {
    max-width: 90%;
    margin: 0 auto;
    background-color: white;
}

.markdown {
    display: flex;
    flex-direction: column;
    padding: 2rem;
}

.list header {
    margin: 0;
    margin-bottom: 1rem;
    font-size: 20px;
    font-weight: bold;
}

.header.list {
    @media screen and (max-width: 1260px) {
        display: none;
    }

    ul {
        list-style: none;
        position: fixed;
        margin: 0;
        padding: 2rem;
        margin-right: 2rem;
        background: rgb(250, 250, 250);
        font-size: 16px;

        li {
            &:not(:last-child) {
                padding-bottom: 1rem;
            }

            &.three {
                margin-left: 1rem;
            }

            &.four {
                margin-left: 2rem;
            }
        }
    }

    a {
        text-decoration: none;
    }
}
.post.list {
    // Some strange reason if I share the ul styling between the two lists, it fucks up sizing massively.
    ol {
        margin: 0;
        margin-left: 3rem;
        padding: 1rem;
        padding-left: 3rem;
        background: rgb(250, 250, 250);
        font-size: 16px;
        li {
            &:not(:last-child) {
                padding-bottom: 1rem;
            }
        }
    }
}
</style>