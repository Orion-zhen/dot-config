local opt = vim.opt

local tabsize = 2

opt.updatetime = 2000             -- 窗口更新间隔 ms
opt.winbar = "%=%m %f"            -- 顶端窗口提示

opt.wrap = true                   -- 自动折行

opt.mouse = "a"                   -- 全鼠标支持

opt.number = true                 -- 显示行号
opt.relativenumber = false        -- 相对行号
opt.signcolumn = "yes"            -- 始终显示符号列
opt.cursorline = true             -- 显示光标行
opt.scrolloff = 5                 -- 光标上下方始终有几行
opt.sidescrolloff = 5             -- 光标左右边始终有几列

opt.showmatch = true              -- 显示匹配括号
opt.showmode = false              -- 不显示模式状态, 只留在状态栏中

opt.guifont = { "Maple Mono NF" } -- GUI字体
opt.list = true
-- opt.listchars = { space = "·" } -- 显示空格
opt.conceallevel = 0          -- 禁用自动隐藏, 比如隐藏掉 Markdown 中的代码块

opt.autoindent = true         -- 自动缩进
opt.smartindent = true        -- 智能缩进
opt.expandtab = true          -- 用空格代替缩进
opt.shiftwidth = tabsize      -- 缩进空格数
opt.tabstop = tabsize         -- tab

opt.hlsearch = true           -- 高亮搜索结果
opt.incsearch = true          -- 实时显示搜索结果
opt.ignorecase = true         -- 搜索忽略大小写
opt.smartcase = true          -- 如果搜索词中包含大写字母, 则不忽略大小写

opt.autoread = true           -- 自动读取别处的更改

opt.clipboard = "unnamedplus" -- 使用系统剪贴板

-- 开启现代化的浮动弹窗 (Popup Menu)
vim.opt.wildmenu = true
vim.opt.wildoptions = "pum"

-- 界面显示优化
vim.opt.pumblend = 15  -- 设置弹出菜单的背景透明度为 15% (需要终端本身支持真色彩和透明)
vim.opt.pumheight = 20 -- 限制菜单的最大高度为 20 行，保持界面清爽，避免遮挡代码

-- 交互逻辑优化：现代 Shell 风格 (类似 Fish)
-- longest: 第一次按 Tab 补全最长公共前缀
-- full: 第二次按 Tab 完全展开并进入菜单循环选择
vim.opt.wildmode = "longest:full,full"

-- 视觉降噪：过滤掉不需要在命令提示中出现的文件
-- 这能极大提升路径补全时的视觉信噪比
vim.opt.wildignore = {
  "*.o", "*.a", "*.so", "*.out", -- C/C++ 编译产物
  "*.aux", "*.bbl", "*.blg",     -- LaTeX 临时文件
  "*.jpg", "*.png", "*.pdf",     -- 媒体与文档文件
  ".git", ".obsidian"            -- 隐藏的配置与版本控制目录
}

-- 高亮与色彩微调
-- 让弹窗的背景更柔和，选中项更醒目 (这里使用的是偏暗黑现代风格的配色逻辑)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "#24273A", fg = "#CAD3F5" })                 -- 菜单主体
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#8AADF4", fg = "#24273A", bold = true }) -- 选中状态
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#1E2030" })                             -- 滚动条背景
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#5B6078" })                            -- 滚动条滑块
  end,
})

local function set_transparent() -- set UI component to transparent
  local groups = {
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "ColorColumn",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#8FB2C9" })
end

set_transparent()
