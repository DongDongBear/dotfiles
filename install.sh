#!/bin/bash
# 动动的 dotfiles 安装脚本
# 用法: bash install.sh

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "🔗 链接 Ghostty 配置..."
mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES/ghostty/config" ~/.config/ghostty/config

echo "🔗 链接 Neovim 配置..."
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES/nvim/init.lua" ~/.config/nvim/init.lua

echo "🔗 链接 Cursor 快捷键..."
CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_DIR"
ln -sf "$DOTFILES/cursor/keybindings.json" "$CURSOR_DIR/keybindings.json"

echo "✅ 全部搞定！重启 Ghostty 和 Cursor 生效。"
