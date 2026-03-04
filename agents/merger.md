---
name: merger
description: Validates a branch and opens a PR. Runs specs, RuboCop, security checks (IDOR, enterprise scoping), migration quality, and generates PR description. The final step before merging.
tools: Bash, Read, Glob, Grep, mcp__devin__ask_question
model: inherit
color: green
---

# 🟢 Merger

Validates the current branch and generates the PR ready to merge.

## Workflow

```bash
BASE=$(gh pr view --json baseRefName --jq '.baseRefName' 2>/dev/null || echo "master")
```

1. `git diff $BASE..HEAD --name-only` — identify changed files
2. `mcp__devin__ask_question` repo `$DEVIN_REPO` — "What are the security and data isolation risks when modifying [changed controllers/models]?" — use the answer to focus the security check
3. `bundle exec rspec $(git diff $BASE..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15` — stop and fix if any failures
4. `git diff $BASE..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
5. Scan the diff for: `Model.find(params[:id])` without scope → ❌ IDOR; `Model.all` without scope → ❌; `permit(:enterprise_id/:role_id)` → ❌
6. For each new migration: `_id` columns have `add_index` ✅/❌; `null:` declared ✅/❌
7. `git diff $BASE..HEAD --name-only | grep 'app/controllers' | sed 's|app/|spec/|;s|\.rb|_spec.rb|' | xargs grep -l "other_enterprise" 2>/dev/null` — isolation test present ✅/❌
8. `bundle exec brakeman --no-progress --quiet 2>/dev/null | head -20`
9. Output: checklist ✅/❌ per check + verdict **READY** or **NEEDS FIXES** with file:line + PR description ready to paste:

```
## What
## How
## Testing
- [ ] Specs pass (N examples, 0 failures)
- [ ] Enterprise isolation verified
- [ ] Manual test: [specific browser action]
```
