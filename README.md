# 🚂👨‍💻 Rails Daddy Expert 💪🔥

Claude Code agents and skills for full-stack Rails developers. Drop into any Rails project to go from GitHub issue to PR-ready code — with tests, linting, and security checks in one workflow.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    WITHOUT Rails Daddy Expert                        │
│                                                                      │
│  📋 Issue → 🤔 Read code → ✍️  Write → 🐛 Debug → 🧪 Tests →       │
│  🔍 Rubocop → 🔐 Security check → 📝 PR description → 😩 2h later  │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                     WITH Rails Daddy Expert                          │
│                                                                      │
│  📋 Issue                                                            │
│     │                                                                │
│     ▼                                                                │
│  🤖 @issuer 1234  ──── queries Devin ────►  📚 Knows your codebase  │
│     │                                                                │
│     ├── 📄 spec.md   (what to build)                                 │
│     ├── 🗺️  plan.md   (how to build it)                              │
│     ├── ✅ tasks.md  (step by step)                                  │
│     ├── ⚙️  implements (minimal diff, no noise)                      │
│     ├── 🧪 rspec     (runs your tests)                               │
│     └── ⏸️  PAUSE → shows git diff → waits for YOU                  │
│                                                                      │
│  👀 You review → say "ok"                                            │
│     │                                                                │
│     ▼                                                                │
│  💾 commits → @merger                                                │
│     │                                                                │
│     ├── 🔐 IDOR / tenant scoping check                               │
│     ├── 🧱 migration quality check                                   │
│     ├── 🛡️  Brakeman security scan                                   │
│     └── 📋 PR description generated                                  │
│                                                                      │
│  🚀 PR ready in minutes, not hours                                   │
└─────────────────────────────────────────────────────────────────────┘
```

## Installation

From the root of any Rails project:

```bash
bash <(curl -s https://raw.githubusercontent.com/bedomax/rails-daddy-expert/main/install.sh)
```

Or by cloning:

```bash
git clone git@github.com:bedomax/rails-daddy-expert.git /tmp/rcs
bash /tmp/rcs/install.sh
```

## Agents

### 🔴 Issuer — `@issuer 1234`
> For bug fixes and issue-driven work. Follows the full speckit cycle.

```
  GitHub Issue #1234
        │
        ▼
  📖 Read issue  ──► understand bug vs feat, acceptance criteria
        │
        ▼
  🧠 Query Devin ──► "How does this area work? Which files?"
        │            (grounded in YOUR codebase, not generic Rails)
        ▼
  📄 spec.md     ──► what needs to be built / fixed
  🗺️  plan.md     ──► approach and file changes
  ✅ tasks.md    ──► step-by-step checklist
        │
        ▼
  ⚙️  Implement   ──► minimal diff · no cosmetic changes · no refactors
        │
        ▼
  🧪 rspec        ──► runs only affected spec files
  🔍 rubocop      ──► auto-correct new files only (not existing ones)
        │
        ▼
  ⏸️  PAUSE ──────► shows git diff · waits for your approval
        │
   you say "ok"
        │
        ▼
  💾 git commit   ──► "fix: description"
  📢 "Ready for @merger"
```

---

### 🔵 Maker — `@maker 1234` or `@maker "add X to Y"`
> For new features. Skips the speckit overhead, goes straight to implementation.

```
  Issue number OR plain description
        │
        ▼
  🧠 Query Devin ──► "How does this area work? Which models/controllers?"
        │
        ▼
  👁️  Read 1-2 files Devin identified  ──► confirm the pattern
        │
        ▼
  ⚙️  Implement in order:
        ├── 📦 migration  (null:, add_index on _id FKs)
        ├── 🏛️  model      (comment methods, soft-delete if needed)
        ├── 🎮 controller (tenant scoped, authorized, no tenant IDs in params)
        ├── 🖼️  views      (Hotwire / Turbo if applicable)
        └── 🧪 specs      (cross-tenant isolation test required)
        │
        ▼
  🧪 rspec   ──► runs changed spec files
  🔍 rubocop ──► auto-correct all changed files
        │
        ▼
  ⏸️  PAUSE ──► shows git diff · waits for your approval
        │
   you say "ok"
        │
        ▼
  💾 git commit  ──► "feat: description"
  📢 "Ready for @merger"
```

---

### 🟢 Merger — `@merger`
> Always the last step. Validates the branch and generates the PR description.

```
  Current branch
        │
        ▼
  🔎 git diff ──► identify all changed files
        │
        ▼
  🧠 Query Devin ──► "What are the security risks for these controllers?"
        │
        ▼
  🧪 rspec    ──► full spec run · stops on failure
  🔍 rubocop  ──► auto-correct changed files
        │
        ▼
  🔐 Security scan:
        ├── Model.find without tenant scope  ──► ❌ IDOR
        ├── Model.all / unscoped .where      ──► ❌
        └── permit(:tenant_id/:role_id)      ──► ❌
        │
        ▼
  🧱 Migration checks:
        ├── _id columns have add_index       ──► ✅/❌
        └── null: declared on every column   ──► ✅/❌
        │
        ▼
  🛡️  Brakeman security scan
        │
        ▼
  📋 Output:
        ├── checklist ✅/❌ for every check
        ├── verdict: READY or NEEDS FIXES (with file:line)
        └── PR description ready to paste
                ## What
                ## How
                ## Testing
                - [ ] Specs pass
                - [ ] Tenant isolation verified
                - [ ] Manual test: [action]
```

## Skills

| Skill | Command | When to use |
|-------|---------|-------------|
| `solve-issue` | `/solve-issue 1234` | Same as `@issuer` but as a skill |
| `add-feat` | `/add-feat "description"` | Same as `@maker` but as a skill |
| `validate-branch` | `/validate-branch` | Same as `@merger` but as a skill |
| `rails-expert` | automatic | Activates on Rails, ActiveRecord, Hotwire keywords |

## Typical flows

```bash
# Resolve a GitHub issue
@issuer 1350
# → agent reads issue, queries Devin for codebase context, implements, runs tests
# → shows git diff and pauses for your review
# → you say "ok" / "approved"
# → agent commits → "Ready for @merger"
@merger

# New feature from issue or description
@maker 1350
@maker "add export to CSV to the reports page"
# → agent implements, runs tests, shows git diff, pauses for your review
# → you approve → agent commits → "Ready for @merger"
@merger
```

## Commit approval flow

`@issuer` and `@maker` never commit automatically:

1. Agent implements all changes
2. Runs `rspec` and `rubocop`
3. Shows a `git diff` summary
4. **Pauses and waits for your explicit approval**
5. On approval → stages relevant files (`git add -p`) → commits

This ensures you always review code before it enters git history.

## How agents use Devin

Every agent queries `mcp__devin__ask_question` on your repo (`$DEVIN_REPO`) before writing code:

- **issuer / maker** — asks how the affected area works and which files are involved
- **merger** — asks what the security and data isolation risks are for the changed files

This grounds all code changes in your actual codebase patterns instead of generating generic Rails code.

## Requirements

- [Claude Code](https://claude.ai/code)
- [Devin MCP](https://devin.ai) with access to your repository
- `gh` CLI authenticated
- Rails project with `bundle exec rspec` and `rubocop` available

**No additional Claude plugins or skills required.** Rails Daddy Expert is self-contained — it does not depend on speckit, GSD, or any other Claude marketplace package.

## Setup

### 1. Install agents and skills

From the root of your Rails project:

```bash
bash <(curl -s https://raw.githubusercontent.com/bedomax/rails-daddy-expert/main/install.sh)
```

This copies agents into `.claude/agents/` and skills into `.claude/skills/`.

### 2. Configure Devin MCP

All agents query Devin before writing code to understand your codebase patterns. Add your repo to your project's `.claude/CLAUDE.md`:

```markdown
## Devin
DEVIN_REPO: your-org/your-repo
```

Replace `your-org/your-repo` with your actual GitHub repository (e.g. `acme/rails-app`).

### 3. Add your project conventions (optional)

The agents follow generic Rails best practices by default. To customize for your project, append your own rules to `.claude/CLAUDE.md`:

```markdown
## Project conventions
- Tenant method: `current_account` (or `current_company`, `current_workspace`, etc.)
- Auth: Pundit / CanCanCan / custom
- Soft delete: Discard / acts_as_paranoid / none
- Sign-in helper: `sign_in user` / `login_as user` / custom
```

## Session specs — `.claude/specs/`

After each implementation, `@issuer` and `@maker` write a brief spec file to `.claude/specs/<branch-name>.md`:

```markdown
# Fix broken CSV export
issue: #1234 · branch: fix/1234-csv-export · date: 2026-03-04
## What
Fix nil error when exporting empty report to CSV
## Files changed
app/controllers/reports_controller.rb
spec/controllers/reports_controller_spec.rb
## Tests
12 examples, 0 failures
```

This gives you a searchable history of every change made by the agents — what was built, which files were touched, and whether tests passed.

Add `.claude/specs/` to version control to keep the history in git.

## Token footprint

Agent and skill files are kept intentionally small to minimize tokens consumed per session:

| File | Words |
|------|-------|
| `agents/issuer.md` | ~300 |
| `agents/maker.md` | ~310 |
| `agents/merger.md` | ~270 |
| `skills/rails-expert.md` | ~120 |
| `skills/add-feat.md` | ~240 |
| `skills/solve-issue.md` | ~220 |
| `skills/validate-branch.md` | ~280 |
| **Total** | **~1750** |

Design principles that keep token count low:
- No boilerplate "Role Definition" or "When to Use" sections — only actionable instructions
- Rules are written as dense bullet points, not prose
- No duplicate content between agents — each file covers only its own workflow
- `rails-expert.md` was trimmed from 467 → 122 words (-74%) by removing decorative sections

## Rails conventions enforced

All agents enforce these patterns automatically:

- **Tenant scoping**: all queries scoped to the current tenant — never unscoped `Model.find(params[:id])`
- **Authorization**: authorization check on every controller action
- **Migrations**: explicit `null:` on columns; `add_index` for every FK
- **Minimal diffs**: only change lines required to fix the issue — no cosmetic reformatting of surrounding code
- **Tests**: cross-tenant isolation test for every modified controller
- **English**: all branch names, commit messages, and PR descriptions in English
