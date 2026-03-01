# CLAUDE.md

This repo contains custom Claude Code subagents and slash commands.

## Structure

- `agents/` — Subagent system prompts (`.md` files). Each file defines a specialized agent type.
- `commands/` — Slash command definitions (`.md` files). Each file defines a user-invocable `/command`.
- `Makefile` — Installs agents and commands to `~/.claude/`.

## Conventions

- Agent files are named after their `subagent_type` (e.g., `go-reviewer.md` → `go-reviewer` agent).
- Command files are named after their slash command (e.g., `go-review.md` → `/go-review`).
- Review commands come in pairs: `<lang>-review` for uncommitted changes and `<lang>-review-all` for full codebase.
- `code-review` and `code-review-all` auto-detect the project language and delegate to the appropriate reviewer.
