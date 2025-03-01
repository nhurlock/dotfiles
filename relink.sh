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


# aerospace
rm ~/.aerospace.toml
ln -s "$(pwd)/aerospace/.aerospace.toml" ~/.aerospace.toml
