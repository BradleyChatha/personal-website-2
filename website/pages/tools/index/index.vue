<template>
    <div>
        <section class="deck">
            <nuxt-link to="/tools/subnet-calculator" class="app card">
                <div class="image blue gradiant one">
                    <span>192.168.1.0/24</span>
                </div>
                <div class="name">
                    <span class="gfont consolas">Subnet Calc</span>
                </div>
            </nuxt-link>
        </section>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    mounted() {
        this.hookAllCards()
    },
    methods: {
        hookAllCards() {
            const cards = document.querySelectorAll('.app.card')
            cards.forEach((card) => {
                const el = card as HTMLElement
                card.addEventListener('mouseover', (_event: any) => {
                    el.style.transform = `scale(1.1)`
                })
                card.addEventListener('mouseleave', (_event: any) => {
                    el.style.transform = 'scale(1)'
                })
            })
        },
    },
})
</script>

<style lang="scss" scoped>
.deck {
    display: flex;
    padding-top: 2rem;
    width: 80%;
    margin: 0 auto;
    justify-content: space-evenly;
}

.app.card {
    @include g-generic-card;
    display: flex;
    flex-direction: column;
    width: 192px;
    height: 192px;
    border-radius: 30px;
    transition: transform 0.25s;
    text-decoration: none;
    perspective: 40px;

    // Undo global link styling
    color: inherit;
    &:hover {
        color: inherit;
    }

    .image {
        display: flex;
        width: 100%;
        height: 70%;
        border-top-left-radius: 30px;
        border-top-right-radius: 30px;
        span {
            margin: auto auto;
            font-size: 24px;
        }

        &.blue.gradiant.one {
            background: linear-gradient(
                135deg,
                #d0e4f7 0%,
                #73b1e7 24%,
                #0a77d5 50%,
                #539fe1 79%,
                #87bcea 100%
            );
            color: white;
        }
    }

    .name {
        display: flex;
        width: 100%;
        height: 30%;
        border-bottom-left-radius: 30px;
        border-bottom-right-radius: 30px;
        background-color: rgb(248, 248, 248);

        span {
            margin: auto auto;
            font-size: 24px;
        }
    }
}
</style>