<template>
    <section class="wrapper">
        <BaseInputField class="wide">
            <BaseLabel>Search</BaseLabel>
            <BaseInput value="" type="text" @input="onSearch($event.target.value)" />
        </BaseInputField>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Rank</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="result in results" :key="result.id">
                    <td><nuxt-link :to="'/tools/dubstats?package='+result.name">{{ result.name }}</nuxt-link></td>
                    <td>{{ result.rank }}</td>
                </tr>
            </tbody>
        </table>
    </section>
</template>

<script lang="ts">
import Vue from 'vue'
import { debounce } from 'debounce'
import BaseInput from '~/components/layout/BaseInput.vue'
import BaseInputField from '~/components/layout/BaseInputField.vue'
import BaseLabel from '~/components/layout/BaseLabel.vue'
export default Vue.extend({
    components: {
        BaseInputField,
        BaseLabel,
        BaseInput,
    },

    data() {
        return {
            results: [],
            onSearch: {},
        }
    },

    created() {
        this.onSearch = debounce((term: string) => {
            this.onSearchImpl(term)
        }, 500)
    },

    methods: {
        onSearchImpl(term: string) {
            fetch('https://api.chatha.dev/dub/search?query=' + term, {
                method: 'GET',
                headers: {
                    Accept: 'application/json',
                },
            })
                .then((r) => r.json())
                .then((j) => {
                    this.results = j.sort((a : any, b : any) => a.rank < b.rank)
                })
                .catch((err) => {
                    // eslint-disable-next-line no-console
                    console.log(err)
                })
        },
    },
})
</script>

<style lang="scss" scoped>
.wrapper {
    display: flex;
    flex-direction: column;
    margin: 0 auto;
    width: 66%;
    background: white;
    padding: 1rem;
}

table {
    margin-top: 2rem;
    text-align: center;

    thead {
        background: #eeebeb;
    }

    td, th {
        padding: 1rem
    }

    tbody tr {
        background: white;

        &:nth-child(even) {
            background: #eeebeb;
        }
    }
}
</style>
