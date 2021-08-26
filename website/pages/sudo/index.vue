<template>
    <div></div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    beforeMount: () => {
        window.location.replace(
            'https://ssobradleychathaadmin.auth.eu-west-2.amazoncognito.com/login?client_id=6v4lqk1oe7fikr38ht0sk8s0nm&response_type=token&scope=aws.cognito.signin.user.admin+email+openid+phone+profile&redirect_uri=https://bradley.chatha.dev/sudo/success'
        )
    },
})
</script>