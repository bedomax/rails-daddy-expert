---
name: solve-issue
description: Go from a GitHub issue number to working code with tests. Chains speckit commands, implements following Lexgo conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — issue number. If missing, ask and stop.

## Steps

1. `gh issue view $ARGUMENTS --json title,body,labels,comments` — read to understand bug vs feat and acceptance criteria
2. **Query Devin** with `mcp__devin__ask_question` on repo `Lexgo-cl/rails-backend` — ask: "How does [affected area from issue title] work? Which files are involved?" Use the answer to understand existing patterns before planning.
3. `/speckit.specify $ARGUMENTS` — creates branch + spec.md
4. `/speckit.plan` — creates plan.md
5. `/speckit.tasks` — creates tasks.md
6. `/speckit.implement` — implements each task, commits after each
7. Run specs: `bundle exec rspec $(git diff master..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
8. Lint: `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
9. Report: issue title, branch, tasks done N/N, test results → "Ready for /validate-branch"

## Lexgo rules during implementation
- Queries: always `current_enterprise.models.find(params[:id])`, never `Model.find(...)`
- Controllers: `load_and_authorize_resource` on every action
- Migrations: index for every new `_id` column
- Specs: use `sign_in_with_multi_email_support`, `request.host = 'localhost'`, stub `layout_variables`
- Methods: comment every new method
