#!/usr/bin/env sh
set -eu

# Session-aware logout for wlogout.
# Do not use `loginctl terminate-user`: it kills the whole user manager and can
# leave SDDM on a black screen after Hyprland exits.

if command -v uwsm >/dev/null 2>&1 && uwsm check is-active >/dev/null 2>&1; then
    exec uwsm stop
fi

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && command -v hyprctl >/dev/null 2>&1; then
    exec hyprctl dispatch exit
fi

if [ "${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -n "${XDG_SESSION_ID:-}" ]; then
    exec loginctl terminate-session "$XDG_SESSION_ID"
fi

printf '%s\n' "No recognized UWSM/Hyprland Wayland session; refusing unsafe logout fallback." >&2
exit 1
