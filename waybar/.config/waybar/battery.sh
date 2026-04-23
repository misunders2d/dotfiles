#!/bin/bash
set -e

BAT="/sys/class/power_supply/BAT0"
[ ! -d "$BAT" ] && BAT="/sys/class/power_supply/BAT1"

if [ "$1" = "cycle" ]; then
    PROFILES=(performance balanced power-saver)
    cur="$(powerprofilesctl get)"
    for i in "${!PROFILES[@]}"; do
        if [ "${PROFILES[$i]}" = "$cur" ]; then
            next="${PROFILES[$(( (i + 1) % ${#PROFILES[@]} ))]}"
            powerprofilesctl set "$next"
            exit 0
        fi
    done
    exit 1
fi

bolt=""
scale=""
leaf=""

capacity="$(cat "$BAT/capacity")"
status="$(cat "$BAT/status")"
profile="$(powerprofilesctl get 2>/dev/null || echo balanced)"

case "$profile" in
    performance) icon="$bolt";  plabel="Performance" ;;
    balanced)    icon="$scale"; plabel="Balanced" ;;
    power-saver) icon="$leaf";  plabel="Power Saver" ;;
    *)           icon="$scale"; plabel="$profile" ;;
esac

# class stack: profile + state
classes="$profile"
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

# time remaining / to full
time_info=""
if [ -f "$BAT/time_to_empty_now" ] && [ "$status" = "Discharging" ]; then
    mins=$(( $(cat "$BAT/time_to_empty_now") / 60 ))
    [ "$mins" -gt 0 ] && time_info="\\nTime remaining: ${mins} min"
elif [ -f "$BAT/time_to_full_now" ] && [ "$status" = "Charging" ]; then
    mins=$(( $(cat "$BAT/time_to_full_now") / 60 ))
    [ "$mins" -gt 0 ] && time_info="\\nTime to full: ${mins} min"
fi

# build classes as JSON array
IFS=' ' read -r -a arr <<< "$classes"
jarr=""
for c in "${arr[@]}"; do
    [ -z "$c" ] && continue
    [ -n "$jarr" ] && jarr="$jarr,"
    jarr="$jarr\"$c\""
done

printf '{"text":"%s  %s%%%s","tooltip":"Battery: %s%% (%s)%s\\nProfile: %s\\n\\nLeft-click: cycle power profile","class":[%s]}\n'     "$icon" "$capacity" "$charge_marker" "$capacity" "$status" "$time_info" "$plabel" "$jarr"
