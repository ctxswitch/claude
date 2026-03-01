# Code Review — Full Codebase

Auto-detects the project language and launches the appropriate review agent for a full codebase review.

## Steps

1. **Detect language:**
   - Check for `Cargo.toml` in the project root → Rust → use `rust-reviewer` agent
   - Check for `go.mod` in the project root → Go → use `go-reviewer` agent
   - Check for `tsconfig.json` in the project root → TypeScript → use `typescript-reviewer` agent
   - Check for `pyproject.toml` or `setup.py` or `setup.cfg` in the project root → Python → use `python-reviewer` agent
   - If multiple or none are found, ask the user which language to review.

2. **Launch review agent:**
   - Use the Agent tool with the detected `subagent_type` and `model: "sonnet"`.
   - For **Rust**, tell the agent: "Review the entire codebase. Run `find src -name '*.rs' | sort` to get every Rust source file. Read and review every file in dependency order (leaf modules first, then toward main.rs/lib.rs). Also review `Cargo.toml` for dependency hygiene (unused deps, missing features, version pinning). After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."
   - For **Go**, tell the agent: "Review the entire codebase. Run `find . -name '*.go' -not -path './vendor/*' -not -name 'zz_generated*' | sort` to get every Go source file. Read and review every file in dependency order (leaf packages first, then toward main.go). Also review `go.mod` for dependency hygiene. After individual files, assess cross-cutting concerns (consistency, architecture, package boundaries). Do not skip files."
   - For **TypeScript**, tell the agent: "Review the entire codebase. Run `find src -name '*.ts' -o -name '*.tsx' | sort` to get every TypeScript source file. Read and review every file in dependency order (leaf modules first, then toward entry points). Also review `package.json` for dependency hygiene and `tsconfig.json` for strictness settings. After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."
   - For **Python**, tell the agent: "Review the entire codebase. Run `find . -name '*.py' -not -path './.venv/*' -not -path './venv/*' -not -path './.tox/*' | sort` to get every Python source file. Read and review every file in dependency order (leaf modules first, then toward entry points). Also review `pyproject.toml` for dependency hygiene and type checking configuration. After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."

3. Return the agent's findings to the user.
