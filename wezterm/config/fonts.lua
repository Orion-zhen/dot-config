local wezterm = require("wezterm")

local module = {}

function module.apply(config)
    -- 字体设置
    config.font = wezterm.font_with_fallback(
        {
            { family = "Maple Mono NF",    style = "Normal" },
            { family = "Hack Nerd Font",   style = "Normal" },
            { family = "Noto Sans CJK SC", style = "Normal" }
        }
    )
    config.font_size = 15.0
end

return module
