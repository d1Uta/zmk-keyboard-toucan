# 実装計画 - ドラッグ操作の実装

## 目的
Toucan キーボードの SYM レイヤー (Layer 2) でドラッグ操作を可能にするため、スクロール機能を無効化し、クリックキーを追加する。

## ユーザーレビューが必要な事項
- 特になし（ユーザー要望に基づく変更）

## 変更内容

### [Config]
#### [NEW] [config/boards/shields/toucan/toucan.dtsi](file:///c:/repos/key_mapping_heatmap/config/boards/shields/toucan/toucan.dtsi)
- GitHub から取得したオリジナルの定義ファイルを配置。
- **変更点**: `scroller` ノードの `layers` から `2` を削除し、Layer 2 でのスクロールを無効化する。

#### [MODIFY] [config/toucan.keymap](file:///c:/repos/key_mapping_heatmap/config/toucan.keymap)
- **変更点**: `sym` レイヤー (Layer 2) の `&kp SPACE` (左手親指位置) を `&mkp LCLK` (左クリック) に変更する。
- **目的**: SYMレイヤー有効時に、このキーを押しながらトラックパッドを操作することでドラッグ操作を実現するため。

## 検証計画
### 自動チェック
- ファイルのコンパイルチェック (ZMK 環境がないため不可、構文チェックのみ実施)
