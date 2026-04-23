#!/bin/bash
set -e

BAT="/sys/class/power_supply/BAT0"
[ ! -d "$BAT" ] && BAT="/sys/class/power_supply/BAT1"
AC="/sys/class/power_supply/AC"
TLP_MODE_FILE="/run/tlp/manual_mode"

# Resolve tlp applied mode: ac | bat
# /run/tlp/manual_mode: "0" = forced AC, "1" = forced BAT, otherwise auto (use plug state).
resolve_mode() {
    local m=""
    [ -r "$TLP_MODE_FILE" ] && m="$(cat "$TLP_MODE_FILE" 2>/dev/null)"
    case "$m" in
        0) echo ac ;;
        1) echo bat ;;
        *) [ "$(cat "$AC/online" 2>/dev/null)" = "1" ] && echo ac || echo bat ;;
    esac
}

if [ "$1" = "toggle" ]; then
    if [ "$(resolve_mode)" = "ac" ]; then
        sudo -n tlp bat >/dev/null 2>&1 || true
    else
        sudo -n tlp ac  >/dev/null 2>&1 || true
    fi
    exit 0
fi

bolt=""
leaf=""

capacity="$(cat "$BAT/capacity")"
status="$(cat "$BAT/status")"
mode="$(resolve_mode)"

if [ "$mode" = "ac" ]; then
    icon="$bolt"
    mode_label="AC"
    mode_class="ac"
else
    icon="$leaf"
    mode_label="Battery"
    mode_class="bat"
fi

classes="$mode_class"

if [ "$status" = "Charging" ]; then
    classes="$classes charging"
    charge_marker=" +"
elif [ "$status" = "Full" ]; then
    classes="$classes full"
    charge_marker=""
else
    charge_marker=""
    if [ "$capacity" -le 15 ]; then
        classes="$classes critical"
    elif [ "$capacity" -le 30 ]; then
        classes="$classes warning"
    fi
fi

time_info=""
if [ -f "$BAT/time_to_empty_now" ] && [ "$status" = "Discharging" ]; then
    mins=$(( $(cat "$BAT/time_to_empty_now") / 60 ))
    [ "$mins" -gt 0 ] && time_info="\\nTime remaining: ${mins} min"
elif [ -f "$BAT/time_to_full_now" ] && [ "$status" = "Charging" ]; then
    mins=$(( $(cat "$BAT/time_to_full_now") / 60 ))
    [ "$mins" -gt 0 ] && time_info="\\nTime to full: ${mins} min"
fi

IFS=' ' read -r -a arr <<< "$classes"
jarr=""
for c in "${arr[@]}"; do
    [ -z "$c" ] && continue
    [ -n "$jarr" ] && jarr="$jarr,"
    jarr="$jarr\"$c\""
done

printf '{"text":"%s  %s%%%s","tooltip":"Battery: %s%% (%s)%s\\nMode: %s\\n\\nLeft-click: toggle tlp AC/BAT","class":[%s]}\n' \
    "$icon" "$capacity" "$charge_marker" "$capacity" "$status" "$time_info" "$mode_label" "$jarr"
