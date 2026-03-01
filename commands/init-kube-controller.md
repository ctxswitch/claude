# Initialize Kubernetes Controller Project

**IMPORTANT: This command MUST run using the `golang-kube-controller` agent.** Always use the Agent tool with `subagent_type: "golang-kube-controller"` to spawn a new agent. Pass the entire contents of this prompt to the agent. Do NOT run this in the current conversation context.

---

You are scaffolding a new Kubernetes controller project. Before generating any files, gather project information:

**Step 1: Check for existing `go.mod`.** Read `go.mod` in the current directory. If it exists, extract the module path from the `module` directive — do not ask the user for it.

**Step 2: Ask the user** for the remaining information using AskUserQuestion:

1. **API group** — e.g. `myapp.ctx.sh` (the Kubernetes API group for the CRD)
2. **API version** — e.g. `v1beta1` (default to `v1beta1` if not specified)
3. **CRD kind** — e.g. `Widget` (PascalCase singular, used for the Go type name)

Only ask for the **Go module path** if `go.mod` does not exist. Use a single AskUserQuestion with all applicable questions.

Once you have the answers, derive the following:

- `{module_path}` = from `go.mod` or user input
- `{project_short_name}` = last segment of module path (e.g. `ctx.sh/my-operator` → `my-operator`)
- `{resource}` = lowercase of CRD kind (e.g. `widget`)
- `{resource_plural}` = lowercase plural of CRD kind (e.g. `widgets`)
- `{short_name}` = first 3 letters of resource (e.g. `wid`)
- `{group_package}` = API group used as directory name under `pkg/apis/` (e.g. `myapp.ctx.sh`)
- `{leader_lock}` = `{resource}-{project_short_name}-leader-lock`

## Files to Generate

Generate ALL of the following files. Every file must compile. Use the exact patterns from the golang-kube-controller agent specification.

### 1. `go.mod`

Initialize with the module path and Go 1.24. Include these dependencies:
```
github.com/spf13/cobra
go.uber.org/zap
k8s.io/apimachinery
k8s.io/api
k8s.io/client-go
sigs.k8s.io/controller-runtime
```

After writing `go.mod`, run `go mod tidy` to resolve versions.

### 2. `pkg/build/build.go`

```go
package build

var Version = "0.0.1"
```

### 3. `pkg/apis/{group}/register.go`

GroupName constant.

### 4. `pkg/apis/{group}/{version}/docs.go`

Package doc with `+groupName`, `+versionName`, and `go:generate` directive for controller-gen.

### 5. `pkg/apis/{group}/{version}/types.go`

- CRD type with full kubebuilder markers (`+genclient`, `+k8s:deepcopy-gen`, `+kubebuilder:subresource:status`, `+kubebuilder:resource` with scope/shortName/singular, `+kubebuilder:printcolumn` for Age)
- Empty `{Kind}Spec` struct with a TODO comment
- `{Kind}Status` struct with a TODO comment
- `{Kind}List` type

### 6. `pkg/apis/{group}/{version}/default.go`

- `defaulted{Kind}Spec` function (empty body with TODO)
- `defaulted{Kind}` calling spec defaulter
- Exported `Defaulted` with type switch

### 7. `pkg/apis/{group}/{version}/register.go`

- `Version` const
- `SchemeGroupVersion`
- `Kind` and `Resource` helper functions
- `SchemeBuilder`, `AddToScheme`, `addKnownTypes`

### 8. `pkg/controller/{resource}/controller.go`

- `Options` struct (empty)
- `Controller` struct with `opts *Options`
- `SetupWithManager` standalone function
- `Reconcile` method with RBAC markers and TODO skeleton comments for the 5-step reconcile pattern

### 9. `pkg/webhook/webhook.go`

- `SetupWebhooksWithManager` function
- Health and readiness check registration

### 10. `pkg/webhook/{resource}/webhook.go`

- `Webhook` struct
- `SetupWebhookWithManager` method
- `Default` delegating to `Defaulted`
- `ValidateCreate`, `ValidateUpdate`, `ValidateDelete` stubs
- Interface compliance assertions
- Kubebuilder webhook markers

### 11. `pkg/cmd/main.go`

Minimal entrypoint: `NewRoot().Execute()`.

### 12. `pkg/cmd/defaults.go`

Typed constants for all CLI defaults:
- `DefaultCertDir` string = `"/etc/webhook/tls"`
- `DefaultCACertName` string = `"ca.crt"`
- `DefaultCertName` string = `"tls.crt"`
- `DefaultKeyName` string = `"tls.key"`
- `DefaultEnableLeaderElection` bool = `false`
- `DefaultSkipInsecureVerify` bool = `true`
- `DefaultLogLevel` int8 = `4`
- `DefaultNamespace` string = `""`

### 13. `pkg/cmd/root.go`

- `Root` struct, `NewRoot`, `Execute`, `Command`
- Usage/description constants at the top
- Subcommand registration for the resource

### 14. `pkg/cmd/{resource}/{resource}.go`

- Struct with all CLI flag fields
- `LeaderElectionID` const
- `RunE` method: scheme setup, zap logger, signal handler, manager creation, controller + webhook registration, `mgr.Start`

### 15. `Makefile`

Include targets for:
- `codegen` — controller-gen object generation
- `manifests` — CRD/RBAC/webhook manifest generation
- `generate` — both codegen and manifests
- `build` — `CGO_ENABLED=0 go build` with ldflags for version
- `test` — `go test ./...` with optional coverage and verbose
- `lint` — golangci-lint
- `lint-fix` — golangci-lint --fix + goimports
- `fmt` / `vet`
- `deps` — install controller-gen, kustomize, golangci-lint, goimports
- `clean`

Use variables for tool versions (controller-tools, kustomize, golangci-lint, goimports). Install tools to `./bin/`.

### 16. `hack/boilerplate.go.txt`

Empty boilerplate file (used by controller-gen for generated file headers).

## After Generating

1. Run `go mod tidy` to resolve all dependency versions
2. Run `go build ./...` to verify everything compiles
3. Report any errors and fix them

Do NOT generate `zz_generated.deepcopy.go` — that is produced by `controller-gen`.
