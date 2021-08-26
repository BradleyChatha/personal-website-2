<template>
    <div style="margin-top: 2rem">
        <nuxt-child />
    </div>
</template>

<style lang="scss" scoped>
.page-enter-active,
.page-leave-active {
    transition: all 0.5s;
    opacity: 1;
    transform: scale(1);
}
.page-enter,
.page-leave-to {
    opacity: 0;
    transform: scale(1.5);
}
</style>