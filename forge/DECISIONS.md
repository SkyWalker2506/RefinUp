# Forge Decision Log — RefinUp

Append-only log of significant decisions made during forge runs.

---

## Run 4 — 2026-04-26

### D001: Rename local `StepState` to `RefinementStepState`
- **Karar:** `lib/shared/widgets/step_indicator.dart` enum renamed.
- **Neden:** Clashed with `flutter/material.dart`'s built-in `StepState` causing `ambiguous_import` errors in any file importing both.
- **Alternatif:** `import 'package:flutter/material.dart' hide StepState;` — rejected because all consumers would need the `hide` clause; renaming is cleaner and explicit.
- **Etkisi:** 5 files updated. No public-API breakage (project is single-app).

### D002: `RefinementParams` typed payload for go_router `extra`
- **Karar:** Introduce `RefinementParams` data class instead of raw String.
- **Neden:** Type-safe extension for future fields (preferred roles, resume tokens) without silently breaking call sites.
- **Backward compat:** `fromExtra(Object?)` factory accepts both typed and raw-String legacy callers.

### D003: Test discovery noise from missing assets dir is acceptable for now
- **Karar:** Leave the `packages/refinup_model_registry/assets/` dangling pubspec entry as-is for Run 4.
- **Neden:** It's a printed warning, not a test failure. Fix is trivial but out of scope.
- **Follow-up:** Run 5 priority #7.

### D004: Single-orchestrator forge pattern over per-task agent dispatch
- **Karar:** For sub-300-line tasks, the orchestrator runs the entire pipeline (branch → code → PR → review → merge) directly rather than dispatching one agent per task.
- **Neden:** Lower token spend, faster turnaround, no inter-agent handoff loss. Matches MEMORY.md `feedback_forge_single_orchestrator`.
- **When to revisit:** Tasks > 300 lines or requiring deep specialist knowledge → dispatch.
