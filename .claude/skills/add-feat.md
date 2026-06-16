---
name: add-feat
description: Implement a new feature. Creates a GitHub issue, explores existing code, plans, implements following Rails conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — feature description. If missing, ask and stop.

**Spec path**: `specs/<N>-<slug>/spec.md` — always. Example: `specs/1234-add-export/spec.md`

## Steps

1. **Clarify** — if scope is ambiguous, ask 1 question max before proceeding
2. `gh issue create --title "<description>" --body "<description>"` → get `$N`; slug: kebab-case, max 4 words
3. **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — "How does [feature area] work? Which models, controllers and files are involved?"
4. `git checkout -b <N>-<slug>`
5. Create `specs/<N>-<slug>/spec.md` — **draft** per `specs/_template.md`: What, Acceptance, Context
6. **Explore** — read 1–2 files Devin identified to confirm the pattern
7. **Implement in order**: migration → model → controller → views → specs
8. **Run specs**: `bundle exec rspec [changed spec files] --format progress 2>&1 | tail -15`
9. **Lint**: `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
10. **Finalize** `specs/<N>-<slug>/spec.md` — Decisions, Implemented, Routes, Tests, Manual QA, Deferred
11. **Commit**: stage code + `specs/<N>-<slug>/` → `git commit -m "feat: <description>"`
12. Report files changed, test results → "Ready for /validate-branch"

## Rails rules
- **Migration**: `null:` explicit on every column; `add_index` for every `_id` FK
- **Model**: comment every new method; use soft-delete (e.g. `acts_as_paranoid`) if record is deletable
- **Controller**: always scope to current tenant (e.g. `current_account.models.find(...)`); use authorization (`load_and_authorize_resource`); never permit tenant/role IDs in strong params
- **Specs**: set `request.host`, sign in with your project helper, stub layout helpers
- Every controller spec needs at least one cross-tenant isolation test
