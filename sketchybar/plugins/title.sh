TITLE=$(aerospace list-windows --focused --json | jq -r '.[]."app-name"')
if [ "$TITLE" = "" ]; then
    sketchybar --animate circ 5 --set title y_offset=70
    sleep 0.2 && sketchybar --set title label=""
else
    if [ "$(sketchybar --query title | jq -r '.label.value')" != "$TITLE" ]; then
        sketchybar --animate circ 5 --set title y_offset=70            \
                   --animate circ 5 --set title y_offset=7            \
                   --animate circ 5 --set title y_offset=0
        sleep 0.05 && sketchybar --set title label="$TITLE"
    fi
fi
