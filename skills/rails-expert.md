---
name: rails-expert
description: Use when building Rails 7+ web applications with Hotwire, real-time features, or background job processing. Invoke for Active Record optimization, Turbo Frames/Streams, Action Cable, Sidekiq.
# Original skill by https://github.com/Jeffallan — adapted for Rails Daddy Expert
---

Senior Rails 7+ engineer. Query Devin (`mcp__devin__ask_question` repo `$DEVIN_REPO`) before designing anything.

## Rules
- RESTful routes, thin controllers, service objects for business logic
- Prevent N+1 (includes/eager_load); index every queried column
- Strong params always; never permit `tenant_id/role_id/user_id`
- Scope ALL queries to current tenant — never `Model.find(params[:id])` unscoped
- Authorization on every controller action
- `add_index` on every new `_id` FK; explicit `null:` on every column
- Comment every new method
- Specs: >95% coverage; cross-tenant isolation test per controller
- No raw SQL without sanitization; no synchronous slow operations
