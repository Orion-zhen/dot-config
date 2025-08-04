#!/usr/bin/env bash

# 定义壁纸存放的目录
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"

# 检查壁纸目录是否存在
if [ ! -d "$WALLPAPER_DIR" ]; then
    rofi -e "错误: 壁纸目录 '$WALLPAPER_DIR' 不存在."
    exit 1
fi

# 生成 rofi 的输入列表
# 关键改动:
# 1. 使用 echo -e 来解析特殊字符.
# 2. 格式为 "文本\0icon\x1f图片路径".
#    - \0 是空字符
#    - icon\x1f 是 rofi 的特殊元数据标记, 告诉它后面是图标路径.
#    - $file 是壁纸的完整路径, rofi 会用它来生成预览.
WALLPAPER_LIST=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | sort)

SELECTED_BASENAME=$(echo -e "$WALLPAPER_LIST" | while read -r file; do
    echo -e "$(basename "$file")\0icon\x1f$file"
done | rofi -dmenu -show-icons -i -p "󰸉 选择壁纸")

# 如果用户在 rofi 中按下了 Esc (取消选择), SELECTED_BASENAME 会为空, 此时脚本直接退出
if [ -z "$SELECTED_BASENAME" ]; then
    exit 0
fi

# 根据用户选择的文件名, 找到它在壁纸目录中的完整路径
# (因为 rofi 的输出只有文件名, 我们仍然需要这一步)
WALLPAPER_FULL_PATH=$(find "$WALLPAPER_DIR" -type f -name "$SELECTED_BASENAME" | head -n 1)

# 如果没有找到对应的文件路径 (理论上不应发生), 则退出
if [ -z "$WALLPAPER_FULL_PATH" ]; then
    rofi -e "错误: 无法找到壁纸 '$SELECTED_BASENAME' 的路径."
    exit 1
fi

# 获取当前聚焦的显示器名称
FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# 使用 hyprpaper 设置壁纸
hyprctl hyprpaper reload "$FOCUSED_MONITOR","$WALLPAPER_FULL_PATH"