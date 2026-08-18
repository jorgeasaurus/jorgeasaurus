# MVP Description Update Queue

- [x] Inspect `currentactivities.json` descriptions.
- [x] Generate enhanced description updates for all current activities.
- [x] Populate `MVPActivities.json` as an update-only queue keyed by current titles.
- [x] Harden script so omitted URL/metrics/quantity fields do not overwrite existing values.
- [x] Fix update path to use activity ids directly and bypass duplicate search/create validation.
- [x] Validate JSON and script syntax.

## Review

`MVPActivities.json` now contains 42 existing-activity update records: 14 Blog, 26 Open Source/Project/Sample code/Tools, 1 Video, and 1 Podcast. Descriptions are 276-411 characters and no update record includes URL or metric fields, so existing values are preserved by the script. The script now uses ids directly for `-UpdateExisting`, skips authentication during `-WhatIf`, and avoids duplicate search/create validation for this queue.

# GitHub Profile README Refresh

- [x] Inspect README, PSREADME, portfolio page, lessons, and git status.
- [x] Verify current repo/project signals and latest publication links.
- [x] Reduce featured projects to the strongest profile-relevant set.
- [x] Simplify certifications and tech stack.
- [x] Update recent publications.
- [x] Mirror content where required across PSREADME and index.html.
- [x] Verify markdown/HTML syntax and review the diff.
- [x] Split Intune Hydration Kit into module and webapp entries.

## Plan

Keep the GitHub README concise: high-impact projects only, compact cert links, grouped text-based stack, and the 5 newest blog posts from RSS. Mirror the same project/cert/stack choices into PSREADME and index.html to avoid stale parallel profiles.

## Review

README now features the strongest projects, including separate Intune Hydration Kit module and webapp entries, grouped core stack, 3 credentials, and the 5 latest RSS-backed posts from May-June 2026. PSREADME and index.html use the same project, stack, and cert choices; verification covered scoped whitespace, PowerShell parsing for both code blocks, `tidy`, and a local Playwright render pass. The module/webapp follow-up was rechecked with scoped whitespace validation and PowerShell parsing.

# Add EndpointJobs Featured Project

- [x] Verify EndpointJobs repo details.
- [x] Add EndpointJobs to `README.md` featured work.
- [x] Mirror EndpointJobs in `PSREADME.md`.
- [x] Mirror EndpointJobs in `index.html`.
- [x] Validate syntax/render impact and review diff.

# Add TerminalSlides Featured Project

- [x] Add TerminalSlides to the synchronized featured-project listings.
- [x] Validate the profile markup and review the scoped diff.

## Review

- Added TerminalSlides with its GitHub link and terminal-native ANSI slide-deck description in `README.md`, `PSREADME.md`, and `index.html`. Both PowerShell representations parse; `tidy` reports no HTML errors, and the scoped diff passes `git diff --check`.

## Plan

Add `https://github.com/jorgeasaurus/EndpointJobs` as a TypeScript endpoint jobs board entry across the three synchronized profile surfaces.

## Review

EndpointJobs is now listed in `README.md`, `PSREADME.md`, and `index.html`. PowerShell snippets parse, `git diff --check` passes, and `tidy` warnings match the pre-change baseline.

# Recent MVP Activity Candidates

- [x] Inventory public project work from June 14-July 14, 2026.
- [x] Inventory blog posts published or materially updated in the same window.
- [x] Reconcile candidates against existing MVP activities.
- [x] Verify dates, URLs, Microsoft relevance, and public audience.
- [x] Produce a ranked evidence table with skipped and confirmation-needed items.

## Plan

Use the last 30 days as the reporting window. Treat repository history as discovery, verify candidate facts from public sources, and keep only auditable Microsoft-relevant contributions.

## Review

Audited 158 local repositories, GitHub source data, the live blog/RSS, and the 42-record MVP snapshot. Identified 10 ready new entries, 4 existing activities to update, 4 items to hold for confirmation, and excluded private, automated, duplicate, or non-Microsoft work. Added a May 17-June 13 backlog pass because the current MVP snapshot ends May 16.

# Add New MVP Activities to JSON

- [x] Confirm the uploader schema and valid portal values.
- [x] Append the 10 verified new activities without changing existing update records.
- [x] Validate JSON structure, required fields, dates, URLs, and duplicate safety.
- [x] Verify normal create mode selects exactly the new activities.
- [x] Document the upload command and validation result.

## Plan

Keep the 42 ID-based update records intact. Append field-rich creation records so normal uploader mode selects only the 10 new activities, while `-UpdateExisting` remains available for the existing queue.

## Review

`MVPActivities.json` now contains 52 records: 42 existing ID-based updates and 10 new creation records with canonical URLs, portal-valid technology areas, audiences, dates, and evidence-backed descriptions. Normal `-WhatIf` selects exactly 10 additions; `-UpdateExisting -WhatIf` selects exactly 42 existing records. JSON, PowerShell syntax, HTTPS evidence URLs, field constraints, duplicate checks, and scoped whitespace validation pass.

# Add Merged Driver Automation Tool PR

- [x] Confirm upstream PR #855 was merged.
- [x] Add the merged contribution to `MVPActivities.json`.
- [x] Validate JSON and the uploader preview count.

## Plan

Add the merged upstream contribution as a separate open-source activity using the PR URL and Microsoft Intune, Graph, identity, and PowerShell classifications.

## Review

Added merged Driver Automation Tool PR #855 with its exact submission and merge timestamps, upstream URL, audience, technology areas, and verified contribution details. The queue now contains 53 records: 11 new creations and 42 existing updates. JSON parsing, duplicate checks, PR URL availability, whitespace validation, and the uploader `-WhatIf` preview pass.
