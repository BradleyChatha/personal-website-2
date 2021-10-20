<template>
    <section class="wrapper">
        <h1>Stats for {{ this.package }}</h1>

        <base-input-field>
            <base-label>Weeks to search</base-label>
            <base-input
                v-model="weeks"
                type="number"
                @input="
                    weeks = $event.target.value
                    onWeeksChanged()
                "
            />
        </base-input-field>

        <canvas id="downloads"></canvas>
    </section>
</template>

<script lang="js">
import Vue from 'vue'
import { Chart, registerables } from 'chart.js'
import 'chartjs-adapter-moment';
import BaseInput from '~/components/layout/BaseInput.vue'
import BaseInputField from '~/components/layout/BaseInputField.vue'
import BaseLabel from '~/components/layout/BaseLabel.vue'
export default Vue.extend({
    components: { BaseInput, BaseInputField, BaseLabel },
    data() {
        return {
            package: '',
            weeks: 4,
            labels: [""],
            downloadsWeekly: [0],
            downloadsMonthly: [0],
            downloadsTotal: [0],

            downloadChart: null
        }
    },

    mounted() {
        const params = new URLSearchParams(window.location.search)
        this.package = params.get('package')
        Chart.register(...registerables)

        const downloadCtx = document.getElementById('downloads').getContext('2d')
        this.downloadChart = new Chart(downloadCtx,{
            type: 'line',
            data: {
                labels: this.labels,
                datasets: [{
                    data: this.downloadsTotal,
                    label: 'Total downloads',
                    backgroundColor: 'red',
                    borderColor: 'red'
                }, {
                    data: this.downloadsMonthly,
                    label: 'Monthly downloads',
                    backgroundColor: 'green',
                    borderColor: 'green'
                }, {
                    data: this.downloadsWeekly,
                    label: 'Weekly downloads',
                    backgroundColor: 'blue',
                    borderColor: 'blue'
                }]
            },
            options: {
                scales: {
                    x: {
                        type: 'timeseries'
                    }
                }
            }
        })

        this.onWeeksChanged()
    },

    methods: {
        onWeeksChanged() {
            fetch(
                'https://api.chatha.dev/dub/stats?package=' +
                    this.package +
                    '&weeks=' +
                    this.weeks,
                {
                    method: 'GET',
                    headers: {
                        Accept: 'application/json',
                    },
                }
            )
                .then((r) => r.json())
                .then((j) => {
                    this.downloadsWeekly = []
                    this.downloadsMonthly = []
                    this.downloadsTotal = []
                    this.labels = []
                    for (const obj of j) {
                        this.downloadsWeekly.push(obj.downloadsWeekly)
                        this.downloadsMonthly.push(obj.downloadsMonthly)
                        this.downloadsTotal.push(obj.downloadsTotal)
                        this.labels.push(obj.time)
                    }
                })
                .then(() => {
                    this.downloadChart.data.labels = this.labels;
                    this.downloadChart.data.datasets[0].data = this.downloadsTotal;
                    this.downloadChart.data.datasets[1].data = this.downloadsMonthly;
                    this.downloadChart.data.datasets[2].data = this.downloadsWeekly;
                    this.downloadChart.update()
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

h1 {
    margin: 0 auto;
    margin-bottom: 2rem;
}

#downloads {
    width: 100%;
    max-height: 400px;
}
</style>