<template>
    <div>
        <div class="hero image container">
            <nuxt-img
                id="hero"
                src="/img/hero/code_1.webp"
                sizes="sm:580px"
                alt="Background showing assembly code"
                quality="1"
            />
        </div>
        <section class="hero overlay">
            <div class="fade group">
                <h1>
                    <span class="headerText1 from above">Hi,</span>
                    &nbsp;
                    <span class="headerText2">I'm Bradley</span>
                </h1>
                <nuxt-img
                    id="me"
                    class="image show"
                    src="/img/me/me_and_cooper.webp"
                    alt="Picture of Bradley"
                    sizes="sm:80vw, md:80vw, lg:50vh"
                    quality="60"
                />
            </div>
            <div class="fade group">
                <p>
                    <span class="subText1 from left">
                        I'm an aspiring DevOps engineer with 10 years of programming experience.
                    </span>
                </p>
                <p>
                    <span class="subText2">
                        Interested? Scroll down to read more about me.
                    </span>
                </p>
            </div>
        </section>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    mounted() {
        const headerText1 = document.querySelector('.fade.group .headerText1')!
        const headerText2 = document.querySelector('.fade.group .headerText2')!
        const image = document.querySelector(
            '.fade.group .image'
        )! as HTMLImageElement
        const subText1 = document.querySelector('.fade.group .subText1')!
        const subText2 = document.querySelector('.fade.group .subText2')!
        const group = document.querySelector('.fade.group')! as HTMLDivElement

        setTimeout(() => headerText1.classList.add('show'), 1) // Otherwise, in certain conditions, the animation won't play.
        setTimeout(() => headerText2.classList.add('show'), 1000)
        setTimeout(() => {
            const imageHeight = image.naturalHeight
            image.style.height = '' + (group.clientHeight + imageHeight) + 'px'
            image.classList.add('show')
        }, 2000)
        setTimeout(() => {
            subText1.classList.add('show')
        }, 3000)
        setTimeout(() => {
            subText2.classList.add('show')
        }, 4000)
    },
})
</script>

<style lang="scss" scoped>
.hero.overlay {
    color: white;
    width: 100%;
    height: calc(100vh - #{$HEADER_SIZE});
    display: flex;
    flex-direction: column;
    justify-content: center;

    .fade.group {
        display: flex;
        flex-direction: column;
        align-self: center;
        width: 80%;
        transition: all 1s ease;

        span,
        img#me {
            opacity: 0;
            transition: all 1s ease-in;

            &.from.above:not(.show) {
                transform: translateY(-100px);
            }

            &.from.below:not(.show) {
                transform: translateY(-100px);
            }

            &.from.left:not(.show) {
                transform: translateX(-100px);
            }

            &.show {
                display: flex;
                opacity: 1;
                transform: none;
            }
        }

        img#me {
            transition: all 1.5s ease-in;
        }
    }

    h1 {
        display: flex;
        align-self: center;
        font-size: 50px;

        @media screen and (max-width: 740px) {
            font-size: 32px;
        }
    }

    img#me {
        display: flex;
        align-self: center;
        height: 0;
        max-width: 80vw;
        max-height: 50vh;
        border-radius: 40px;
        transition: height 2s ease-in;

        @media screen and (max-width: 740px) {
            max-height: 30vh;
        }

        @media screen and (max-height: 640px) {
            max-height: 30vh;
        }

        @media screen and (max-height: 400px) and (max-width: 820px) {
            display: none !important;
        }
    }

    p {
        display: flex;
        flex-direction: column;
        text-align: center;
        align-items: center;
        margin-top: 3rem;
        margin-bottom: 0;

        @media screen and (max-height: 460px) {
            margin-top: 0.75rem;
        }
    }
}

.hero.image.container {
    width: 100%;
    height: 100vh;

    // Position behind the header.
    position: absolute;
    top: 0;
    left: 0;
    z-index: -999;

    // We need to make the image go off-screen in order to hide the blurred edges, so
    // we do this to stop a scrollbar from being made.
    overflow: hidden;
    img#hero {
        max-width: 100%;
        max-height: 100%;
        width: 100vw;
        height: 100vh;
        filter: blur(4px) brightness(0.2);

        // This is what hides the blurred edges.
        transform: scale(1.03);
    }
}
</style>