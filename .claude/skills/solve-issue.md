---
name: solve-issue
description: Go from a GitHub issue number to working code with tests. Plans, implements following Rails conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — issue number. If missing, ask and stop.

**Spec path**: `specs/<N>-<slug>/spec.md` — always. Example: `specs/1234-fix-menu/spec.md`

## Steps

1. `gh issue view $N --json title,body,labels,comments` — bug vs feat, acceptance criteria
2. Slug: kebab-case from issue title, max 4 words
3. **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — "How does [affected area] work? Which files are involved?"
4. `git checkout -b <N>-<slug>`
5. Create `specs/<N>-<slug>/spec.md` — **draft** per `specs/_template.md`: What, Acceptance, Context
6. Plan + tasks inline under `## Plan` and `## Tasks`
7. Implement each task
8. `bundle exec rspec $(git diff master..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
9. `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
10. **Finalize** `specs/<N>-<slug>/spec.md` — Decisions, Implemented, Tests, Manual QA; remove Plan/Tasks
11. Report: issue title, branch, tasks N/N, test results → "Ready for /validate-branch"

## Rails rules during implementation
- Queries: always scope to current tenant (e.g. `current_account.models.find(params[:id])`), never `Model.find(...)`
- Controllers: use authorization on every action (e.g. `load_and_authorize_resource`)
- Migrations: `add_index` for every new `_id` FK column
- Specs: set `request.host`, sign in with your project helper, stub layout helpers
- Methods: comment every new method
