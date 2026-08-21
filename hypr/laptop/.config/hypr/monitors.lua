local built_in = "eDP-1"
local hdmi = "HDMI-A-1"
local display_port = "DP-1" -- via USB

hl.monitor({ output = built_in, mode = "1920x1080", position = "0x0", scale = 1 })
hl.monitor({ output = hdmi, mode = "3840x2160", position = "auto-left", scale = "auto" })
hl.monitor({ output = display_port, mode = "3840x2160", position = "auto-up", scale = "auto" })

MONITORS = {
	MAIN = hdmi,
	SECONDARY = built_in,
}
