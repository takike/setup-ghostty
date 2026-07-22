#!/usr/bin/env bash
#
# このリポジトリの ghostty/ を ~/.config/ghostty として symlink する。
# 既存の設定ディレクトリはタイムスタンプ付きでバックアップする。
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"

if [ -L "$CONFIG_DIR" ]; then
  echo "既存の symlink を更新します: $CONFIG_DIR"
  rm "$CONFIG_DIR"
elif [ -e "$CONFIG_DIR" ]; then
  BACKUP="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
  echo "既存の設定をバックアップします: $BACKUP"
  mv "$CONFIG_DIR" "$BACKUP"
fi

mkdir -p "$(dirname "$CONFIG_DIR")"
ln -s "$REPO_DIR/ghostty" "$CONFIG_DIR"
echo "リンクしました: $CONFIG_DIR -> $REPO_DIR/ghostty"

if command -v ghostty >/dev/null 2>&1; then
  echo "設定を検証しています..."
  ghostty +validate-config && echo "OK"
else
  echo "注意: ghostty コマンドが見つかりません。'brew install --cask ghostty' でインストールしてください。"
fi

echo "Ghostty 起動中なら ⌘⇧, で設定をリロードできます。"
