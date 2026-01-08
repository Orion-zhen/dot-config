# 当删除文件时, 提示确认
function rm --wraps rm
    command rm -i $argv
end