-- mini.icons 根据文件路径和 filetype 返回 Nerd Font 图标及对应高亮组.
local MiniIcons = require("mini.icons")

-- M 保存状态栏公开函数. 点击处理函数必须能从 v:lua 全局表达式访问, 因此文件末尾会导出为 Statusline.
local M = {}

-- nvim_get_mode().mode 返回短模式代码. 部分模式包含额外后缀, 因此 mode() 会在精确匹配失败后尝试首字符.
local mode_labels = {
  n = "\u{f121}  普通", -- 普通模式.
  no = "\u{f121}  等待操作范围", -- 已输入 d, y 等操作符, 正在等待移动范围.
  i = "\u{f11c}  插入", -- 插入模式.
  v = "\u{f0168} 可视", -- 按字符选择的可视模式.
  V = "\u{f0168} 可视行", -- 按整行选择的可视模式.
  ["\22"] = "\u{f0168} 可视块", -- Ctrl+v 进入的块选择模式.
  c = "\u{f120} 命令", -- : 命令行模式.
  s = "\u{f0c5} 选择", -- 按字符选择的选择模式.
  S = "\u{f0c5} 选择行", -- 按整行选择的选择模式.
  ["\19"] = "\u{f0c5} 选择块", -- 块选择模式.
  R = "\u{f044} 替换", -- 替换模式.
  r = "\u{f044} 替换", -- 单字符替换或等待替换字符的状态.
  ["!"] = "\u{f489} 外部命令", -- 正在执行外部 shell 命令.
  t = "\u{f120} 终端", -- 终端输入模式.
}

local function mode()
  local current = vim.api.nvim_get_mode().mode
  return mode_labels[current] or mode_labels[current:sub(1, 1)] or current
end

-- 返回带高亮切换标记的文件图标.
-- 状态栏中的 %#组名# 用来切换高亮组, 因为 Lua format 会处理百分号, 字符串中需要写成 %%.
local function file_icon(bufnr, base_highlight)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype
  -- 已保存文件按完整文件路径查找图标. 未命名缓冲区没有路径, 改为按 filetype 查找.
  local category = name == "" and "filetype" or "file"
  local icon_name = name == "" and filetype or name
  local icon, highlight = MiniIcons.get(category, icon_name)

  -- 图标使用 mini.icons 返回的颜色, 随后恢复到调用方指定的状态栏高亮组.
  return ("%%#%s#%s%%#%s#"):format(highlight, icon, base_highlight)
end

-- 状态栏把 % 解释为格式指令. Git 分支名来自外部数据, 其中的 % 必须变成 %% 才能原样显示.
local function escape_statusline(value)
  return value:gsub("%%", "%%%%")
end

