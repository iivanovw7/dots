# X11 to Wayland Migration Guide

This document tracks the tools and packages that were migrated from X11 to their modern Wayland equivalents to achieve a native, polished, and fully functional Hyprland setup.

## Core Desktop Environment
| Function | X11 Package | Wayland/Hyprland Equivalent | Notes |
| :--- | :--- | :--- | :--- |
| **Window Manager** | `xmonad` | `hyprland` | Native Wayland compositor. Tiling and floating support out of the box. |
| **Status Bar** | `polybar` / `xmobar` | `waybar` | Highly customizable GTK-based Wayland bar. |
| **App Launcher** | `rofi` | `wofi` (or `walker`) | `wofi` acts as an excellent Wayland-native drop-in for `rofi`. |
| **Display Configuration**| `xrandr` / shell scripts | `kanshi` | Automatically applies monitor profiles (resolutions, positions) upon hotplug. |

## Desktop Utilities
| Function | X11 Package | Wayland/Hyprland Equivalent | Notes |
| :--- | :--- | :--- | :--- |
| **Notifications** | `dunst` | `mako` (or `swaync`) | `mako` is a lightweight Wayland notification daemon. |
| **Screenshots** | `maim` / `flameshot` | `grim` + `slurp` | `grim` takes the screenshot, `slurp` lets you select the region. Handled natively by Wayland. |
| **Clipboard Manager** | `xclip` / `xsel` | `wl-clipboard` | Provides `wl-copy` and `wl-paste` for Wayland. |
| **Volume/Brightness OSD**| `pamixer` / `brightnessctl` | `swayosd` | Provides beautiful, macOS-style on-screen display popups when changing volume or brightness. |
| **Screen Locker** | `light-locker` | `hyprlock` | GPU-accelerated lock screen built specifically for Hyprland. |
| **Idle Management** | `xfce4-power-manager` | `hypridle` | Handles screen dimming, locking, and sleeping based on activity. |
| **Wallpaper** | `feh` / `nitrogen` | `swaybg` (or `hyprpaper`) | `swaybg` efficiently renders the wallpaper on all outputs. |
| **Desktop Widgets** | `conky` | `eww` | `conky` struggles with Wayland transparency and placement. `eww` uses GTK and native Wayland protocols. |
| **GTK Theming** | `lxappearance` | `nwg-look` | A GTK3 settings editor specifically designed to work perfectly under Wayland. |
| **Cursor Settings** | `xsetroot` | `hyprland.conf` (`env = XCURSOR_THEME`) | Hyprland manages cursor scaling and theming natively. |

## Recommended Packages to Install (Arch Linux)
```bash
sudo pacman -S hyprland waybar wofi mako swayosd grim slurp wl-clipboard hypridle hyprlock swaybg kanshi eww nwg-look
```
