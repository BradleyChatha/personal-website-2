/* eslint-disable camelcase */
interface SudoToken
{
    id_token: string
    access_token: string
    expires_in: string
    token_type: string
}

export function storeToken(token: any) {
    window.localStorage.setItem('sudo-token', JSON.stringify(token))
}

export function getToken(): SudoToken {
    return JSON.parse(window.localStorage.getItem('sudo-token')!) as SudoToken
}

export function hasToken(): boolean {
    return window.localStorage.getItem('sudo-token') !== null
}