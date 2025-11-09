local opt = vim.opt

local tabsize = 4

-- 顶端窗口提示
opt.winbar = "%=%m %f"

opt.wrap = true -- 自动折行

opt.number = true -- 显示行号
opt.relativenumber = false -- 相对行号
opt.signcolumn = "yes" -- 始终显示符号列
opt.cursorline = true -- 显示光标行

opt.showmatch = true -- 显示匹配括号

opt.guifont = { "Hack Nerd Font" } -- GUI字体
opt.list = true
-- opt.listchars = { space = "·" } -- 显示空格
opt.conceallevel = 0 -- 禁用自动隐藏, 比如隐藏掉 Markdown 中的代码块

opt.autoindent = true -- 自动缩进
opt.smartindent = true -- 智能缩进
opt.expandtab = true -- 用空格代替缩进
opt.shiftwidth = tabsize -- 缩进空格数
opt.tabstop = tabsize -- tab

opt.hlsearch = true -- 高亮搜索结果
opt.incsearch = true -- 实时显示搜索结果
opt.ignorecase = true -- 搜索忽略大小写
opt.smartcase = true -- 如果搜索词中包含大写字母, 则不忽略大小写

opt.clipboard = "unnamedplus" -- 使用系统剪贴板
