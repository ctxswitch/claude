# Python Code Review — Full Codebase

Launch a `python-reviewer` agent to review the entire codebase.

1. Use the Agent tool with `subagent_type: "python-reviewer"` and `model: "sonnet"` to spawn the review agent.
2. Tell the agent: "Review the entire codebase. Run `find . -name '*.py' -not -path './.venv/*' -not -path './venv/*' -not -path './.tox/*' | sort` to get every Python source file. Read and review every file in dependency order (leaf modules first, then toward entry points). Also review `pyproject.toml` for dependency hygiene and type checking configuration. After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."
3. Return the agent's findings to the user.
