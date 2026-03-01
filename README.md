# Claude Code Custom Agents and Commands

Custom subagents and slash commands for [Claude Code](https://claude.com/claude-code).

## Agents

| Agent | Description |
|-------|-------------|
| `go-reviewer` | Go code reviewer |
| `golang-engineer` | Go developer |
| `golang-kube-controller` | Go Kubernetes controller developer |
| `python-engineer` | Python developer |
| `python-reviewer` | Python code reviewer |
| `rust-engineer` | Rust developer |
| `rust-kube-controller` | Rust Kubernetes controller developer |
| `rust-reviewer` | Rust code reviewer |
| `typescript-engineer` | TypeScript developer |
| `typescript-reviewer` | TypeScript code reviewer |

## Commands

| Command | Description |
|---------|-------------|
| `/code-review` | Auto-detect language and review uncommitted changes |
| `/code-review-all` | Auto-detect language and review the full codebase |
| `/go-review` | Review uncommitted Go changes |
| `/go-review-all` | Review entire Go codebase |
| `/rust-review` | Review uncommitted Rust changes |
| `/rust-review-all` | Review entire Rust codebase |
| `/typescript-review` | Review uncommitted TypeScript changes |
| `/typescript-review-all` | Review entire TypeScript codebase |
| `/python-review` | Review uncommitted Python changes |
| `/python-review-all` | Review entire Python codebase |
| `/implement` | Implement with review |
| `/init-kube-controller` | Initialize a Kubernetes controller project |

## Install

```sh
make install
```

Copies agents and commands to `~/.claude/`.
