-- 全局启用 LSP inlay hints. 语言服务器支持时, 参数类型和推导类型等提示会显示在代码中.
vim.lsp.inlay_hint.enable(true)

-- LspAttach 在语言服务器成功连接到缓冲区后触发.
-- document_highlight 使用单独的组, 便于按缓冲区清理并重新创建相关自动命令.
local attach_group = vim.api.nvim_create_augroup("user.lsp", { clear = true })
local highlight_group = vim.api.nvim_create_augroup("user.lsp.document_highlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = attach_group,
  callback = function(ev)
    -- ev.data.client_id 是刚连接的 LSP 客户端编号, ev.buf 是它连接的缓冲区编号.
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      -- 客户端可能在事件排队期间退出. 此时没有可以继续配置的对象.
      return
    end

    -- supports_method 用来确认服务器是否声明了对应能力, 避免为不支持的服务器发送无效请求.
    if client:supports_method("textDocument/completion") then
      -- 第一个参数 true 表示启用. 后两个参数将补全限制到当前客户端和当前缓冲区.
      -- 启用后, Neovim 会处理补全项携带的 snippet, 自动导入和附加命令.
      vim.lsp.completion.enable(true, client.id, ev.buf)
    end

    if client:supports_method("textDocument/documentHighlight") then
      -- 重新加载配置或连接多个服务器时, 先清除此缓冲区已有的高亮自动命令, 防止重复请求.
      vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = ev.buf })

      -- 光标停留时请求服务器高亮与当前符号语义相同的读取和写入位置.
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = highlight_group,
        buffer = ev.buf, -- 只在连接了该能力的缓冲区中生效.
        callback = vim.lsp.buf.document_highlight,
      })

      -- 光标移动后清除旧符号的引用高亮, 等下一次 CursorHold 再显示新符号.
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = highlight_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client:supports_method("textDocument/foldingRange") then
      -- 一个缓冲区可能同时显示在多个窗口中. win_findbuf 返回所有显示该缓冲区的窗口编号.
      for _, winid in ipairs(vim.fn.win_findbuf(ev.buf)) do
        vim.wo[winid].foldmethod = "expr" -- 使用表达式决定每一行的折叠级别.
        -- vim.lsp.foldexpr 根据服务器返回的函数, 类型和区域范围生成折叠.
        vim.wo[winid].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
  end,
})

-- vim.lsp.config 为指定服务器补充或覆盖 Neovim 自带的默认配置.
vim.lsp.config("lua_ls", {
  settings = {
    -- settings.Lua 会作为 workspace/didChangeConfiguration 发送给 lua-language-server.
    Lua = {
      -- Neovim 配置中可以直接使用全局变量 vim, 不应把它报告为未定义变量.
      diagnostics = { globals = { "vim" } },
      -- 不向 lua-language-server 项目发送匿名遥测数据.
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    -- rust-analyzer 的设置键包含连字符, 因此必须使用 ["..."] 写法.
    ["rust-analyzer"] = {
      check = {
        -- 保存后运行 cargo clippy, 除编译错误外也显示常见代码质量诊断.
        command = "clippy",
      },
      cargo = {
        -- 分析 Cargo.toml 中声明的全部 feature, 避免条件编译代码缺少补全和诊断.
        allFeatures = true,
      },
    },
  },
})

vim.lsp.config("texlab", {
  settings = {
    texlab = {
      build = {
        executable = "latexmk", -- texlab 调用 latexmk 负责多轮 LaTeX 编译.
        args = {
          "-xelatex", -- 让 latexmk 使用 XeLaTeX 引擎.
          "-pdfxe", -- 生成 PDF, 并明确选择 XeLaTeX 规则.
          "-gg", -- 编译前清理旧的辅助文件, 然后强制完整重建.
          "-synctex=1", -- 生成 SyncTeX 数据, 支持源码和 PDF 位置互相跳转.
          "-interaction=nonstopmode", -- 遇到错误时继续编译, 让 texlab 收集完整诊断.
          "-file-line-error", -- 使用 文件:行号 格式输出错误, 便于定位.
          "-shell-escape", -- 允许文档调用外部命令. 只应编译可信 LaTeX 项目.
          "-output-directory=build", -- 将 PDF 和辅助文件写入项目的 build 目录.
          "%f", -- texlab 会把 %f 替换成当前主 LaTeX 文件路径.
        },
        onSave = true, -- 保存 LaTeX 文件后自动运行构建.
        forwardSearchAfter = true, -- 构建成功后请求 PDF 阅读器定位到当前源码位置.
      },
      auxDirectory = "build", -- 告诉 texlab 从 build 目录读取 .aux 等辅助文件.
      pdfDirectory = "build", -- 告诉 texlab 生成的 PDF 位于 build 目录.
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" }, -- 通过标准输入输出启动 YAML 语言服务器协议连接.
  filetypes = { "yaml" }, -- 只连接 Neovim 检测为 yaml 的缓冲区. .yml 文件也使用这个 filetype.
})

-- enable 注册要自动启动的服务器. Neovim 会根据各服务器的 filetypes 和项目根目录规则决定何时启动.
-- 对应可执行文件必须已经安装并位于 PATH 中, 否则打开相关文件时服务器无法启动.
vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("texlab")
vim.lsp.enable("yamlls")
