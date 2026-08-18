# Lessons

- When adding MVP activity fields to JSON, explicitly map every field into the `New-MvpActivity` object before submission; the module only sets a small base set by default.
- If `Get-MvpActivity` fails on `MvpActivity` casting, use exported raw `Invoke-MvpRestMethod` for GET/POST/PUT and avoid typed module wrappers for created or existing records.
- For existing MVP activity update queues, include and use the activity `id` directly; do not depend on duplicate search or create-path validation when fields like URL and technology area are intentionally omitted.
- When a project has distinct module and webapp repositories, list them separately instead of collapsing them into one featured project.
- Recheck held pull requests immediately before finalizing an MVP upload queue; a previously open contribution may have merged since the audit.
