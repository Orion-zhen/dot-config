-- vim.opt 提供类型友好的 Neovim 选项接口. 它等价于 :set, 但可以直接使用 Lua 值.
local opt = vim.opt

-- 默认使用 2 个空格缩进. 如果项目包含 .editorconfig, Neovim 可以按项目覆盖相关选项.
local tabsize = 2

-- 触发 CursorHold 等空闲事件前等待 500 ms. LSP 的符号引用高亮依赖这个事件.
opt.updatetime = 500
-- winbar 使用 Neovim 原生格式项. %= 右对齐, %m 显示修改标记, %f 显示文件路径.
opt.winbar = "%=%m %f"

-- 长行显示设置.
opt.wrap = true -- 超出窗口宽度时在屏幕上折行, 不修改文件内容.
opt.breakindent = true -- 折行后的屏幕行保持与原始文本相同的缩进.
opt.linebreak = true -- 尽量在单词边界折行, 避免从单词中间断开.
opt.smoothscroll = true -- 光标经过很长的折行文本时按屏幕行平滑滚动.

opt.mouse = "a" -- 在普通, 插入, 可视, 命令行和帮助等模式中启用鼠标.

-- 左侧栏和光标定位设置.
opt.number = true -- 显示绝对行号.
opt.relativenumber = false -- 不显示相对行号. 开启后其他行会显示与光标的距离.
opt.signcolumn = "yes" -- 始终保留 signcolumn, 防止诊断或 Git 标记出现时文本左右跳动.
opt.cursorline = true -- 高亮光标所在行, 方便在宽窗口中定位.
opt.scrolloff = 5 -- 垂直滚动时尽量在光标上下各保留 5 行.
opt.sidescrolloff = 5 -- 水平滚动时尽量在光标左右各保留 5 列.

opt.showmatch = true -- 输入括号时短暂显示与之匹配的括号.
opt.showmode = false -- 不在命令行显示模式, 因为自定义状态栏已经显示模式.

-- guifont 只对 Neovide 等图形前端生效, 终端中的字体由终端模拟器控制.
opt.guifont = { "Maple Mono NF" }
opt.list = true -- 允许通过 listchars 显示 Tab, 尾随空格等不可见字符.
opt.conceallevel = 0 -- 不隐藏 Markdown 标记等文本, 文件内容始终按原样显示.

-- 缩进设置.
opt.autoindent = true -- 新行继承上一行的缩进.
opt.smartindent = true -- 对 C 风格的大括号等结构自动增减缩进.
opt.expandtab = true -- 按 Tab 时插入空格, 不写入真实 Tab 字符.
opt.shiftwidth = tabsize -- >>, << 和自动缩进每次移动 2 列.
opt.tabstop = tabsize -- 文件中的真实 Tab 字符在屏幕上按 2 列显示.

-- 搜索和替换设置.
opt.hlsearch = true -- 高亮最近一次搜索的所有匹配项.
opt.incsearch = true -- 输入搜索内容时实时跳转到当前匹配项.
opt.ignorecase = true -- 默认忽略搜索内容的大小写.
opt.smartcase = true -- 搜索内容包含大写字母时自动改为区分大小写.
opt.inccommand = "split" -- 输入 :substitute 时在分屏中实时预览替换结果.

-- 文件和撤销设置.
opt.autoread = true -- 缓冲区未修改时, 允许 :checktime 自动读取磁盘上的外部修改.
opt.confirm = true -- 关闭存在未保存内容的缓冲区时显示确认对话框, 而不是直接报错.
opt.undofile = true -- 将撤销历史保存到磁盘, 重启 Neovim 后仍可继续撤销.

-- 新分屏默认出现在当前窗口右侧或下方, 与常见图形编辑器一致.
opt.splitright = true
opt.splitbelow = true

-- 代码折叠设置.
opt.foldcolumn = "auto:1" -- 左侧最多显示 1 列折叠标记, 存在折叠时自动出现, 并支持鼠标点击.
opt.foldlevel = 99 -- 打开缓冲区后默认展开深度不超过 99 的折叠, 即通常全部展开.
opt.foldlevelstart = 99 -- 新窗口使用 99 作为初始折叠级别.
opt.foldmethod = "indent" -- 没有 LSP 折叠能力时按缩进生成折叠. 支持 LSP 时会在 LspAttach 中覆盖.

opt.clipboard = "unnamedplus" -- 让普通复制, 删除和粘贴默认使用系统剪贴板的 + 寄存器.

