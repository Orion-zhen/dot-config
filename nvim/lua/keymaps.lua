-- vim.keymap.set(mode, lhs, rhs, opts) 用来创建快捷键.
-- mode 表示生效模式: n 是普通模式, i 是插入模式, x 是可视模式, s 是选择模式, t 是终端模式.
-- lhs 是要按下的按键, rhs 是执行的按键序列或 Lua 函数. opts.desc 会被 :map 和 mini.clue 显示.
local set = vim.keymap.set

-- <Cmd>write<CR> 可以直接从普通, 插入和可视模式执行命令.
-- 它不会像 :w<CR> 那样在可视模式中自动添加 '<,'> 范围, 因此不会误写部分缓冲区.
set({ "n", "i", "x" }, "<C-s>", "<Cmd>write<CR>", {
  desc = "保存文件",
})

-- 插入模式中的 Ctrl+d 默认用于减少缩进. 这里将它改成 Escape, 作为更容易按到的退出键.
set("i", "<C-d>", "<Esc>", {
  desc = "退出插入模式",
})

-- wq 先保存当前缓冲区, 再关闭当前窗口. 只在普通模式中提供, 避免可视选区产生命令范围.
set("n", "<leader>qq", "<Cmd>wq<CR>", {
  desc = "保存并退出",
})

-- 普通模式的 u 是原生撤销命令.
set("n", "<C-z>", "u", {
  desc = "撤销",
})
-- <C-o> 允许在插入模式中临时执行一个普通模式命令. 执行 u 后会自动回到插入模式.
set("i", "<C-z>", "<C-o>u", {
  desc = "撤销",
})
-- 可视模式先用 Escape 退出选区, 再执行普通模式的 u. 这里不能附加 <CR>, 否则光标会移动到下一行.
set("x", "<C-z>", "<Esc>u", {
  desc = "撤销",
})
-- :undolist 显示原生撤销树中的序号和保存时间. 可以配合 :earlier 和 :later 使用.
set("n", "<leader>u", "<Cmd>undolist<CR>", {
  desc = "显示撤销历史",
})

-- 搜索和替换
set("n", "<C-f>", "/", {
  desc = "在文件中搜索",
})
set("n", "<leader>h", ":%s/", {
  desc = "在文件中替换",
})
set("x", "<leader>h", ":s/", {
  desc = "在选中区域中替换",
})
set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "清除搜索高亮",
})

-- MiniPick.builtin.files 调用文件选择器. 它会优先使用系统中的 rg 或 fd 获取候选文件.
set("n", "<leader>ff", function()
  MiniPick.builtin.files()
end, { desc = "查找文件" })

-- grep_live 会在每次修改查询内容时重新执行文本搜索, 适合全项目搜索.
set("n", "<leader>fg", function()
  MiniPick.builtin.grep_live()
end, { desc = "搜索文本" })

-- buffers 列出当前 Neovim 实例中已经加载的缓冲区, 不限于屏幕上可见的窗口.
set("n", "<leader>fb", function()
  MiniPick.builtin.buffers()
end, { desc = "查找缓冲区" })

-- diagnostic 统一列出当前缓冲区和工作区中的诊断, 选中项目后跳转到对应位置.
set("n", "<leader>fd", function()
  MiniExtra.pickers.diagnostic()
end, { desc = "查找诊断" })

-- document_symbol 请求 LSP 返回当前文件中的函数, 类型和变量等符号.
set("n", "<leader>fs", function()
  MiniExtra.pickers.lsp({ scope = "document_symbol" })
end, { desc = "查找文档符号" })

-- workspace_symbol_live 在整个项目中实时搜索 LSP 符号. 大写 S 用于区别当前文档搜索.
set("n", "<leader>fS", function()
  MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" })
end, { desc = "查找工作区符号" })

-- keymaps 选择器会显示所有普通和插件快捷键及其 desc, 是不了解入口时最重要的帮助工具.
set("n", "<leader>fk", function()
  MiniExtra.pickers.keymaps()
end, { desc = "查找快捷键" })

-- commands 选择器列出内置命令和用户命令. 选择不需要参数的命令会直接执行, 其他命令会填入命令行.
local function pick_commands()
  MiniExtra.pickers.commands()
end
set("n", "<leader>fc", pick_commands, { desc = "命令面板" })
set("n", "<F1>", pick_commands, { desc = "命令面板" })

-- help 选择器搜索 Neovim 和已安装插件的帮助标签, 选中后打开对应 :help 页面.
set("n", "<leader>fh", function()
  MiniPick.builtin.help()
end, { desc = "查找帮助" })

-- scope = ":" 表示只搜索 Ex 命令历史. 搜索历史可以改用 scope = "/".
set("n", "<leader>f:", function()
  MiniExtra.pickers.history({ scope = ":" })
end, { desc = "查找命令历史" })

-- oldfiles 来自 Neovim 的 v:oldfiles 列表, 用于重新打开最近访问过的文件.
set("n", "<leader>fr", function()
  MiniExtra.pickers.oldfiles()
end, { desc = "查找最近文件" })

-- :copen 打开 Quickfix 窗口. LSP 诊断和 :make 等操作都可以把结果放入这个列表.
set("n", "<leader>fq", "<Cmd>copen<CR>", {
  desc = "打开问题列表",
})

