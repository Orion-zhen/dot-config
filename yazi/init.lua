-- ~/.config/yazi/init.lua

-- DuckDB plugin configuration
require("duckdb"):setup()

-- 文件信息中同时展示大小和修改时间
function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    else
        time = os.date("%b %d  %Y", time)
    end

    local size = self._file:size()
    return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- 顶部状态栏中展示用户名和主机名
Header:children_add(function()
    if ya.target_family() ~= "unix" then
        return ""
    end
    return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

-- 底部状态栏中展示符号链接的目标地址
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return " -> " .. tostring(h.link_to)
    else
        return ""
    end
end, 3300, Status.LEFT)
