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

echo "🎉 全部搞定！重启编辑器和 Ghostty 生效。"
