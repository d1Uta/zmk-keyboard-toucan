# Project Rules

- **Git Push on Keymap Changes**: Whenever a keymap change is requested and implemented, the changes must be pushed to the remote repository (https://github.com/d1Uta/zmk-keyboard-toucan).
- **Verify File Content Before Edit**: Always run `view_file` or check the latest diff before applying `replace_file_content` to ensure TargetContent matches exactly.
- **Root Cause & Prevention Record**: When an error is resolved, document the cause and prevention measures in `knowledge/troubleshooting.md`.
- **CI Artifact Isolation**: Any parallel build configuration (strategy.matrix) must ensure strict artifact naming isolation to prevent merge race conditions.
- **Upstream Workflow Patching**: If an external reusable workflow (e.g., ZMK official) contains bugs or breaking changes that impede stability, prioritize creating a local patched copy over unstable parameter adjustments.
