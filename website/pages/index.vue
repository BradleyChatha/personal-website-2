<template>
    <div>
        <TheHero />
        <PersonalSkill title="Versatile">
            <template #left-block>
                <LanguageList
                    title="Web Dev - Front &amp; Backend"
                    class="wait until visible then twirly scale"
                    :lang-logos="webLogos"
                />
                <LanguageList
                    title="Applications, Scripting, &amp; Tooling"
                    class="wait until visible then twirly scale"
                    :lang-logos="appLogos"
                />
                <LanguageList
                    title="Other"
                    class="wait until visible then twirly scale"
                    :lang-logos="otherLogos"
                />
            </template>
            <template #right-block>
                <div class="first text block">
                    <p>
                        I am
                        <span class="highlight">
                            proficient in several programming languages
                        </span>
                        spanning across most of the major software domains.
                    </p>
                    <p>
                        I'm mostly <span class="highlight">self-taught</span>,
                        <span class="highlight">self-motivated</span>, and have
                        a keen interest in all things technical.
                    </p>
                    <p>
                        I'm a <span class="highlight">quick learner</span> who,
                        given a new language or concept, should be able to get
                        up to speed in a very short amount of time.
                    </p>
                    <p>
                        From
                        <span class="highlight">full stack web development</span
                        >, <span class="highlight">desktop applications</span>,
                        <span class="highlight">tooling</span>, and
                        <span class="highlight">scripting</span>, I am fully
                        capable of undertaking most tasks assigned to me.
                    </p>
                    <p>
                        Another highlight of my
                        <span class="highlight">multifaceated skillset</span>
                        includes being a
                        <span class="highlight"
                            >certified AWS SysOps Associate (not yet, but future proofing my text!).</span
                        >
                    </p>
                    <p>
                        I have experience
                        <span class="highlight">architecting</span>,
                        <span class="highlight">maintaining</span>, and evolving
                        <span class="highlight">Postgresql</span> databases -
                        with and without an ORM.
                    </p>
                    <p>
                        I have experience with
                        <span class="highlight">setting up Github Actions and Drone IO</span>
                        with a pipeline to
                        <span class="highlight">automatically deploy</span> new
                        builds. I use
                        <span class="highlight">Terraform and Ansible</span> to maintain all
                        of my infrastructure whilst using
                        <span class="highlight">Grafana</span>
                        to help me monitor the health, performance, and other
                        statistics of my projects.
                    </p>
                    <p>
                        I have experience with using
                        <span class="highlight">Digital Ocean</span> and
                        <span class="highlight">Amazon Web Services</span> as
                        cloud platforms for my various projects.
                    </p>
                </div>
            </template>
        </PersonalSkill>
        <PersonalSkill :is-full-width="true" title="Passionate">
            <template #full-width
                ><div>
                    <ul class="project list">
                        <SomeProject
                            :image="{
                                url: '/img/logos/jcli.png',
                                alt: 'jcli logo',
                            }"
                            title="JCLI - A Command Line Interface library for D"
                            href="https://github.com/BradleyChatha/jcli"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    JCLI is a high-level fully featured CLI
                                    library for the D programming language.
                                </p>
                                <p>
                                    It heavily relies on D's extensive
                                    metaprogramming prowess, while also
                                    providing efficient, reusable components in
                                    case the core library is too heavy-weight.
                                </p>
                            </div>
                        </SomeProject>
                        <SomeProject
                            :image="{
                                url: '/img/logos/html.webp',
                                alt: 'HTML logo',
                            }"
                            title="This website"
                            href="/"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    Once written with ASP Core and deployed by a
                                    custom deployment tool, is now written with
                                    Nuxt and is using standard deployment and
                                    infrastructure tooling.
                                </p>
                                <p>
                                    The website is fully responsive using custom
                                    SCSS and TS code, running on top of Nuxt.
                                </p>
                            </div>
                        </SomeProject>
                        <SomeProject
                            :image="{
                                url: '/img/logos/dlang.png',
                                alt: 'D logo',
                            }"
                            title="D Compiler (DMD) &amp; Standard Library (Phobos)"
                            href="https://github.com/dlang/dmd/pull/12526"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    I've made several contributions to the D
                                    programming language, including adding
                                    features into the compiler and standard
                                    library.
                                </p>
                                <p>
                                    For example, I added the
                                    <code>-verror-format-level</code> flag into
                                    DMD which allows for several different
                                    levels of error formatting, and the
                                    <code>isCopyable</code> trait into Phobos.
                                </p>
                            </div>
                        </SomeProject>
                        <SomeProject
                            :image="{
                                url: '/img/logos/csharp.webp',
                                alt: 'CSharp logo',
                            }"
                            title="SdlangSharp - A SIMD-Accelerated .sdl parser for C#"
                            href="https://github.com/BradleyChatha/SdlangSharp"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    SdlangSharp is a high-performance library
                                    that provides low-level token-by-token
                                    parsing backed by AVX2 instructions;
                                    medium-level push-parsing for when
                                    performance matters, and a high-level AST
                                    for when comfort and convenience is
                                    preferred.
                                </p>
                                <p>There's also a port into TypeScript.</p>
                            </div>
                        </SomeProject>
                        <SomeProject
                            :image="{
                                url: '/img/logos/dlang.png',
                                alt: 'D logo',
                            }"
                            title="bcstd - A standard library for D's -betterC subset"
                            href="https://github.com/BradleyChatha/bcstd"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    D has a subset of the language called
                                    betterC, which disables any language
                                    features that require the garbage collector
                                    or certain parts of DRuntime. This also
                                    makes some of the std unusable.
                                </p>
                                <p>
                                    bcstd is a betterC standard library with no
                                    dependency on libc, and provides its own
                                    version of DRuntime.
                                </p>
                            </div>
                        </SomeProject>
                        <SomeProject
                            :image="{
                                url: '/img/logos/dlang.png',
                                alt: 'D logo',
                            }"
                            title="Primes Drag Race - D solution 2"
                            href="https://github.com/PlummersSoftwareLLC/Primes/tree/drag-race/PrimeD/solution_2"
                            class="wait until visible then flipperydoo"
                        >
                            <div class="gfont cairo">
                                <p>
                                    Organised by Dave Plummer, "Primes | A
                                    Software Drag Race" is a community-led race
                                    to see what implementation of the sieve of
                                    eratosthenes (or similar algorithm) is
                                    faster as well as comparing how each
                                    language implements it.
                                </p>
                                <p>I've provided the second solution for D.</p>
                            </div>
                        </SomeProject>
                    </ul>
                </div>
            </template>
        </PersonalSkill>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import PersonalSkill from '~/components/index/PersonalSkill.vue'
