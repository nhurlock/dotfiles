# icon
sketchybar --add item aerospace left
sketchybar --set aerospace \
  icon= \
  icon.color=$BLUE \
  icon.align=center \
  icon.width=20 \
  icon.padding_left=12 \
  icon.padding_right=6 \
  label.drawing=off

# empty space for padding
sketchybar --add item blank_space_l left 
sketchybar --set blank_space_l \
  background.height=0 \
  icon.width=1 \
  label.drawing=off

# aerospace workspaces
WORKSPACES=($(aerospace list-workspaces --monitor all))
EMPTY_WORKSPACES=($(aerospace list-workspaces --empty --monitor all))
for i in "${!WORKSPACES[@]}"; do
  wspace=${WORKSPACES[i]}
  display=$([ $(printf '%s\0' "${EMPTY_WORKSPACES[@]}" | grep -F -x -z -- $wspace) ] && echo "off" || echo "on")
  sketchybar --add item wspace.$wspace left 
  sketchybar --set wspace.$wspace \
    background.height=20 \
    background.padding_left=1 \
    background.padding_right=1 \
    background.corner_radius=3 \
    icon.drawing=off \
    label=${WORKSPACES[i]} \
    label.font="$FONT:Bold:10.0" \
    label.highlight_color=$BLUE \
    label.align=center \
    label.width=20 \
    click_script="aerospace workspace $wspace" \
    drawing=$display
done

# highlight controller + empty space for padding
sketchybar --add item highlight_cont left
sketchybar --subscribe highlight_cont aerospace_workspace_change
sketchybar --set highlight_cont \
  background.height=0 \
  icon.width=1 \
  label.drawing=off \
  script='./plugins/highlight_cont.sh'

# bracket workspaces
sketchybar --add bracket wspaces aerospace blank_space_l '/wspace\..*/' highlight_cont
sketchybar --set wspaces \
  background.color=$BG \
  background.corner_radius=5 \
  background.border_width=1 \
  background.border_color=$BLUE \
  background.height=24 \
  blur_radius=2
