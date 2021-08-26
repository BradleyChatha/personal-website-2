<template>
    <input
        :value="value"
        @input="$emit('input', $event)"
        @keypress="$emit('keypress', $event)"
    />
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
    props: {
        value: {
            required: true,
        },
    },
})
</script>

<style lang="scss" scoped>
input {
    height: 40px;
    border-radius: 20px;
    border: solid rgb(211, 211, 211);
    padding: 1rem;
    font-size: 20px;
}
</style>