# Code Review — Uncommitted Changes

Auto-detects the project language and launches the appropriate review agent.

## Steps

1. **Detect language:**
   - Check for `Cargo.toml` in the project root → Rust → use `rust-reviewer` agent
   - Check for `go.mod` in the project root → Go → use `go-reviewer` agent
   - Check for `tsconfig.json` in the project root → TypeScript → use `typescript-reviewer` agent
   - Check for `pyproject.toml` or `setup.py` or `setup.cfg` in the project root → Python → use `python-reviewer` agent
   - If multiple or none are found, ask the user which language to review.

2. **Launch review agent:**
   - Use the Agent tool with the detected `subagent_type` (`rust-reviewer`, `go-reviewer`, `typescript-reviewer`, or `python-reviewer`) and `model: "sonnet"`.
   - Tell the agent: "Review all uncommitted changes. Run `git diff HEAD` to see what changed. If there are also untracked files relevant to the changes, run `git status` and read those files too."

3. Return the agent's findings to the user.
