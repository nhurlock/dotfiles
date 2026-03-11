from kittens.tui.handler import kitten_ui

@kitten_ui(allow_remote_control=True)
def main(args: list[str]):
    main.remote_control(['action', '--self', 'layout_action maximize horizontal'], check=True)
    main.remote_control(['action', '--self', 'layout_action maximize vertical'], check=True)
    return
