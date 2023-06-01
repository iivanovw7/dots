## Dotfiles
Personal collection of dotfiles and theme configs

---
### Files
- `.zshrc` -- [Z shell](https://github.com/zsh-users/zsh) config with plugins, uses powerlevel10k, nerdfont, oh-my-zsh.
- `.doom.d/*` -- [doomemacs](https://github.com/doomemacs/doomemacs) theme config.
- `.gitconfig` -- contains config file with semantic commits shortcuts. 
- `.fonts/*` -- contains custom fonts for terminal and etc.
- `.config/alacritty/*` -- theme config for [alacritty](https://github.com/alacritty/alacritty) terminal. 
- `.config/rofi/*` -- theme config for [rofi](https://github.com/davatorium/rofi) menu.
- `.config/gtk-2.0/*` -- gui style overrides.
- `.config/gtk-3.0/*` -- gui style overrides.
- `.config/xfce/**/*` -- xfce config files.
- `.config/i3/*` -- window manager config.
- `.config/polybar/*` -- polybar config.
- 
---
### Requirements
Some optional packages maybe be installed in the system previously:
- nvm
- zsh
- git
- alacritty
- rofi
- emacs
- i3
- polybar
- xmonad

---
### Some useful commands

##### ISO
[Arch Linux Calamares Installer](https://alci.online/downloads/)

##### Install `git`, `nvm` and `yay` helper.
```bash
sudo pacman -Syyu
sudo pacman -S git --needed base-devel
# https://github.com/Jguer/yay
sudo pacman -S yay
yay -S --devel --timeupdate
sudo pacman -S nvm
```

##### Install [git-semantic-commits](https://github.com/fteem/git-semantic-commits)
```bash
git clone https://github.com/fteem/git-semantic-commits ~/.git-semantic-commits
```

##### Install [OhMyZsh](https://ohmyz.sh/)
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

##### Install `zsh-syntax-highlighting`
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

##### Install [PowerLevel10K](https://github.com/romkatv/powerlevel10k)
```bash
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

##### Install [zsh-z](https://github.com/agkozak/zsh-z#installation)
Can be downloaded and then simply sourced from `.zshrc`
```bash
source ~/.zsh-autocomplete/zsh-autocomplete.plugin.zsh
```

##### Install [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
