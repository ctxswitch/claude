# Go Code Review — Full Codebase

Launch a `go-reviewer` agent to review the entire codebase.

1. Use the Agent tool with `subagent_type: "go-reviewer"` and `model: "sonnet"` to spawn the review agent.
2. Tell the agent: "Review the entire codebase. Run `find . -name '*.go' -not -path './vendor/*' -not -name 'zz_generated*' | sort` to get every Go source file. Read and review every file in dependency order (leaf packages first, then toward main.go). Also review `go.mod` for dependency hygiene. After individual files, assess cross-cutting concerns (consistency, architecture, package boundaries). Do not skip files."
3. Return the agent's findings to the user.
