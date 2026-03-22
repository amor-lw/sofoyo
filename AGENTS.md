# Repository Guidelines

## Project Structure & Module Organization
This repository is a legacy Classic ASP site plus migration artifacts. Treat `www/` as the application root. Page entry points live at `www/*.asp` such as `index.asp`, `about.asp`, `news*.asp`, and `pro*.asp`. Shared includes and helpers are in `www/INC/` and `www/conn.asp`. Static assets live in `www/css/`, `www/js/`, `www/image/`, `www/banner/`, `www/uploadpic/`, and related media folders. Legacy data and exports live under `www/Databases/`, `www/wwwlogs/`, and `www/legacy_export/`.

## Build, Test, and Development Commands
There is no `package.json`, `Makefile`, or local build pipeline in this snapshot. Development work is typically file editing plus targeted script runs.

`bash www/legacy_export/scripts/preflight_timeout.sh`
Checks long-running migration prerequisites and timeout risk.

`bash www/legacy_export/scripts/run_resumable_phase.sh`
Copies site assets into `www/legacy_export/site_assets/` with checkpointing.

`bash www/legacy_export/scripts/export_db_resumable.sh`
Exports the Access database to CSV and PostgreSQL schema files under `www/legacy_export/db/`.

`node www/legacy_export/scripts/phase4_import_prepare.js`
Prepares phase 4 import data for the Strapi migration path.

## Coding Style & Naming Conventions
Preserve Classic ASP and VBScript conventions in existing files. Match the surrounding style: tabs or 4-space indentation, inline server-side script blocks, and concise helper functions. Keep includes and asset references relative to `www/`. Use descriptive lowercase filenames for new scripts; follow the current naming pattern for legacy pages (`news1.asp`, `pro12.asp`) only when extending that system rather than introducing new routes.

## Testing Guidelines
No automated test suite is present. Validate changes by exercising the affected ASP page on IIS or a compatible staging environment and by checking generated files in `www/legacy_export/reports/`. For migration scripts, rerun only the relevant phase and confirm updated logs, manifests, or CSV output. Document manual verification steps in your change notes.

## Commit & Pull Request Guidelines
Git history is not available in this workspace snapshot, so use a simple, consistent format: imperative, present-tense commit subjects such as `Fix product pagination query` or `Add export manifest validation`. Keep PRs narrow, describe affected paths, list manual verification steps, and include screenshots for UI changes. Call out any edits touching `Databases/`, credentials, or export scripts.

## Security & Configuration Tips
Treat `www/Databases/`, `www/wwwlogs/`, and any credentials in ASP includes as sensitive. Do not add new secrets to the repo. Prefer migration outputs under `www/legacy_export/` and avoid editing generated reports by hand.
