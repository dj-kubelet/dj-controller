#!/bin/bash
set -euo pipefail

NAMESPACE=spotify-matti4s
ACCESS_TOKEN=$(kubectl --namespace="$NAMESPACE" get secrets spotify-oauth -ojsonpath='{.data.accesstoken}' | base64 --decode)

# Create a Kubernetes friendly name of the track search input
normalize_str() {
    S=${1// /-}                                 # remove spaces from $1
    S=${S//:/-}                                 # replace : with -
    S=$(echo "$S" | tr "[:upper:]" "[:lower:]") # lowercase
    S=$(echo "$S" | LANG=c tr -cd '[:print:]')  # remove non ascii characters
    S=$(echo "$S" | cut -c-253)                 # trim to max 253 characters
    echo "$S"
}

# Remove "spotify:playlist:" from the input if present
playlist_id=${1/spotify:playlist:/}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
    "https://api.spotify.com/v1/playlists/$playlist_id/tracks" |
    jq -r '.items[].track.uri' |
    while read -r uri; do
        name="${uri/spotify:track:/}"
        name="$(normalize_str "$name")"
        URI="$uri" NAME="$name" envsubst <"$DIR/track.tmpl.yaml" | kubectl --namespace="$NAMESPACE" create -f -
    done
