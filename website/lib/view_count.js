export function getViewCount(seriesUid, postUid) {
    return fetch('https://api.chatha.dev/personal/view_count', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        },
        body: JSON.stringify({query: `
            query($seriesUid: String!, $postUid: String!) { 
                post(seriesUid: $seriesUid, postUid: $postUid) {
                    view_count
                } 
            }
        `, variables: { seriesUid, postUid }
        })
    })
    .then(r => r.json())
    .then(j => j.post.view_count);
}

// What're the bets that some cunts are gonna fuck the numbers up?
// Guess what, I can just go into the DB and fix it, waste your time if you want.
export function incrementViewCount(seriesUid, postUid) {
    return fetch('https://api.chatha.dev/personal/view_count', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        },
        body: JSON.stringify({query: `
            mutation($seriesUid: String!, $postUid: String!) {
                increment(seriesUid: $seriesUid, postUid: $postUid)
            }
        `, variables: { seriesUid, postUid }
        })
    });
}