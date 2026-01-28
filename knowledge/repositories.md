# プロジェクト・レポジトリ管理帳

本ドキュメントは、各プロジェクトが紐付いているリモートレポジトリを管理するものです。
作業を開始する前に、必ず本ファイルを参照して正しい環境で作業しているか確認してください。

## 1. プロジェクト一覧

| プロジェクト名 | リモートレポジトリ URL | 備考 |
| :--- | :--- | :--- |
| **zmk-keyboard-toucan** | [https://github.com/d1Uta/zmk-keyboard-toucan](https://github.com/d1Uta/zmk-keyboard-toucan) | `key_mapping_heatmap` 等を含むメイン |
| **bible-batou-app** | (未登録) | 新規作成、要 Git Push |
| **knowns-backend** | (未登録) | 要 Git Push |
| **todo_app** | (未登録) | 要 Git Push |
| **claude-project** | (未登録) | |

## 2. 管理ルール

### 2.1 新規プロジェクト作成時
1. `c:\repos\<project_name>` ディレクトリを作成。
2. `git init` を行い、初期コミットを作成。
3. リモートレポジトリ（GitHub 等）を作成し、URL を本ドキュメントの「プロジェクト一覧」に追記する。
4. `git push` を完了させる。

### 2.2 作業開始前の確認事項
- 常に `knowledge/repositories.md` を参照し、作業対象のプロジェクトにリモートレポジトリが設定されているか確認すること。
- 未登録の場合は、作業完了までにレポジトリを作成し、Push すること。
