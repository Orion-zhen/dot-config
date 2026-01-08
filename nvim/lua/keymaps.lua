vim.g.mapleader = " " -- 空格键为 leader key
vim.g.maplocalleader = " " -- 空格键为 leader key

local set = vim.keymap.set
-- set 语法:
-- set(mode, lhs, rhs, opts)
-- 参数:
-- mode: vim 当前模式. 可选:
-- n: 普通模式, 打开文件时默认进入的模式, 用于移动和执行命令
-- i: 插入模式, 用于输入文本
-- v: 可视模式, 用于选中文本(就像鼠标拖选)
-- x: 可视块模式, 用于按列选中文本
-- t: 终端模式, 在 neovim 中内置终端中生效
---
-- lhs: 按下的键位, 字符串, 区分大小写. 可以是:
-- 普通按键: 单个字符组成的字符串. 多个字符表示连续按下对应键
-- 特殊按键: 必须用 <> 包裹. 如回车: "<CR>", Escape: "<Esc>", 空格: "<Space>", 退格: "<BS>" 等
-- 组合按键: Crtl, Alt, Shift 键. 如 Ctrl + c: "<C-c>", Alt + v: "<A-v>", Shift + d: "<S-d>"
-- leader: "<leader>"
---
-- rhs: 对应触发的动作, 可以是:
-- 模拟按键: 一个字符串, neovim 将执行这个字符串中的按键组合
-- lua 函数: 可以执行复杂的逻辑
---
-- opts: 选项, 一个 lua table

---
-- 分支 1: 高频动作
---

-- 保存文件
set({"n", "v", "x"}, "<C-s>", ":w<CR>", {
    desc = "保存文件"
})
set("i", "<C-s>", "<esc>:w<CR>", {
    desc = "保存文件"
})

-- ctrl+d 等效 esc
set("i", "<c-d>", "<esc>", {
    desc = "ESC"
})

-- 保存并退出
set({"n", "v", "x"}, "<leader>qq", ":wq<CR>", {
    desc = "保存并退出"
})

-- 撤销
set({"n", "v", "i"}, "<C-z>", "<ESC>u<CR>", {
    desc = "撤销"
})

-- 系统剪贴板
set({"n", "v"}, "<C-c>", '"+y', {
    desc = "复制到系统剪切板"
})
set({"n", "v"}, "<C-x>", '"+d', {
    desc = "剪切到系统剪切板"
})
set({"n", "v"}, "<C-p>", '"+p', {
    desc = "粘贴到系统剪切板"
})
