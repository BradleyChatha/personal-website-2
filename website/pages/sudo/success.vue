<template>
    <div></div>
</template>

<script>
import Vue from 'vue'
export default Vue.extend({
    mounted() {
        const urlParams = new URLSearchParams(window.location.hash.slice(1))
        const urlParamsObj = Object.fromEntries(urlParams.entries())
        window.localStorage.setItem('sudo-token', JSON.stringify(urlParamsObj))
        window.location.replace('/')
    },
})
</script>