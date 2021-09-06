<template>
    <nav id="header" :class="headerClass">
        <section id="wrapper">
            <div id="name" class="gfont teko">{{ logoText }}</div>
            <div id="links" class="gfont cairo">
                <nuxt-link to="/">Home</nuxt-link>
                <nuxt-link to="/blog">Blog</nuxt-link>
                <nuxt-link to="/projects">Projects</nuxt-link>
                <nuxt-link to="/tools">Tools</nuxt-link>
            </div>
        </section>
    </nav>
</template>

<script lang="ts">
import Vue from 'vue'
import { hasToken } from '~/lib/sudo'

export enum HeaderStyle {
    HERO,
    BLOG,
    DEFAULT,
}

export default Vue.extend({
    props: {
        headerStyle: {
            type: Number as () => HeaderStyle,
            default: HeaderStyle.DEFAULT,
        },
    },
    data() {
        return {
            logoText: 'CHATHA'
        }
    },
    computed: {
        headerClass() {
            return HeaderStyle[this.headerStyle as HeaderStyle]
        },
    },
    mounted() {
        if(hasToken())
            (this as any).logoText = 'SUDO';
    }
})
</script>

<style lang="scss" scoped>
@import '~/assets/scss/vars/header.scss';
$MOBILE_BREAKPOINT: 480px;

// Common
nav#header {
    width: 100%;
    display: flex;
    flex-direction: row;
    background-color: rgba(0, 0, 0, 0);
    transition: background-color 1s cubic-bezier(0.39, 0.575, 0.565, 1);

    div#name {
        display: flex;
        flex-direction: row;
        font-size: 52px;
        margin-top: auto;

        @media screen and(max-width:$MOBILE_BREAKPOINT) {
            margin-left: auto;
            margin-right: auto;
        }
    }

    div#links {
        display: flex;
        flex-direction: row;
        justify-content: center;

        @media screen and(max-width:$MOBILE_BREAKPOINT) {
            width: 100%;
        }

        a {
            margin-right: 0;
            padding-right: 1rem;
            padding-left: 1rem;
            display: flex;
            align-self: center;
            font-size: 21px;

            text-decoration: none;
            color: hsl(210, 38%, 61%);
            transition: color 0.2s ease;

            &.nuxt-link-exact-active {
                color: hsl(
                    194,
                    36%,
                    70%
                ) !important; // For some reason these are *less* specific
            }

            &:hover {
                color: hsl(0, 0%, 83%) !important;
            }
        }
    }

    section#wrapper {
        width: 96%;
        height: 100%;
        display: flex;
        margin: 0 auto;
        justify-content: space-between;

        @media screen and(max-width:$MOBILE_BREAKPOINT) {
            flex-wrap: wrap;
        }
    }
}

// HERO
nav#header.HERO {
    color: white;
    $LINK_BACKGROUND_COLOUR: rgba(57, 67, 119, 0.603);

    div#links {
        a {
            background-size: 0 100%;
            background-position: 0 0;
            background-repeat: no-repeat;
            background-image: linear-gradient(
                $LINK_BACKGROUND_COLOUR,
                $LINK_BACKGROUND_COLOUR
            );
            transition: 0.5s background-size cubic-bezier(0.165, 0.84, 0.44, 1);

            &:hover {
                background-size: 100% 100%;
            }
        }
    }
}

// BLOG
nav#header.BLOG {
    color: white;
    background-color: #004e83;

    div#links {
        a {
            color: #c7d6e3;

            &:hover {
                color: #eee !important;
            }
        }
    }
}
</style>