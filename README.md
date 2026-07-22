# Ghostty セットアップガイド — iTerm2 からの乗り換え

iTerm2 から [Ghostty](https://ghostty.org) に乗り換えるためのガイドと、すぐ使える設定ファイル一式です。
Ghostty 1.3 系(2026年3月リリースの 1.3.1 が最新)を前提にしています。

## TL;DR

```sh
# インストール
brew install --cask ghostty

# このリポジトリの設定を適用(既存設定はバックアップされます)
git clone https://github.com/takike/setup-ghostty.git
cd setup-ghostty
./install.sh
```

設定は `ghostty/config` に全部入っています。Ghostty 起動中に `⌘⇧,` でリロードできます。

---

## 1. Ghostty の何が良いのか(iTerm2 と比べて)

| 観点 | Ghostty | iTerm2 |
|---|---|---|
| 描画 | GPU(Metal)レンダラ。高スループット・低入力レイテンシ | CPU 描画中心(Metal レンダラはあるが世代が古い) |
| UI | Swift/AppKit のネイティブ macOS アプリ。タブ・分割・設定 UI すべてネイティブ | ネイティブだが UI が複雑化している |
| 設定 | **プレーンテキスト 1 ファイル**。dotfiles で管理できる(このリポジトリの目的) | plist / GUI 中心でバージョン管理しづらい |
| シェル統合 | **ゼロコンフィグ**。bash/zsh/fish を自動検出して自動注入 | スクリプトのインストールが必要 |
| テーマ | 300 以上を同梱。**ライト/ダークをOSに追従して自動切替** | インポートが必要。自動切替はプロファイル頼み |
| プロトコル | Kitty graphics / Kitty keyboard / synchronized output / OSC 133 / OSC 9;4 進捗バーなどモダン仕様に積極対応 | 独自拡張(imgcat 等)が中心 |
| フォント | JetBrains Mono と **Nerd Font シンボルを内蔵**。パッチ済みフォント不要 | 別途 Nerd Font のインストールが必要 |

バージョンごとの目玉機能:

- **1.2**(2025-09): Quick Terminal の強化、コマンドパレット(`⌘⇧P`)、OSC 9;4 進捗バーのネイティブ表示、カスタムシェーダ、背景画像、閉じたタブ/分割の Undo(`⌘Z`)
- **1.3**(2026-03): **スクロールバック検索(`⌘F`)**、ネイティブスクロールバー、**プロンプト内クリックでカーソル移動**、キーテーブル・チェインキーバインド、AppleScript 対応(実験的)、コマンド完了通知

iTerm2 で「検索がないから乗り換えられない」と言われていた最大の弱点は 1.3 で解消済みです。

## 2. インストール

```sh
brew install --cask ghostty        # 安定版
# brew install --cask ghostty@tip  # 開発版(新機能を先取りしたい場合)
```

初回起動後にやっておくこと:

1. **デフォルトターミナルに設定** — メニューの Ghostty → 「Set as Default Terminal App」(1.3+)
2. **アクセシビリティ許可** — Quick Terminal のグローバルホットキーを使う場合、システム設定 → プライバシーとセキュリティ → アクセシビリティで Ghostty を許可

アップデートはアプリ内蔵の自動更新(ウィンドウ内に控えめな通知が出ます)か `brew upgrade` で。

## 3. 設定システムの基本

設定ファイルは `~/.config/ghostty/config`(または `~/Library/Application Support/com.mitchellh.ghostty/config`)。
書式は `キー = 値` を並べるだけです。GUI の設定画面はほぼなく、**このファイルがすべて**です。

覚えておくと便利な操作・コマンド:

| 操作 | 内容 |
|---|---|
| `⌘,` | 設定ファイルをエディタで開く |
| `⌘⇧,` | 設定をリロード(ほとんどの項目は再起動不要) |
| `ghostty +show-config --default --docs` | 全オプションをドキュメント付きで表示 |
| `ghostty +list-themes` | テーマ一覧を**プレビュー付き**でブラウズ |
| `ghostty +list-keybinds` | 現在のキーバインド一覧 |
| `ghostty +list-actions` | キーバインドに割当可能なアクション一覧 |
| `ghostty +list-fonts` | 利用可能なフォント一覧 |
| `ghostty +validate-config` | 設定ファイルの構文チェック |

`config-file = 別ファイル` で設定を分割インポートもできます(dotfiles を共通部分とマシン固有部分に分ける、など)。

## 4. iTerm2 → Ghostty キーバインド対応表

Ghostty のデフォルトは iTerm2 経験者にかなり馴染みやすい配置です。ほぼ移行コストなし:

| 機能 | iTerm2 | Ghostty(デフォルト) |
|---|---|---|
| 新規タブ | `⌘T` | `⌘T` |
| タブ切替 | `⌘⇧[` / `⌘⇧]` | 同じ(`⌃Tab` も可) |
| タブ番号ジャンプ | `⌘1`〜`⌘9` | 同じ |
| 縦分割(右に開く) | `⌘D` | `⌘D` |
| 横分割(下に開く) | `⌘⇧D` | `⌘⇧D` |
| ペイン移動 | `⌘⌥矢印` | `⌘⌥矢印`(`⌘[` / `⌘]` で前後移動も) |
| ペイン最大化 | `⌘⇧Enter` | `⌘⇧Enter`(toggle_split_zoom) |
| ペインリサイズ | `⌃⌘矢印` | `⌃⌘矢印`(`⌃⌘=` で均等化) |
| 画面クリア | `⌘K` | `⌘K` |
| 検索 | `⌘F` | `⌘F`(1.3+、`⌘G` / `⌘⇧G` で次/前) |
| 前/次のプロンプトへ | `⌘⇧↑` / `⌘⇧↓` | `⌘↑` / `⌘↓`(シェル統合で自動動作) |
| フォントサイズ | `⌘+` / `⌘-` / `⌘0` | 同じ |
| Hotkey Window | 独自設定 | Quick Terminal(グローバルキーバインド) |
| 閉じたタブを戻す | ─ | `⌘Z`(1.2+) |

## 5. Ghostty の利点を活かす使い方

### 5.1 シェル統合(設定不要で全部動く)

Ghostty はシェル(zsh/bash/fish)を自動検出して統合コードを注入します。iTerm2 のように `.zshrc` にスクリプトを書く必要はありません。これだけで:

- **`⌘↑` / `⌘↓` でプロンプト間ジャンプ** — 長い出力を遡るのが一瞬
- **新しいタブ/分割が現在のディレクトリを引き継ぐ**
- **プロンプト位置へのクリックでカーソル移動**(1.3+、テキストフィールド感覚)
- ウィンドウタイトルの自動更新、プロンプトでのカーソル形状変更(bar)
- `sudo` 下でも統合が維持される

### 5.2 Quick Terminal(iTerm2 の Hotkey Window 相当)

どのアプリを使っていても、グローバルホットキー一発で画面端からターミナルがスライドインします。同梱の config では `⌘\`` に割り当てています:

```ini
keybind = global:cmd+grave_accent=toggle_quick_terminal
```

`quick-terminal-position`(top/bottom/left/right/center)や `quick-terminal-size` で位置・サイズを調整できます。※グローバルキーにはアクセシビリティ許可が必要です。

### 5.3 コマンドパレット(`⌘⇧P`)

VS Code と同じ操作感で、Ghostty の全アクション(分割、テーマ切替、設定リロード…)をあいまい検索して実行できます。キーバインドを覚える前の入口として優秀です。

### 5.4 テーマのライト/ダーク自動切替

macOS の外観モードに追従してテーマが自動で切り替わります。iTerm2 だとプロファイルを分けて頑張っていたことが 1 行で済みます:

```ini
theme = light:catppuccin-latte,dark:catppuccin-mocha
```

`ghostty +list-themes` で 300 以上のテーマをプレビューしながら選べます。

### 5.5 画像表示(Kitty graphics protocol)

iTerm2 の `imgcat` の代わりに、業界標準になりつつある Kitty graphics protocol をサポートしています。対応ツールがそのまま動きます:

- ファイラー [yazi](https://github.com/sxyazi/yazi) のプレビュー画像
- `timg` / `chafa` などの画像表示 CLI
- Neovim の画像プラグイン(image.nvim 等)

### 5.6 コマンド完了の通知と進捗バー(長時間タスクに)

- **OSC 9;4 進捗バー**(1.2+): 対応ツール(systemd など)の進捗をタブに**ネイティブの進捗バー**として表示
- **コマンド完了通知**(1.3+): ビルドを回して他の作業をしていても、終わったら教えてくれます

```ini
notify-on-command-finish = unfocused   # フォーカスが外れているときだけ
notify-on-command-finish-after = 10s   # 10秒以上かかったコマンドのみ
```

### 5.7 キーバインド上級編

**テキスト送信** — Claude Code などの AI CLI で `Shift+Enter` 改行を使いたい場合(iTerm2 では `/terminal-setup` が必要でした):

```ini
keybind = shift+enter=text:\n
```

**シーケンス(プレフィックスキー)** — tmux 風の 2 段階キーも定義できます:

```ini
keybind = ctrl+a>c=new_tab
keybind = ctrl+a>%=new_split:right
```

**キーテーブル(1.3+)** — モーダルなキーバインド。例えばリサイズモード:

```ini
keybind = cmd+shift+r=activate_key_table:resize
keybind = resize/left=resize_split:left,40
keybind = resize/right=resize_split:right,40
keybind = resize/up=resize_split:up,40
keybind = resize/down=resize_split:down,40
```

(テーブルの抜け方や `chain=` による複数アクション連結、`catch_all` などの詳細は [1.3.0 リリースノート](https://ghostty.org/docs/install/release-notes/1-3-0) と `ghostty +list-actions` を参照)

### 5.8 SSH を快適にする

Ghostty は `TERM=xterm-ghostty` を使うため、素の状態だと SSH 先で「unknown terminal」エラーが出ることがあります。同梱 config では統合機能で解決しています:

```ini
shell-integration-features = ssh-env,ssh-terminfo
```

- `ssh-env`: SSH 先に安全な TERM 値を渡す
- `ssh-terminfo`: 接続先に xterm-ghostty の terminfo を自動インストール

手動でやるなら: `infocmp -x | ssh yourhost -- tic -x -`

### 5.9 見た目のカスタマイズ

- `background-opacity` + `background-blur`(macOS のネイティブブラー。1.3 では Liquid Glass 対応の `macos-glass-*` 値も)
- `background-image` で背景画像(1.2+)
- `custom-shader` で GLSL シェーダ(カーソル残像エフェクト等。[ghostty-shaders](https://github.com/hackr-sh/ghostty-shaders) にサンプル多数)
- `macos-icon` でアプリアイコン変更(retro / glass / holographic など)

### 5.10 自動化(1.3+、実験的)

AppleScript に対応したので、「ウィンドウを開いて特定コマンドを実行」のような iTerm2 の Python API 的な自動化が書けるようになりつつあります。

## 6. iTerm2 にあって Ghostty にないもの(と代替策)

Ghostty は意図的にミニマルなので、以下は割り切りが必要です:

| iTerm2 の機能 | 代替策 |
|---|---|
| プロファイル / Arrangements | なし。設定は 1 セット。`config-file` の分割 + テーマ自動切替で部分的にカバー。ウィンドウ復元は `window-save-state = always` |
| `tmux -CC` 統合 | なし。ネイティブ分割 + `window-save-state` で足りることが多い。必要なら普通に tmux / zellij を中で使う |
| Triggers(出力への正規表現反応) | なし。シェル側で対応(`notify-on-command-finish` が一部を代替) |
| Instant Replay | なし。スクロールバック検索(`⌘F`)+ `scrollback-limit` 増量で代替 |
| Password Manager | なし。1Password CLI(`op`)等を使う |
| Badges / Toolbelt | なし |
| Semantic History(ファイルパス ⌘クリックでエディタ起動) | URL の ⌘クリックは対応。ファイルパスは今後に期待 |
| Autocomplete(`⌘;`) | シェル側で(fzf / atuin / zsh-autosuggestions) |

「Triggers と tmux -CC が生命線」という使い方でなければ、失うものより得るもの(速度・検索・設定のポータビリティ)の方が大きいはずです。

## 7. トラブルシューティング / 日本語環境メモ

- **日本語入力(IME)**: ネイティブ実装なので変換・インライン入力は安定しています。1.0 時代の IME 問題はほぼ解消済み
- **Option キー**: デフォルトでは Option は macOS 流(記号入力)。ターミナルの Meta キーとして使いたい場合は `macos-option-as-alt = left` を有効化(左だけ Alt にして、右 Option は記号入力用に残すのがおすすめ)
- **SSH 先で terminfo エラー**: → [5.8](#58-ssh-を快適にする)
- **CJK フォント**: macOS のフォントフォールバックが効くので通常は設定不要。明示したい場合は `font-family` を複数行書けばフォールバック順になります
- **設定が反映されない**: `background-opacity` など一部項目は再起動が必要。まず `ghostty +validate-config` で構文確認 → `⌘⇧,` でリロード → ダメなら再起動

## リポジトリ構成

```
.
├── README.md        # このガイド
├── install.sh       # ~/.config/ghostty への symlink 設置(既存はバックアップ)
└── ghostty/
    └── config       # コメント付き設定ファイル本体
```

## 参考リンク

- [公式ドキュメント](https://ghostty.org/docs)
- [設定リファレンス](https://ghostty.org/docs/config/reference)
- [キーバインドアクション一覧](https://ghostty.org/docs/config/keybind/reference)
- [1.2.0 リリースノート](https://ghostty.org/docs/install/release-notes/1-2-0) / [1.3.0 リリースノート](https://ghostty.org/docs/install/release-notes/1-3-0)
