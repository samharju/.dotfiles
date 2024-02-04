-- Using just in windows

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
--config.color_scheme = 'AdventureTime'

--config.font = wezterm.font('BitstromWera Nerd Font Mono', { weight = 'Regular'} )
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
	cursor_bg = '#FBF9FF',
	cursor_fg = 'black',
	cursor_border = '#52ad70',
}

config.default_cursor_style = 'BlinkingBar'

config.window_background_image = 'C:/Users/sharju/Pictures/Wallpapers/isis-franca-hsPFuudRg5I-unsplash.jpg'
config.window_background_image_hsb = {
  brightness = 0.05,
}
config.window_background_opacity = 1.0
config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

-- and finally, return the configuration to wezterm
return config
