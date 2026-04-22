# Forge Run 2 — Lessons

## What Worked
- Token-to-code translation from `tokens.md` → Dart was clean and direct
- Splitting theme into 4 files (colors, typography, theme, spacing) keeps each file focused
- Writing RefinementScreen as a pure stateless widget with injected data makes it easy to wire Riverpod later
- How-it-works modal bottom sheet is a zero-cost UX improvement (no new screen, no routing needed)

## What Could Be Better
- Screens need `go_router` — currently no way to navigate from IdeaInputScreen to RefinementScreen
- StepIndicator assumes fixed step count — should accept dynamic list
- RefinementScreen currentStep calculation has an off-by-one risk with the "Your Idea" prefix step
- No test files created — next run should add at least widget tests for StepIndicator and StreamingText

## Run 3 Priorities (ordered)
1. Add `go_router` + AppRouter
2. Add Riverpod providers: `ideaProvider`, `refinementSessionProvider`
3. Add `InputSanitizer` utility (required before any AI call)
4. Add AppEvents constants (required before PostHog integration)
5. Wire navigation: IdeaInputScreen → RefinementScreen
6. Add widget tests for shared widgets
