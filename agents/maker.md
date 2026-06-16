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

**Spec path**: `specs/<N>-<slug>/spec.md` — always. Example: `specs/1234-add-export/spec.md`

## Workflow

1. **Resolve issue + slug**:
   - If number → `gh issue view $N --json title,body,labels,comments`
   - If text → `gh issue create --title "<description>" --body "<description>"` to get `$N`
   - Slug: kebab-case from issue title, max 4 words
   - Branch: `<N>-<slug>`
2. `git checkout -b <N>-<slug>` (skip if already on matching branch)
3. `mcp__devin__ask_question` repo `$DEVIN_REPO` — "How does [feature area] work? Which models, controllers and files are involved?"
4. Create `specs/<N>-<slug>/spec.md` — **draft**: What, Acceptance, Context. Follow `specs/_template.md`.
5. Read 1–2 reference files Devin named to confirm pattern
6. If scope ambiguous, ask at most 1 question
7. Implement: migration → model → controller → views → specs
8. `bundle exec rspec [changed spec files] --format progress 2>&1 | tail -15`
9. `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
10. **Finalize** `specs/<N>-<slug>/spec.md` — Decisions, Implemented, Routes, Tests, Manual QA, Deferred. No code dumps; ≤5 bullets per section.
11. Show `git diff` summary and **pause — wait for user approval before committing**
12. On approval: stage code + `specs/<N>-<slug>/` → `git commit -m "feat: <description>"` → Report changed files, test results → "Ready for @merger"

## Spec rules (token-efficient handoff)
- Write early (Context) so later steps don't re-query Devin for the same patterns
- Record **Decisions** only when non-obvious (auth approach, soft-delete, naming)
- **Implemented**: file path + one-line purpose — not diffs or full methods
- **Deferred**: what was skipped — prevents duplicate work in future sessions
- **Manual QA**: concrete browser steps `@merger` can paste into PR

## Rules
- Migration: `null:` on every column; `add_index` every `_id` FK
- Model: comment every method; soft-delete if deletable
- Controller: scope to tenant; authorization on every action; never permit tenant/role IDs
- Specs: `request.host`, project sign-in helper, stub layout; cross-tenant isolation test required
