-- vim.pack.add 使用 Neovim 原生包管理器安装并加载插件.
-- 第一个参数是插件地址列表. 第二个参数中的 load = true 表示安装完成后立即加入 runtimepath.
vim.pack.add({
  "https://www.github.com/lewis6991/gitsigns.nvim", -- 在 signcolumn 中显示并操作 Git 变更.
  "https://www.github.com/nvim-mini/mini.nvim", -- 一个仓库提供多个相互独立的小型编辑器模块.
  "https://github.com/nvim-treesitter/nvim-treesitter", -- 安装 Tree-sitter 解析器和查询文件.
}, {
  load = true,
})

-- nvim-treesitter 只管理解析器和查询文件. 语法高亮由 Neovim 内置的 vim.treesitter.start 启用.
require("nvim-treesitter").install({
  "bash",
  "c",
  "cpp",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
})

require("gitsigns").setup({
  -- signs 定义 Git 变更在左侧 signcolumn 中显示的字符.
  signs = {
    add = { text = "\u{2590}" }, -- 新增行.
    change = { text = "\u{2590}" }, -- 已修改行.
    delete = { text = "\u{2590}" }, -- 当前位置之后存在删除内容.
    topdelete = { text = "\u{25e6}" }, -- 文件顶部存在删除内容.
    changedelete = { text = "\u{25cf}" }, -- 同一个 hunk 同时包含修改和删除.
    untracked = { text = "\u{25cb}" }, -- Git 尚未跟踪的新文件或新行.
  },
  signcolumn = true, -- 在 signcolumn 中显示上述标记.
  current_line_blame = false, -- 不持续显示 blame, 需要时通过 <leader>gb 手动查看.

  -- on_attach 在 Gitsigns 成功连接到一个 Git 缓冲区后运行.
  -- bufnr 是该缓冲区的数字编号. 使用 buffer = bufnr 可以避免 Git 快捷键污染普通文件.
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    -- 统一创建当前缓冲区的 Git 快捷键.
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr, -- 只在当前 Git 缓冲区中生效.
        desc = desc, -- 供 mini.clue 和快捷键选择器显示.
      })
    end

    -- nav_hunk 在当前文件的 Git 变更块之间跳转. next 和 prev 分别表示向后和向前.
    map("n", "]h", function()
      gitsigns.nav_hunk("next")
    end, "下一个 Git 变更块")
    map("n", "[h", function()
      gitsigns.nav_hunk("prev")
    end, "上一个 Git 变更块")

    map("n", "<leader>gp", gitsigns.preview_hunk, "预览 Git 变更块")
    map("n", "<leader>gs", gitsigns.stage_hunk, "暂存 Git 变更块")
    map("n", "<leader>gr", gitsigns.reset_hunk, "还原 Git 变更块")
    map("n", "<leader>gb", function()
      -- full = true 显示完整提交哈希, 作者, 时间和提交信息.
      gitsigns.blame_line({ full = true })
    end, "显示当前行提交信息")
    map("n", "<leader>gd", gitsigns.diffthis, "比较 Git 变更")

    -- 可视模式的起点和终点可能与选择方向相反. math.min 和 math.max 将范围整理为从小到大.
    local function visual_range()
      local first = vim.fn.line("v") -- v 标记表示可视选择开始位置.
      local last = vim.fn.line(".") -- . 表示当前光标位置.
      return { math.min(first, last), math.max(first, last) }
    end

    -- 向 stage_hunk 或 reset_hunk 传入 { 起始行, 结束行 }, 只操作选中的部分.
    map("x", "<leader>gs", function()
      gitsigns.stage_hunk(visual_range())
    end, "暂存选中的 Git 变更")
    map("x", "<leader>gr", function()
      gitsigns.reset_hunk(visual_range())
    end, "还原选中的 Git 变更")
  end,
})

