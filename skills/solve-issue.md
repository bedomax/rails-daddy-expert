---
name: solve-issue
description: Go from a GitHub issue number to working code with tests. Plans, implements following Rails conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — issue number. If missing, ask and stop.

## Steps

1. `gh issue view $ARGUMENTS --json title,body,labels,comments` — read to understand bug vs feat and acceptance criteria
2. **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — ask: "How does [affected area from issue title] work? Which files are involved?" Use the answer to understand existing patterns before planning.
3. Create branch: `git checkout -b fix/<N>-<slug>`
4. Write `.claude/specs/<branch>.md` — acceptance criteria, files likely involved
5. Plan: ordered list of changes needed
6. Tasks: numbered checklist of atomic changes
7. Implement each task
8. `bundle exec rspec $(git diff master..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
9. `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
10. Report: issue title, branch, tasks done N/N, test results → "Ready for /validate-branch"

## Rails rules during implementation
- Queries: always scope to current tenant (e.g. `current_account.models.find(params[:id])`), never `Model.find(...)`
- Controllers: use authorization on every action (e.g. `load_and_authorize_resource`)
- Migrations: `add_index` for every new `_id` FK column
- Specs: set `request.host`, sign in with your project helper, stub layout helpers
- Methods: comment every new method
