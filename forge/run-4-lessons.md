# Forge Run 4 — Lessons

## What Worked
- **Wave-based execution kept dependencies clean.** Wave 1 (independent tasks) merged first; Wave 2 (depending on Wave 1 stability) only ran after main was green.
- **Latent bug discovery via verify gate.** T-011's `flutter analyze` flagged a pre-existing `StepState` ambiguous-import that runs 1-3 missed because they only ran inside isolated files. Running analyze across the full tree caught it.
- **Test-first run pattern is forge-friendly.** Pure-Dart unit tests (InputSanitizer, RefinementState getters) finished in seconds and gave high confidence with low token spend.
- **Backward-compatible refactors avoid blast radius.** `RefinementParams.fromExtra` accepts both the new typed payload and the legacy raw String — no other call sites needed touching.
- **Single orchestrator pattern continues to outperform per-task agent dispatch** for sub-300-line tasks. Five tasks done in one session with full PR loop.

## What Could Be Better
- **`StepState` clash should have been caught in Run 1 lint config.** Adding `flutter analyze lib/` to a CI/pre-commit step would have surfaced this immediately. Worth a Run 5 task.
- **Test-discovery error noise.** `Error: unable to find directory entry in pubspec.yaml: .../packages/refinup_model_registry/assets/` printed every test invocation — harmless but noisy. Either drop the asset reference from `apps/refinup_flutter/pubspec.yaml` or create the empty directory.
- **No CI yet.** All verify is local; if a PR were ever merged without `flutter test` passing locally, regressions would slip in. Add GitHub Actions in Run 5.
- **Test for InputSanitizer ChatML pattern revealed a precedence subtlety.** HTML-strip happens before injection check, so any injection marker containing `<...>` gets neutralized first. Documented in test, but the implementation should arguably swap order or handle ChatML markers explicitly. Tracked for review.

## Run 5 Priorities (ordered)
1. **Supabase client setup.** Add `supabase_flutter` to pubspec, env loading via `--dart-define` or `.env`, init in `main.dart`.
2. **Real `/refine` Edge Function call.** Replace `_simulateRound` in `RefinementNotifier` with a Supabase Edge Function invocation (mock the function until it exists; Stripe-style stub).
3. **PostHog integration.** Wire `posthog_flutter` and emit AppEvents at the 5 key user-journey points (idea_submitted, refinement_started, round_complete, refinement_complete, share_clicked).
4. **GitHub Actions CI.** `flutter analyze` + `flutter test` on every PR. Block merge on red.
5. **IdeaInputScreen widget tests.** Form validation, char counter, submit gating, navigation invocation.
6. **Auth scaffold.** Google + email via Supabase Auth, basic AuthGuard widget for the refinement route.
7. **Fix `pubspec.yaml` asset reference noise.** Remove dangling `packages/refinup_model_registry/assets/` entry or create the directory.

## Cross-Run Pattern Recognition

After 4 runs, the consistent winning pattern is:
1. Read previous lessons before planning.
2. Define 4-6 atomic tasks max per sprint.
3. Wave-1 = independent, Wave-2 = anything that needs Wave 1's stability.
4. Run verify after every PR merge — never accumulate untested changes.
5. Latent bug discovery is a feature, not a delay — fix in scope rather than deferring.
