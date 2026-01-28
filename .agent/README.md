# Antigravity プロジェクト

Google Antigravity の公式仕様に基づいたエージェント開発基盤です。

## ディレクトリ構成

本プロジェクトは以下の構成で管理されており、エージェントの能力拡張（Skills）や学習（Knowledge）を公式の仕組みで利用可能です。

```text
.
├── .agent/
│   ├── README.md      # プロジェクト全体の構成
│   ├── instructions.md # エージェントへの共通指示事項
│   ├── skills/        # ワークスペース固有のスキル（能力拡張）
│   ├── rules/         # プロジェクト固有のルール
│   └── workflows/     # 自動化手順（ワークフロー）
└── knowledge/         # 知識ベース（学習内容の蓄積場所）
```

## 運用フロー (Best Practices)

1.  **参照 (Check)**: 作業前に `troubleshooting.md` を確認し、既知のエラーを回避する。
2.  **実行 (Execution)**: 指示書に従い、日本語での Artifact 作成と確実なコマンド実行を行う。
3.  **更新 (Update)**: エラー解決や構成変更があった場合、即座に `README.md` と `troubleshooting.md` を更新して履歴を保持する。
