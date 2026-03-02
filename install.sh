#!/bin/bash
# Instala agents y skills de bedomax en el proyecto actual
# Uso: bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET=".claude"

mkdir -p "$TARGET/agents" "$TARGET/skills"

cp "$REPO_DIR/agents/"*.md "$TARGET/agents/"
cp "$REPO_DIR/skills/"*.md "$TARGET/skills/"

echo "✓ Instalado en $TARGET/"
echo "  agents: issuer, maker, merger"
echo "  skills: solve-issue, add-feat, validate-branch, rails-expert"
