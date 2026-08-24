-- Leader 是自定义快捷键的公共前缀. 例如 <leader>ff 实际表示先按 Space, 再连续按 ff.
-- maplocalleader 用于只对特定文件类型生效的局部快捷键, 目前与全局 Leader 使用同一个按键.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 模块按依赖顺序加载. options 最先加载基础选项, plugins 必须在使用 mini.nvim 模块前完成初始化.
require("options")
require("autocmds")
require("diagnosis")
require("keymaps")
require("plugins")
require("tabline")
require("lsp")
require("mouse")
require("statusline")
