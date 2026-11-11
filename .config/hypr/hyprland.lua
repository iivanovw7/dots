local HOME = os.getenv("HOME") or ""

-- Programs
local terminal = "ghostty"
local fileManager = "thunar"
local menu = "hyprlauncher"

-- Monitors
local laptop = "eDP-1"
local monitor1 = "DVI-I-2"
local monitor2 = "DVI-I-1"

hl.monitor({
	output = laptop,
	mode = "1920x1080",
	position = "0x0",
	scale = 1,
})
hl.monitor({
	output = monitor1,
	mode = "preferred",
	position = "auto-right",
	scale = 1,
})
hl.monitor({
	output = monitor2,
	mode = "preferred",
	position = "auto-right",
	scale = 1,
})

-- Cursor and environment
hl.config({
	cursor = {
		no_hardware_cursors = true,
	},
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Capitaine Cursors - White")
hl.env("GTK_THEME", "monokai-gtk")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("WLC_REPEAT_RATE", "50")

-- Palette
local bg = "rgba(2d2a2eff)"
local bg_alt = "rgba(403e41ff)"
local fg = "rgba(fcfcfaff)"
local yellow = "rgba(ffd866ee)"
local pink = "rgba(ff6188ee)"
local green = "rgba(a9dc76ee)"
local purple = "rgba(ab9df2ee)"
local gray = "rgba(5b595cff)"

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 6,
		border_size = 1,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
		col = {
			active_border = yellow,
			inactive_border = gray,
		},
	},
	group = {
		groupbar = {
			enabled = true,
			font_size = 12,
			font_family = "JetBrainsMono Nerd Font",
			height = 22,
			gradients = false,
			render_titles = true,
			text_color = yellow,
			text_color_inactive = fg,
		},
		col = {
			border_active = yellow,
			border_inactive = bg_alt,
			border_locked_active = yellow,
			border_locked_inactive = bg_alt,
		},
	},
	decoration = {
		rounding = 0,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
			ignore_opacity = true,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:alt_shift_toggle",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
	xwayland = {
		force_zero_scaling = true,
	},
})