-- 传入当前文件路径后, MiniFiles 会从当前文件所在位置展开列式文件浏览器.
set("n", "<leader>e", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = "文件浏览器" })

-- MiniBufremove.delete 会删除当前缓冲区, 同时尽量保留已有分屏布局.
-- 第一个参数 0 表示当前缓冲区, force = false 表示存在未保存内容时必须确认.
set("n", "<leader>bd", function()
  MiniBufremove.delete(0, false)
end, { desc = "关闭缓冲区" })

-- code_action 请求 LSP 提供快速修复和重构. 可视模式调用时会把选区范围一并发送给服务器.
set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, {
  desc = "代码操作",
})

-- rename 请求 LSP 在整个项目中安全重命名光标下的符号. F2 是与常见图形编辑器一致的别名.
set("n", "<leader>cr", vim.lsp.buf.rename, {
  desc = "重命名符号",
})
set("n", "<F2>", vim.lsp.buf.rename, {
  desc = "重命名符号",
})

-- async = true 表示格式化请求完成前不阻塞编辑器输入.
set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, {
  desc = "格式化",
})

-- open_float 显示光标附近的诊断详情, 具体边框和来源显示方式在 diagnosis.lua 中配置.
set("n", "<leader>cd", vim.diagnostic.open_float, {
  desc = "显示诊断详情",
})

-- setqflist 收集所有缓冲区的诊断. open = true 表示填充完成后立即打开 Quickfix 窗口.
set("n", "<leader>cq", function()
  vim.diagnostic.setqflist({ open = true })
end, {
  desc = "诊断列表",
})

-- K 是 Vim 查看关键字帮助的传统按键. 在代码缓冲区中将它用于 LSP hover 文档.
set("n", "K", vim.lsp.buf.hover, {
  desc = "显示符号文档",
})

-- definition 跳转到符号实现位置, declaration 跳转到符号声明位置. 两者由LSP区分.
set("n", "gd", vim.lsp.buf.definition, {
  desc = "转到定义",
})
set("n", "gD", vim.lsp.buf.declaration, {
  desc = "转到声明",
})
set("n", "<F12>", vim.lsp.buf.definition, {
  desc = "转到定义",
})
set("n", "<S-F12>", vim.lsp.buf.references, {
  desc = "查找引用",
})

-- 手动请求 LSP 补全. 自动补全已开启, 这个按键用于菜单未出现时主动触发.
set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end, {
  desc = "触发LSP补全",
})

-- signature_help 显示当前函数调用的参数列表和光标所在参数.
-- 原生默认键是插入模式 <C-s>, 但该键已经用于保存, 因此改为 <C-k>.
set("i", "<C-k>", vim.lsp.buf.signature_help, {
  desc = "显示签名帮助",
})

-- Tab 根据当前界面状态执行三种不同操作.
set({ "i", "s" }, "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    -- 补全菜单可见时, <C-n> 选择下一项.
    return "<C-n>"
  end
  if vim.snippet.active({ direction = 1 }) then
    -- snippet 存在后续占位符时, 跳到下一个占位符.
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  end
  -- 没有补全菜单或 snippet 时保留普通 Tab 行为.
  return "<Tab>"
end, {
  expr = true, -- rhs 函数返回的字符串会被当作按键继续执行.
  silent = true, -- 不在命令行回显返回的按键序列.
  desc = "下一个补全项或代码片段占位符",
})

-- Shift+Tab 与 Tab 方向相反. direction = -1 表示寻找前一个 snippet 占位符.
set({ "i", "s" }, "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  if vim.snippet.active({ direction = -1 }) then
    return "<Cmd>lua vim.snippet.jump(-1)<CR>"
  end
  return "<S-Tab>"
end, {
  expr = true,
  silent = true,
  desc = "上一个补全项或代码片段占位符",
})

-- Enter 只在补全菜单中已经明确选择某项时接受补全, 否则保持普通换行.
set("i", "<CR>", function()
  local selected = vim.fn.complete_info({ "selected" }).selected
  if vim.fn.pumvisible() == 1 and selected >= 0 then
    return "<C-y>" -- <C-y> 是 Neovim 原生的接受当前补全项操作.
  end
  return "<CR>"
end, {
  expr = true,
  silent = true,
  desc = "确认补全或换行",
})

-- botright 把终端分屏放到最下方, 15split 指定窗口高度为 15 行, terminal 启动默认 shell.
set("n", "<leader>tt", "<Cmd>botright 15split | terminal<CR>", {
  desc = "打开终端",
})

-- 终端模式会把普通按键发送给 shell. <C-\><C-n> 是 Neovim 返回普通模式的原生命令.
set("t", "<Esc><Esc>", "<C-\\><C-n>", {
  desc = "退出终端模式",
})

-- "+ 是系统剪贴板寄存器. x 模式表示这些操作也适用于可视选区.
set({ "n", "x" }, "<C-c>", '"+y', {
  desc = "复制到系统剪贴板",
})
set({ "n", "x" }, "<C-x>", '"+d', {
  desc = "剪切到系统剪贴板",
})
set({ "n", "x" }, "<C-p>", '"+p', {
  desc = "粘贴系统剪贴板",
})
