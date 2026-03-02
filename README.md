# lexgo-claude-setup

Claude Code agents y skills personales para proyectos Rails/Lexgo.

## Instalación

En la raíz de cualquier proyecto Rails:

```bash
bash <(curl -s https://raw.githubusercontent.com/bedomax/lexgo-claude-setup/main/install.sh)
```

O clonando:

```bash
git clone git@github.com:bedomax/lexgo-claude-setup.git /tmp/lcs
bash /tmp/lcs/install.sh
```

## Agentes

| Agente | Comando | Para qué |
|--------|---------|----------|
| 🔴 issuer | `@issuer 1234` | Resolver un issue de GitHub de punta a punta |
| 🔵 maker | `@maker "descripción"` | Implementar feature nueva sin issue |
| 🟢 merger | `@merger` | Validar branch y generar PR |

## Skills

| Skill | Comando | Para qué |
|-------|---------|----------|
| solve-issue | `/solve-issue 1234` | Flujo completo desde issue |
| add-feat | `/add-feat "descripción"` | Feature sin issue, paso a paso |
| validate-branch | `/validate-branch` | Validar branch antes del PR |
| rails-expert | automático | Se activa con Rails, ActiveRecord, Hotwire |

## Flujo típico

```
# Resolver un issue
@issuer 1350
@merger

# Feature nueva
@maker "agregar X"
@merger
```

## Requisitos

- Claude Code con MCP de Devin configurado (`Lexgo-cl/rails-backend`)
- `gh` CLI autenticado
- Proyecto Rails con `bundle exec rspec` y `rubocop` disponibles
