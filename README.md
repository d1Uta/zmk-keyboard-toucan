# ZMK config for beekeeb Toucan Keyboard (Customized)

[The beekeeb Toucan Keyboard](https://beekeeb.com/toucan-keyboard/) 用のカスタマイズ済み ZMK 設定リポジトリです。本設定は **o24 (大西配列)** をデフォルトとし、トラックパッドの感度やショートカットレイヤーを最適化しています。

## 🚀 beekeeb 公式設定からの主な変更点

1.  **デフォルト配列の変更**: QWERTY から **o24 (大西配列)** へ変更しました。
2.  **SYM レイヤーの挙動修正**: 
    - 以前の Mod-tap (長押しで Ctrl) を廃止。
    - 単体押しで `Ctrl + Key` (Win) または `Cmd + Key` (Mac) が即座に発行されるダイレクトショートカット方式に変更。
    - Win 用 (Ctrl) と Mac 用 (Command/GUI) の設定を分離して最適化。
3.  **NAV レイヤーの改善**: 右手側の操作性を考慮し、中指上段の `Backspace` を `Delete` に変更しました。
4.  **トラックパッド感度の向上**: デフォルトより高速に移動できるよう調整済みです。

---

## ⌨️ キーマップ・レイアウト

本リポジトリには複数のバリアント（Mac/Win, 大西配列/QWERTY）が含まれていますが、**NAV, SYM, ADJ レイヤーは全バリアントで共通の設計**となっています。

### Base Layer: o24 (Onishi Layout)
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | TAB | Q | L | U | , | . | | F | W | R | Y | P | BSPC |
| **Home** | LCTRL | E | I | A | O | - | | K | T | N | S | H | SQT |
| **Bottom** | LSHFT | Z | X | C | V | ; | | G | D | M | J | B | ESC |
| **Thumb** | | | LGUI | NAV | SPC | | | RET | SYM | RALT | | | |

### Base Layer: QWERTY
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | TAB | Q | W | E | R | T | | Y | U | I | O | P | BSPC |
| **Home** | LCTRL | A | S | D | F | G | | H | J | K | L | ; | SQT |
| **Bottom** | LSHFT | Z | X | C | V | B | | N | M | , | . | / | ESC |
| **Thumb** | | | LGUI | NAV | SPC | | | RET | SYM | RALT | | | |

### Nav Layer (共通)
カーソル移動や数字入力を担当します。
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | ESC | 1 | 2 | 3 | 4 | 5 | | 6 | 7 | 8 | 9 | 0 | DEL |
| **Home** | LCTRL | (trans) | (trans) | (trans) | (trans) | (trans) | | LEFT | DOWN | UP | RIGHT | (trans) | (trans) |
| **Bottom** | LSHFT | UNLOCK | (trans) | (trans) | (trans) | (trans) | | LC+L | PG_DN | PG_UP | LC+R | (trans) | (trans) |
| **Thumb** | | | LGUI | (trans) | LCLK | | | RCLK | SYM | LALT | | | |

### Sym Layer (共通)
記号入力と、左手側に配置されたダイレクトショートカットキーを担当します。Win 用と Mac 用で修飾キーが最適化されています。
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | TAB | ! | @ | # | $ | % | | ^ | & | * | ( | ) | BSPC |
| **Home** | LCTRL | SelectAll | Save | (trans) | (trans) | (trans) | | - | = | [ | ] | \ | ` |
| **Bottom** | LSHFT | Undo | Cut | Copy | Paste | Bold | | _ | + | { | } | \| | ~ |
| **Thumb** | | | LGUI | (trans) | SPC | | | RCLK | (trans) | RALT | | | |

### Adj Layer (共通)
ファンクションキーとメディアコントロールを担当します（NAV + SYM の同時押しでアクセス）。
| row | 1 | 2 | 3 | 4 | 5 | 6 | | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Top** | TAB | UNLOCK | F7 | F8 | F9 | F12 | | Vol_Dn | Mute | Vol_Up | (trans) | (trans) | BSPC |
| **Home** | LCTRL | UNLOCK | F4 | F5 | F6 | F11 | | (trans) | (trans) | (trans) | (trans) | (trans) | (trans) |
| **Bottom** | LSHFT | (trans) | F1 | F2 | F3 | F10 | | (trans) | (trans) | (trans) | (trans) | (trans) | LGUI |
| **Thumb** | | | LANG2 | NAV | SPC | | | RET | SYM | LANG1 | | | |

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

- `mac_onishi/`: Mac 用大西配列 (**o24 MAC**)
- `mac_qwerty/`: Mac 用 QWERTY (**QWTY MAC**)
- `win_onishi/`: Windows 用大西配列 (**o24 W**)
- `win_qwerty/`: Windows 用 QWERTY (**QWTY W**)

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