-- 插入模式自动补全. 优先使用 LSP, 然后使用当前和已打开缓冲区中的单词.
opt.autocomplete = true -- 输入时自动打开补全菜单, 不必每次手动按 <C-Space>.
opt.autocompletedelay = 80 -- 输入停止 80 ms 后请求并显示自动补全.
-- complete 中的来源按顺序参与补全: o 是 omni/LSP, . 是当前缓冲区, w 是其他窗口, b 是其他缓冲区.
-- 越靠前的来源优先级越高. ^10 和 ^5 分别限制该来源最多提供 10 项和 5 项候选结果.
opt.complete = { "o", ".^10", "w^5", "b^5" }
-- menuone 即使只有一项也显示菜单, noselect 不自动选中, fuzzy 启用模糊匹配, popup 显示附加文档.
opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
-- 补全项从左到右显示类型, 文本和附加来源.
opt.completeitemalign = { "kind", "abbr", "menu" }

-- 命令行补全设置.
opt.wildmenu = true -- 为 :edit, :help 等命令显示候选菜单.
opt.wildoptions = "pum" -- 使用与插入补全相似的弹出菜单显示候选项.
opt.wildmode = "longest:full,full" -- 第一次补全公共前缀并显示菜单, 后续按键循环选择完整候选项.

-- 弹出菜单外观.
opt.termguicolors = true -- 启用 24 位真彩色, 让配色方案使用完整的真彩色调色板.
vim.cmd.colorscheme("catppuccin") -- 使用 Neovim 内置的 Catppuccin 配色方案.
-- 关闭 Neovim 窗口层之间的混合, 避免底层文字透入. 高亮仍使用 bg = "none", 因此保留终端透明和模糊效果.
opt.winblend = 0
opt.pumblend = 0
opt.pumborder = "rounded" -- 为补全菜单使用圆角边框.
opt.pumheight = 20 -- 补全菜单最多显示 20 行, 其余内容通过滚动查看.

-- 命令行文件补全时忽略常见构建产物和不希望直接编辑的文件.
-- 这个选项不会改变 MiniPick 的搜索规则. MiniPick 主要遵循 rg, fd 和 Git 的忽略规则.
opt.wildignore = {
  "*.o", -- C 和 C++ 目标文件.
  "*.a", -- 静态链接库.
  "*.so", -- 动态链接库.
  "*.out", -- 常见可执行文件或输出文件.
  "*.aux", -- LaTeX 辅助文件.
  "*.bbl", -- BibTeX 生成的参考文献文件.
  "*.blg", -- BibTeX 日志.
  "*.jpg", -- 图片文件.
  "*.png", -- 图片文件.
  "*.pdf", -- PDF 文档.
  ".git", -- Git 内部目录.
  ".obsidian", -- Obsidian 配置目录.
}

-- 只覆盖大面积界面的背景. 前景色、边框色和文字属性仍由当前配色方案决定.
local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "FloatFooter",
  "FloatShadow",
  "FloatShadowThrough",
  "Pmenu",
  "PmenuKind",
  "PmenuExtra",
  "PmenuMatch",
  "PmenuBorder",
  "PmenuSbar",
  "PmenuShadow",
  "PmenuShadowThrough",
  "SignColumn",
  "FoldColumn",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "WinBar",
  "WinBarNC",
  "ColorColumn",
  "CursorLine",
}

-- 自定义标签栏从配色方案的标准高亮组派生颜色, 再添加用于区分缓冲区状态的文字属性.
-- 不直接链接到 TabLineFill, 因为部分透明配色中的该组只有背景色, 移除背景后会失去样式.
local tabline_highlight_specs = {
  UserTablineCurrent = { source = "TabLineSel", bold = true },
  UserTablineVisible = { source = "Comment" },
  UserTablineHidden = { source = "TabLine" },
  UserTablineModifiedCurrent = { source = "WarningMsg", bold = true },
  UserTablineModifiedVisible = { source = "WarningMsg" },
  UserTablineModifiedHidden = { source = "WarningMsg", dim = true },
  UserTablineSeparator = { source = "WinSeparator" },
  UserTablineTrunc = { source = "NonText" },
}

local function apply_appearance()
  for _, group in ipairs(transparent_groups) do
    -- 先读取配色方案给出的完整样式, 再只移除背景, 避免覆盖前景色和粗体等属性.
    local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
    highlight.bg = nil
    highlight.ctermbg = nil
    vim.api.nvim_set_hl(0, group, highlight)
  end

  for group, spec in pairs(tabline_highlight_specs) do
    local highlight = vim.api.nvim_get_hl(0, { name = spec.source, link = false })
    highlight.bg = nil
    highlight.ctermbg = nil

    for attribute, value in pairs(spec) do
      if attribute ~= "source" then
        highlight[attribute] = value
      end
    end

    vim.api.nvim_set_hl(0, group, highlight)
  end
end

-- 每次切换配色方案后重新移除背景, 其余样式继续使用新配色方案的定义.
local appearance_group = vim.api.nvim_create_augroup("user.appearance", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = appearance_group,
  pattern = "*",
  callback = apply_appearance,
})

-- Catppuccin 在上面创建自动命令前加载, 因此启动时主动应用一次透明背景.
apply_appearance()
