# dot-config

使用 Git 保存配置，通过 GNU Stow 链接到 `~/.config`。Linux 和 macOS 共用同一套配置。

## 安装

先安装 Git 和 GNU Stow，然后克隆仓库：

```bash
git clone git@github.com:Orion-zhen/dot-config.git ~/dot-config
mkdir -p ~/.config
```

预览并部署全部配置：

```bash
stow -n -v -d "$HOME" -t "$HOME/.config" dot-config # 预览配置
```

```bash
stow -d "$HOME" -t "$HOME/.config" dot-config # 实际应用配置
```

目标位置已有同名普通文件时，Stow 会报告冲突。先备份并比较文件，再移走冲突文件，重新运行命令。不要直接覆盖整份 `~/.config`，也不要用 `--adopt` 无差别导入本机配置。

## 日常使用

直接修改 `~/.config` 中已链接的配置，就是修改仓库文件：

```bash
git -C ~/dot-config diff
git -C ~/dot-config add <配置路径>
git -C ~/dot-config commit -m "Update configuration"
git -C ~/dot-config push
```

Stow 默认尽量链接整个目录。整目录链接下新建的文件会进入仓库工作区，由 `.gitignore` 排除本机设置和运行数据。已有目录混有未管理文件时，Stow 会保留该目录，按需链接其子目录或文件。

如果新文件建在未整目录链接的位置，需要先把文件移到 `~/dot-config` 中的对应相对路径，再重新部署。不要把缓存或私密信息移入仓库。

新增或删除仓库文件后，重新部署全部配置：

```bash
stow -R -d "$HOME" -t "$HOME/.config" dot-config
```

在另一台机器拉取配置后也运行该命令：

```bash
git -C ~/dot-config pull --ff-only
stow -R -d "$HOME" -t "$HOME/.config" dot-config
```

`.stow-local-ignore` 只排除仓库根目录的元数据和文档，不排除应用目录内的同名文件。`.gitignore` 只控制 Git，不控制 Stow 的部署范围。

## 命令与路径映射

以这条命令为例：

```bash
stow -d "$HOME" -t "$HOME/.config" dot-config
```

- `-d "$HOME"`：指定 Stow 查找配置组的父目录，即 `~`，不是仓库目录本身。
- `dot-config`：配置组名称，与 `-d` 拼接后得到源目录 `~/dot-config`。
- `-t "$HOME/.config"`：指定链接的目标目录，即 `~/.config`。

Stow 将配置组内部的相对路径映射到目标目录，不会在目标目录下额外创建一层 `dot-config`：

```text
源文件：< -d 目录 >/<配置组>/<相对路径>
目标位置：< -t 目录 >/<相对路径>

~/dot-config/fish/config.fish  → ~/.config/fish/config.fish
~/dot-config/btop/btop.conf    → ~/.config/btop/btop.conf
~/dot-config/starship.toml     → ~/.config/starship.toml
```

上面的箭头表示部署映射。实际符号链接的方向是从目标位置指向仓库。Stow 默认尽量链接整个目录，例如：

```text
~/.config/btop → ../dot-config/btop
```

因此，访问 `~/.config/btop/btop.conf` 就是在访问 `~/dot-config/btop/btop.conf`。如果目标目录已经存在，Stow 会按需进入目录，为子目录或文件建立链接。

`-n` 表示只预览，`-v` 表示显示操作详情，`-R` 表示先撤销再重新部署，`-D` 表示只撤销链接。这些选项不改变路径映射关系。由于命令显式指定了绝对路径，运行时不必先进入仓库目录。

## 撤销链接

```bash
stow -D -d "$HOME" -t "$HOME/.config" dot-config
```

这会撤销 Stow 管理的链接，保留仓库源文件和目标目录中的未管理文件。不要删除仍被链接引用的仓库目录。
