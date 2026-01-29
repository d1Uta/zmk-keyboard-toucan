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

### 引数エラー (System Tokens)
- **事象**: `Copy-Item : 引数 'pupil' を受け入れる位置指定パラメーターが見つかりません。` 等のエラー。
- **原因**: システム（プロンプト等）から自動注入されたパディングトークン（`pupil` 等）を、`run_command` の `CommandLine` 引数に含めたまま実行してしまった。
- **解決策**: コマンド実行前に、引数内に不要な単語が混じっていないか文字列を目視確認し、あれば削除して再実行する。
- **再発防止策**: マスター指示書に「実行直前の最終目視確認」をルールとして追加し、これを遵守する。

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

### Git 操作の不整合
- **事象**: `error: failed to push some refs to ...` (Updates were rejected because the remote contains work that you do not have locally).
- **原因**: 他のエージェントやユーザーがリモートリポジトリを更新しており、ローカルの状態が古くなっている。
- **解決策**: 
    1. `git fetch origin` で最新状態を取得。
    2. `git rebase origin/main` で自身のコミットを最新の先端に載せ替える。
    3. 再度 `git push origin main` を実行する。
    - ※ 競合が発生した場合は、手動で解消した後に `git rebase --continue` を行う。

### CI エラー：Invalid input, artifact_name is not defined
- **事象**: CI ビルドが `Invalid input, artifact_name is not defined in the referenced workflow` で失敗する。
- **原因**: `zmk/.github/workflows/build-user-config.yml` が `artifact_name` という引数を持っておらず、正しくは `archive_name` であるため。
- **解決策**: ワークフローファイルの `with:` セクションで `archive_name` を使用する。
- **再発防止策**: 外部の再利用可能ワークフローを使用する際は、必ず最新のリポジトリまたはドキュメントを確認し、定義されている引数（`inputs`）を正確に把握すること。

### CI エラー：mkdir: cannot create directory
- **事象**: CI ビルド中に `mkdir: cannot create directory '...': No such file or directory` というエラーが発生する。
- **原因**: 外部の再利用可能ワークフロー内で `mkdir` が実行される際、中間ディレクトリ（例: `config/`）が自動作成されないため、深い階層を指定すると失敗する。
- **解決策**: ディレクトリ構成を **リポジトリのルート直下** に移動し（例: `mac_onishi/`）、`west.yml` の `self: path:` を新しいパスに合わせ、`build.yml` でもルート階層を直接参照するように変更する。
- **再発防止策**: 外部ワークフローを使用する際は、その環境が多段ディレクトリの作成（`mkdir -p` 相当）をサポートしているか、特定のパス構成を要求していないかを確認し、可能な限りフラットなルート構成を採用する。

### CI エラー：Aborting due to Kconfig warnings (malformed line)
- **事象**: `toucan_left.conf:1: warning: ignoring malformed line '../boards/shields/toucan/toucan.conf'` というエラーでビルドが中断される。
- **原因**: `.conf` ファイル内で指定された相対パスが、ディレクトリ構造の変更（ルート移動）によって無効になった、あるいは Kconfig がサポートしない形式（単なるパスの羅列）であったため。
- **解決策**: バリアント固有の `.conf` ファイルから不要・不正なパス指定を削除する。シールド共通の設定は自動的にマージされるため、明示的なインクルードは不要。
- **再発防止策**: ディレクトリ構造を変更した際は、すべての設定ファイル（`.conf`, `west.yml`等）内のパス指定を網羅的にチェックする。

### CI エラー：409 Conflict (Artifact already exists) - 根本解決版
- **事象**: `Failed to CreateArtifact: (409) Conflict: an artifact with this name already exists...` が全ターゲットで発生し、個別設定が無視される。
- **原因**: 
    1. **共有名前空間**: マトリックスビルドでは成果物保存領域が共有されるため、Shield/Board名が同じだと衝突する。
    2. **キー名の不整合 (重要)**: ZMK の再利用可能ワークフロー内部では `${{ matrix.artifact-name }}` (ハイフン) として参照されている。これを `artifact_name` (アンダーバー) 等で独自に定義すると無視され、デフォルト名（衝突の元）が使われてしまう。
