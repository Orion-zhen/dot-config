-- augroup 用来管理一组相关的自动命令.
-- clear = true 表示重新加载配置时先删除这个组中的旧命令, 避免同一个回调被重复注册.
local group = vim.api.nvim_create_augroup("user.autocmds", { clear = true })

-- FileType 在 Neovim 识别出缓冲区的文件类型后触发. 这些文件类型已经声明了对应的 Tree-sitter 解析器.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "bash",
    "c",
    "cpp",
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "markdown",
    "python",
    "rust",
    "typescript",
    "typescriptreact",
    "vim",
    "vimdoc",
  },
  callback = function(args)
    -- Neovim 内置高亮器根据当前文件类型选择解析器并加载 highlights 查询.
    vim.treesitter.start(args.buf)
  end,
})

-- TextYankPost 在完成 yank 操作后触发. yank 包括 y 复制以及其他写入寄存器的操作.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group, -- 将自动命令放入上面创建的组中.
  callback = function()
    -- 短暂高亮刚复制的文本, 用视觉反馈确认实际复制范围.
    vim.hl.on_yank()
  end,
})

-- FocusGained 在终端焦点回到 Neovim 时触发, BufEnter 在进入缓冲区时触发.
-- 两个事件共同覆盖从外部程序返回和在 Neovim 内切换文件的场景.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = group,
  callback = function()
    -- :checktime 比较缓冲区和磁盘文件的修改时间.
    -- 文件被外部程序修改时, 'autoread' 会自动重新读取未在 Neovim 中修改的缓冲区.
    vim.cmd.checktime()
  end,
})

-- Terminal 缓冲区默认关闭 'modifiable', 但终端输入不依赖这个选项.
-- 打开终端后主动进入 Terminal-mode, 让键盘输入直接发送给 shell.
vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.cmd.startinsert()
  end,
})
