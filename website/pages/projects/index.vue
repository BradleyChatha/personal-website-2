<template>
    <div>
        <div class="header gutter"></div>
        <ProjectCard
            image="/img/logos/terraform.png"
            category="DEVOPS"
            title="My AWS infrastructure"
            href="https://github.com/BradleyChatha/infrastructure"
        >
            <p>
                My entire AWS infrastructure is managed by a single
                <span class="highlight">Terraform</span> project, split up in a
                <span class="highlight">modular</span> fashion.
            </p>
            <p>
                Submodules may also be configured with their own
                <span class="highlight">Ansible playbooks</span> to configure
                any provisioned instances.
            </p>
        </ProjectCard>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import ProjectCard from '~/components/projects/ProjectCard.vue'
export default Vue.extend({
    components: {
        ProjectCard,
    },
})
</script>

<style scoped lang="scss">
.page-enter-active,
.page-leave-active {
    transition: all 0.5s;
    opacity: 1;
    transform: translateX(0);
}
.page-enter,
.page-leave-to {
    opacity: 0;
    transform: translateX(-200px);
}

.header.gutter {
    padding-top: 2rem;
}
</style>