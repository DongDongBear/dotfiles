#!/bin/bash
# 动动的 dotfiles 安装脚本
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "🔗 链接 Ghostty 配置..."
mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES/ghostty/config" ~/.config/ghostty/config

echo "🔗 链接 Neovim 配置..."
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES/nvim/init.lua" ~/.config/nvim/init.lua

echo "🔗 链接 VSCode 系编辑器配置..."
for APP in "Code" "Cursor" "Windsurf" "VSCodium" "Antigravity"; do
  DIR="$HOME/Library/Application Support/$APP/User"
  if [ -d "$DIR" ]; then
    ln -sf "$DOTFILES/vscode/settings.json" "$DIR/settings.json"
    ln -sf "$DOTFILES/vscode/keybindings.json" "$DIR/keybindings.json"
    echo "   ✅ $APP"
  fi
done

echo "📋 初始化 Claude Code 配置..."
mkdir -p ~/.claude
# 用 copy 而非 symlink：Claude Code 会自动追加权限记录，symlink 会污染 dotfiles repo
if [ ! -f ~/.claude/settings.json ]; then
  cp "$DOTFILES/claude/settings.json" ~/.claude/settings.json
  echo "   ✅ Claude Code settings.json (已复制基础配置)"
else
  echo "   ⏭️  Claude Code settings.json 已存在，跳过"
fi

echo ""
echo "🧩 安装 VSCode 扩展..."
# 确保 code CLI 可用
if ! command -v code &>/dev/null; then
  echo "   ⚠️  'code' 命令未找到！"
  echo "   请先在 VSCode 中按 Cmd+Shift+P → 输入 'Shell Command: Install code command in PATH'"
  echo "   然后重新运行此脚本，或手动执行："
  echo "   cat $DOTFILES/vscode/extensions.txt | grep -v '^#' | grep -v '^\$' | xargs -L 1 code --install-extension"
else
  INSTALLED=$(code --list-extensions 2>/dev/null)
  TOTAL=0
  SKIPPED=0
  INSTALLED_COUNT=0
  while IFS= read -r ext; do
    [[ "$ext" =~ ^#.*$ || -z "$ext" ]] && continue
    ext=$(echo "$ext" | xargs)  # trim whitespace
    TOTAL=$((TOTAL + 1))
    if echo "$INSTALLED" | grep -qi "^${ext}$"; then
      SKIPPED=$((SKIPPED + 1))
    else
      echo "   📦 安装 $ext ..."
      code --install-extension "$ext" --force 2>/dev/null || echo "   ⚠️  安装失败: $ext"
      INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    fi
  done < "$DOTFILES/vscode/extensions.txt"
  echo "   ✅ 扩展安装完成！共 $TOTAL 个，新装 $INSTALLED_COUNT 个，已有 $SKIPPED 个"
fi

echo ""
echo "🎉 全部搞定！重启编辑器和 Ghostty 生效。"
