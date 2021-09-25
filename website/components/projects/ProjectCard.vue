<template>
    <div class="project container">
        <a :href="href" class="project card not a link">
            <div class="side text">
                <div class="img container">
                    <nuxt-img
                        :src="image"
                        alt="Terraform logo"
                        width="200px"
                        format="webp"
                        loading="lazy"
                    />
                </div>
                <div class="gfont teko">{{ category }}</div>
            </div>
            <div class="title and body">
                <div class="title gfont cairo">
                    <h2>{{ title }}</h2>
                </div>
                <div class="body">
                    <slot></slot>
                </div>
            </div>
        </a>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    props: {
        image: {
            type: String,
            required: true,
        },
        category: {
            type: String,
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

<style scoped lang="scss">
.project.container {
    width: 60%;
    display: flex;
    margin: 0 auto;
}

.project.card {
    @include g-generic-card;
    display: flex;
    width: 100%;
    min-height: 240px;
    background: #e8f2ef;
    text-decoration: none;
    color: black;
    transition: all 0.25s ease;

    &:hover {
        transform: scale(102%);
    }

    .side.text {
        display: flex;
        flex-direction: column;
        width: 20%;
        min-width: 240px;
        height: 100%;
        font-size: 40px;
        background: #53bd9f;
        border-top-left-radius: 20px;
        border-bottom-left-radius: 20px;
        color: white;

        .img.container {
            display: flex;
            width: 100%;
            height: 80%;
        }

        div {
            display: flex;
            align-self: center;
        }

        img {
            margin: 0 auto;
            width: 230px;
            height: 230px;
        }
    }

    .title.and.body {
        display: flex;
        flex-direction: column;
        width: 100%;
        height: 100%;
        .title {
            display: flex;
            width: 100%;
            height: 20%;
            background: #9dd7c6;
            border-top-right-radius: 20px;

            h2 {
                display: flex;
                height: 100%;
                margin: 0 auto;
                margin-left: 1rem;
                margin-bottom: 15px;
                align-self: center;
                font-size: 30px;
            }
        }
        .body {
            display: flex;
            flex-direction: column;
            width: 100%;
            height: 80%;
            margin: 1rem;

            p {
                margin-top: 1rem;
                margin-right: 2rem;
            }
            p:first-of-type {
                margin-top: 0;
            }
        }
    }

    .highlight {
        color: #7127a4;
    }
}
</style>