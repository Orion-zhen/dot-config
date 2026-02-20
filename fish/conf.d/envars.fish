set -gx LANG zh_CN.UTF-8

# fcitx5 输入法支持
set -gx GTK_IN_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"

# no_proxy 设置
set -gx no_proxy "localhost,127.0.0.1"

if test -d /opt/cuda
    set -gx CUDA_HOME /opt/cuda
end

if test -d /opt/rocm
    set -gx ROCM_HOME /opt/rocm
end

if test -d $HOME/.cert
    set -gx SSL_HOME $HOME/.cert
end

if test -d $HOME/models
    set -gx MODELS $HOME/models
else
    set -gx MODELS $HOME
end

set -gx GPG_TTY $(tty)

set -gx GPGHOME $HOME/.config/gnupg

# set -gx HOMEBREW_NO_INSTALL_CLEANUP false

# Wine 相关设置（如果需要，可取消注释）
# set -gx WINEARCH win32
# set -gx WINEPREFIX ~/.local/share/wineprefixes/wine32

# 智能配置 EDITOR
# 1. 判断是否是本地图形化会话
#    - 没有 SSH_TTY (非 ssh)
#    - DISPLAY 已定义 (有 X/Wayland)
set -q SSH_TTY; and set _is_ssh true; or set _is_ssh false
set -q DISPLAY; and set _has_display true; or set _has_display false

# 2. 判断 code 命令是否在 PATH 中
if type -q code
    set _have_code true
else
    set _have_code false
end

# 3. 综合判断并设置 EDITOR
if not $_is_ssh; and $_has_display; and $_have_code
    # 本地图形会话且 code 可用 → 用 VS Code 作为编辑器
    # 若想让 VS Code 在编辑完文件后才返回，建议加 -w 参数
    # set -gx EDITOR "code -w"
    set -gx EDITOR "code --wait"
else
    # 任何其它情况 → 用 nvim
    set -gx EDITOR nvim
end

set -gx OPENCODE_ENABLE_EXA 1
