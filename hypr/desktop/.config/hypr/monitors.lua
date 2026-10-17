local display_port = "DP-1"

hl.monitor({ output = display_port, mode = "5120x2160@180", position = "0x0", scale = 1.25 })

MONITORS = {
	MAIN = display_port,
	SECONDARY = display_port,
}
