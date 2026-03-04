# Rails Daddy Expert

Claude Code agents and skills for full-stack Rails developers. Drop into any Rails project to go from GitHub issue to PR-ready code — with tests, linting, and security checks in one workflow.

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

| Agent | Command | Input | When to use |
|-------|---------|-------|-------------|
| 🔴 `issuer` | `@issuer 1234` | Issue number | Resolve a GitHub issue end-to-end via speckit (spec → plan → tasks → implement) |
| 🔵 `maker` | `@maker 1234` or `@maker "add X"` | Issue number **or** plain description | Implement a feature directly — skips speckit overhead |
| 🟢 `merger` | `@merger` | None | Validate branch and generate PR — always the last step |

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
- [Devin MCP](https://devin.ai) configured with your repo (`owner/repo`)
- `gh` CLI authenticated
- Rails project with `bundle exec rspec` and `rubocop` available

## Configuration

Set your Devin repo in your project's `CLAUDE.md` or shell environment:

```bash
export DEVIN_REPO="your-org/your-repo"
```

Or add it to `.claude/CLAUDE.md` at the root of your project:

```markdown
# Project config
DEVIN_REPO: your-org/your-repo
```

## Rails conventions enforced

All agents enforce these patterns automatically:

- **Tenant scoping**: all queries scoped to the current tenant — never unscoped `Model.find(params[:id])`
- **Authorization**: authorization check on every controller action
- **Migrations**: explicit `null:` on columns; `add_index` for every FK
- **Minimal diffs**: only changes lines required to fix the issue — no cosmetic reformatting of surrounding code
- **Tests**: cross-tenant isolation test for every modified controller
- **English**: all branch names, commit messages, and PR descriptions in English