-- Animations
hl.curve("easeOutQuint", {
	type = "bezier",
	points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
	type = "bezier",
	points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", {
	type = "bezier",
	points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("almostLinear", {
	type = "bezier",
	points = { { 0.5, 0.5 }, { 0.75, 1 } },
})
hl.curve("quick", {
	type = "bezier",
	points = { { 0.15, 0 }, { 0.1, 1 } },
})

local animations = {
	{ "global", 10, "default" },
	{ "border", 5.39, "easeOutQuint" },
	{ "windows", 4.79, "easeOutQuint" },
	{ "windowsIn", 4.1, "easeOutQuint", "popin 87%" },
	{ "windowsOut", 1.49, "linear", "popin 87%" },
	{ "fadeIn", 1.73, "almostLinear" },
	{ "fadeOut", 1.46, "almostLinear" },
	{ "fade", 3.03, "quick" },
	{ "layers", 3.81, "easeOutQuint" },
	{ "layersIn", 4, "easeOutQuint", "fade" },
	{ "layersOut", 1.5, "linear", "fade" },
	{ "fadeLayersIn", 1.79, "almostLinear" },
	{ "fadeLayersOut", 1.39, "almostLinear" },
	{ "workspaces", 1.94, "almostLinear", "fade" },
	{ "workspacesIn", 1.21, "almostLinear", "fade" },
	{ "workspacesOut", 1.94, "almostLinear", "fade" },
	{ "zoomFactor", 7, "quick" },
}

for _, a in ipairs(animations) do
	hl.animation({
		leaf = a[1],
		enabled = true,
		speed = a[2],
		bezier = a[3],
		style = a[4],
	})
end

-- Input gestures and per-device settings
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

-- Keybindings
local keybinds = dofile(HOME .. "/.config/hypr/scripts/keybindings.lua")

local bind = keybinds.bind
local exec = keybinds.exec

exec("SUPER+RETURN", terminal) -- Open terminal
exec("SUPER+E", fileManager) -- Open file manager
bind("SUPER+V", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating window
exec("SUPER+R", "pkill -SIGUSR2 waybar") -- Reload Waybar
bind("SUPER+P", hl.dsp.window.pseudo()) -- Toggle pseudo-tiling
bind("SUPER+TAB", hl.dsp.layout("togglesplit")) -- Toggle split layout
bind("SUPER+F", hl.dsp.window.fullscreen({ action = "toggle" })) -- Toggle fullscreen

-- Group manipulation
bind("SUPER+G", hl.dsp.group.toggle()) -- Toggle window group

-- Add window to an existing group, or create one in that direction
bind("SUPER+ALT+H", hl.dsp.window.move({ into_or_create_group = "left" })) -- Add window to group on the left
bind("SUPER+ALT+L", hl.dsp.window.move({ into_or_create_group = "right" })) -- Add window to group on the right
bind("SUPER+ALT+K", hl.dsp.window.move({ into_or_create_group = "up" })) -- Add window to group above
bind("SUPER+ALT+J", hl.dsp.window.move({ into_or_create_group = "down" })) -- Add window to group below

-- Remove active window from its group
bind("SUPER+ALT+G", hl.dsp.window.move({ out_of_group = true })) -- Remove window from group

-- Switch between windows inside the group
bind("SUPER+CONTROL+TAB", hl.dsp.group.next()) -- Next window in group
bind("SUPER+CONTROL+SHIFT+TAB", hl.dsp.group.prev()) -- Previous window in group

-- Reorder windows inside the group
bind("SUPER+SHIFT+CONTROL+H", hl.dsp.group.move_window({ forward = false })) -- Move group tab backward
bind("SUPER+SHIFT+CONTROL+L", hl.dsp.group.move_window({ forward = true })) -- Move group tab forward

-- Session / application commands
exec("SUPER+SHIFT+M", "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit") -- Exit Hyprland
exec("SUPER+SHIFT+R", "hyprctl reload; pkill waybar; waybar >/dev/null 2>&1 &") -- Reload Hyprland and Waybar
bind("SUPER+SHIFT+C", hl.dsp.window.close()) -- Close active window
exec("SUPER+SHIFT+RETURN", "fuzzel") -- Open application launcher
exec("SUPER+SHIFT+Q", HOME .. "/.local/scripts/fuzzel-powermenu") -- Open power menu
exec("SUPER+SHIFT+I", HOME .. "/.local/scripts/input-switch") -- Switch input device
exec("SUPER+SHIFT+O", HOME .. "/.local/scripts/output-switch") -- Switch audio output
exec("SUPER+SHIFT+X", terminal .. " --title='hyprmoncfg-float' -e hyprmoncfg") -- Open monitor configuration
bind("SUPER+SHIFT+A", hl.dsp.workspace.toggle_special("ai-watcher")) -- Toggle AI workspace
exec("SUPER+A", terminal .. " --title='wiremix-float' -e wiremix") -- Open WireMix audio mixer
exec("SUPER+ESCAPE", terminal .. " --title='btop-float' -e bpytop") -- Open system monitor
exec("SUPER+Y", "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy") -- Open clipboard history
exec("SUPER+B", "pkill waybar || waybar") -- Toggle Waybar
exec("SUPER+T", HOME .. "/.local/scripts/fuzzel-keybindings") -- Show keyboard shortcuts
exec("SUPER+CONTROL+S", "bash -c 'grim -g \"$(slurp)\" - | satty -f - --copy-command wl-copy'") -- Take selected-area screenshot
exec("SUPER+CONTROL+A", "bash -c 'grim -t png - | satty --filename - --copy-command wl-copy'") -- Take full-screen screenshot

-- Focus
bind("SUPER+LEFT", hl.dsp.focus({ direction = "left" })) -- Focus window left
bind("SUPER+RIGHT", hl.dsp.focus({ direction = "right" })) -- Focus window right
bind("SUPER+UP", hl.dsp.focus({ direction = "up" })) -- Focus window above
bind("SUPER+DOWN", hl.dsp.focus({ direction = "down" })) -- Focus window below
bind("SUPER+H", hl.dsp.focus({ direction = "left" })) -- Focus window left
bind("SUPER+L", hl.dsp.focus({ direction = "right" })) -- Focus window right
bind("SUPER+K", hl.dsp.focus({ direction = "up" })) -- Focus window above
bind("SUPER+J", hl.dsp.focus({ direction = "down" })) -- Focus window below

-- Move windows
bind("SUPER+SHIFT+H", hl.dsp.window.move({ direction = "left" })) -- Move window left
bind("SUPER+SHIFT+L", hl.dsp.window.move({ direction = "right" })) -- Move window right
bind("SUPER+SHIFT+K", hl.dsp.window.move({ direction = "up" })) -- Move window up
bind("SUPER+SHIFT+J", hl.dsp.window.move({ direction = "down" })) -- Move window down
bind("SUPER+SHIFT+CONTROL+H", hl.dsp.group.move_window({ forward = false })) -- Move group tab backward
bind("SUPER+SHIFT+CONTROL+L", hl.dsp.group.move_window({ forward = true })) -- Move group tab forward

-- Resize windows
bind("SUPER+CONTROL+H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true }) -- Resize window left
bind("SUPER+CONTROL+L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true }) -- Resize window right
bind("SUPER+CONTROL+K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true }) -- Resize window up
bind("SUPER+CONTROL+J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true }) -- Resize window down

-- Workspaces 1-9
for i = 1, 9 do
	bind("SUPER+" .. tostring(i), hl.dsp.focus({ workspace = tostring(i) })) -- Switch to workspace
	bind("SUPER+SHIFT+" .. tostring(i), hl.dsp.window.move({ workspace = tostring(i) })) -- Move window to workspace
end

-- Workspace 10 and special workspace
bind("SUPER+0", hl.dsp.focus({ workspace = "10" })) -- Switch to workspace 10
bind("SUPER+SHIFT+0", hl.dsp.window.move({ workspace = "10" })) -- Move window to workspace 10
bind("SUPER+S", hl.dsp.workspace.toggle_special("magic")) -- Toggle special workspace
bind("SUPER+SHIFT+S", hl.dsp.window.move({ workspace = "special:magic" })) -- Move window to special workspace

-- Monitor focus
bind("SUPER+PERIOD", hl.dsp.focus({ monitor = "+" })) -- Focus next monitor
bind("SUPER+COMMA", hl.dsp.focus({ monitor = "-" })) -- Focus previous monitor

-- Mouse controls
bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag window with mouse
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize window with mouse

-- Laptop lid switch
exec("switch:off:Lid Switch", "hyprctl keyword monitor 'eDP-1, preferred, auto, 1'", { locked = true }) -- Enable laptop display when lid opens
exec("switch:on:Lid Switch", "hyprctl keyword monitor 'eDP-1, disable'", { locked = true }) -- Disable laptop display when lid closes

-- Multimedia keys
exec("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { repeating = true, locked = true }) -- Increase volume
exec("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { repeating = true, locked = true }) -- Decrease volume
exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true }) -- Toggle audio mute
exec("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true }) -- Toggle microphone mute
exec("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", { repeating = true, locked = true }) -- Increase screen brightness
exec("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", { repeating = true, locked = true }) -- Decrease screen brightness
exec("XF86AudioNext", "playerctl next", { locked = true }) -- Play next track
exec("XF86AudioPause", "playerctl play-pause", { locked = true }) -- Pause media playback
exec("XF86AudioPlay", "playerctl play-pause", { locked = true }) -- Toggle media playback
exec("XF86AudioPrev", "playerctl previous", { locked = true }) -- Play previous track

-- Window rules
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "floating-pink-border",
	match = { float = true },
	border_color = pink,
})

hl.window_rule({
	name = "floating-opacity",
	match = { float = true },
	opacity = "0.95",
})

local function rule(name, match, effects)
	local r = {
		name = name,
		match = match,
	}
	for k, v in pairs(effects) do
		r[k] = v
	end
	hl.window_rule(r)
end

-- Picture-in-picture
rule("pip-float", { title = "^(Picture-in-Picture)$" }, { float = true })
rule("pip-pin", { title = "^(Picture-in-Picture)$" }, { pin = true })
rule("zen-pip-float", { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, { float = true })
rule("zen-pip-pin", { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, { pin = true })

local utilityRules = {
	{ "hyprmoncfg", { title = "^(hyprmoncfg-float)$" }, "1200 900" },
	{ "wiremix", { title = "^(wiremix-float)$" }, "900 600" },
	{ "nm-connection-editor", { class = "^(nm-connection-editor)$" }, "600 400" },
	{ "volume-control", { title = "^(Volume Control)$" }, "900 700" },
	{ "pwvucontrol", { class = "^(com.saivert.pwvucontrol)$" }, "900 700" },
	{ "blueman-manager", { class = "^(blueman-manager)$" }, "900 700" },
	{ "btop", { title = "^(btop-float)$" }, "1200 900" },
	{ "nmtui", { title = "^(nmtui-float)$" }, "1200 900" },
}

for _, item in ipairs(utilityRules) do
	local name, match, size = item[1], item[2], item[3]
	rule(name .. "-float", match, { float = true })
	rule(name .. "-size", match, { size = size })
	rule(name .. "-center", match, { center = true })
end

rule("eww-dashboard-float", { class = "^(eww-dashboard)$" }, { float = true })
rule("eww-dashboard-pin", { class = "^(eww-dashboard)$" }, { pin = true })

-- Application workspace placement
rule("telegram-workspace", { class = "^(org.telegram.desktop)$" }, { workspace = "2" })
rule("steam-workspace", { class = "^(steam)$" }, { workspace = "5" })
rule("chromium-workspace", { class = "^(chromium)$" }, { workspace = "6" })
rule("zen-workspace", { class = "^(zen)$" }, { workspace = "7" })

-- Floating AI terminal
rule("ai-terminal-float", { class = "^(com\\.ai\\.floatingterminal)$" }, { float = true })
rule("ai-terminal-center", { class = "^(com\\.ai\\.floatingterminal)$" }, { center = true })
rule("ai-terminal-size", { class = "^(com\\.ai\\.floatingterminal)$" }, { size = "480 640" })
rule("ai-terminal-no-screen-share", { class = "^(com\\.ai\\.floatingterminal)$" }, { no_screen_share = true })
rule(
	"ai-terminal-workspace",
	{ class = "^(com\\.ai\\.floatingterminal)$" },
	{ workspace = "special:ai-watcher silent" }
)

-- Layer rules
hl.layer_rule({
	match = { namespace = "^(fuzzel)$" },
	blur = true,
	ignore_alpha = 0.1,
})

-- Workspace-to-monitor assignments
for i = 1, 5 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = monitor1,
		default = (i == 1),
	})
end

for i = 6, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = monitor2,
		default = (i == 6),
	})
end

-- Startup applications and services
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
	)
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
	hl.exec_cmd("pkill swaybg; swaybg -m fill -i " .. HOME .. "/Backgrounds/desktop.png >/dev/null 2>&1 &")
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("mako")
	hl.exec_cmd(HOME .. "/.config/waybar/launch.sh")
	hl.exec_cmd(HOME .. "/.config/quickshell/run.sh")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("xrdb -merge ~/.Xresources")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Dracula'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Capitaine Cursors - White'")
end)

-- Load optional generated monitor rules last.
do
	local path = HOME .. "/.config/hypr/hyprmoncfg-monitors.lua"
	local file = io.open(path, "r")
	if file then
		file:close()
		dofile(path)
	end
end

do
	local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"
	local file = io.open(path, "r")
	if file then
		file:close()
		dofile(path)
	end
end

do
	local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"
	local file = io.open(path, "r")
	if file then
		file:close()
		dofile(path)
	end
end

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do
	local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"
	local file = io.open(path, "r")
	if file then
		file:close()
		dofile(path)
	end
end
