-- 安装插件
vim.pack.add(
  {
    "https://www.github.com/lewis6991/gitsigns.nvim", -- git 状态追踪
    "https://www.github.com/echasnovski/mini.nvim",   -- 超级多合一插件
  }
)

-- 加载插件
local function packadd(name)
  vim.cmd("packadd " .. name)
end

packadd("gitsigns.nvim")
packadd("mini.nvim")

---

require("gitsigns").setup({
  signs = {
    add = { text = "\u{2590}" },          -- ▏
    change = { text = "\u{2590}" },       -- ▐
    delete = { text = "\u{2590}" },       -- ◦
    topdelete = { text = "\u{25e6}" },    -- ◦
    changedelete = { text = "\u{25cf}" }, -- ●
    untracked = { text = "\u{25cb}" },    -- ○
  },
  signcolumn = true,
  current_line_blame = false,
})

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})
require("mini.animate").setup({
  scroll = {
    enable = false, -- 禁用滚动动画, 滚动速度太慢了
  }
})
