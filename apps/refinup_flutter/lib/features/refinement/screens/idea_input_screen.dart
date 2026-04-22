import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_events.dart';
import '../../../shared/widgets/step_indicator.dart';
import '../providers/refinement_provider.dart';

/// First screen: user inputs their raw idea.
/// WCAG 2.1 AA: form fields have semantic labels, character count announced.
class IdeaInputScreen extends ConsumerStatefulWidget {
  const IdeaInputScreen({super.key});

  @override
  ConsumerState<IdeaInputScreen> createState() => _IdeaInputScreenState();
}

class _IdeaInputScreenState extends ConsumerState<IdeaInputScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  static const int _maxLength = 5000;

  int get _charCount => _controller.text.length;
  bool get _canSubmit => _charCount >= 10 && _charCount <= _maxLength;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;
    final ideaText = _controller.text;

    // Navigate to refinement screen — provider will handle validation + run
    context.go(AppRoutes.refinement, extra: ideaText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNearLimit = _charCount > _maxLength * 0.8;
    final isOverLimit = _charCount > _maxLength;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RefinUp'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Semantics(
              label: 'How it works',
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showHowItWorks(context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingH,
            vertical: AppSpacing.pagePaddingV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator — 3 steps: Input → Refine → Result
              StepIndicator(
                steps: const [
                  StepInfo(label: 'Your Idea', state: StepState.active),
                  StepInfo(label: 'AI Rounds', state: StepState.pending, roleTag: 'Multi-AI'),
                  StepInfo(label: 'Result', state: StepState.pending),
                ],
                currentStep: 0,
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'What\'s your idea?',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Share any idea — product, business, creative project, or problem to solve. '
                'Multiple AI perspectives will refine it for you.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: Semantics(
                  label: 'Idea input field, maximum $_maxLength characters',
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'e.g., A mobile app that helps remote teams build genuine friendships through weekly micro-challenges...',
                      hintStyle: AppTextStyles.bodyLarge.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Character count
              Semantics(
                liveRegion: true,
                label: '$_charCount of $_maxLength characters',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$_charCount / $_maxLength',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isOverLimit
                            ? AppColors.error
                            : isNearLimit
                                ? AppColors.tertiary
                                : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Semantics(
                button: true,
                enabled: _canSubmit,
                label: 'Refine my idea with AI',
                child: ElevatedButton(
                  onPressed: _canSubmit ? _onSubmit : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome),
                      SizedBox(width: AppSpacing.sm),
                      Text('Refine My Idea'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Social proof / expectation setting
              Semantics(
                label: '3 AI perspectives, takes about 30 seconds',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.groups_2, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '3 AI perspectives · ~30 seconds',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowItWorks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How RefinUp Works',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            _HowItWorksItem(
              color: AppColors.roleOptimist,
              role: 'Optimist',
              description: 'Finds the strongest potential and what makes your idea unique.',
            ),
            _HowItWorksItem(
              color: AppColors.roleCritic,
              role: 'Critic',
              description: 'Identifies real risks and gaps — the hard questions investors would ask.',
            ),
            _HowItWorksItem(
              color: AppColors.rolePragmatist,
              role: 'Pragmatist',
              description: 'Turns insights into a concrete, actionable next step plan.',
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksItem extends StatelessWidget {
  final Color color;
  final String role;
  final String description;

  const _HowItWorksItem({
    required this.color,
    required this.role,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role,
                    style: AppTextStyles.labelLarge.copyWith(
                        color: color, fontWeight: FontWeight.w700)),
                Text(description,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
