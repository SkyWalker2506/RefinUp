import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum RefinementStepState { pending, active, completed }

class StepInfo {
  final String label;
  final String? roleTag;
  final RefinementStepState state;

  const StepInfo({
    required this.label,
    this.roleTag,
    this.state = RefinementStepState.pending,
  });
}

/// Horizontal step indicator for AI refinement rounds.
/// WCAG 2.1 AA: each step has Semantics label announcing progress.
class StepIndicator extends StatelessWidget {
  final List<StepInfo> steps;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Step ${currentStep + 1} of ${steps.length}: ${steps[currentStep].label}',
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            final leftCompleted = (i ~/ 2) < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: leftCompleted ? AppColors.primary : AppColors.outline,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final step = steps[stepIndex];
          return _StepDot(
            index: stepIndex,
            info: step,
            isCurrent: stepIndex == currentStep,
            colorScheme: colorScheme,
          );
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final StepInfo info;
  final bool isCurrent;
  final ColorScheme colorScheme;

  const _StepDot({
    required this.index,
    required this.info,
    required this.isCurrent,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = info.roleTag != null
        ? AppColors.roleColor(info.roleTag!)
        : AppColors.primary;

    Color bgColor;
    Color borderColor;
    Widget child;

    switch (info.state) {
      case RefinementStepState.completed:
        bgColor = AppColors.primary;
        borderColor = AppColors.primary;
        child = const Icon(Icons.check, size: 14, color: Colors.white);
        break;
      case RefinementStepState.active:
        bgColor = Colors.white;
        borderColor = roleColor;
        child = Text(
          '${index + 1}',
          style: AppTextStyles.labelSmall.copyWith(
            color: roleColor,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case RefinementStepState.pending:
        bgColor = Colors.white;
        borderColor = AppColors.outline;
        child = Text(
          '${index + 1}',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        );
        break;
    }

    return Semantics(
      label: '${info.label}, step ${index + 1}, ${info.state.name}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isCurrent ? 32 : 28,
            height: isCurrent ? 32 : 28,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: isCurrent ? 2.5 : 1.5,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: roleColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(child: child),
          ),
          if (info.roleTag != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              info.roleTag!,
              style: AppTextStyles.labelSmall.copyWith(
                color: isCurrent ? roleColor : AppColors.onSurfaceVariant,
                fontWeight:
                    isCurrent ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
