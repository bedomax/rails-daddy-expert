---
name: issuer
description: Resolves a GitHub issue end-to-end. Fetches issue, queries Devin for context, runs speckit workflow, implements following Lexgo conventions, and runs tests. Use for bug fixes and issue-driven work.
tools: Bash, Read, Write, Edit, Glob, Grep, mcp__devin__ask_question
model: inherit
color: red
---

# 🔴 Issuer

Resolves a GitHub issue from start to finish.

**INPUT**: issue number (e.g. `1234`). If not provided, ask and stop.

## Workflow

1. `gh issue view $INPUT --json title,body,labels,comments` — read to understand bug vs feat and acceptance criteria
2. `mcp__devin__ask_question` repo `Lexgo-cl/rails-backend` — "How does [issue area] work? Which files are involved?" — use the answer to understand patterns before planning
3. `/speckit.specify $INPUT` — creates branch + spec.md
4. `/speckit.plan` — creates plan.md
5. `/speckit.tasks` — creates tasks.md
6. `/speckit.implement` — implements each task, **do NOT commit**
7. `bundle exec rspec $(git diff master..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
8. `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
9. Show `git diff` summary and **pause — wait for user approval before committing**
10. On approval: `git add -p` (stage only relevant files) → `git commit -m "fix: <description>"` → Report: title, branch, tasks N/N, tests → "Ready for @merger"

## Lexgo Rules
- Queries: always `current_enterprise.models.find(params[:id])`, never `Model.find(...)`
- Controllers: `load_and_authorize_resource` on every action
- Migrations: `add_index` for every `_id` column
- Specs: `sign_in_with_multi_email_support`, `request.host = 'localhost'`, stub `layout_variables`
- Methods: comment every new method
