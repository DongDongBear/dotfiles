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

echo "🔗 链接 VSCode 系编辑器快捷键..."
for APP in "Code" "Cursor" "Windsurf" "VSCodium"; do
  DIR="$HOME/Library/Application Support/$APP/User"
  if [ -d "$DIR" ]; then
    ln -sf "$DOTFILES/vscode/keybindings.json" "$DIR/keybindings.json"
    echo "   ✅ $APP"
  fi
done

echo "🎉 全部搞定！重启编辑器和 Ghostty 生效。"
