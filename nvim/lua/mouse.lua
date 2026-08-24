local set = vim.keymap.set

-- Neovim 默认的 Ctrl+左键通过 tags 跳转. 这里先执行普通左键定位光标, 再请求 LSP 定义.
-- rhs 使用字符串是为了保证 <LeftMouse> 和 LSP 请求严格按顺序执行.
set("n", "<C-LeftMouse>", "<LeftMouse><Cmd>lua vim.lsp.buf.definition()<CR>", {
  desc = "鼠标转到定义",
})

-- <C-o> 在 jump list 中后退, <C-i> 在 jump list 中前进.
-- LSP 跳转, 搜索跳转和部分文件跳转都会把位置写入 jump list.
set("n", "<C-RightMouse>", "<C-o>", {
  desc = "鼠标返回上一个位置",
})
set("n", "<X1Mouse>", "<C-o>", {
  desc = "鼠标后退",
})
set("n", "<X2Mouse>", "<C-i>", {
  desc = "鼠标前进",
})

-- PopUp 是 Neovim 在 mousemodel = "popup" 或 "popup_setpos" 时显示的原生右键菜单.
-- Neovim 还会通过内置 MenuPopup 自动命令动态控制默认菜单项是否可用.
-- 因此这里保留默认菜单及其英文内部路径, 避免复制上游实现或破坏后续版本的动态逻辑.

-- 下面只使用原生 :menu 命令添加默认菜单没有提供的操作.
-- nnoremenu 创建普通模式菜单项, xnoremenu 创建可视模式菜单项, <silent> 禁止命令回显.
-- TUI 右键菜单不能进入子菜单, 因此使用全角冒号在单层菜单中保留操作分组.
vim.cmd([[nnoremenu <silent> PopUp.LSP：悬浮文档 <Cmd>lua vim.lsp.buf.hover()<CR>]])
vim.cmd([[nnoremenu <silent> PopUp.LSP：查找引用 <Cmd>lua vim.lsp.buf.references()<CR>]])
vim.cmd([[nnoremenu <silent> PopUp.LSP：重命名 <Cmd>lua vim.lsp.buf.rename()<CR>]])
vim.cmd([[nnoremenu <silent> PopUp.LSP：代码操作 <Cmd>lua vim.lsp.buf.code_action()<CR>]])
-- 可视模式单独注册代码操作, 让 LSP 获得当前选区范围.
vim.cmd([[xnoremenu <silent> PopUp.LSP：代码操作 <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd([[nnoremenu <silent> PopUp.LSP：格式化 <Cmd>lua vim.lsp.buf.format({ async = true })<CR>]])

-- false 表示关闭存在未保存内容的缓冲区前要求确认, 不强制丢弃修改.
vim.cmd([[nnoremenu <silent> PopUp.缓冲区：关闭 <Cmd>lua MiniBufremove.delete(0, false)<CR>]])

-- MiniFilesBufferCreate 是 mini.files 创建目录缓冲区后发送的 User 事件.
-- 使用独立 augroup 可以在重新加载配置时清除旧事件, 避免重复创建快捷键.
local group = vim.api.nvim_create_augroup("user.mouse", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    -- mini.files 通过 args.data.buf_id 提供刚创建的目录缓冲区编号.
    local bufnr = args.data.buf_id

    -- MiniFiles.go_in 对目录表示进入下一层, 对文件表示在目标窗口中打开.
    set("n", "<CR>", MiniFiles.go_in, {
      buffer = bufnr, -- 只覆盖 MiniFiles 缓冲区中的 Enter.
      desc = "打开文件或目录",
    })

    -- 先执行 <LeftMouse> 将光标移动到被双击的行, 再打开该行代表的文件或目录.
    set("n", "<2-LeftMouse>", "<LeftMouse><Cmd>lua MiniFiles.go_in()<CR>", {
      buffer = bufnr,
      desc = "双击打开文件或目录",
    })

    -- vim.ui.open 将路径交给操作系统默认程序, 适合图片, PDF 等不应在 Neovim 中编辑的文件.
    set("n", "gX", function()
      vim.ui.open(MiniFiles.get_fs_entry().path)
    end, {
      buffer = bufnr,
      desc = "使用系统程序打开",
    })
  end,
})
