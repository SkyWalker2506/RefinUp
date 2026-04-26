import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refinup_flutter/shared/widgets/step_indicator.dart';

/// Helper to wrap StepIndicator in a minimal MaterialApp scaffold.
Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

const _threeStepsAtFirst = [
  StepInfo(label: 'Idea', state: RefinementStepState.active),
  StepInfo(label: 'Refine', state: RefinementStepState.pending, roleTag: 'AI'),
  StepInfo(label: 'Result', state: RefinementStepState.pending),
];

const _threeStepsAtMiddle = [
  StepInfo(label: 'Idea', state: RefinementStepState.completed),
  StepInfo(label: 'Refine', state: RefinementStepState.active, roleTag: 'AI'),
  StepInfo(label: 'Result', state: RefinementStepState.pending),
];

const _threeStepsAllDone = [
  StepInfo(label: 'Idea', state: RefinementStepState.completed),
  StepInfo(label: 'Refine', state: RefinementStepState.completed, roleTag: 'AI'),
  StepInfo(label: 'Result', state: RefinementStepState.completed),
];

void main() {
  group('StepIndicator rendering', () {
    testWidgets('renders all step labels for non-empty list with role tag',
        (tester) async {
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtFirst, currentStep: 0)),
      );

      // role tag should appear (label only if roleTag set)
      expect(find.text('AI'), findsOneWidget);
      // step numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders check icon on completed steps', (tester) async {
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAllDone, currentStep: 2)),
      );

      // 3 completed steps -> 3 check icons
      expect(find.byIcon(Icons.check), findsNWidgets(3));
    });

    testWidgets('renders no check icon when no step is completed',
        (tester) async {
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtFirst, currentStep: 0)),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('exposes Semantics label with current/total progress',
        (tester) async {
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtMiddle, currentStep: 1)),
      );

      // The wrapper Semantics announces progress.
      final semantics = tester.getSemantics(
        find.byType(StepIndicator),
      );
      expect(semantics.label, contains('Step 2 of 3'));
      expect(semantics.label, contains('Refine'));
    });
  });

  group('StepIndicator state transitions', () {
    testWidgets(
        'transitions check icons as currentStep advances and steps complete',
        (tester) async {
      // Initial: step 0 active
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtFirst, currentStep: 0)),
      );
      expect(find.byIcon(Icons.check), findsNothing);

      // Advance: step 0 done, step 1 active
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtMiddle, currentStep: 1)),
      );
      await tester.pump(const Duration(milliseconds: 300)); // animation
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Done: all 3 completed
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAllDone, currentStep: 2)),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byIcon(Icons.check), findsNWidgets(3));
    });

    testWidgets('current step has the larger animated container size',
        (tester) async {
      await tester.pumpWidget(
        _wrap(StepIndicator(steps: _threeStepsAtMiddle, currentStep: 1)),
      );
      await tester.pumpAndSettle();

      // AnimatedContainer with width 32 (current) and 28 (others)
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(containers, hasLength(3));
      final currentSized = containers.firstWhere(
        (c) => c.constraints?.maxWidth == 32 || _hasWidth(c, 32),
        orElse: () => containers.first,
      );
      expect(_hasWidth(currentSized, 32), isTrue,
          reason: 'current step container should be 32px wide');
    });
  });
}

/// AnimatedContainer stores its target width via the constraints helper used
/// internally; this checks the widget's outer constraints.
bool _hasWidth(AnimatedContainer c, double w) {
  final cons = c.constraints;
  if (cons == null) return false;
  return cons.maxWidth == w || cons.minWidth == w;
}
