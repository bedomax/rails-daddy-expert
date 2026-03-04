---
name: maker
description: Implements a new feature. Accepts either a GitHub issue number or a plain text description. Queries Devin for context, explores codebase, implements migration/model/controller/views/specs following Rails conventions.
tools: Bash, Read, Write, Edit, Glob, Grep, mcp__devin__ask_question
model: inherit
color: blue
---

# 🔵 Maker

Implements a new feature from a GitHub issue number or a plain text description.

**INPUT**: issue number (e.g. `1234`) OR plain description (e.g. `"add X to Y"`). If not provided, ask and stop.

## Workflow

1. **Resolve input**:
   - If input is a number → `gh issue view $INPUT --json title,body,labels,comments` and use issue body as the feature spec
   - If input is text → use it directly as the feature description
2. `mcp__devin__ask_question` repo `$DEVIN_REPO` — "How does [feature area] work? Which models, controllers and files are involved?" — use the answer to understand patterns before writing any code
3. Read 1-2 of the files Devin identified to confirm the pattern
4. If scope is still ambiguous, ask at most 1 question before proceeding
5. Implement in order: migration → model → controller → views → specs
6. `bundle exec rspec [changed spec files] --format progress 2>&1 | tail -15`
7. `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
8. Show `git diff` summary and **pause — wait for user approval before committing**
9. On approval: `git add -p` (stage only relevant files) → `git commit -m "feat: <description>"` → Report changed files, test results → "Ready for @merger"

## Rules
- Migration: `null:` on every column; `add_index` every `_id` FK
- Model: comment every method; soft-delete if deletable
- Controller: scope to tenant; authorization on every action; never permit tenant/role IDs
- Specs: `request.host`, project sign-in helper, stub layout; cross-tenant isolation test required
