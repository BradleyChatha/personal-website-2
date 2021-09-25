<template>
    <div>
        <TheHeader key="the-header" :header-style="headerStyle" />
        <Nuxt />
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import TheHeader, { HeaderStyle } from '~/components/layout/TheHeader.vue'
export default Vue.extend({
    components: { TheHeader },
    data() {
        return {
            headerStyle: HeaderStyle.DEFAULT,
        }
    },
    watch: {
        $route() {
            this.updateStyleFromRoute()
        },
    },
    mounted() {
        this.updateStyleFromRoute()
    },
    methods: {
        updateStyleFromRoute() {
            if (
                this.$route.path.startsWith('/blog') ||
                this.$route.path.startsWith('/tools') ||
                this.$route.path.startsWith('/projects')
            ) {
                document.body.classList.add('gray')
                this.headerStyle = HeaderStyle.BLOG
            } else if (this.$route.path === '/')
                this.headerStyle = HeaderStyle.HERO
            else this.headerStyle = HeaderStyle.DEFAULT
        },
    },
})
</script>

<style lang="scss">
body.gray {
    background: whitesmoke;
}
</style>