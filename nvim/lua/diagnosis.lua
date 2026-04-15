-- 定义 Nerd Fonts 图标
local diagnostic_signs = {
  Error = " ",
  Warn  = " ",
  Hint  = "󰠠 ",
  Info  = " ",
}

-- 核心显示与行为配置
vim.diagnostic.config({
  -- 虚拟文本 (代码行尾的内联提示)
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many", -- 当有多个诊断来源时，显示具体来源名称
  },

  -- 侧边栏图标
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN]  = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO]  = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT]  = diagnostic_signs.Hint,
    },
    -- 侧边栏的行号也改变颜色
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
    }
  },

  -- 代码下划线
  underline = true,

  -- 核心交互体验
  update_in_insert = false, -- 敲打代码时保持安静，按 Esc 退出插入模式后才刷新报错
  severity_sort = true,     -- 确保 Error 永远压制 Warn 和 Hint 显示在最前面

  -- 错误详情悬浮窗 UI
  float = {
    border = "rounded",
    source = "always", -- 弹窗中始终明确指出是哪个 LSP 报的错
    header = "",       -- 隐藏默认且冗余的 "Diagnostics:" 表头
    prefix = "",       -- 隐藏列表默认的短横线，让排版更紧凑
    focusable = false, -- 防止光标不小心切入悬浮窗
    style = "minimal",
  },
})
