#!/bin/bash

# Get list of currently running rclone user services
mounts=$(systemctl --user list-units --type=service --state=running "rclone-mount@*" --no-legend | awk '{print $1}')

# Stop them to unmount cleanly before network goes down
if [ -n "$mounts" ]; then
    echo "Stopping rclone mounts: $mounts"
    # Try graceful stop first
    systemctl --user stop $mounts
    
    # Clean up any stale mounts that refused to die
    for m in $mounts; do
        # Extract remote name from service name (rclone-mount@work.service -> work)
        remote=$(echo "$m" | sed 's/rclone-mount@//;s/\.service//')
        mountpoint="$HOME/gdrive/$remote"
        if mountpoint -q "$mountpoint"; then
            echo "Force unmounting $mountpoint..."
            fusermount3 -u -z "$mountpoint"
        fi
    done
fi

# Suspend
systemctl suspend

# Wait for network to be back before restarting
echo "Waiting for network..."
until ping -c 1 8.8.8.8 &>/dev/null; do
    sleep 1
done

# Restart them on wake
if [ -n "$mounts" ]; then
    echo "Restarting rclone mounts: $mounts"
    systemctl --user start $mounts
fi
