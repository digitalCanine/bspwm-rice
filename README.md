# digitalCanine's BSPWM Rice

A dark, warm-themed bspwm rice featuring golden/amber accents inspired by sunset lighting. This setup prioritizes aesthetics with smooth animations and a cohesive color scheme across all applications.

![Desktop](./images/desktop.png)

## Theme

- **Color Scheme**: Dark base with golden/amber highlights and warm brown tones
- **Wallpaper**: Custom artwork featuring golden lighting effects
- **Overall Aesthetic**: Warm, cozy, and visually unified

## Components

### Window Manager

- **bspwm** - Tiling window manager
- **sxhkd** - Hotkey daemon

### Compositor

- **picom** - Compositor with animations and transparency effects
  - Window animations (slide-up/slide-down transitions)
  - Fade effects for tag switching
  - Opacity rules for various applications

### Bar & System

- **Polybar** - Status bar (visible in terminal screenshot)
- Custom system monitoring with CPU, RAM, and GPU stats

### Applications Shown

- **Terminal**: Custom-themed terminal with golden accents
- **Editor**: Neovim with matching color scheme
- **File Manager**: GUI file manager with icon support
- **Music Player**: Strawberry Music Player with custom theming
- **Image Viewer**: Terminal-based image viewer
- **Notification Daemon**: Dunst (configured but screenshot aborted)

### Additional Tools

- **btop/htop** - System monitor with golden theme
- **spotifyd/spotify-tui** - Spotify integration
- **ranger/lf** - Terminal file managers
- **Various CLI tools** - fish shell, neofetch, etc.

## Screenshots

### Desktop

![Desktop Overview](./images/desktop.png)
*Main desktop with custom wallpaper and window layout*

### Dunst Notifications

![Dunst](./images/dunst.png)
*Notification system (Flameshot info example)*

### Neovim

![Neovim](./images/nvim.png)
*Neovim with picom configuration file open*

### Applications

![Qt/GTK Theming](./images/qt-gtk.png)
*Strawberry Music Player and file manager showing consistent theming*

### Terminal & System Monitor

![Terminal](./images/terminal.png)
*Terminal with system information, image viewer, and music player*

## Configuration Files

Key configuration locations:

- `~/.config/bspwm/` - BSPWM window manager configuration
- `~/.config/dunst/` - Notification daemon settings
- `~/.config/fastfetch/` - System info fetch tool
- `~/.config/fish/` - Fish shell configuration
- `~/.config/gtk-2.0/`, `~/.config/gtk-3.0/`, `~/.config/gtk-4.0/` - GTK theming
- `~/.config/kitty/` - Kitty terminal configuration
- `~/.config/nvim/` - Neovim editor setup
- `~/.config/polybar/` - Status bar configuration
- `~/.config/qt5ct/`, `~/.config/qt6ct/` - Qt theme settings
- `~/.config/rofi/` - Application launcher
- `~/.config/scripts/` - Custom scripts
- `~/.config/spotatui/` - Spotify TUI client
- `~/.config/yazi/` - Terminal file manager
- `~.config/legcord/themes` - Discord theme
- `~/.theme/` - Custom GTK/Qt color themes

## Key Features

- **Smooth Animations**: Window sliding and fading effects via picom
- **Unified Color Scheme**: Golden/amber theme across terminal, editor, and applications
- **Application-Specific Opacity**: Custom transparency rules for different window classes
- **Media Integration**: Integrated Spotify playback with spotatui
- **System Monitoring**: Real-time CPU, RAM, GPU, and network statistics
- **Custom GTK/Qt Theming**: Consistent look across all GUI applications
- **VPN Integration**: Quick access to MultiVPN for managing VPN connections

## ⌨️ Keybindings

### System

| Keybind | Action |
|---------|--------|
| `Super + Return` | Launch terminal (kitty) |
| `Super + D` | Application launcher (rofi) |
| `Super + P` | Volume control (pavucontrol) |
| `Super + V` | Clipboard manager |
| `Super + X` | Power menu |
| `Super + B` | Toggle polybar visibility |
| `Super + .` | Emoji picker (rofimoji) |
| `Print` | Screenshot (flameshot) |
| `Alt + Shift + V` | MultiVPN menu |

### Applications

| Keybind | Action |
|---------|--------|
| `Super + Shift + F` | Firefox |
| `Super + Shift + T` | Signal messenger |
| `Super + Shift + S` | Screen recorder |
| `Super + Shift + N` | File manager (yazi) |
| `Super + Shift + V` | Neovim |
| `Super + Shift + M` | Music player (spotatui) |

### Window Management

| Keybind | Action |
|---------|--------|
| `Super + Q` | Close window |
| `Super + F` | Toggle fullscreen |
| `Super + Space` | Toggle floating/tiled |
| `Super + Arrow Keys` | Focus window in direction |
| `Super + Shift + Arrow Keys` | Move window in direction |
| `Super + 1-9,0` | Switch to desktop 1-10 |
| `Super + Shift + 1-9,0` | Move window to desktop 1-10 |
| `Super + Ctrl + Left/Right` | Previous/Next desktop |
| `Alt + Tab` | Switch to last window |

### Media Control

| Keybind | Action |
|---------|--------|
| `XF86AudioRaiseVolume` | Increase volume |
| `XF86AudioLowerVolume` | Decrease volume |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle microphone |
| `XF86AudioPlay/Pause` | Play/Pause media |
| `XF86AudioNext/Prev` | Next/Previous track |
| `Ctrl + Alt + C` | Play/Pause media |
| `Ctrl + Alt + X` | Next track |
| `Ctrl + Alt + Z` | Previous track |

### System Management

| Keybind | Action |
|---------|--------|
| `Ctrl + Shift + R` | Reload bspwm |
| `Super + Escape + R` | Reload sxhkd |
| `Super + Delete` | Quit bspwm |

## Installation

1. Clone this repository

   ```bash
   git clone https://github.com/digitalcanine/bspwm-rice
   ```

2. Install dependencies (see Dependencies section)

3. Install JetBrainsMono Nerd Font

   ```bash
   # Arch Linux
   yay -S ttf-jetbrains-mono-nerd
   ```

4. Copy/symlink configuration files to `~/.config/` and the content of `.theme` to `~/.theme`

5. Set up [digitalCanine's MultiVPN](https://github.com/digitalcanine/multivpn) (optional)

6. Reload bspwm

   ```bash
   bspc wm -r
   # or use the keybind: Ctrl + Shift + R
   ```

## Dependencies

```
legcord
bspwm           # Window manager
sxhkd           # Hotkey daemon
picom           # Compositor
polybar         # Status bar
dunst           # Notification daemon
rofi            # Application launcher
kitty           # Terminal emulator
fish            # Shell
neovim          # Text editor
yazi            # Terminal file manager
spotatui        # Spotify TUI client
fastfetch       # System information tool
playerctl       # Media player controller
JetBrainsMono Nerd Font  # Primary font
flameshot       # Screenshot tool
pavucontrol     # Audio control
firefox         # Web browser
signal-desktop  # Messaging app
simplescreenrecorder  # Screen recording
feh             # Image viewer
xorg
```

### Custom Scripts

- [digitalCanine's MultiVPN](https://github.com/digitalcanine/multivpn) - VPN manager using OpenVPN profiles

## Color Palette

- Background: #141414 - Deep charcoal
- Foreground: #feffd3 - Soft cream
- Cursor: #ffffff - Pure white
- Selection: #303030 (bg) / #141414 (fg)

## License

Feel free to use and modify these configurations for your own setup!
