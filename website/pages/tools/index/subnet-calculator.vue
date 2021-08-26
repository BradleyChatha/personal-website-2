<template>
    <section class="wrapper">
        <BaseInputField>
            <BaseLabel>Network with mask</BaseLabel>
            <BaseInput
                :value="network"
                type="text"
                @keypress="onlyAllowIPChars($event)"
                @input="network = $event.target.value"
            />
        </BaseInputField>
        <BaseInputField>
            <BaseLabel>Subnet</BaseLabel>
            <BaseInput
                :value="subnet"
                type="number"
                @input="subnet = $event.target.value"
            />
            = /{{ parsedNetwork.cidr + Number(subnet) }}
        </BaseInputField>
        <section>
            <div class="section">
                <h3>As bits</h3>
                <p><span class="red">Red</span> = Network portion</p>
                <p><span class="green">Green</span> = Host portion</p>
                <p><span class="orange">Orange</span> = Subnet portion</p>
                <p>
                    <span class="red">{{
                        parsedNetwork.networkBitString
                    }}</span>
                    <span class="green">{{ parsedNetwork.hostBitString }}</span>
                    <span class="orange">{{
                        parsedNetwork.subnetBitString
                    }}</span>
                </p>
            </div>
            <div class="section">
                <h3>As IP</h3>
                <p>
                    Network =
                    <span class="red">{{ parsedNetwork.networkIp }}</span>
                </p>
                <p>
                    Host = <span class="green">{{ parsedNetwork.hostIp }}</span>
                </p>
                <p>
                    Subnet =
                    <span class="orange">{{ parsedNetwork.subnetIp }}</span>
                </p>
            </div>
            <div class="section">
                <h3>Network</h3>
                <p>
                    Network =
                    <span class="red">{{
                        parsedNetwork.networkInfoNoSub.networkIp
                    }}</span>
                </p>
                <p>
                    First =
                    <span class="green">{{
                        parsedNetwork.networkInfoNoSub.firstIp
                    }}</span>
                </p>
                <p>
                    Last =
                    <span class="green">{{
                        parsedNetwork.networkInfoNoSub.lastIp
                    }}</span>
                </p>
                <p>
                    Broadcast =
                    <span class="red">{{
                        parsedNetwork.networkInfoNoSub.broadcastIp
                    }}</span>
                </p>
            </div>
            <div class="section">
                <h3>Subnets</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Network IP</th>
                            <th>First IP</th>
                            <th>Last IP</th>
                            <th>Broadcast IP</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr
                            v-for="sub in parsedNetwork.subnets"
                            :key="sub.networkIp"
                        >
                            <td>{{ sub.networkIp }}</td>
                            <td>{{ sub.firstIp }}</td>
                            <td>{{ sub.lastIp }}</td>
                            <td>{{ sub.broadcastIp }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </section>
</template>

<script lang="ts">
import Vue from 'vue'
import BaseLabel from '~/components/layout/BaseLabel.vue'
import BaseInput from '~/components/layout/BaseInput.vue'
import BaseInputField from '~/components/layout/BaseInputField.vue'
export default Vue.extend({
    components: {
        BaseLabel,
        BaseInput,
        BaseInputField,
    },
    transition: 'page',
    data() {
        return { network: '192.168.1.254/24', subnet: 4 }
    },
    computed: {
        parsedNetwork() {
            let regex: any =
                /([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\/([0-9]{1,2})/.exec(
                    (this as any).network
                )
            if (!regex) regex = ['0', '0', '0', '0', '0']

            const obj = {
                b1: Number(regex[1]),
                b2: Number(regex[2]),
                b3: Number(regex[3]),
                b4: Number(regex[4]),
                cidr: Number(regex[5]),
                netAsInt: 0,

                fullBitString: '',
                networkBitString: '',
                hostBitString: '',
                subnetBitString: '',

                networkIp: '',
                hostIp: '',
                subnetIp: '',

                networkOffset: 0,
                hostOffset: 0,
                subnetOffset: 0,

                networkMask: 0,
                hostMask: 0,
                subnetMask: 0,

                networkInfoNoSub: (this as any).getNetworkInfo(0, 0),
                subnets: [],
            }

            if ([obj.b1, obj.b2, obj.b3, obj.b4].find((n) => n > 255 || n < 0))
                return obj
            if (obj.cidr < 0 || obj.cidr > 32) return obj

            obj.netAsInt =
                (obj.b1 << 24) | (obj.b2 << 16) | (obj.b3 << 8) | obj.b4

            obj.networkOffset = 32 - obj.cidr
            obj.hostOffset = obj.networkOffset - (this as any).subnet
            obj.subnetOffset = 0

            obj.networkMask =
                (this as any).makeMask(obj.cidr) << obj.networkOffset
            obj.hostMask =
                (this as any).makeMask(obj.hostOffset) << obj.hostOffset
            obj.subnetMask = (this as any).makeMask((this as any).subnet)

            obj.fullBitString = (this as any).numToBitString(obj.netAsInt)
            obj.networkBitString = obj.fullBitString.substr(0, obj.cidr)
            obj.hostBitString = obj.fullBitString.substr(
                obj.cidr,
                32 - obj.cidr - (this as any).subnet
            )
            obj.subnetBitString = obj.fullBitString.substr(
                obj.fullBitString.length - (this as any).subnet,
                (this as any).subnet
            )

            obj.networkIp = (this as any).numberAsIp(
                obj.netAsInt & obj.networkMask
            )
            obj.hostIp = (this as any).numberAsIp(obj.netAsInt & obj.hostMask)
            obj.subnetIp = (this as any).numberAsIp(
                obj.netAsInt & obj.subnetMask
            )

            obj.networkInfoNoSub = (this as any).getNetworkInfo(
                obj.netAsInt & obj.networkMask,
                32 - obj.cidr - (this as any).subnet
            )
            obj.subnets = (this as any).getSubnets(
                obj.netAsInt & obj.networkMask,
                32 - obj.cidr - (this as any).subnet,
                (this as any).subnet
            )

            obj.networkBitString = (this as any).insertEveryN(
                ' ',
                8,
                obj.networkBitString
            )

            return obj
        },
    },
    methods: {
        makeMask(bitsSet: number) {
            let num = 0
            while (bitsSet > 0) {
                num <<= 1
                num |= 1
                bitsSet--
            }
            return num
        },

        onlyAllowIPChars(event: KeyboardEvent) {
            if (/[0-9./]/.test(event.key)) return true
            else event.preventDefault()
        },

        numToBitString(number: number) {
            return (number >>> 0).toString(2)
        },

        insertEveryN(char: string, n: number, str: string) {
            let output = ''
            for (let i = 0; i < str.length; i += n) {
                output += str.substr(i, n)
                output += char
            }
            return output
        },

        numberAsIp(num: number) {
            return (
                ((num & 0xff000000) >>> 24).toString() +
                '.' +
                ((num & 0x00ff0000) >>> 16).toString() +
                '.' +
                ((num & 0x0000ff00) >>> 8).toString() +
                '.' +
                (num & 0x000000ff).toString()
            )
        },
        getNetworkInfo(network: number, hostBits: number) {
            const obj = {
                networkIp: '',
                broadcastIp: '',
                firstIp: '',
                lastIp: '',
            }

            if (hostBits < 2) return obj
            const hostMask = (this as any).makeMask(hostBits)

            obj.networkIp = (this as any).numberAsIp(network)
            obj.firstIp = (this as any).numberAsIp(network + 1)
            obj.broadcastIp = (this as any).numberAsIp(network | hostMask)
            obj.lastIp = (this as any).numberAsIp((network | hostMask) - 1)

            return obj
        },
        getSubnets(network: number, hostBits: number, subnetBits: number) {
            const arr = []
            const maxHostBits = (this as any).makeMask(hostBits)

            if (subnetBits <= 1) return []

            for (let i = 0; i <= maxHostBits; i++) {
                const networkIp = network | (i << subnetBits)
                const broadcastIp = network | (((i + 1) << subnetBits) - 1)
                const lastIp = broadcastIp - 1
                const firstIp = networkIp + 1
                arr.push({
                    networkIp: (this as any).numberAsIp(networkIp),
                    broadcastIp: (this as any).numberAsIp(broadcastIp),
                    lastIp: (this as any).numberAsIp(lastIp),
                    firstIp: (this as any).numberAsIp(firstIp),
                })
                hostBits++
                if (i === 100) {
                    arr.push({
                        networkIp: 'More...',
                        broadcastIp: 'More...',
                        lastIp: 'More...',
                        firstIp: 'More...',
                    })
                    break
                }
            }

            return arr
        },
    },
})
</script>

<style lang="scss" scoped>
.red {
    color: darkred;
}

.green {
    color: green;
}

.orange {
    color: darkorange;
}

.wrapper {
    display: flex;
    flex-direction: column;
    padding: 1rem;
    width: 50%;
    background: white;
    margin: 0 auto;

    @media screen and (max-width: 1500px) {
        width: 80%;
    }

    @media screen and (max-width: 860px) {
        width: 100%;
    }
}

.section {
    padding: 1rem;
    background-color: whitesmoke;

    &:first-child {
        margin-top: 1rem;
    }

    &:not(:last-child) {
        margin-bottom: 1rem;
    }
}

table {
    width: 100%;
}

tr {
    display: flex;
    width: 100%;
    justify-content: space-evenly;
}

td,
th {
    display: flex;
    width: 25%;
}

h3 {
    margin-top: 0;
}
</style>