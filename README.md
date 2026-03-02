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

| Agent | Command | When to use |
|-------|---------|-------------|
| 🔴 issuer | `@issuer 1234` | Resolve a GitHub issue end-to-end |
| 🔵 maker | `@maker "description"` | Implement a new feature without an issue |
| 🟢 merger | `@merger` | Validate branch and generate PR |

## Skills

| Skill | Command | When to use |
|-------|---------|-------------|
| solve-issue | `/solve-issue 1234` | Full flow from a GitHub issue |
| add-feat | `/add-feat "description"` | Feature without issue, step by step |
| validate-branch | `/validate-branch` | Validate branch before opening PR |
| rails-expert | automatic | Activates on Rails, ActiveRecord, Hotwire keywords |

## Typical flow

```bash
# Resolve an issue
@issuer 1350
@merger

# New feature
@maker "add X to Y"
@merger
```

## Requirements

- Claude Code with Devin MCP configured (`Lexgo-cl/rails-backend`)
- `gh` CLI authenticated
- Rails project with `bundle exec rspec` and `rubocop` available