- **解決策**: 
    1. **ワークフローの最新化**: `@main` を使用して最新の衝突回避機能を有効にする。
    2. **厳密なキー指定**: `build.yaml` で必ず **`artifact-name`** (ハイフン) を使用し、バリアント名を含めた一意な値を指定する。
- **再発防止策**: 外部ワークフローを使用する際は、独自の「安全そうな命名」を優先せず、必ずソースコードを直接確認して要求されるキー名を正確に指定する。

### CI エラー：409 Conflict (Artifact already exists) - 根本解決への軌跡
- **事象**: `Failed to CreateArtifact: (409) Conflict: an artifact with this name already exists...` が発生し、個別設定...（略：以前の内容）
- **原因**: 1. 共有名前空間 2. キー名の不整合 (- vs _)
- **解決策**: 1. 最新ワークフロー(@main) 2. 厳密なハイフン使用
- **再発防止策**: ソースコード直接確認

### CI エラー：mkdir /tmp/zmk-config/. (File exists) と構成の集約
- **事象**: `mkdir: cannot create directory '/tmp/zmk-config/.': File exists` が発生。
- **原因**: `zephyr/module.yml` が存在するプロジェクトで `config_path: .` を指定すると、ZMK ワークフローが自分自身の隔離ディレクトリ内で `.` を作成しようとして自滅する。
- **最終解決策 (決定版) - 統合 config フォルダ構成**:
    1. **config フォルダへの集約**: ルートディレクトリ（`.`）の使用を避け、全バリアントを `config/` サブフォルダの下に配置する。
    2. **config_path: config**: ワークフローの入力に `config` を指定することで、名前の衝突を回避する。
    3. **ルートでの一括管理**: ルートの `build.yaml` で 12 個のターゲットを一括定義し、ジョブ間の成果物競合を解消する。
    4. **マニフェストのパス修正**: `config/west.yml` の `self: path:` を `.` に設定し、隔離環境下でのビルドパス不整合を防ぐ。
- **再発防止策**: ルートディレクトリを直接設定パスとして使うことの危険性を認識し、常に明示的なサブディレクトリ（`config` 等）を介して制御する構造を維持する。

### CI エラー：lexer: invalid input text (yq quoting & upstream bug)
- **事象**: `lexer: invalid input text` というエラーでビルドマトリックスの取得に失敗する。
- **原因**: ZMK 公式ワークフロー（@main）の最新の更新により、`yq` 実行時に `build_matrix_path` が単一引用符で囲まれるようになり、パスにスラッシュを含む場合にパースエラーを引き起こすバグが混入した。
- **解決策 (決定的)**: 
    1. 公式ワークフローをローカルにコピーし、引用符の問題を修正したパッチ版（`.github/workflows/zmk_build_fixed.yml`）を作成。
    2. メインの `build.yml` からこのローカル修正版を呼び出す。これにより外部の仕様変更に左右されない安定性を確保。
- **再発防止策**: 外部の再利用可能ワークフローに依存し、その内部で破壊的な変更やバグが生じた場合、無理に引数調整で対応しようとせず「ローカルパッチ」を適用することを検討する。

### CI エラー：マージ失敗 (Merge failed / Race Condition)
- **事象**: 複数の並列ジョブが完了した際、アーティファクトのマージで失敗する（Artifact not found 等）。
- **原因**: 複数の並列ジョブが同じ名名のプレフィックス（`artifact-*`）でアップロードとマージ（及び削除）を同時に行うため、他のジョブのファイルを誤って削除したり、読み取れなかったりする競合（Race Condition）が発生する。
- **解決策**: 
    1. アーティファクトアップロード名に `archive_name`（バリアント名）を含めて一意にする（例: `artifact-${{ inputs.archive_name }}-...`）。
    2. マージ時の検索パターンもそのバリアント固有のプレフィックスに限定する。
- **再発防止策**: マトリックスビルドでマージジョブ（upload-artifact/merge 等）を使用する場合、必ず各列（Job）が他の列を邪魔しない「名前空間の隔離（Isolation）」を徹底する。
