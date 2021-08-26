import { getPostUrl } from '../lib/links'

export async function extendSitemap() {
    const routes = []

    const { $content } = require('@nuxt/content')
    const posts = (await $content('blog/manifest').fetch()).posts
    for (const post of posts) {
        routes.push(getPostUrl(post.uid))
    }

    return routes
}
