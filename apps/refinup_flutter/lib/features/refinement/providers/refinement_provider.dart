import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/input_sanitizer.dart';

/// State of the current refinement session
enum RefinementStatus {
  idle,
  validating,
  running,
  complete,
  error,
}

class RefinementState {
  final String rawIdea;
  final String sanitizedIdea;
  final RefinementStatus status;
  final List<RoundState> rounds;
  final String? errorMessage;
  final int currentRound;

  const RefinementState({
    this.rawIdea = '',
    this.sanitizedIdea = '',
    this.status = RefinementStatus.idle,
    this.rounds = const [],
    this.errorMessage,
    this.currentRound = 0,
  });

  RefinementState copyWith({
    String? rawIdea,
    String? sanitizedIdea,
    RefinementStatus? status,
    List<RoundState>? rounds,
    String? errorMessage,
    int? currentRound,
  }) {
    return RefinementState(
      rawIdea: rawIdea ?? this.rawIdea,
      sanitizedIdea: sanitizedIdea ?? this.sanitizedIdea,
      status: status ?? this.status,
      rounds: rounds ?? this.rounds,
      errorMessage: errorMessage,
      currentRound: currentRound ?? this.currentRound,
    );
  }

  bool get isRunning => status == RefinementStatus.running;
  bool get isComplete => status == RefinementStatus.complete;
  bool get hasError => status == RefinementStatus.error;
}

class RoundState {
  final String role;
  final String text;
  final bool isStreaming;
  final bool isComplete;

  const RoundState({
    required this.role,
    this.text = '',
    this.isStreaming = false,
    this.isComplete = false,
  });

  RoundState copyWith({
    String? role,
    String? text,
    bool? isStreaming,
    bool? isComplete,
  }) {
    return RoundState(
      role: role ?? this.role,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Default AI round configuration
const _defaultRoles = ['Optimist', 'Critic', 'Pragmatist'];

/// Riverpod provider for refinement session state
class RefinementNotifier extends StateNotifier<RefinementState> {
  RefinementNotifier() : super(const RefinementState());

  /// Validate and start a refinement session
  Future<bool> startRefinement(String rawIdea) async {
    // Phase 1: Validate input
    state = state.copyWith(
      rawIdea: rawIdea,
      status: RefinementStatus.validating,
    );

    final result = InputSanitizer.sanitize(rawIdea);
    if (!result.isOk) {
      state = state.copyWith(
        status: RefinementStatus.error,
        errorMessage: result.error,
      );
      return false;
    }

    // Phase 2: Initialize rounds
    final rounds = _defaultRoles
        .map((role) => RoundState(role: role))
        .toList();

    state = state.copyWith(
      sanitizedIdea: result.text,
      status: RefinementStatus.running,
      rounds: rounds,
      currentRound: 0,
    );

    // Phase 3: Run rounds sequentially
    // NOTE: This stub simulates streaming — real impl calls Supabase Edge Function
    for (int i = 0; i < rounds.length; i++) {
      await _simulateRound(i);
    }

    state = state.copyWith(status: RefinementStatus.complete);
    return true;
  }

  Future<void> _simulateRound(int roundIndex) async {
    final role = state.rounds[roundIndex].role;

    // Mark round as streaming
    final updatedRounds = [...state.rounds];
    updatedRounds[roundIndex] = updatedRounds[roundIndex].copyWith(
      isStreaming: true,
    );
    state = state.copyWith(rounds: updatedRounds, currentRound: roundIndex);

    // Simulate chunked streaming (500ms delay between chunks)
    final mockTexts = _getMockText(role);
    var accumulated = '';
    for (final chunk in mockTexts) {
      await Future.delayed(const Duration(milliseconds: 300));
      accumulated += chunk;
      final newRounds = [...state.rounds];
      newRounds[roundIndex] = newRounds[roundIndex].copyWith(
        text: accumulated,
        isStreaming: true,
      );
      state = state.copyWith(rounds: newRounds);
    }

    // Mark round complete
    final finalRounds = [...state.rounds];
    finalRounds[roundIndex] = finalRounds[roundIndex].copyWith(
      isStreaming: false,
      isComplete: true,
    );
    state = state.copyWith(rounds: finalRounds);
  }

  List<String> _getMockText(String role) {
    switch (role) {
      case 'Optimist':
        return [
          'This idea has real potential. ',
          'The core value proposition is clear and the timing looks favorable. ',
          'Key strengths: novel approach, underserved market, and strong differentiation. ',
          'If executed well, this could become a category-defining product.',
        ];
      case 'Critic':
        return [
          'Let\'s pressure-test this. ',
          'Main risks: distribution is unclear, the monetization model needs validation, ',
          'and competitors with more resources could copy this quickly. ',
          'The hardest question: why would users switch from their current solution?',
        ];
      case 'Pragmatist':
        return [
          'Here\'s a concrete 30-day action plan. ',
          'Week 1: Interview 5 potential users to validate the core assumption. ',
          'Week 2: Build a no-code prototype and gather feedback. ',
          'Week 3–4: Iterate based on feedback and define your first paid tier. ',
          'The most important metric to track: time from sign-up to first "aha moment."',
        ];
      default:
        return ['Analysis complete.'];
    }
  }

  void reset() {
    state = const RefinementState();
  }
}

final refinementProvider =
    StateNotifierProvider<RefinementNotifier, RefinementState>(
  (ref) => RefinementNotifier(),
);
