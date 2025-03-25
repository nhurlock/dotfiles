import os
from datetime import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_powerline,
)

options = get_options()

REFRESH_TIME = 1
LEFT_SLANT = ""
CHARGING_ICON = "󰚥"
BATTERY_ICONS = [
    "󰂃",
    "󰁻",
    "󰁼",
    "󰁽",
    "󰁾",
    "󰁿",
    "󰂀",
    "󰂁",
    "󰂂",
    "󱟢",
]


timer_id = None


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(screen, is_last, draw_data)
    return screen.cursor.x


def _get_key_mode_cell() -> dict:
    mode = get_boss().mappings.current_keyboard_mode_name
    match mode:
        case "leader":
            return {"icon_bg_color": options.color3, "text": "L"}
        case _:
            return {"icon_bg_color": options.color1, "text": mode}


def _get_datetime_cell() -> dict:
    now = datetime.now().strftime("%a %b %-d %I:%M %p")
    return {"icon_bg_color": options.color4, "text": now}


def _get_battery_cell() -> dict:
    cell = {"icon_bg_color": options.color7, "text": ""}
    try:
        battery_info = (
            os.popen("pmset -g batt | awk '/[0-9]+%/{ print $3$4 }'")
            .read()
            .strip(" ;\n")
            .split(";")
        )

        if len(battery_info) != 2:
            raise AssertionError

        battery_charge = battery_info[0]
        cell["text"] = battery_charge

        battery_charge = int(battery_charge[:-1])
        battery_state = battery_info[1]

        if battery_state == "charging":
            cell["icon"] = CHARGING_ICON
        else:
            cell["icon"] = BATTERY_ICONS[(battery_charge // 10) - 1]
    except:
        cell["text"] = ""

    return cell


def _create_cells() -> list[dict]:
    return [
        cell
        for cell in [_get_key_mode_cell(), _get_battery_cell(), _get_datetime_cell()]
        if len(cell["text"]) > 0
    ]


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cells = _create_cells()
    default_bg = as_rgb(int(draw_data.default_bg))
    right_status_length = 0

    for c in cells:
        icon_len = len(c["icon"]) + 1 if "icon" in c else 0
        right_status_length += 3 + icon_len + len(c["text"])

    screen.cursor.x = screen.columns - right_status_length
    screen.cursor.bg = default_bg

    for c in cells:
        icon_bg_color = as_rgb(color_as_int(c["icon_bg_color"]))
        screen.cursor.fg = icon_bg_color
        screen.draw(LEFT_SLANT)

        screen.cursor.bg = icon_bg_color
        screen.cursor.fg = default_bg

        if "icon" in c and len(c["icon"]) > 0:
            screen.draw(f" {c['icon']}")
        screen.draw(f" {c['text']} ")

    return screen.cursor.x


def _redraw_tab_bar(_) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()
