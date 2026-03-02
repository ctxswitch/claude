# Global Rules

## Implementation Workflow

When implementing code changes, follow this workflow for every unit of work:

1. **Implement** — Use the appropriate implementation agent via the Agent tool.
2. **Build & format** — Run the build check and format commands for every language touched.
3. **Review** — Launch a SEPARATE review agent (`model: "sonnet"`) to review all uncommitted changes via `git diff HEAD`. Never review in the implementation context. Never skip this step.
4. **Fix** — If the review finds issues, fix each one individually, rebuild, commit the fix, and re-review until it passes. One fix per commit.
5. **Commit** — Only after the review passes and tests pass.

This cycle applies to every discrete step. If a plan has 5 steps, each step goes through all 5 phases independently.

## Language and Agent Selection

Select agents based on the language of the files involved:

| | Rust | Go | TypeScript | Python |
|---|---|---|---|---|
| **Implementation agent** | `rust-engineer` | `golang-engineer` | `typescript-engineer` | `python-engineer` |
| **Kube controller agent** | `rust-kube-controller` | `golang-kube-controller` | — | — |
| **Review agent** | `rust-reviewer` | `go-reviewer` | `typescript-reviewer` | `python-reviewer` |
| **Build check** | `cargo build && cargo clippy` | `go build ./... && go vet ./...` | `tsc --noEmit` | `mypy .` (or project equivalent) |
| **Test command** | `cargo test` | `go test ./...` | project test script | `pytest` |
| **Format command** | `cargo fmt` | `gofmt -w .` | `prettier --write .` | `ruff format .` |

If a step involves Kubernetes controllers or CRDs, prefer the kube controller agent over the general implementation agent. If a step spans multiple languages, launch one implementation agent and one review agent per language.

For languages not listed above, use `general-purpose` as both the implementation and review agent.

## Planning

When designing a plan, each step in the plan MUST include:
- What to implement and which files to create or modify
- Which implementation agent to use
- Which build, format, and test commands to run
- Which review agent to launch after implementation
- The full workflow: implement → build & format → review → fix → commit

Prefer single-language steps. Split cross-language work into separate steps unless tightly coupled.

After the plan is approved, create a task (via `TaskCreate`) for each step. Each task description must contain the full workflow above so it is self-contained. Chain all tasks sequentially using `addBlockedBy` — task 2 is blocked by task 1, task 3 is blocked by task 2, and so on.

## Commits

These are checkpoint commits that will be squashed at the end. Keep them simple:
- Use `git commit -m "short description"` — single line, no body, no co-author, no heredocs.
- Never use command substitution (`$(...)`) in commit messages.

## Hard Rules

- **NEVER commit without a review.** Every set of changes MUST be reviewed by a separate review agent BEFORE committing. If you are about to commit and have not launched a review agent, STOP and launch one. No exceptions.
- **One step at a time.** Complete one step (implement → build → review → fix → commit) before starting the next. Never start a step while its predecessor is still open.
- **Reviews are always isolated.** Always a separate review agent — never review your own work in the same context.
- **Build must pass before commit.** Never commit code that doesn't compile or pass format checks.
- **Tests must pass before commit.** Run tests after implementation and after each fix.
- **Do not over-engineer.** Implement what was planned, nothing more.
