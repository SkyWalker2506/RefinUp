import 'package:flutter_test/flutter_test.dart';
import 'package:refinup_flutter/features/refinement/providers/refinement_provider.dart';

void main() {
  group('RefinementState.currentRoundRole', () {
    test('returns null when no rounds are loaded (idle)', () {
      const state = RefinementState();
      expect(state.currentRoundRole, isNull);
    });

    test('returns null when rounds list is empty even if currentRound is set',
        () {
      const state = RefinementState(currentRound: 0);
      expect(state.currentRoundRole, isNull);
    });

    test('returns null when currentRound is below range', () {
      const state = RefinementState(
        rounds: [RoundState(role: 'Optimist')],
        currentRound: -1,
      );
      expect(state.currentRoundRole, isNull);
    });

    test('returns null when currentRound is above range', () {
      const state = RefinementState(
        rounds: [RoundState(role: 'Optimist')],
        currentRound: 5,
      );
      expect(state.currentRoundRole, isNull);
    });

    test('returns the first round role when currentRound is 0', () {
      const state = RefinementState(
        rounds: [
          RoundState(role: 'Optimist'),
          RoundState(role: 'Critic'),
          RoundState(role: 'Pragmatist'),
        ],
        currentRound: 0,
      );
      expect(state.currentRoundRole, equals('Optimist'));
    });

    test('returns the middle round role when currentRound advances', () {
      const state = RefinementState(
        rounds: [
          RoundState(role: 'Optimist'),
          RoundState(role: 'Critic'),
          RoundState(role: 'Pragmatist'),
        ],
        currentRound: 1,
      );
      expect(state.currentRoundRole, equals('Critic'));
    });

    test('returns the last round role at the final index', () {
      const state = RefinementState(
        rounds: [
          RoundState(role: 'Optimist'),
          RoundState(role: 'Critic'),
          RoundState(role: 'Pragmatist'),
        ],
        currentRound: 2,
      );
      expect(state.currentRoundRole, equals('Pragmatist'));
    });

    test('still works when status is complete', () {
      const state = RefinementState(
        status: RefinementStatus.complete,
        rounds: [RoundState(role: 'Optimist', isComplete: true)],
        currentRound: 0,
      );
      expect(state.currentRoundRole, equals('Optimist'));
    });
  });

  group('RefinementState convenience flags', () {
    test('isRunning reflects running status', () {
      const idle = RefinementState();
      const running = RefinementState(status: RefinementStatus.running);
      expect(idle.isRunning, isFalse);
      expect(running.isRunning, isTrue);
    });

    test('isComplete reflects complete status', () {
      const idle = RefinementState();
      const complete = RefinementState(status: RefinementStatus.complete);
      expect(idle.isComplete, isFalse);
      expect(complete.isComplete, isTrue);
    });

    test('hasError reflects error status', () {
      const idle = RefinementState();
      const err = RefinementState(
        status: RefinementStatus.error,
        errorMessage: 'oops',
      );
      expect(idle.hasError, isFalse);
      expect(err.hasError, isTrue);
      expect(err.errorMessage, equals('oops'));
    });
  });

  group('RefinementNotifier', () {
    test('reset returns state to idle', () {
      final notifier = RefinementNotifier();
      notifier.reset();
      expect(notifier.state.status, equals(RefinementStatus.idle));
      expect(notifier.state.rounds, isEmpty);
      expect(notifier.state.currentRoundRole, isNull);
    });

    test('startRefinement rejects too-short input synchronously', () async {
      final notifier = RefinementNotifier();
      final ok = await notifier.startRefinement('x');
      expect(ok, isFalse);
      expect(notifier.state.status, equals(RefinementStatus.error));
      expect(notifier.state.errorMessage, isNotNull);
    });
  });
}
