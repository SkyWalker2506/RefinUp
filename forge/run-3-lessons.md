# Forge Run 3 — Lessons

## What Worked
- Riverpod StateNotifier cleanly separates simulation from real implementation — swapping to real Supabase call is one method replacement
- InputSanitizer as a standalone utility is testable and reusable
- AppEvents constants prevent tracking drift from spec
- ConsumerStatefulWidget + addPostFrameCallback pattern is reliable for triggering async work on mount
- go_router extra param is clean for passing idea text without URL encoding concerns

## What Could Be Better
- No unit tests written yet — InputSanitizer is a pure Dart class, should be tested immediately
- Re-mount guard missing in RefinementFlowScreen — if Flutter hot-reloads, startRefinement could fire twice
- RefinementState.currentRound is an int index, but should probably be tied to the round's role for clarity
- AppRouter uses `state.extra as String?` — should add type safety with a typed extra params class

## Run 4 Priorities (ordered)
1. Write unit tests for InputSanitizer (pure Dart, no Flutter needed)
2. Write widget test for StepIndicator state transitions
3. Add re-mount guard to RefinementFlowScreen (use _started bool flag)
4. Integrate Supabase client package (supabase_flutter)
5. Implement real Edge Function call replacing _simulateRound
6. Add PostHog tracking at key AppEvents points
