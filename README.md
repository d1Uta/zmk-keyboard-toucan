# ZMK config for beekeeb Toucan Keyboard (Customized)

[The beekeeb Toucan Keyboard](https://beekeeb.com/toucan-keyboard/) 用のカスタマイズ済み ZMK 設定リポジトリです。本設定は **o24 (大西配列)** をデフォルトとし、トラックパッドの感度やショートカットレイヤーを最適化しています。

## 🚀 beekeeb 公式設定からの主な変更点

1.  **デフォルト配列の変更**: QWERTY から **o24 (大西配列)** へ変更しました。
2.  **SYM レイヤーの挙動修正**: 
    - 以前の Mod-tap (長押しで Ctrl) を廃止。
    - 単体押しで `Ctrl + Key` が即座に発行されるダイレクトショートカット方式に変更。
    - Win 用 (Ctrl) と Mac 用 (Command/GUI) の両方の設定を同梱。
3.  **NAV レイヤーの改善**: 右手側の操作性を考慮し、中指上段の `Backspace` を `Delete` に変更しました。
4.  **トラックパッド感度の向上**: デフォルトより高速に移動できるよう調整済みです。

---

## ⌨️ キーマップ・レイアウト

### Base Layer: o24 (Onishi Layout)
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | TAB | Q | L | U | , | . | | F | W | R | Y | P | BSPC |
| **Home** | LCTRL | E | I | A | O | - | | K | T | N | S | H | SQT |
| **Bottom** | LSHFT | Z | X | C | V | ; | | G | D | M | J | B | ESC |
| **Thumb** | | | | LGUI | NAV | SPC | | RET | SYM | RALT | | |

### Shortcut Keys (SYM Layer)
作業効率を高めるため、以下のキーに `LC` (Win/Linux) または `LG` (Mac) 修飾のショートカットを割り当てています。
- `SYM + A`: Select All
- `SYM + S`: Save
- `SYM + Z`: Undo
- `SYM + X`: Cut
- `SYM + C`: Copy
- `SYM + V`: Paste
- `SYM + B`: Bold (等)

---

## 🖱️ トラックパッド (ポインタ) 設定

### 現在の設定値
- **X軸感度**: 公式比 **1.5 倍** (188/100)
- **Y軸感度**: 公式比 **2.5 倍** (250/100)

### 変更方法
`boards/shields/toucan/toucan.dtsi` 内の以下の数値を編集します。

```dtsi
input-processors = <&zip_x_scaler 188 100>, <&zip_y_scaler 250 100>;
```
- **第1引数**: 速度の分子。大きくすると速くなります。
- **第2引数**: 速度の分母（通常は 100）。

---

## 📂 フォルダ構成
OS や配列の好みに応じて `config/` 以下のファイルを切り替えてビルド可能です。

- `config/mac/onishi/`: Mac 用大西配列 (Command ショートカット)
- `config/mac/qwerty/`: Mac 用 QWERTY (Command ショートカット)
- `config/win/onishi/`: Windows 用大西配列 (Ctrl ショートカット)
- `config/win/qwerty/`: Windows 用 QWERTY (Ctrl ショートカット)

---

## 🛠️ ビルドと導入
GitHub Actions を使用して自動ビルドされます。
1. 変更をコミットして GitHub に Push。
2. Actions タブからビルド結果の `.uf2` ファイルをダウンロード。
3. キーボードをブートローダーモードにしてファイルをドラッグ＆ドロップ。

## License
The code in this repo is available under the MIT license.
ZMK code snippets are taken from the ZMK documentation under the MIT license.
The embedded font QuinqueFive is designed by GGBotNet, licensed under under the SIL Open Font License, Version 1.1.
