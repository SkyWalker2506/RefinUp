import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/round_badge.dart';
import '../../../shared/widgets/step_indicator.dart';
import '../../../shared/widgets/streaming_text.dart';

/// Holds the output of one AI round
class RoundOutput {
  final String role;
  final String text;
  final bool isStreaming;

  const RoundOutput({
    required this.role,
    required this.text,
    this.isStreaming = false,
  });
}

/// Shows AI refinement rounds sequentially with streaming text.
/// WCAG 2.1 AA: live regions, semantics on each round card.
class RefinementScreen extends StatelessWidget {
  final String ideaText;
  final List<RoundOutput> rounds;
  final int currentRoundIndex;
  final bool isComplete;
  final VoidCallback? onShare;
  final VoidCallback? onNewIdea;

  const RefinementScreen({
    super.key,
    required this.ideaText,
    required this.rounds,
    required this.currentRoundIndex,
    required this.isComplete,
    this.onShare,
    this.onNewIdea,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build step list from rounds
    final steps = [
      const StepInfo(label: 'Your Idea', state: RefinementStepState.completed),
      ...rounds.asMap().entries.map((e) {
        final RefinementStepState state;
        if (e.key < currentRoundIndex) {
          state = RefinementStepState.completed;
        } else if (e.key == currentRoundIndex) {
          state = RefinementStepState.active;
        } else {
          state = RefinementStepState.pending;
        }
        return StepInfo(
          label: 'Round ${e.key + 1}',
          roleTag: e.value.role,
          state: state,
        );
      }),
      StepInfo(
        label: 'Result',
        state: isComplete ? RefinementStepState.completed : RefinementStepState.pending,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refining...'),
        actions: [
          if (isComplete) ...[
            Semantics(
              button: true,
              label: 'Share your refined idea',
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: onShare,
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingH,
                vertical: AppSpacing.md,
              ),
              child: StepIndicator(
                steps: steps,
                currentStep: isComplete
                    ? steps.length - 1
                    : currentRoundIndex + 1, // +1 for "Your Idea" step
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingH,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  // Original idea card
                  _IdeaCard(ideaText: ideaText),
                  const SizedBox(height: AppSpacing.md),

                  // Round cards
                  ...rounds.asMap().entries.map((e) {
                    final isActive = e.key == currentRoundIndex;
                    final isVisible = e.key <= currentRoundIndex;
                    if (!isVisible) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _RoundCard(
                        roundNumber: e.key + 1,
                        output: e.value,
                        isActive: isActive,
                      ),
                    );
                  }),

                  if (isComplete) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _CompletionActions(
                      onShare: onShare,
                      onNewIdea: onNewIdea,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdeaCard extends StatelessWidget {
  final String ideaText;

  const _IdeaCard({required this.ideaText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Your original idea',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      size: 16, color: AppColors.tertiary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Your Idea',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                ideaText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  final int roundNumber;
  final RoundOutput output;
  final bool isActive;

  const _RoundCard({
    required this.roundNumber,
    required this.output,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = AppColors.roleColor(output.role);

    return Semantics(
      label: 'Round $roundNumber: ${output.role} perspective',
      child: AnimatedOpacity(
        opacity: isActive || !output.isStreaming ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(
              color: isActive ? roleColor.withOpacity(0.4) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Round $roundNumber',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    RoundBadge(role: output.role),
                    if (output.isStreaming) ...[
                      const Spacer(),
                      const _PulsingDot(),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                StreamingText(
                  text: output.text,
                  isStreaming: output.isStreaming,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CompletionActions extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onNewIdea;

  const _CompletionActions({this.onShare, this.onNewIdea});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: 'Share your refined idea',
          child: ElevatedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share),
            label: const Text('Share My Refined Idea'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          button: true,
          label: 'Start a new idea',
          child: OutlinedButton(
            onPressed: onNewIdea,
            child: const Text('Refine Another Idea'),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
