# Rust Code Review — Full Codebase

Launch a `rust-reviewer` agent to review the entire codebase.

1. Use the Agent tool with `subagent_type: "rust-reviewer"` and `model: "sonnet"` to spawn the review agent.
2. Tell the agent: "Review the entire codebase. Run `find src -name '*.rs' | sort` to get every Rust source file. Read and review every file in dependency order (leaf modules first, then toward main.rs/lib.rs). Also review `Cargo.toml` for dependency hygiene (unused deps, missing features, version pinning). After individual files, assess cross-cutting concerns (consistency, architecture, module boundaries). Do not skip files."
3. Return the agent's findings to the user.
