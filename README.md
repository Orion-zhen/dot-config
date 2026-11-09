# dot-config

用 Git 保存配置，用 GNU Stow 按软件分包部署到家目录。

## 安装与部署

先安装 Git 和 GNU Stow，再克隆仓库：

```bash
git clone git@github.com:Orion-zhen/dot-config.git ~/dot-config
cd ~/dot-config
stow -n -v */    # 预览，确认无误后执行下一条
stow -v */      # 部署全部包
```

以下命令均在 `~/dot-config` 中执行，`.stowrc` 已将目标设为家目录。只管理部分包时，将命令中的 `*/` 换成包名，例如 `stow -v fish git nvim`。给 Stow 命令加上 `-n` 可以预览而不修改文件。

## 修改与同步

直接编辑仓库中的配置文件，无需重复部署。应用是否需要重载取决于软件本身。提交前检查差异，不要提交密码、令牌或本机运行数据。

```bash
git diff
git add <配置路径>
git commit -m "Update configuration"
git push
```

在其他机器上拉取并重新部署：

```bash
git pull --ff-only
stow -R -v */
```

若更新涉及删除或重命名整个包，拉取前先用 `stow -D <旧包名>` 撤销受影响的包。

## 新增与调整配置

仓库根目录的每个非隐藏子目录都是一个包，包内路径对应家目录下的路径。例如：

```text
fish/.config/fish/config.fish  → ~/.config/fish/config.fish
starship/.config/starship.toml → ~/.config/starship.toml
```

新增软件时，先备份现有配置，再将配置移到 `<包名>/<相对于家目录的路径>`，然后执行 `stow -v <包名>`。不要在仓库根目录混放 `docs/` 等非包目录。

新增、删除或移动包内文件后，重新部署对应包：

```bash
stow -R -v fish
```

本机专属文件按包内路径加入 `.gitignore`。它只控制 Git，不会阻止 Stow 部署这些文件。

## 撤销、删除与移动

```bash
stow -D -v nvim  # 撤销一个包
stow -D -v */    # 撤销全部包
```

撤销部署会移除 Stow 管理的链接，保留仓库配置和目标目录中未管理的文件。

- 删除或重命名包：先撤销旧包，再修改目录。重命名后用新包名重新部署。
- 移动仓库：先撤销全部包，移动后进入新位置重新部署所需包。
- 停止使用：先撤销全部包，再按需备份或删除仓库。需要继续使用的配置应另行复制回原位置。
