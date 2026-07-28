require("monitors")

local terminal = "ghostty"
local file_manager = "yazi"
local menu = "wofi --show drun"
local browser = "zen-browser"

-- #######################
-- ### WORKSPACE RULES ###
-- #######################

hl.workspace_rule({ workspace = "1", monitor = MONITORS.MAIN, default = true, on_created_empty = browser })
hl.workspace_rule({
	workspace = "2",
	monitor = MONITORS.MAIN,
	default = true,
	on_created_empty = terminal .. "-e" .. file_manager,
})
hl.workspace_rule({ workspace = "3", monitor = MONITORS.SECONDARY, default = true, on_created_empty = "mattermost-desktop" })
hl.workspace_rule({ workspace = "5", monitor = MONITORS.MAIN, default = true, on_created_empty = "spotify-launcher" }) -- for TUI: `ghostty -e spotify_player`
hl.workspace_rule({
	workspace = "6",
	monitor = MONITORS.MAIN,
	default = true,
	on_created_empty = "OBSIDIAN_USE_WAYLAND=1 obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland",
})
hl.workspace_rule({ workspace = "7", monitor = MONITORS.MAIN, default = true, on_created_empty = terminal })
hl.workspace_rule({ workspace = "8", monitor = MONITORS.SECONDARY, default = true, on_created_empty = browser })

-- #################
-- ### AUTOSTART ###
-- #################

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper & waybar")
	hl.exec_cmd("systemctl --user start hyprpolkitagent ") -- for authentication notifications
end)

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- #####################
-- ### LOOK AND FEEL ###
-- #####################

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 0,
		col = {
			active_border = "rgba(d08770ff)",
			inactive_border = "rgba(d0877088)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 4,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = false,
	},
})

hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

-- #############
-- ### INPUT ###
-- #############

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		kb_options = "",
		kb_model = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = -0.45, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- touchpad on the thinkpad t14s
hl.device({
	name = "elan0678:00-04f3:3195-touchpad",
	sensitivity = 0,
	accel_profile = "flat",
})

-- ###################
-- ### KEYBINDINGS ###
-- ###################

local main_mod = "SUPER"

hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + F4", hl.dsp.window.close())
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --output-folder ~/Pictures/Screenshots"))

-- Move focus with main_mod + arrow keys
hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces mainMod with main_mod + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- TODO: fix -- Move active window to a monitor L - R
-- hl.bind("CTRL + ALT + " .. main_mod .. " + SHIFT + L", hl.dsp.workspace.move({ direction = "right" }))
-- hl.bind("CTRL + ALT + " .. main_mod .. " + SHIFT + H", hl.dsp.workspace.move({ direction = "left" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multiedia keys for volume - call a script to notify dunst - requires wpctl
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mute"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Brightness - requires brightnessctl
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh down"))

-- Media - Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
