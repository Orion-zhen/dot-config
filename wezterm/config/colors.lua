local module = {}

function module.apply(config)
    -- 配色方案
    -- 参考 https://github.com/mbadolato/iTerm2-Color-Schemes#screenshots
    config.color_scheme = "Dark+"
    config.colors = {}

    -- 标签栏配色
    config.colors.tab_bar = {
        background = "rgba(12%, 12%, 18%, 90%)", -- 整体背景
        -- 活跃标签页
        active_tab = {
            bg_color = "#8fb2c9",
            fg_color = "rgba(12%, 12%, 18%, 0%)",
            intensity = "Bold",
        },
        -- 非活跃标签页
        inactive_tab = {
            fg_color = "#8fb2c9",
            bg_color = "rgba(12%, 12%, 18%, 90%)",
            intensity = "Normal",
        },
        -- 非活跃标签页鼠标悬停
        inactive_tab_hover = {
            fg_color = "#8fb2c9",
            bg_color = "rgba(27%, 28%, 35%, 90%)",
            intensity = "Bold",
        },
        -- 新窗口
        new_tab = {
            fg_color = "#808080",
            bg_color = "#1e1e2e",
        },
    }
end

return module