-- mini.nvim 中每个模块都可以独立启用. setup({}) 表示采用该模块的默认配置.
require("mini.ai").setup({}) -- 扩展 a 和 i 文本对象, 支持函数参数, 括号和自定义范围.
require("mini.bufremove").setup({}) -- 删除缓冲区时尽量保留现有窗口布局.
require("mini.files").setup({
  -- windows 控制列式文件浏览器的窗口布局.
  windows = {
    preview = true, -- 在焦点列右侧显示文件内容或子目录预览.
    width_focus = 35, -- 当前操作列宽度为 35 个字符.
    width_preview = 80, -- 预览列宽度为 80 个字符.
  },
})
require("mini.icons").setup({}) -- 根据文件名和文件类型提供图标, 供选择器, 标签栏和状态栏使用.
require("mini.indentscope").setup({}) -- 显示当前代码缩进范围, 并提供范围跳转和文本对象.
require("mini.move").setup({}) -- 使用 Alt+h/j/k/l 移动当前行或可视选区.
require("mini.notify").setup({}) -- 使用统一的悬浮窗口显示 vim.notify 消息.
require("mini.pairs").setup({}) -- 输入左括号或引号时自动补全对应右侧字符.
require("mini.pick").setup({}) -- 提供文件, grep, 缓冲区和帮助等模糊选择器.
require("mini.extra").setup({}) -- 为 MiniPick 增加诊断, LSP, 快捷键和命令等选择器.
require("mini.surround").setup({}) -- 添加, 删除, 替换括号和引号等包围字符.
require("mini.trailspace").setup({}) -- 高亮行尾多余空格.

local clue = require("mini.clue")
clue.setup({
  -- trigger 是会进入等待状态并显示提示窗口的按键前缀.
  -- mode 可以是单个模式字符串, 也可以是同时生效的模式列表.
  triggers = {
    { mode = { "n", "x" }, keys = "<Leader>" }, -- 自定义 Leader 快捷键.
    { mode = "n", keys = "[" }, -- 上一个诊断, hunk, 缓冲区等反向跳转.
    { mode = "n", keys = "]" }, -- 下一个诊断, hunk, 缓冲区等正向跳转.
    { mode = "i", keys = "<C-x>" }, -- Neovim 内置插入模式补全子命令.
    { mode = { "n", "x" }, keys = "g" }, -- LSP 跳转和 Vim 的 g 系列命令.
    { mode = { "n", "x" }, keys = "'" }, -- 按行跳转到 mark.
    { mode = { "n", "x" }, keys = "`" }, -- 精确跳转到 mark 的行和列.
    { mode = { "n", "x" }, keys = '"' }, -- 选择用于复制, 删除或粘贴的寄存器.
    { mode = { "i", "c" }, keys = "<C-r>" }, -- 在插入或命令行模式中插入寄存器内容.
    { mode = "n", keys = "<C-w>" }, -- 创建, 关闭, 移动和调整窗口.
    { mode = { "n", "x" }, keys = "z" }, -- 折叠, 拼写和屏幕位置相关命令.
  },

  -- clues 为提示窗口提供分组名称和内置命令说明.
  clues = {
    { mode = "n", keys = "<Leader>b", desc = "+缓冲区" },
    { mode = "n", keys = "<Leader>c", desc = "+代码" },
    { mode = { "n", "x" }, keys = "<Leader>g", desc = "+版本控制" },
    { mode = "n", keys = "<Leader>f", desc = "+查找" },
    { mode = "n", keys = "<Leader>t", desc = "+终端" },
    { mode = "n", keys = "<Leader>u", desc = "+撤销" },
    clue.gen_clues.square_brackets(), -- 生成 [ 和 ] 开头的内置跳转说明.
    clue.gen_clues.builtin_completion(), -- 生成插入模式 <C-x> 补全说明.
    clue.gen_clues.g(), -- 生成 g 开头的内置命令说明.
    clue.gen_clues.marks(), -- 生成 mark 列表和说明.
    clue.gen_clues.registers(), -- 生成寄存器列表和说明.
    clue.gen_clues.windows(), -- 生成 <C-w> 窗口命令说明.
    clue.gen_clues.z(), -- 生成 z 开头的折叠和视图命令说明.
  },
})
