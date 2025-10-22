local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Synth Midnight Terminal Dark (base16)"
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true
config.colors = { cursor_bg = "#FBF9FF", cursor_fg = "black", cursor_border = "#FBF9FF", visual_bell = "#A0A0A0" }
config.default_cursor_style = "BlinkingBar"
config.audible_bell = "Disabled"
config.visual_bell =
	{ fade_in_function = "EaseIn", fade_in_duration_ms = 10, fade_out_function = "EaseOut", fade_out_duration_ms = 100 }
config.window_padding = { left = 6, right = 6, top = 6, bottom = 6 }
config.hyperlink_rules = {
	{ regex = [[FCA_RSP\-\d+]], format = "https://jiradc.ext.net.nokia.com/browse/$0" },
	{ regex = [[\b\w+:/\S+\b]], format = "$0" },
}

return config
