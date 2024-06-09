-- Using just in windows, keep in dotfiles for easy copy pasting

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
--config.color_scheme = 'AdventureTime'
--config.color_scheme = 'One Half Black (Gogh)'



--config.font = wezterm.font('BitstromWera Nerd Font Mono', { weight = 'Regular'} )
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
    cursor_bg = '#FBF9FF',
    cursor_fg = 'black',
    cursor_border = '#FBF9FF',
    visual_bell = '#A0A0A0',
}

config.default_cursor_style = 'BlinkingBar'
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 10,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 100,
}

local function image_choice() 
	local images = {
		'C:/Users/sharju/Pictures/Wallpapers/american-public-power-association-bv2pvCGMtzg-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-CKSef84w0Nc-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-SLIFI67jv5k-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-TQUPXwRMrPA-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-UYTobvtRbEU-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-_qWeqqmpBpU-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-io7dX_1EFCg-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ant-rozetsky-lI7sCqOAt1Q-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/earth.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/isis-franca-hsPFuudRg5I-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/maksym-kaharlytskyi-kDVaFjoQf4M-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/paul-volkmer-qVotvbsuM_c-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/peter-herrmann-z6DJJZ1-1Cg-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/ricardo-gomez-angel-41X6FwTwPh4-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/robin-sommer-wnOJ83k8r4w-unsplash.jpg',
		'C:/Users/sharju/Pictures/Wallpapers/thom-schneider-iSYYLt2rKac-unsplash.jpg',
	}

	return images[math.random(#images)]
end

local bg = image_choice()

local dimmer = { brightness = 0.025 }

config.background = {
    {
        source = {
            File = bg
        },
        width = "100%",
        hsb = dimmer,
    }

}

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.hyperlink_rules = {
    {
        regex = [[FCA_RSP\-\d+]],
        format = "https://jiradc.ext.net.nokia.com/browse/$0"
    },
    {
        regex = [[\b\w+:/\S+\b]],
        format = "$0"
    }
}

-- and finally, return the configuration to wezterm
return config

