<template>
    <div>
        <div class="header gutter"></div>
        <section
            v-for="series in manifest.series"
            :key="series.uid"
            class="series"
        >
            <h2>{{ series.title }}</h2>
            <div class="metadata">
                <div class="meta">
                    <div class="data wrapper">
                        Created {{ dateCreated(series) }} | Updated
                        {{ dateUpdated(series) }}
                    </div>
                </div>
                <div class="meta">
                    <div class="data wrapper right align">
                        <font-awesome-icon
                            class="icon tags"
                            :icon="fa.faTags"
                        ></font-awesome-icon>
                        {{ tagsConcat(series) }}
                    </div>
                </div>
            </div>
            <div class="description">
                {{ series.description }}
            </div>
            <ol>
                <li v-for="post in getPosts(series)" :key="post.uid">
                    <nuxt-link :to="postUrl(post)">{{ post.title }}</nuxt-link>
                </li>
            </ol>
        </section>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faTags } from '@fortawesome/free-solid-svg-icons'
import { getPostUrl } from '~/lib/links'

interface Series {
    description: string
    tags: string[]
    postUids: string[]
}

interface Post {
    uid: string
    title: string
    created: string
    updated: string
    seoUrl: string | null | undefined
    seoTitle: string | null | undefined
}

interface Manifest {
    posts: Post[]
    series: Series[]
}

export default Vue.extend({
    components: {
        FontAwesomeIcon,
    },
    layout: 'blog',
    async asyncData({ $content }) {
        const manifest = await $content('blog/manifest').fetch()
        return { manifest }
    },
    data() {
        return {
            fa: {
                faTags,
            },
        }
    },
    head: {
        title: 'Blog Series List - Bradley Chatha',
    },
    methods: {
        tagsConcat(series: Series) {
            return series.tags.reduce((a, b) => a + ', ' + b)
        },

        getPosts(series: Series) {
            return ((this as any).manifest as Manifest).posts.filter((p) =>
                series.postUids.find((u) => u === p.uid)
            )
        },

        dateCreated(series: Series) {
            const posts = this.getPosts(series)
            const byCreated = posts.sort((a, b) =>
                a.created < b.created ? -1 : a.created > b.created ? 1 : 0
            )
            return byCreated.length
                ? byCreated[0].created.split('T')[0]
                : 'null'
        },

        postUrl(post: Post) {
            return post.seoUrl && post.seoUrl || getPostUrl(post.uid)
        },

        dateUpdated(series: Series) {
            const posts = this.getPosts(series)
            const byUpdated = posts.sort((a, b) =>
                a.updated < b.updated ? -1 : a.updated > b.updated ? 1 : 0
            )
            return byUpdated.length
                ? byUpdated[byUpdated.length - 1].updated.split('T')[0]
                : 'null'
        },
    },
})
</script>

<style lang="scss" scoped>
.page-enter-active,
.page-leave-active {
    transition: all 0.5s;
    opacity: 1;
    transform: translateY(0);
}
.page-enter,
.page-leave-to {
    opacity: 0;
    transform: translateY(200px);
}
.header.gutter {
    padding-top: 2rem;
}

.series {
    @include g-generic-card;
    display: flex;
    flex-direction: column;
    margin: 0 auto;
    width: 860px;
    min-height: 4rem;
    background-color: white;

    @media screen and(max-width: 920px) {
        width: 80%;
    }

    &:not(:last-child) {
        margin-bottom: 2rem;
    }

    h2 {
        display: flex;
        flex-direction: row;
        align-self: center;
        padding-left: 1rem;
        padding-right: 1rem;
        margin-bottom: 1rem;
    }

    .metadata {
        display: flex;
        flex-direction: row;
        padding-bottom: 1rem;
        width: 100%;

        .meta {
            width: 50%;
        }
    }

    .data.wrapper {
        width: 100%;
        padding-left: 1.5rem;
        font-size: 16px;
        color: #555;

        &.right.align {
            text-align: right;
            padding-right: 1.5rem;
        }
    }

    .description {
        padding-left: 1.5rem;
        padding-right: 1.5rem;
        padding-bottom: 1.5rem;
    }

    ol {
        margin-top: 0;

        li:not(:last-child) {
            margin-bottom: 0.5rem;
        }
    }
}
</style>