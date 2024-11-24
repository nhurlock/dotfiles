SSID=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork | cut -c 24-)
sketchybar --set wifi label="$SSID"
