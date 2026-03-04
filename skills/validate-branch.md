---
name: validate-branch
description: Validate current branch before opening a PR. Runs specs, RuboCop, security checks, and generates a PR description.
---

## Steps

```bash
BASE=$(gh pr view --json baseRefName --jq '.baseRefName' 2>/dev/null || echo "master")
```

1. **Changed files**: `git diff $BASE..HEAD --name-only`
2. **Query Devin** with `mcp__devin__ask_question` on repo `$DEVIN_REPO` — ask: "What are the security and data isolation risks when modifying [changed controllers/models]?" Use the answer to focus the security check in step 5.
3. **Specs**: `bundle exec rspec $(git diff $BASE..HEAD --name-only | grep '_spec\.rb' | tr '\n' ' ') --format progress 2>&1 | tail -15`
   — stop and fix failures before continuing

4. **RuboCop**: `git diff $BASE..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`

5. **Security** — scan the diff for:
   - `Model.find(params[:id])` without `current_enterprise` scope → ❌ IDOR
   - `Model.all` or unscoped `.where` in controllers → ❌
   - `permit(:enterprise_id)` or `permit(:role_id)` → ❌

6. **Migrations** — for each new file in `db/migrate/`:
   - `_id` columns have matching `add_index` → ✅/❌
   - `null:` declared explicitly → ✅/❌

7. **Isolation tests** — for each changed controller, its spec must contain `other_enterprise`:
   `git diff $BASE..HEAD --name-only | grep 'app/controllers' | sed 's|app/|spec/|;s|\.rb|_spec.rb|' | xargs grep -l "other_enterprise" 2>/dev/null`

8. **Brakeman**: `bundle exec brakeman --no-progress --quiet 2>/dev/null | head -20`

9. **Output**:
   - Checklist: ✅/❌ for each check above
   - Verdict: **READY** or **NEEDS FIXES** with file:line for each issue
   - PR description ready to paste:
     ```
     ## What
     ## How
     ## Testing
     - [ ] Specs pass (N examples, 0 failures)
     - [ ] Enterprise isolation verified
     - [ ] Manual test: [specific browser action]
     ```