import LanguageList from '~/components/index/LanguageList.vue'
import TheHero from '~/components/index/TheHero.vue'
import SomeProject from '~/components/index/SomeProject.vue'
export default Vue.extend({
    components: { PersonalSkill, LanguageList, TheHero, SomeProject },
    data() {
        return {
            webLogos: [
                {
                    img: '/img/logos/html.webp',
                    alt: 'HTML 5 Logo',
                    link: 'https://developer.mozilla.org/en-US/docs/Glossary/HTML',
                },
                {
                    img: '/img/logos/css.webp',
                    alt: 'CSS 3 Logo',
                    link: 'https://developer.mozilla.org/en-US/docs/Web/CSS',
                },
                {
                    img: '/img/logos/ts.webp',
                    alt: 'TypeScript Logo',
                    link: 'https://www.typescriptlang.org/',
                },
                {
                    img: '/img/logos/nuxt.png',
                    alt: 'Nuxt Logo',
                    link: 'https://nuxtjs.org',
                },
                {
                    img: '/img/logos/vue.png',
                    alt: 'Vue Logo',
                    link: 'https://vuejs.org/',
                },
                {
                    img: '/img/logos/csharp.webp',
                    alt: 'C Sharp Logo',
                    link: 'https://docs.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/',
                },
            ],
            appLogos: [
                {
                    img: '/img/logos/csharp.webp',
                    alt: 'C Sharp Logo',
                    link: 'https://docs.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/',
                },
                {
                    img: '/img/logos/dlang.png',
                    alt: 'D Logo',
                    link: 'https://dlang.org',
                },
                {
                    img: '/img/logos/python.png',
                    alt: 'Python Logo',
                    link: 'https://python.org',
                },
                {
                    img: '/img/logos/powershell.png',
                    alt: 'Powershell Logo',
                    link: 'https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1',
                },
                {
                    img: '/img/logos/lua.png',
                    alt: 'LUA Logo',
                    link: 'https://lua.org',
                },
            ],
            otherLogos: [
                {
                    img: '/img/logos/psql.png',
                    alt: 'Postgresql Logo',
                    link: 'https://postgresql.org',
                },
                {
                    img: '/img/logos/docker.png',
                    alt: 'Docker Logo',
                    link: 'https://docker.com',
                },
                {
                    img: '/img/logos/github.png',
                    alt: 'Github Logo',
                    link: 'https://github.com',
                },
                {
                    img: '/img/logos/terraform.png',
                    alt: 'Terraform Logo',
                    link: 'https://terraform.io',
                },
                {
                    img: '/img/logos/linux.png',
                    alt: 'Linux Logo',
                    link: 'https://ubuntu.com',
                },
                {
                    img: '/img/logos/grafana.png',
                    alt: 'Grafana Logo',
                    link: 'https://grafana.com',
                },
                {
                    img: '/img/logos/ansible.png',
                    alt: 'Ansible Logo',
                    link: 'https://ansible.com',
                },
                {
                    img: '/img/logos/drone.png',
                    alt: 'drone Logo',
                    link: 'https://drone.io',
                },
            ],
        }
    },
    head: {
        title: 'An introduction to myself - Bradley Chatha',
    },
    mounted() {
        const waitUntilVisible = document.querySelectorAll(
            '.wait.until.visible'
        )
        const observer = new IntersectionObserver((entry) => {
            for (const item of entry) {
                if (item.intersectionRatio > 0.9)
                    item.target.classList.add('ok')
            }
        })

        waitUntilVisible.forEach((el) => observer.observe(el))
    },
})
</script>

<style lang="scss" scoped>
.first.text.block {
    width: 100%;
    margin-left: 2rem;
    margin-bottom: 3rem;
    padding-top: 2rem;
    padding-left: 1rem;
    padding-right: 1rem;

    // Create a card effect.
    background-color: lighten($G_INDEX_PERSONAL_SKILL_BG1, 10%);
    @include g-generic-card;

    p {
        &:not(:last-child) {
            margin-bottom: 4rem;
        }
        &:last-child {
            padding-bottom: 1rem;
        }
    }
}

ul.project.list {
    list-style: none;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    width: 100%;
}

.wait.until.visible {
    transform: scale(0);

    &.ok.then.twirly.scale {
        animation: on-visible-twirly-scale 1s forwards;
    }

    &.ok.then.flipperydoo {
        animation: on-visible-flipperydoo 1s forwards;
    }
}

@keyframes on-visible-twirly-scale {
    0% {
        transform: scale(0) rotate(0deg);
    }

    100% {
        transform: scale(1) rotate(360deg);
    }
}

@keyframes on-visible-flipperydoo {
    0% {
        transform: rotateY(90deg);
    }

    100% {
        transform: rotateY(0deg);
    }
}
</style>
