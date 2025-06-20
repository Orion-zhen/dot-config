local module = {}

function module.apply(config)
    -- 检测 hyprland 环境
    local is_hyprland = os.getenv("HYPRLAND_INSTANCE_SIGNATURE") ~= nil

    -- 标签栏配置
    config.enable_tab_bar = true
    -- 样式
    config.use_fancy_tab_bar = true
    -- 仅有一个标签页时关闭标签栏
    if is_hyprland then
        config.hide_tab_bar_if_only_one_tab = true
    end
    -- 标签栏置底
    config.tab_bar_at_bottom = false

    -- 非活跃窗口变暗
    config.inactive_pane_hsb = {
        saturation = 0.9, -- 降低饱和度
        brightness = 0.9, -- 降低亮度
    }

    -- 终端背景
    -- config.window_background_image = "/path/to/my/wallpaper"
    -- 背景图片设置
    config.window_background_image_hsb = {
        brightness = 0.3, -- 图片亮度
        hue = 1.0,        -- 图片色调, 1.0 为保持不变
        saturation = 1.0, -- 饱和度, 1.0 为保持不变
    }

    -- 背景不透明度
    config.window_background_opacity = 0.4
    -- 背景模糊
    config.macos_window_background_blur = 32
    config.kde_window_background_blur = true

    -- 窗口栏设置
    -- RESIZE: 可调整大小
    -- TITLE: 启用标题栏
    -- NONE: 啥都没有
    -- MACOS_FORCE_ENABLE_SHADOW: 启用阴影效果
    -- INTEGRATED_BUTTONS: 将窗口管理按钮内嵌到标签栏中
    if is_hyprland then
        config.window_decorations = "NONE"
    else
        config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW | INTEGRATED_BUTTONS"
    end

    -- 启用滚动条
    config.enable_scroll_bar = false
    -- 使用 macOS 系统级全屏
    config.native_macos_fullscreen_mode = true
end

return module
