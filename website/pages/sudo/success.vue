<template>
    <div></div>
</template>

<script>
import Vue from 'vue'
import { storeToken } from '~/lib/sudo.ts'
export default Vue.extend({
    mounted() {
        const urlParams = new URLSearchParams(window.location.hash.slice(1))
        const urlParamsObj = Object.fromEntries(urlParams.entries())
        storeToken(urlParamsObj)
        window.location.replace('/')
    },
})
</script>