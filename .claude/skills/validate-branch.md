---
name: validate-branch
description: Validate current branch before opening a PR. Runs specs, RuboCop, security checks, and generates a PR description.
---

**Spec path**: `specs/<N>-<slug>/spec.md` — derive from branch (`1234-add-export` → `specs/1234-add-export/spec.md`) or from diff.

## Steps

```bash
BASE=$(gh pr view --json baseRefName --jq '.baseRefName' 2>/dev/null || echo "master")
```

1. **Changed files**: `git diff $BASE..HEAD --name-only`
2. **Load spec** — read `specs/<N>-<slug>/spec.md` from diff, or parse branch name
3. **Security context**:
   - If spec has **Context** + **Implemented** → use those files; skip Devin
   - Else → **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — "What are the security and data isolation risks when modifying [changed controllers/models]?"
4. **Specs**: `bundle exec rspec $(git diff $BASE..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
   — stop and fix failures before continuing

5. **RuboCop**: `git diff $BASE..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`

6. **Security** — scan the diff for:
   - `Model.find(params[:id])` without tenant scope → ❌ IDOR
   - `Model.all` or unscoped `.where` in controllers → ❌
   - `permit(:tenant_id)` or `permit(:role_id)` → ❌

7. **Migrations** — for each new file in `db/migrate/`:
   - `_id` columns have matching `add_index` → ✅/❌
   - `null:` declared explicitly → ✅/❌

8. **Isolation tests** — for each changed controller, its spec must contain `other_tenant`:
   `git diff $BASE..HEAD --name-only | grep 'app/controllers' | sed 's|app/|spec/|;s|\.rb|_spec.rb|' | xargs grep -l "other_tenant" 2>/dev/null`

9. **Brakeman**: `bundle exec brakeman --no-progress --quiet 2>/dev/null | head -20`

10. **Output**:
   - Checklist: ✅/❌ for each check above
   - Verdict: **READY** or **NEEDS FIXES** with file:line for each issue
   - PR description from `specs/<N>-<slug>/spec.md` if present (same mapping as @merger), else:
     ```
     ## What
     ## How
     ## Testing
     - [ ] Specs pass (N examples, 0 failures)
     - [ ] Tenant isolation verified
     - [ ] Manual test: [specific browser action]
     ```
