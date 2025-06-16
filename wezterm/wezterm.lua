local wezterm = require("wezterm")
local config = wezterm.config_builder()

local appearance = require("config.appearance")
local keymaps = require("config.keymaps")
local colors = require("config.colors")
local fonts = require("config.fonts")

appearance.apply(config)
keymaps.apply(config)
colors.apply(config)
fonts.apply(config)

return config
