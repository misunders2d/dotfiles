#!/usr/bin/env bash
set -euo pipefail

signal=8
state_file="${XDG_RUNTIME_DIR:-/tmp}/waybar-keyboard-layer"

normalize_state() {
    case "${1,,}" in
        base|0) printf 'base' ;;
        num|number|numbers|1) printf 'num' ;;
        sym|symbol|symbols|2) printf 'sym' ;;
        *) return 1 ;;
    esac
}

read_state() {
    local state
    if [[ -r "$state_file" ]]; then
        state="$(<"$state_file")"
        normalize_state "$state" 2>/dev/null && return 0
    fi
    printf 'base'
}

write_state() {
    local state="$1"
    local dir tmp
    dir="$(dirname "$state_file")"
    mkdir -p "$dir"
    tmp="$(mktemp "$dir/waybar-keyboard-layer.XXXXXX")"
    printf '%s\n' "$state" > "$tmp"
    mv "$tmp" "$state_file"
}

emit_json() {
    local state text tooltip
    state="$(read_state)"
    case "$state" in
        base) text='BASE'; tooltip='Keyboard layer: Base' ;;
        num)  text='NUM';  tooltip='Keyboard layer: Numbers / navigation' ;;
        sym)  text='SYM';  tooltip='Keyboard layer: Symbols / function' ;;
        *)    text='?';    tooltip='Keyboard layer: unknown'; state='unknown' ;;
    esac
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$state"
}

case "${1:-show}" in
    show)
        emit_json
        ;;
    set)
        if [[ $# -ne 2 ]]; then
            echo "usage: $0 set <base|num|sym>" >&2
            exit 2
        fi
        state="$(normalize_state "$2")" || {
            echo "invalid keyboard layer: $2" >&2
            exit 2
        }
        write_state "$state"
        pkill "-RTMIN+$signal" -x waybar 2>/dev/null || true
        ;;
    *)
        echo "usage: $0 [show|set <base|num|sym>]" >&2
        exit 2
        ;;
esac
