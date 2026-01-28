# トラブルシューティングガイド (Language-Specific Knowledge)

本ドキュメントは、Antigravity での作業中に発生したエラーとその解決策を集積したナレッジベースです。

## 1. PowerShell (Environment & Shell)

### コマンド互換性
- **事象**: `ls -la` や `mkdir -p` がエラーになる。
- **原因**: PowerShell は Unix ライクなフラグの一部をサポートしていない。
- **解決策**: 詳細リストは `dir`、ディレクトリ作成は `New-Item -ItemType Directory -Force` を使用する。
    - > [!WARNING]
    - > Junction（リンク）フォルダ上で `-Force` を使用すると、リンク先のマスターディレクトリ内のファイルが予期せず操作・削除されるリスクがあるため、リンクの起点では慎重に使用すること。

### エンコーディング (Mojibake)
- **事象**: 日本語コメントを含むスクリプトがパースエラーになる。
- **原因**: 非 ASCII 文字のエンコーディング不整合。
- **解決策**: 自動実行スクリプトからは日本語コメントを除去し、ASCII のみで構成する。

### 構文エラー (ParserError)
- **事象**: `if not exist ...` 等のコマンドが `MissingOpenParenthesisInIfStatement` で失敗する。
- **原因**: PowerShell の `if` 文は `if (...) { ... }` の形式である必要があるが、CMD スタイルの構文を直接実行してしまった。
- **解決策**: PowerShell では以下の形式を徹底するか、`cmd /c` を介して実行する。
    - 形式: `if (Test-Path <path>) { ... }`
    - ワンライナー: `if (!(Test-Path config/onishi)) { mkdir config/onishi }`

## 2. Python (Scripting & Automation)

### パス操作 (Windows/Unix)
- **事象**: `os.path` 関連でパスが見つからない。
- **原因**: バックスラッシュとスラッシュの混在。
- **解決策**: `pathlib` モジュールを使用し、クロスプラットフォームなパス操作を行う。

### 依存関係
- **事象**: `ImportError` の発生。
- **解決策**: 作業前に `pip list` で環境を確認し、不足があれば Plan に追加する。

## 3. Antigravity System (Junctions & Links)

### Junction 処理の安全性
- **事象**: `.agent` 下のリンク（Junction/Symlink）を削除する際、誤って Master（`C:\.agent_central`）側の実ファイルまで削除してしまう。
- **原因**: PowerShell の `Remove-Item -Recurse` はジャンクションを通常のディレクトリとして扱い、ターゲットの中身まで再帰的に削除してしまう場合がある。
- **解決策**: 
    - **ジャンクション（ディレクトリリンク）の解除**: 常に `cmd /c "rd <path>"` を使用すること。これはリンクのみを削除し、ターゲットの中身には影響を与えない。
    - **ファイルのシンボリックリンク削除**: `Remove-Item <file_path>` を使用（再帰フラグは不要）。
    - **事前確認**: 操作前に `(Get-Item <path>).Attributes` を確認し、`ReparsePoint` が含まれているか（リンクであるか）をチェックする。

> [!CAUTION]
> `.agent` 内のファイルを整理する際、`Remove-Item -Recurse -Force` を安易に使用しないこと。万が一マスター側を削除してしまった場合は、Git 等のバージョン管理から即座に復元するか、バックアップから戻す手順を確認すること。

### README の自動更新
- **ルール**: `.agent` 下のファイル構成が変わった際は必ず `README.md` を更新し、全エージェントが最新状態を把握できるようにする。
## 4. ZMK Keyboard (Firmware & Configuration)

### ビルドエラー (西ビルド / West Build)
- **事象**: `west build` がマウス関連のトークン（&mkp 等）で失敗する。
- **原因**: `.keymap` ファイルに `<dt-bindings/zmk/mouse.h>` がインクルードされていない。
- **解決策**: 以下をインクルードセクションに追加する。
  ```c
  #include <dt-bindings/zmk/mouse.h>
  ```

### Bluetooth 接続
- **事象**: ペアリングができない、またはデバイスが見つからない。
- **解決策**:
  1. キーボード側でプロファイルをクリアする（`&bt BT_CLR`）。
  2. OS 側の Bluetooth 設定からデバイスを削除（Forget device）する。
  3. 再度ペアリングを試行する。

- **解決策**: ジャンクションのみを安全に解除するために `cmd /c "rd <path>"` を使用し、管理者権限が必要なシンボリックリンクではなく `Copy-Item` を検討する。

## 5. Antigravity Tool Usage

### ファイル編集時の不一致 (targetContent not found)
- **事象**: `replace_file_content` や `multi_replace_file_content` が失敗する。
- **原因**: 直前の `view_file` から時間が経過しており、ファイル内容が（他のツールやユーザーによって）変更されていた、あるいはコピーミス。
- **解決策**:
    - 大規模な置換を行う前には、必ず最新の `view_file` を実行し、`TargetContent` をコピー＆ペーストして正確性を期すこと。
    - 文字列の「揺らぎ」を防ぐため、可能な限り行番号（StartLine/EndLine）を併用する。
