<template>
    <section class="row">
        <div class="header">
            <h3>{{ title }}</h3>
        </div>
        <div class="logos">
            <div v-for="logo in langLogos" :key="logo.img" class="logo wrapper">
                <a :href="logo.link" target="_blank" rel="noopener noreferrer">
                    <nuxt-img
                        :src="logo.img"
                        :alt="logo.alt"
                        width="96px"
                        format="webp"
                        loading="lazy"
                    />
                </a>
            </div>
        </div>
    </section>
</template>

<script lang="ts">
import Vue, { PropType } from 'vue'

interface LogoProp {
    img: string
    alt: string
    link: URL
}

export default Vue.extend({
    props: {
        title: {
            type: String,
            required: true,
        },
        langLogos: {
            type: Array as PropType<LogoProp[]>,
            required: true,
        },
    },
})
</script>

<style lang="scss" scoped>
.row {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    padding-right: 10%;
    padding-left: 5%;
}

.header {
    display: flex;
    flex-direction: column;
    width: 100%;

    h3 {
        display: flex;
        justify-content: center;
        margin: 0;
        padding-bottom: 1rem;
        border-bottom: 2px solid white;
    }
}

.logos {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    margin-top: 1.6rem;
    width: 100%;

    .logo.wrapper {
        display: flex;
        flex-direction: row;
        justify-content: center;
        width: 33%;

        &:not(:last-of-type) {
            padding-bottom: 1.6rem;
        }
    }

    img {
        width: 96px;
        height: 96px;
    }
}
</style>