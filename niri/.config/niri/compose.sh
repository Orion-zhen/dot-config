#!/bin/bash

# ---
# 安全地将 conf.d/ 目录下的所有 .kdl 文件合并到 config.kdl,
# 确保每个文件内容之间至少有一个换行符分隔。
# ---

# 设置工作目录为脚本所在的目录, 这样无论从哪里运行此脚本都能正常工作
cd "$(dirname "$0")"

# 定义源目录和目标文件
SOURCE_DIR="conf.d"
TARGET_FILE="config.kdl"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "错误: 源目录 '${SOURCE_DIR}' 不存在。"
    exit 1
fi

echo "正在从 '${SOURCE_DIR}/' 构建 '${TARGET_FILE}'..."

# 核心改动：
# 1. 使用 for 循环遍历每一个 .kdl 文件。
# 2. 对整个循环体使用 I/O 重定向, 只打开一次目标文件, 效率更高。
# 3. 在每次 cat 文件内容后, 使用 printf "\n" 输出一个换行符。
#    (使用 printf 比 echo 更可靠、更具可移植性)
{
    for part in "${SOURCE_DIR}"/*.kdl; do
        # 这个检查很重要, 确保在 conf.d 目录为空时, 脚本不会因找不到文件而出错
        [ -e "$part" ] || continue

        cat "$part"
        printf "\n"
    done
} > "$TARGET_FILE"

echo "构建完成。"