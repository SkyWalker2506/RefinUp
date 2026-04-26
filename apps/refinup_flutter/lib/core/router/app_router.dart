import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/refinement/screens/idea_input_screen.dart';
import '../../features/refinement/screens/refinement_flow_screen.dart';
import 'refinement_params.dart';

export 'refinement_params.dart';

/// Named route paths
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String refinement = '/refine';
}

/// App router singleton using go_router
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const IdeaInputScreen(),
    ),
    GoRoute(
      path: AppRoutes.refinement,
      name: 'refinement',
      builder: (context, state) {
        // Accepts either a typed RefinementParams or a legacy raw String.
        final params = RefinementParams.fromExtra(state.extra);
        return RefinementFlowScreen(ideaText: params.ideaText);
      },
    ),
  ],
  // Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text('Page not found: ${state.uri}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
