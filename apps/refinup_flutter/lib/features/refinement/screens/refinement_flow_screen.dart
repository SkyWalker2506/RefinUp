import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../providers/refinement_provider.dart';
import 'refinement_screen.dart';

/// Riverpod-connected wrapper around [RefinementScreen].
/// Triggers the refinement flow on mount and maps provider state to screen props.
class RefinementFlowScreen extends ConsumerStatefulWidget {
  final String ideaText;

  const RefinementFlowScreen({super.key, required this.ideaText});

  @override
  ConsumerState<RefinementFlowScreen> createState() =>
      _RefinementFlowScreenState();
}

class _RefinementFlowScreenState extends ConsumerState<RefinementFlowScreen> {
  @override
  void initState() {
    super.initState();
    // Start the refinement pipeline on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refinementProvider.notifier).startRefinement(widget.ideaText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(refinementProvider);

    if (state.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.read(refinementProvider.notifier).reset();
                    context.go(AppRoutes.home);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Map provider round states to RefinementScreen model
    final rounds = state.rounds
        .map(
          (r) => RoundOutput(
            role: r.role,
            text: r.text,
            isStreaming: r.isStreaming,
          ),
        )
        .toList();

    return RefinementScreen(
      ideaText: widget.ideaText,
      rounds: rounds,
      currentRoundIndex: state.currentRound,
      isComplete: state.isComplete,
      onShare: () {
        // TODO(sprint2): generate shareable URL via Supabase
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shareable link coming soon!')),
        );
      },
      onNewIdea: () {
        ref.read(refinementProvider.notifier).reset();
        context.go(AppRoutes.home);
      },
    );
  }
}