-- Gitsigns 会在每个已连接缓冲区的 b:gitsigns_status_dict 中维护分支和变更数量.
-- 直接读取这个表可以避免状态栏每次重绘时执行 git 子进程.
local function git_status(bufnr)
  local status = vim.b[bufnr].gitsigns_status_dict
  if not status then
    return "" -- 普通文件或非 Git 文件没有 Gitsigns 状态.
  end

  local parts = {}
  if status.head and status.head ~= "" then
    parts[#parts + 1] = "\u{e725} " .. escape_statusline(status.head)
  end
  if status.added and status.added > 0 then
    parts[#parts + 1] = "%#GitSignsAdd#+" .. status.added .. "%#StatusLine#"
  end
  if status.changed and status.changed > 0 then
    parts[#parts + 1] = "%#GitSignsChange#~" .. status.changed .. "%#StatusLine#"
  end
  if status.removed and status.removed > 0 then
    parts[#parts + 1] = "%#GitSignsDelete#-" .. status.removed .. "%#StatusLine#"
  end

  if #parts == 0 then
    return ""
  end
  return " " .. table.concat(parts, " ")
end

-- 统计当前缓冲区中每个严重级别的诊断数量.
local function diagnostics(bufnr)
  local count = vim.diagnostic.count(bufnr)
  local severity = vim.diagnostic.severity
  local parts = {}
  -- 每项依次包含诊断级别常量, 状态栏缩写和对应高亮组.
  local definitions = {
    { severity.ERROR, "错误", "DiagnosticError" },
    { severity.WARN, "警告", "DiagnosticWarn" },
    { severity.INFO, "信息", "DiagnosticInfo" },
    { severity.HINT, "提示", "DiagnosticHint" },
  }

  for _, definition in ipairs(definitions) do
    local amount = count[definition[1]] or 0
    if amount > 0 then
      -- 只显示数量大于 0 的级别, 并在每段结束后恢复 StatusLine 高亮.
      parts[#parts + 1] = ("%%#%s#%s:%d%%#StatusLine#"):format(definition[3], definition[2], amount)
    end
  end

  return table.concat(parts, " ")
end

-- 只有附加信息非空时才添加  分隔符, 避免出现连续的空分段.
local function append_metadata(statusline, value)
  if value ~= "" then
    statusline[#statusline + 1] = " \u{e0b1} " .. value
  end
end

-- 当前窗口显示完整状态. statusline 是字符串数组, 最后一次性连接可以避免大量 .. 表达式难以阅读.
local function active_statusline(bufnr)
  local statusline = {
    "  ", -- 左侧留出两个空格.
    mode(),
    " \u{e0b1} ",
    -- %N@函数@ 开始可点击区域. N 作为第一个参数传给回调, 这里使用缓冲区编号.
    ("%%%d@v:lua.Statusline.open_file@"):format(bufnr),
    file_icon(bufnr, "StatusLine"),
    " %f %h%m%r", -- 使用原生格式项显示文件路径, 帮助, 修改和只读状态.
    "%X", -- 结束文件名的可点击区域.
    git_status(bufnr),
  }

  append_metadata(statusline, vim.bo[bufnr].filetype)

  local diagnostic_status = diagnostics(bufnr)
  if diagnostic_status ~= "" then
    -- 没有指定 N 时, 点击回调的第一个参数为 0. 诊断回调不需要知道具体缓冲区.
    statusline[#statusline + 1] = " \u{e0b1} %@v:lua.Statusline.open_diagnostics@" .. diagnostic_status .. "%X"
  end

  -- %= 将后续内容推到最右侧. %l 和 %c 是当前行列, %p%% 使用纯数字显示文件位置百分比.
  statusline[#statusline + 1] = "%= \u{f017} %l:%c  %p%% "
  return table.concat(statusline)
end

-- 非当前窗口只显示文件名和位置, 减少分屏中的视觉干扰.
local function inactive_statusline(bufnr)
  return table.concat({
    "  ",
    file_icon(bufnr, "StatusLineNC"),
    " %f %h%m%r",
    "%= %l:%c  %p%% ",
  })
end

-- g:statusline_winid 由 Neovim 在计算状态栏时临时设置, 表示当前正在渲染哪个窗口的状态栏.
function M.render()
  local winid = vim.g.statusline_winid
  local bufnr = vim.api.nvim_win_get_buf(winid)

  if winid == vim.api.nvim_get_current_win() then
    return active_statusline(bufnr)
  end
  return inactive_statusline(bufnr)
end

-- 状态栏点击函数固定接收 4 个参数: minwid, 点击次数, 鼠标按钮和修饰键.
-- 这里只有左键需要执行操作, 所以未使用的参数以 _ 命名.
function M.open_file(bufnr, _, button, _)
  if button ~= "l" or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  MiniFiles.open(vim.api.nvim_buf_get_name(bufnr))
end

function M.open_diagnostics(_, _, button, _)
  if button == "l" then
    -- 收集所有缓冲区诊断并立即打开问题列表, 用法与 <leader>cq 相同.
    vim.diagnostic.setqflist({ open = true })
  end
end

-- %! 表示整个 statusline 由后面的表达式生成. v:lua 只能访问全局 Lua 对象, 因此导出 M.
_G.Statusline = M
vim.o.statusline = "%!v:lua.Statusline.render()"

return M
