# Implement with Review

Orchestrates the full implementation lifecycle: discover, plan, implement, review, fix, commit, reset. Auto-detects the project language and uses the appropriate agents.

## Step 0: Discovery

Before doing anything else, work with the user to fully understand what they want built. This is a conversation — ask clarifying questions until the intent is clear.

1. **Summarize your understanding** of what the user is asking for.
2. **Ask clarifying questions** about anything ambiguous or underspecified. Examples:
   - What is the expected behavior or outcome?
   - Are there edge cases or error scenarios to handle?
   - Are there constraints (performance, compatibility, dependencies)?
   - Should this integrate with existing code or be standalone?
   - Are there specific patterns or conventions to follow?
3. **Continue the conversation** until both you and the user agree on what will be built. Do not move on until the user confirms the requirements are complete.

Do NOT skip discovery. Even if the request seems clear, confirm your understanding with the user before proceeding.

## Step 1: Record Starting Point

Before any work begins, record the current HEAD so we can reset at the end:

```
git rev-parse HEAD
```

Store this as `$START_SHA`.

## Step 2: Plan

Before writing any code, enter plan mode to design the approach:

1. Explore the codebase to understand existing patterns, structure, and conventions.
2. Identify which files need to be created or modified.
3. Write a step-by-step implementation plan.
4. Present the plan to the user for approval via ExitPlanMode.

Do NOT skip planning. Even for seemingly simple tasks, confirm the approach first.

When designing steps, **prefer single-language steps**. If a task involves changes across multiple languages (e.g., backend in Go and frontend in TypeScript), split them into separate steps rather than combining them. This keeps implementation and review focused. Only combine languages in a single step when the changes are tightly coupled and cannot be meaningfully separated.

## Step 3: Implement, Review, and Commit — One Step at a Time

Iterate through the approved plan **one step/phase at a time**. For each step, determine the appropriate language and agents based on the files being touched.

### Language and Agent Selection

Projects may use multiple languages. For each step, select agents based on the language of the files involved:

| | Rust | Go | TypeScript | Python |
|---|---|---|---|---|
| **Implementation agent** | `rust-engineer` | `golang-engineer` | `typescript-engineer` | `python-engineer` |
| **Kube controller agent** | `rust-kube-controller` | `golang-kube-controller` | — | — |
| **Review agent** | `rust-reviewer` | `go-reviewer` | `typescript-reviewer` | `python-reviewer` |
| **Build check** | `cargo build && cargo clippy` | `go build ./... && go vet ./...` | `tsc --noEmit` | `mypy .` (or project equivalent) |
| **Test command** | `cargo test` | `go test ./...` | project test script | `pytest` |
| **Format command** | `cargo fmt` | `gofmt -w .` | `prettier --write .` | `ruff format .` |

If a step involves Kubernetes controllers or CRDs, prefer the kube controller agent over the general implementation agent.

### 3a: Implement the Step

Use the Agent tool with the appropriate implementation agent for the language this step targets. If the step spans multiple languages, launch an implementation agent **for each language** — they can run in parallel. Provide each agent with:

- **Only the current step** from the plan — not the entire plan
- The specific files to create or modify **in that agent's language**
- Any relevant context from the codebase exploration

### 3b: Build and Format

Run the build check and format commands for **every language** that was touched in this step.

### 3c: Review the Step

Launch the appropriate review agent with `model: "sonnet"` for each language changed in this step. If multiple languages were touched, launch **one review agent per language** — they can run in parallel. Tell each agent: "Review all uncommitted changes. Run `git diff HEAD` to see what changed. If there are also untracked files relevant to the changes, run `git status` and read those files too."

### 3d: Fix Review Issues

If the review returns issues:

1. For each issue identified by the review:
   a. Fix the issue — use the implementation agent for complex fixes, or fix directly for simple ones.
   b. Run the build check to verify the fix compiles.
   c. Commit the fix.
   d. Launch a **new** review agent with `model: "sonnet"` to review uncommitted changes.
   e. Repeat until the review passes.

2. Each fix is one commit. Do not batch multiple fixes.

### 3e: Commit the Step

Once the review passes and tests pass, commit the step with a message describing what was implemented.

### 3f: Next Step

Move to the next step in the plan and repeat from 3a. Do not proceed to the next step until the current step is committed and passing.

## Step 4: Reset

Once all steps are implemented, reviewed, and committed, soft reset to the starting point:

```
git reset --soft $START_SHA
```

This leaves all changes staged but uncommitted, so the user can craft the final commit(s) themselves.

## Rules

- **One step at a time.** Never send the full plan to an agent. Implement, review, and commit each step before moving on.
- **Never skip the review.** Every step gets reviewed before it is committed.
- **Reviews are always isolated.** Always a separate review agent — never review in the implementation context.
- **One fix per commit.** Each review issue is addressed and committed individually. These are checkpoints, not final history.
- **Build must pass.** Never commit code that doesn't compile or pass format checks.
- **Tests must pass.** Run tests after implementation and after each fix.
- **Do not over-engineer.** Implement what was planned, nothing more.
- **Always reset at the end.** The soft reset is mandatory. The user decides the final commit structure.
