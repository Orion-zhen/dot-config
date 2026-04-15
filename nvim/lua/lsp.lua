-- 需要安装 neovim-lspconfig
-- 1. vim.lsp.config("name", {cmd={"commands"}})
-- 2. vim.lsp.enable("name")

vim.lsp.inlay_hint.enable(true) -- 内联提示功能

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } }, -- 认为 vim 全局可用
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy", -- 存时用 clippy 替代默认的 cargo check
      },
      cargo = {
        allFeatures = true, -- 开启项目中所有可选 features
      },
      -- 需要细粒度关闭时:
      -- inlayHints = {
      --   lifetimeElisionHints = { enable = "never" },
      -- }
    }
  }
})

vim.lsp.config("texlab", {
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = {
          "-xelatex",
          "-pdfxe",
          "-gg",                      -- 强制清理
          "-synctex=1",
          "-interaction=nonstopmode", -- 用 nonstopmode 方便在 NVim 看到错误
          "-file-line-error",
          "-shell-escape",            -- 允许执行 shell 脚本
          "-output-directory=build",  -- 输出目录 ./build
          "%f"                        -- 指代当前文件
        },
        onSave = true,
        forwardSearchAfter = true,
      },
      -- 确保 texlab 知道去哪里找生成的 PDF
      auxDirectory = "build",
      pdfDirectory = "build",
    }
  }
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
})

vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("texlab")
vim.lsp.enable("yamlls")
