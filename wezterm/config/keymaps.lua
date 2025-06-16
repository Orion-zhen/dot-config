local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

function module.apply(config)
    -- 键位设置
    config.keys = {
        -- 标签页管理
        {
            -- Ctrl + T 新建标签页
            -- macOS: Command + T
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "t",
            action = act.SpawnTab("DefaultDomain")
        },
        {
            -- Ctrl + W 关闭标签页
            -- macOS: Command + T
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "w",
            -- 直接关闭
            action = act.CloseCurrentTab({ confirm = false })
        },

        -- ALT + 方向键 移动光标
        -- macOS: Option + 方向键
        {
            mods = "ALT",
            key = "LeftArrow",
            -- 移动到开头
            action = act.SendString("\u{1b}OH")
        },
        {
            mods = "ALT",
            key = "RightArrow",
            -- 移动到末尾
            action = act.SendString("\u{1b}OF")
        },
        -- Ctrl + Backspace 清空一行
        -- macOS: Command + Backspace
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "Backspace",
            action = act.SendString("\u{15}")
        },

        -- 分屏
        {
            -- Ctrl + \ 左右分屏
            -- macOS: Command + \
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "\\",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" })
        },
        {
            -- Ctrl + - 上下分屏
            -- macOS: Command + -
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "-",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" })
        },
        -- Ctrl + Vim 风格方向键 切换分屏光标
        -- macOS: Command + Vim 风格方向键
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "h",
            action = act.ActivatePaneDirection("Left")
        },
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "l",
            action = act.ActivatePaneDirection("Right")
        },
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "k",
            action = act.ActivatePaneDirection("Up")
        },
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "j",
            action = act.ActivatePaneDirection("Down")
        },
        -- Ctrl + M 切换分屏最大化
        -- macOS: Command + M
        {
            mods = (wezterm.target_triple == "aarch64-apple-darwin") and "CMD" or "CTRL",
            key = "m",
            action = act.TogglePaneZoomState
        }
    }
end

return module
