# time
sketchybar --add item time right                                    
sketchybar --set time \
  background.border_color=$PURPLE \
  icon=󱑎 \
  icon.color=$PURPLE \
  label="$(date '+%I:%M %p')" \
  script='./plugins/time.sh' \
  update_freq=1

# date
sketchybar --add item date right                                    
sketchybar --set date \
  background.border_color=$RED \
  icon=󱨰 \
  icon.color=$RED \
  label="$(date '+%a %b %d')" \
  script='./plugins/date.sh' \
  update_freq=10

# battery
sketchybar --add item battery right                                 
sketchybar --set battery \
  background.border_color=$GREEN \
  icon= \
  icon.color=$GREEN \
  label="--%" \
  script='./plugins/battery.sh' \
  update_freq=20

# volume
sketchybar --add item volume right                                
sketchybar --subscribe volume volume_change
sketchybar --set volume \
  background.border_color=$CYAN \
  icon= \
  icon.color=$CYAN \
  label="--%" \
  script='./plugins/volume.sh'

# wifi
sketchybar --add item wifi right                                 
sketchybar --subscribe wifi wifi_change
sketchybar --set wifi \
  background.border_color=$ORANGE \
  icon=󰤨 \
  icon.color=$ORANGE \
  label="" \
  script='./plugins/wifi.sh'         
