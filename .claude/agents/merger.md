---
name: merger
description: Validates a branch and opens a PR. Runs specs, RuboCop, security checks (IDOR, tenant scoping), migration quality, and generates PR description. The final step before merging.
tools: Bash, Read, Glob, Grep, mcp__devin__ask_question
model: inherit
color: green
---

# 🟢 Merger

Validates the current branch and generates the PR ready to merge.

**Spec path**: `specs/<N>-<slug>/spec.md` — derive from branch (`1234-add-export` → `specs/1234-add-export/spec.md`) or from diff.

## Workflow

```bash
BASE=$(gh pr view --json baseRefName --jq '.baseRefName' 2>/dev/null || echo "master")
```

1. `git diff $BASE..HEAD --name-only` — identify changed files
2. **Load spec** — read `specs/<N>-<slug>/spec.md` from diff, or parse branch name (`<N>-<slug>` → `specs/<N>-<slug>/spec.md`)
3. **Security context**:
   - If spec has **Context** + **Implemented** → use those files for the security scan; skip Devin
   - Else → `mcp__devin__ask_question` repo `$DEVIN_REPO` — "What are the security and data isolation risks when modifying [changed controllers/models]?"
4. `bundle exec rspec $(git diff $BASE..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15` — stop and fix if any failures
5. `git diff $BASE..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
6. Scan the diff for: `Model.find(params[:id])` without tenant scope → ❌ IDOR; `Model.all` without scope → ❌; `permit(:tenant_id/:role_id)` → ❌
7. For each new migration: `_id` columns have `add_index` ✅/❌; `null:` declared ✅/❌
8. `git diff $BASE..HEAD --name-only | grep 'app/controllers' | sed 's|app/|spec/|;s|\.rb|_spec.rb|' | xargs grep -l "other_tenant" 2>/dev/null` — isolation test present ✅/❌
9. `bundle exec brakeman --no-progress --quiet 2>/dev/null | head -20`
10. Output: checklist ✅/❌ per check + verdict **READY** or **NEEDS FIXES** with file:line + PR description:

**If `specs/<N>-<slug>/spec.md` exists** — map sections directly (do not re-analyze the diff for prose):
```
## What
<spec What>

## How
<spec Decisions as bullets, then Implemented summary by layer>

## Testing
<spec Tests as checkbox>
- [ ] Tenant isolation verified
<spec Manual QA as numbered checkboxes>

## Out of scope
<spec Deferred — omit section if empty>
```

**If no spec** — fall back:
```
## What
## How
## Testing
- [ ] Specs pass (N examples, 0 failures)
- [ ] Tenant isolation verified
- [ ] Manual test: [specific browser action]
```
