<template>
    <section class="skill">
        <div class="row gfont teko">
            <h2>{{ title }}</h2>
        </div>
        <div v-if="isFullWidth" class="full block">
            <slot name="full-width"></slot>
        </div>
        <div v-if="!isFullWidth" class="block">
            <slot name="left-block" />
        </div>
        <div v-if="!isFullWidth" class="block gfont cairo">
            <slot name="right-block" />
        </div>
    </section>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    props: {
        title: {
            type: String,
            required: true,
        },
        isFullWidth: {
            type: Boolean,
            default: false,
        },
    },
})
</script>

<style lang="scss" scoped>
.skill {
    $BG_1: $G_INDEX_PERSONAL_SKILL_BG1;
    $BG_2: $G_INDEX_PERSONAL_SKILL_BG2;
    $HIGLIGHT_COL: #ffea75;

    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    width: 100%;
    background: $BG_1;
    color: rgb(225, 244, 255);

    &:nth-of-type(2) {
        background: $BG_2;
    }

    .row {
        display: flex;
        flex-direction: row;
        width: 100%;
        margin-bottom: 1rem;
    }

    h2 {
        display: flex;
        margin-top: 0;
        margin: 0 auto;
        padding-top: 1rem;
        font-size: 80px;
        color: $HIGLIGHT_COL;
    }

    .block {
        display: flex;
        flex-direction: column;
        width: 50%;
        height: 60%;
        text-align: center;

        @media screen and(max-width:820px) {
            width: 100%;
        }

        &.full {
            width: 100%;
        }

        p {
            margin: 0;
            margin-bottom: 1rem;

            span.highlight {
                color: $HIGLIGHT_COL;
            }
        }

        &:nth-of-type(2) {
            padding-left: 6%;
        }

        &:last-of-type {
            padding-right: 6%;
        }
    }
}
</style>