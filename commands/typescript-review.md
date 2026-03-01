# TypeScript Code Review — Uncommitted Changes

Launch a `typescript-reviewer` agent to review all uncommitted changes.

1. Use the Agent tool with `subagent_type: "typescript-reviewer"` and `model: "sonnet"` to spawn the review agent.
2. Tell the agent: "Review all uncommitted changes. Run `git diff HEAD` to see what changed. If there are also untracked files relevant to the changes, run `git status` and read those files too."
3. Return the agent's findings to the user.
