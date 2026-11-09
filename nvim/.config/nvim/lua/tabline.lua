-- 使用 Neovim 原生 'tabline' 格式构建缓冲区标签栏.
-- MiniTabline 的标签整体只有一个点击区域, 无法为关闭按钮分配独立行为.
local MiniBufremove = require("mini.bufremove")
local MiniIcons = require("mini.icons")

local M = {}
local last_buffer
local editor_windows = {}

local function escape_tabline(value)
  return value:gsub("%%", "%%%%")
end

local function is_normal_window(winid)
  return vim.api.nvim_win_get_config(winid).relative == ""
end

-- 记录每个 Neovim 标签页最后使用的普通编辑窗口. 从 MiniFiles 等浮动窗口点击标签时,
-- 文件应回到编辑区, 而不是替换文件浏览器缓冲区.
local function remember_editor()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)

  if vim.bo[bufnr].buflisted then
    last_buffer = bufnr
  end
  if is_normal_window(winid) and vim.bo[bufnr].buftype == "" then
    editor_windows[vim.api.nvim_get_current_tabpage()] = winid
  end
end

local function buffer_label(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[未命名]", {}
  end

  return vim.fn.fnamemodify(name, ":t"),
    vim.split(vim.fs.normalize(name), "/", {
      plain = true,
      trimempty = true,
    })
end

-- 同名文件使用最短的唯一父目录后缀, 例如 src/init.lua 和 test/init.lua.
local function make_labels(buffers)
  local labels = {}
  local path_parts = {}
  local groups = {}

  for _, bufnr in ipairs(buffers) do
    local label, parts = buffer_label(bufnr)
    labels[bufnr] = label
    path_parts[bufnr] = parts
    groups[label] = groups[label] or {}
    table.insert(groups[label], bufnr)
  end

  for label, group in pairs(groups) do
    if #group > 1 then
      for _, bufnr in ipairs(group) do
        local parts = path_parts[bufnr]
        if #parts == 0 then
          labels[bufnr] = ("%s %d"):format(label, bufnr)
        else
          for depth = 2, #parts do
            local first = math.max(1, #parts - depth + 1)
            local candidate = table.concat(parts, "/", first)
            local unique = true

            for _, other in ipairs(group) do
              if other ~= bufnr then
                local other_parts = path_parts[other]
                local other_first = math.max(1, #other_parts - depth + 1)
                if table.concat(other_parts, "/", other_first) == candidate then
                  unique = false
                  break
                end
              end
            end

            if unique then
              labels[bufnr] = candidate
              break
            end
          end
        end
      end
    end
  end

  return labels
end

local function highlight_for(bufnr, current, visible)
  local suffix
  if current then
    suffix = "Current"
  elseif visible then
    suffix = "Visible"
  else
    suffix = "Hidden"
  end

  if vim.bo[bufnr].modified then
    return "UserTablineModified" .. suffix
  end
  return "UserTabline" .. suffix
end

local function icon_for(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local category = name == "" and "filetype" or "file"
  local icon_name = name == "" and filetype or name
  local icon, highlight = MiniIcons.get(category, icon_name)
  return icon or "", highlight
end

local function make_entries()
  local buffers = vim.tbl_filter(function(bufnr)
    return vim.bo[bufnr].buflisted
  end, vim.api.nvim_list_bufs())
  local labels = make_labels(buffers)
  local current = vim.api.nvim_get_current_buf()
  local entries = {}

  for _, bufnr in ipairs(buffers) do
    local icon, icon_highlight = icon_for(bufnr)
    local label_text = icon == "" and (" %s "):format(labels[bufnr]) or (" %s %s "):format(icon, labels[bufnr])
    local close_text = "× "
    local separator = "│"

    entries[#entries + 1] = {
      bufnr = bufnr,
      label = label_text,
      close = close_text,
      separator = separator,
      icon_highlight = icon_highlight,
      highlight = highlight_for(bufnr, bufnr == current, #vim.fn.win_findbuf(bufnr) > 0),
      width = vim.fn.strdisplaywidth(label_text .. close_text .. separator),
    }
  end

  return entries
end

-- 标签过多时保留当前标签及其两侧标签, 并用尖括号表示还有隐藏内容.
local function visible_range(entries)
  if #entries == 0 then
    return 1, 0
  end

  local center = 1
  for index, entry in ipairs(entries) do
    if entry.bufnr == last_buffer then
      center = index
      break
    end
  end

  local left, right = center, center
  local width = entries[center].width
  local left_width, right_width = 0, 0
  local left_blocked, right_blocked = false, false

  while not (left_blocked and right_blocked) do
    local try_left = not left_blocked and (right_blocked or left_width <= right_width)
    local candidate = try_left and left - 1 or right + 1

    if candidate < 1 then
      left_blocked = true
    elseif candidate > #entries then
      right_blocked = true
    else
      local new_left = try_left and candidate or left
      local new_right = try_left and right or candidate
      local markers = (new_left > 1 and 1 or 0) + (new_right < #entries and 1 or 0)

      if width + entries[candidate].width + markers <= vim.o.columns then
        width = width + entries[candidate].width
        if try_left then
          left = candidate
          left_width = left_width + entries[candidate].width
        else
          right = candidate
          right_width = right_width + entries[candidate].width
        end
      elseif try_left then
        left_blocked = true
      else
        right_blocked = true
      end
    end
  end

  return left, right
end

local function render_entry(entry)
  local label = escape_tabline(entry.label)
  if entry.icon_highlight and entry.icon_highlight ~= "" then
    local icon, rest = label:match("^( %S+)(.*)$")
    if icon then
      label = ("%%#%s#%s%%#%s#%s"):format(entry.icon_highlight, icon, entry.highlight, rest)
    end
  end

  return table.concat({
    ("%%#%s#%%%d@v:lua.Tabline.switch_buffer@"):format(entry.highlight, entry.bufnr),
    label,
    "%X",
    ("%%%d@v:lua.Tabline.close_buffer@"):format(entry.bufnr),
    escape_tabline(entry.close),
    "%X",
    "%#UserTablineSeparator#",
    entry.separator,
  })
end

function M.render()
  local entries = make_entries()
  local left, right = visible_range(entries)
  local result = {}

  if left > 1 then
    result[#result + 1] = "%#UserTablineTrunc#‹"
  end
  for index = left, right do
    result[#result + 1] = render_entry(entries[index])
  end
  if right < #entries then
    result[#result + 1] = "%#UserTablineTrunc#›"
  end

  result[#result + 1] = "%X%#TabLineFill#"
  return table.concat(result)
end

function M.switch_buffer(bufnr, _, button, _)
  if button == "m" then
    MiniBufremove.delete(bufnr, false)
    return
  end
  if button ~= "l" or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local target = editor_windows[tabpage]
  if target and vim.api.nvim_win_is_valid(target) then
    vim.api.nvim_set_current_win(target)
  end
  vim.api.nvim_set_current_buf(bufnr)
end

function M.close_buffer(bufnr, _, button, _)
  if (button == "l" or button == "m") and vim.api.nvim_buf_is_valid(bufnr) then
    MiniBufremove.delete(bufnr, false)
  end
end

local group = vim.api.nvim_create_augroup("user.tabline", { clear = true })
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter", "VimResized", "WinEnter" }, {
  group = group,
  callback = function()
    remember_editor()
    vim.cmd.redrawtabline()
  end,
})
vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = "modified",
  command = "redrawtabline",
})

remember_editor()
_G.Tabline = M
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.Tabline.render()"

return M
