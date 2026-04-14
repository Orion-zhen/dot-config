local opt = vim.opt

local tabsize = 2

-- 顶端窗口提示
opt.winbar = "%=%m %f"

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
opt.conceallevel = 0             -- 禁用自动隐藏, 比如隐藏掉 Markdown 中的代码块

opt.autoindent = true            -- 自动缩进
opt.smartindent = true           -- 智能缩进
opt.expandtab = true             -- 用空格代替缩进
opt.shiftwidth = tabsize         -- 缩进空格数
opt.tabstop = tabsize            -- tab

opt.hlsearch = true              -- 高亮搜索结果
opt.incsearch = true             -- 实时显示搜索结果
opt.ignorecase = true            -- 搜索忽略大小写
opt.smartcase = true             -- 如果搜索词中包含大写字母, 则不忽略大小写

opt.autoread = true              -- 自动读取别处的更改

opt.clipboard = "unnamedplus"    -- 使用系统剪贴板

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
