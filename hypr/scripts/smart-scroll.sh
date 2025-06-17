#!/bin/bash

# 检查是否提供了参数
if [ -z "$1" ]; then
    echo "错误: 请提供 'back' 或 'forward' 作为参数。"
    exit 1
fi

# 根据参数设置方向
direction=""
if [ "$1" = "back" ]; then
    direction="b"
elif [ "$1" = "forward" ]; then
    direction="f"
else
    echo "错误: 无效的参数 '$1'. 请使用 'back' 或 'forward'."
    exit 1
fi

# 检查当前窗口是否在组中
# hyprctl -j activewindow | jq '.grouped' 的输出是一个数组。
# 如果窗口不在组中, 它是一个空数组 '[]'
# 如果在组中，它会包含同组其他窗口的地址，例如 '["0x123", "0x456"]'
# 我们检查这个数组的长度是否大于 0
is_grouped=$(hyprctl -j activewindow | jq '.grouped | length > 0')

if [ "$is_grouped" = "true" ]; then
    # 如果在组中, 则在组内切换活动窗口
    hyprctl dispatch changegroupactive "$direction"
else
    # 如果不在组中, 则切换工作区
    if [ "$1" = "back" ]; then
        hyprctl dispatch workspace e-1
    else
        hyprctl dispatch workspace e+1
    fi
fi
