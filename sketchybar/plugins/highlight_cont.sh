source ./colors.sh

INACTIVE_WORKSPACES=($(aerospace list-workspaces --empty --monitor all))
ACTIVE_WORKSPACES=($(aerospace list-workspaces --empty no --monitor all))

FOCUSED_WORKSPACE=${FOCUSED_WORKSPACE:=$(aerospace list-workspaces --focused)}
FOCUSED_DISPLAY=$(sketchybar --query wspace.$FOCUSED_WORKSPACE | jq -r ".geometry.drawing")

PREV_FOCUSED_WORKSPACE=$(sketchybar --query highlight_cont | jq -r ".label.value")
PREV_FOCUSED_INACTIVE=false

sketchybar --set highlight_cont label="$FOCUSED_WORKSPACE"

for i in "${!ACTIVE_WORKSPACES[@]}"; do
  if [ "${ACTIVE_WORKSPACES[i]}" = "$PREV_FOCUSED_WORKSPACE" ]; then
    sketchybar --set wspace.${ACTIVE_WORKSPACES[i]} drawing=on
  elif [ "${ACTIVE_WORKSPACES[i]}" != "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set wspace.${ACTIVE_WORKSPACES[i]} \
      background.color=$TRANSPARENT \
      label.color=$FG \
      drawing=on
  fi
done

for i in "${!INACTIVE_WORKSPACES[@]}"; do
  if [ "${INACTIVE_WORKSPACES[i]}" = "$PREV_FOCUSED_WORKSPACE" ]; then
    PREV_FOCUSED_INACTIVE=true
  else
    sketchybar --set wspace.${INACTIVE_WORKSPACES[i]} \
      background.color=$TRANSPARENT \
      label.color=$FG \
      drawing=off
  fi
done

if [ "$FOCUSED_DISPLAY" = "off" ]; then
  sketchybar --set wspace.$FOCUSED_WORKSPACE \
    background.height=0 \
    label.width=0
fi
sketchybar --set wspace.$FOCUSED_WORKSPACE \
  background.color=$TRANSPARENT \
  background.corner_radius=10 \
  background.height=10 \
  label.color=$FG \
  drawing=on

sketchybar --animate circ 15 --set wspace.$FOCUSED_WORKSPACE \
  background.color=$BLUE \
  background.corner_radius=3 \
  background.height=20 \
  label.color=$BG \
  label.width=20

if [ $PREV_FOCUSED_INACTIVE = true ]; then
  sketchybar --animate circ 15 --set wspace.$PREV_FOCUSED_WORKSPACE \
    background.color=$TRANSPARENT \
    background.corner_radius=10 \
    background.height=0 \
    label.color=$FG \
    label.width=0
  sleep 0.15 && sketchybar --set wspace.$PREV_FOCUSED_WORKSPACE \
    background.height=20 \
    label.width=20 \
    drawing=off
elif [ ! -z "$PREV_FOCUSED_WORKSPACE" ]; then
  sketchybar --animate circ 15 --set wspace.$PREV_FOCUSED_WORKSPACE \
    background.color=$TRANSPARENT \
    background.corner_radius=10 \
    background.height=10 \
    label.color=$FG
fi
