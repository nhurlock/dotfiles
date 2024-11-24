VOLUME="${INFO:=0}"

case "$VOLUME" in
  [7-9][0-9]|100)
    ICON="󰕾"
    ;;
  [3-6][0-9])
    ICON="󰖀"
    ;;
  [1-9]|[1-2][0-9])
    ICON="󰕿"
    ;;
  *)
    ICON="󰖁"
esac

sketchybar --set volume \
  icon="$ICON" \
  label="$VOLUME%"
