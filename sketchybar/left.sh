source ./aerospace.sh

# update defaults
sketchybar --default \
  background.color=$BG \
  background.height=24 \
  background.padding_left=5 \
  background.border_width=1 \
  background.corner_radius=5 \
  icon.padding_left=12 \
  icon.padding_right=4 \
  label.padding_left=4 \
  label.padding_right=12 \
  blur_radius=2

# app title
sketchybar --add item title left
sketchybar --subscribe title aerospace_focus_change
sketchybar --set title \
  background.border_color=$BLACK4 \
  icon.drawing=off \
  label="" \
  label.padding_left=12 \
  label.max_chars=50 \
  label.scroll_duration=200 \
  scroll_texts=on \
  script='./plugins/title.sh'
