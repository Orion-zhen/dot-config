# Neovim 配置

这是一套以 Neovim 原生 API 为主的精简配置. 仓库只使用两个插件依赖: `mini.nvim` 提供编辑器工具, `gitsigns.nvim` 提供 Git 集成.

## 环境要求

- 兼容 Neovim 0.13-dev 的构建版本. 当前配置使用了新版原生包管理, 补全, LSP 和界面 API.
- Nerd Font 字体, 例如 Maple Mono NF.
- `git`, `rg` 和 `fd`. 这些程序分别用于包管理, 文本搜索和文件搜索.
- 系统剪贴板工具. 当前 Linux 配置使用 `wl-copy`.
- 你所使用语言对应的语言服务器.

配置已启用以下语言服务器:

- `bash-language-server`
- `clangd`
- `lua-language-server`
- `pyright-langserver`
- `rust-analyzer`
- `texlab`
- `yaml-language-server`

## 安装

将仓库克隆到 Neovim 配置目录:

```sh
git clone <仓库地址> "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

启动 Neovim. `vim.pack` 会安装配置中声明的插件.

使用以下命令更新插件:

```vim
:lua vim.pack.update()
```

使用以下命令更新 Tree-sitter 解析器:

```vim
:TSUpdate
```

## 配置结构

| 文件 | 作用 |
| --- | --- |
| `init.lua` | 设置 Leader 键, 并按依赖顺序加载其他模块 |
| `lua/options.lua` | 配置编辑, 搜索, 补全, 折叠和界面选项 |
| `lua/autocmds.lua` | 配置复制高亮和外部文件刷新等自动命令 |
| `lua/diagnosis.lua` | 配置 LSP 诊断的图标, 行尾文字和悬浮窗口 |
| `lua/keymaps.lua` | 配置键盘快捷键和功能搜索入口 |
| `lua/plugins.lua` | 安装并配置 `mini.nvim` 和 `gitsigns.nvim` |
| `lua/lsp.lua` | 配置语言服务器, 原生补全, 符号高亮和代码折叠 |
| `lua/mouse.lua` | 配置鼠标跳转, 右键菜单和 MiniFiles 鼠标操作 |
| `lua/tabline.lua` | 使用原生 tabline 格式构建可点击和可关闭的缓冲区标签栏 |
| `lua/statusline.lua` | 使用原生 statusline 格式构建状态栏和点击操作 |

每个 Lua 文件都包含中文注释. 阅读配置时可以先查看 `init.lua`, 再根据上表进入对应模块.

## 发现功能

不需要一开始记住所有快捷键. 先记住以下入口:

| 快捷键或命令 | 功能 |
| --- | --- |
| `<leader>fk` | 搜索所有快捷键 |
| `<leader>fc` 或 `<F1>` | 打开命令面板 |
| `<leader>fh` | 搜索 Neovim 帮助 |
| `:Tutor` | 打开 Vim 交互教程 |
| `<leader>` | 通过 `mini.clue` 显示 Leader 快捷键 |
| `g`, `[`, `]`, `z` 或 `<C-w>` | 输入前缀后稍作等待, 查看相关快捷键 |

Leader 键是 Space.

## 主要快捷键

### 文件和搜索

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 搜索工作区文本 |
| `<leader>fb` | 查找缓冲区 |
| `<leader>fr` | 查找最近打开的文件 |
| `<leader>e` | 打开 MiniFiles |
| `<leader>bd` | 关闭当前缓冲区 |
| `<C-s>` | 保存文件 |

### 语言服务和诊断

| 快捷键 | 功能 |
| --- | --- |
| `K` | 显示符号文档 |
| `gd` 或 `<F12>` | 转到定义 |
| `gD` | 转到声明 |
| `grr` 或 `<S-F12>` | 查找引用 |
| `gri` | 转到实现 |
| `grt` | 转到类型定义 |
| `grn` 或 `<F2>` | 重命名符号 |
| `gra` 或 `<leader>ca` | 显示代码操作 |
| `<leader>cf` | 格式化当前缓冲区 |
| `<leader>cd` | 显示光标处的诊断 |
| `<leader>cq` | 将诊断放入问题列表 |
| `[d` 和 `]d` | 转到上一个或下一个诊断 |
| `<C-Space>` | 触发补全 |
| 插入模式 `<C-k>` | 显示签名帮助 |

### Git

Gitsigns 连接到 Git 跟踪文件后, 以下缓冲区局部快捷键才会出现.

| 快捷键 | 功能 |
| --- | --- |
| `[h` 和 `]h` | 转到上一个或下一个 Git 变更块 |
| `<leader>gp` | 预览当前 Git 变更块 |
| `<leader>gs` | 暂存当前 Git 变更块或可视选区 |
| `<leader>gr` | 还原当前 Git 变更块或可视选区 |
| `<leader>gb` | 显示当前行的提交信息 |
| `<leader>gd` | 比较当前文件和 Git 索引 |

### 终端, 撤销和剪贴板

| 快捷键 | 功能 |
| --- | --- |
| `<leader>tt` | 打开内置终端 |
| 终端模式 `<Esc><Esc>` | 返回普通模式 |
| `<C-z>` | 撤销 |
| 普通模式 `<C-r>` | 重做 |
| `<leader>u` | 显示原生撤销列表 |
| `<C-c>` | 复制到系统剪贴板 |
| `<C-x>` | 剪切到系统剪贴板 |
| `<C-p>` | 粘贴系统剪贴板 |

配置已启用持久撤销. `:earlier 10m` 和 `:later 10m` 可以按时间浏览撤销历史.

## 鼠标

所有模式都启用了鼠标支持.

- 单击可以放置光标, 拖动可以选择文本.
- 双击, 三击和四击可以分别选择单词, 行和文本块.
- 拖动窗口分隔线或状态栏可以调整分屏大小.
- 右键可以打开 Neovim 上下文菜单, 菜单中包含新增的语言服务操作.
- Ctrl+左键可以转到语言服务返回的定义位置.
- Ctrl+右键或鼠标 X1 键可以在跳转列表中后退.
- 鼠标 X2 键可以在跳转列表中前进.
- 单击标签名称可以切换缓冲区, 单击标签上的 `×` 或中键单击标签可以关闭缓冲区.
- 双击 MiniFiles 条目可以打开文件或目录.
- 单击状态栏文件名可以在 MiniFiles 中显示当前文件.
- 单击状态栏诊断数量可以打开问题列表.

鼠标行为取决于终端或图形前端是否将对应事件转发给 Neovim.

## 健康检查

运行以下命令检查环境:

```vim
:checkhealth
```

Node.js, Perl 和 Ruby provider 是可选组件. 除非以后引入的插件明确依赖这些 provider, 缺少对应包不会影响当前配置.
