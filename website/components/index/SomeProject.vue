<template>
    <li>
        <a
            class="not a link wrapper"
            :href="href"
            target="_blank"
            rel="noopener noreferrer"
        >
            <div class="image">
                <nuxt-img
                    :src="image.url"
                    :alt="image.alt"
                    width="96px"
                    format="webp"
                    loading="lazy"
                />
            </div>
            <div class="title and text">
                <h3>{{ title }}</h3>
                <slot />
            </div>
        </a>
    </li>
</template>

<script lang="ts">
import Vue, { PropType } from 'vue'

interface ProjectImage {
    url: String
    alt: String
}

export default Vue.extend({
    props: {
        image: {
            type: Object as PropType<ProjectImage>,
            required: true,
        },
        title: {
            type: String,
            required: true,
        },
        href: {
            type: String,
            required: true,
        },
    },
})
</script>

<style lang="scss" scoped>
$TITLE_COLOUR: #ffea75;

li {
    display: flex;
    flex-direction: column;
    width: 50%;

    @media screen and(max-width: 1024px) {
        width: 100%;
    }
}

p {
    text-align: left;
}

h3 {
    display: flex;
    margin: 0;
    color: $TITLE_COLOUR;
    width: 100%;
    text-align: left;
    @media screen and(max-width: 740px) {
        text-align: center;
    }
}

.image {
    display: flex;
    width: 20%;
    min-width: 96px;
    max-height: 96px;

    @media screen and(max-width: 740px) {
        width: 100%;
        justify-content: center;
        margin-bottom: 1rem;
    }
}

.title.and.text {
    display: flex;
    flex-direction: column;
    width: 80%;
    @media screen and(max-width: 740px) {
        width: 100%;
    }
}

a {
    text-decoration: none;
    color: #e1f4ff;
}

.wrapper {
    @include g-generic-card;
    display: flex;
    flex-wrap: wrap;
    margin: 1rem;
    margin-left: 0;
    margin-bottom: 1rem;
    width: calc(100% - 3rem);
    padding: 1rem;
    padding-bottom: 0;
    height: 100%;
    background-color: lighten($G_INDEX_PERSONAL_SKILL_BG2, 10%);
    transition: background-color 1s cubic-bezier(0.19, 1, 0.22, 1);

    &:hover {
        background-color: lighten($G_INDEX_PERSONAL_SKILL_BG2, 20%);
    }
}
</style>