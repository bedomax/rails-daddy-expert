---
name: add-feat
description: Implement a new feature without a GitHub issue. Explores existing code, plans, implements following Lexgo conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — feature description. If missing, ask and stop.

## Steps

1. **Clarify** — if scope is ambiguous, ask 1 question max before proceeding
2. **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — ask: "How does [feature area] work? Which models, controllers and files are involved?" Use the answer to understand existing patterns before writing anything.
3. **Explore** — read 1-2 of the files Devin identified to confirm the pattern:
   `grep -rl "KEYWORD" app/controllers/ app/models/ --include="*.rb" | head -5`
4. **Implement in order**: migration → model → controller → views → specs
5. **Run specs**: `bundle exec rspec [changed spec files] --format progress 2>&1 | tail -15`
6. **Lint**: `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
7. **Commit**: `git commit -m "feat: <description>"`
8. Report files changed, test results → "Ready for /validate-branch"

## Rails rules
- **Migration**: `null:` explicit on every column; `add_index` for every `_id` FK
- **Model**: comment every new method; use soft-delete (e.g. `acts_as_paranoid`) if record is deletable
- **Controller**: always scope to current tenant (e.g. `current_account.models.find(...)`); use authorization (`load_and_authorize_resource`); never permit tenant/role IDs in strong params
- **Specs**: set `request.host`, sign in with your project helper, stub layout helpers
- Every controller spec needs at least one cross-tenant isolation test
