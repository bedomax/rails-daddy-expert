# lexgo-claude-setup

Personal Claude Code agents and skills for Rails/Lexgo projects.

## Installation

From the root of any Rails project:

```bash
bash <(curl -s https://raw.githubusercontent.com/bedomax/lexgo-claude-setup/main/install.sh)
```

Or by cloning:

```bash
git clone git@github.com:bedomax/lexgo-claude-setup.git /tmp/lcs
bash /tmp/lcs/install.sh
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
| `add-feat` | `/add-feat "description"` | Same as `@maker` but step by step |
| `validate-branch` | `/validate-branch` | Same as `@merger` but manual |
| `rails-expert` | automatic | Activates on Rails, ActiveRecord, Hotwire keywords |

## Typical flows

```bash
# Resolve a GitHub issue
@issuer 1350
# → agent implements, runs tests, shows git diff, pauses for your review
# → you review the code and say "ok" / "approved"
# → agent commits and reports "Ready for @merger"
@merger

# New feature from issue or description
@maker 1350
@maker "add signer message to bulk signature"
# → agent implements, runs tests, shows git diff, pauses for your review
# → you review the code and say "ok" / "approved"
# → agent commits and reports "Ready for @merger"
@merger
```

## Commit approval flow

`@issuer` and `@maker` never commit automatically. The flow is:

1. Agent implements all changes
2. Runs `rspec` and `rubocop`
3. Shows a `git diff` summary
4. **Pauses and waits for your explicit approval**
5. On approval → stages relevant files (`git add -p`) → commits

This ensures you always review code before it enters git history.

## How each agent uses Devin

Every agent queries `mcp__devin__ask_question` on `Lexgo-cl/rails-backend` before writing code:
- **issuer / maker** — asks how the affected area works and which files are involved
- **merger** — asks what the security and data isolation risks are for the changed files

## Requirements

- Claude Code with Devin MCP configured (`Lexgo-cl/rails-backend`)
- `gh` CLI authenticated
- Rails project with `bundle exec rspec` and `rubocop` available
