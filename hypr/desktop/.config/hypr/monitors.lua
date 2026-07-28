local display_port = "DP-1"

hl.monitor({
	output = display_port,
	mode = "2560x1440@165",
	position = "0x0",
	scale = 1,
})

MONITORS = {
	MAIN = display_port,
	SECONDARY = display_port,
}
