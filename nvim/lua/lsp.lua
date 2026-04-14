-- 需要安装 nvim-lspconfig
-- 1. vim.lsp.config("name", {cmd={"commands"}})
-- 2. vim.lsp.enable("name")

vim.lsp.config('yamlls', {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
})

vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("pyright")
vim.lsp.enable("yamlls")
