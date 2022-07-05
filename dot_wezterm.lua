local wezterm = require 'wezterm';

return {
	color_scheme = "Urple",
    font = wezterm.font("Iosevka"),
    font_size = 12,
    use_fancy_tab_bar = false,
    window_padding = {
        left = 8,
        right = 8,
        bottom = 2,
        up = 8,
    },
    warn_about_missing_glyphs = false, 
}
