mkdir -p ~/.config

# lazydocker
rm -rf ~/.config/lazydocker
ln -s "$(pwd)/lazydocker" ~/.config/lazydocker

# lazygit
rm -rf ~/.config/lazygit
ln -s "$(pwd)/lazygit" ~/.config/lazygit


# nvim
rm -rf ~/.config/nvim
ln -s "$(pwd)/nvim" ~/.config/nvim


# neovide
rm -rf ~/.config/neovide
ln -s "$(pwd)/neovide" ~/.config/neovide


# wezterm
rm -rf ~/.config/wezterm
ln -s "$(pwd)/wezterm" ~/.config/wezterm


# kitty
rm -rf ~/.config/kitty
ln -s "$(pwd)/kitty" ~/.config/kitty


# gh-dash
rm -rf ~/.config/gh-dash
ln -s "$(pwd)/gh-dash" ~/.config/gh-dash


# aerospace
rm ~/.aerospace.toml
ln -s "$(pwd)/aerospace/.aerospace.toml" ~/.aerospace.toml
