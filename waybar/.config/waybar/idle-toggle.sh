#!/bin/bash
set -e
STATE_FILE="/tmp/waybar-idle-state"

if [ "$1" = "toggle" ]; then
    if pgrep -x hypridle >/dev/null; then
        pkill -x hypridle || true
    else
        setsid -f hypridle >/dev/null 2>&1 < /dev/null
    fi
    exit 0
fi

moon=""
sun=""

if pgrep -x hypridle >/dev/null; then
    printf '{"text":"%s","tooltip":"Idle timer active — screen will dim/lock/suspend when idle\\n\\nLeft-click: inhibit idle (stay awake)","class":"active"}\n' "$moon"
else
    printf '{"text":"%s","tooltip":"Idle inhibited — staying awake\\n\\nLeft-click: re-enable idle timer","class":"inhibited"}\n' "$sun"
fi
