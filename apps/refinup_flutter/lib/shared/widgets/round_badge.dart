import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// Colored role badge for AI refinement rounds.
/// WCAG 2.1 AA: uses Semantics to announce role name to screen readers.
class RoundBadge extends StatelessWidget {
  final String role;
  final bool compact;

  const RoundBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.roleColor(role);
    final bgColor = color.withOpacity(0.12);

    return Semantics(
      label: 'AI role: $role',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
          vertical: compact ? 2 : AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          role,
          style: (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
              .copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
