<template>
    <div>
        <slot></slot>
    </div>
</template>

<style lang="scss" scoped>
div {
    display: flex;
    flex-direction: column;
    width: 100%;

    &:not(:first-child) {
        margin-top: 1rem;
    }

    .wide input {
        width: 100%;
        max-width: 100%;
    }
}

label {
    display: flex;
}

input {
    display: flex;
    max-width: 350px;
}
</style>