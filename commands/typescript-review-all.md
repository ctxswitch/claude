# TypeScript Code Review — Full Codebase

Launch a `typescript-reviewer` agent to review the entire codebase.

1. Use the Agent tool with `subagent_type: "typescript-reviewer"` and `model: "sonnet"` to spawn the review agent.
2. Tell the agent: "Review the entire codebase. Run `find src -name '*.ts' -o -name '*.tsx' | sort` to get every TypeScript source file. Read and review every file in dependency order (leaf modules first, then toward entry points). Also review `package.json` for dependency hygiene and `tsconfig.json` for strictness settings. After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."
3. Return the agent's findings to the user.
