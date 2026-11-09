-- 诊断级别使用 Nerd Font 图标. 末尾空格用于让图标和代码之间保留间距.
local diagnostic_signs = {
  Error = " ", -- 错误, 通常表示代码无法编译或运行.
  Warn = " ", -- 警告, 代码可能可以运行, 但存在风险.
  Hint = "󰠠 ", -- 提示, 例如可以简化的写法.
  Info = " ", -- 信息, 严重程度低于警告.
}

vim.diagnostic.config({
  -- virtual_text 控制显示在代码行末尾的诊断文字.
  virtual_text = {
    prefix = "●", -- 每条行尾诊断前显示的符号.
    spacing = 4, -- 代码和诊断文字之间保留 4 列空白.
    source = "if_many", -- 只有多个诊断来源同时存在时才显示来源名称.
  },

  -- signs 控制左侧 signcolumn 中的诊断标记.
  signs = {
    -- text 以诊断级别常量为键, 指定每个级别显示的图标.
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
    -- numhl 指定诊断所在行的行号高亮组. 这里只突出错误和警告, 避免提示过多时界面太花.
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
    },
  },

  underline = true, -- 使用下划线标记存在诊断的代码范围.
  update_in_insert = false, -- 插入模式中不刷新诊断, 避免输入尚未完成时提示不断闪烁.
  severity_sort = true, -- 同一位置存在多条诊断时, 优先显示更严重的诊断.

  -- float 控制 K, <leader>cd 或右键菜单打开的诊断悬浮窗.
  float = {
    border = "rounded", -- 使用圆角边框.
    source = "always", -- 始终显示诊断来源, 方便区分 LSP 或其他工具.
    header = "", -- 不显示默认的 Diagnostics 标题.
    prefix = "", -- 不在每条诊断前添加默认列表前缀.
    focusable = false, -- 悬浮窗不接收焦点, 防止窗口切换时误入其中.
    style = "minimal", -- 隐藏普通窗口中与悬浮诊断无关的界面元素.
  },
})
