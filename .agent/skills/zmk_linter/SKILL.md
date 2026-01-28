---
name: zmk_linter
description: Lints ZMK .keymap and .dtsi files for valid #include statements to prevent build failures.
---

# ZMK Include Linter

This skill provides a way to verify that all `#include` statements in your ZMK configuration are valid.

## Usage

Run the linter script to check all `.keymap` and `.dtsi` files in your repository:

```powershell
.agent/skills/zmk_linter/lint_includes.ps1
```

## Features
- Checks for local `#include "..."` files existence.
- Verifies standard `#include <...>` syntax.
- Warns about missing common headers (like `mouse.h` if mouse bindings are detected).

## Script Details
The script [lint_includes.ps1](file:///C:/.agent_central/skills/zmk_linter/lint_includes.ps1) scans the `config/` directory by default.
