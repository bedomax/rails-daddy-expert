---
name: add-feat
description: Implement a new feature without a GitHub issue. Explores existing code, plans, implements following Lexgo conventions, and runs tests.
---

**INPUT**: `$ARGUMENTS` — feature description. If missing, ask and stop.

## Steps

1. **Clarify** — if scope is ambiguous, ask 1 question max before proceeding
2. **Query Devin** with `mcp__devin__ask_question` on repo `Lexgo-cl/rails-backend` — ask: "How does [feature area] work? Which models, controllers and files are involved?" Use the answer to understand existing patterns before writing anything.
3. **Explore** — read 1-2 of the files Devin identified to confirm the pattern:
   `grep -rl "KEYWORD" app/controllers/ app/models/ --include="*.rb" | head -5`
4. **Implement in order**: migration → model → controller → views → specs
5. **Run specs**: `bundle exec rspec [changed spec files] --format progress 2>&1 | tail -15`
6. **Lint**: `git diff master..HEAD --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop --auto-correct 2>&1 | tail -10`
7. **Commit**: `git commit -m "feat: <description>"`
8. Report files changed, test results → "Ready for /validate-branch"

## Lexgo rules
- **Migration**: `null:` explicit on every column; `add_index` for every `_id` FK
- **Model**: comment every new method; use `acts_as_paranoid` if record is deletable
- **Controller**: `current_enterprise.models.find(...)` always; `load_and_authorize_resource`; never permit `enterprise_id/role_id` in strong params
- **Specs boilerplate** (controller specs):
  ```ruby
  before do
    request.host = 'localhost'
    create(:admin_role) unless Role.exists?(1)
    create(:account_manager) unless Role.exists?(2)
    create(:client) unless Role.exists?(5)
    user.update!(last_sign_in_at: 2.minutes.ago)
    sign_in_with_multi_email_support user
    session[:enterprise_id] = enterprise.id
    allow(controller).to receive(:layout_variables)
  end
  ```
- Every controller spec needs at least one cross-enterprise isolation test
