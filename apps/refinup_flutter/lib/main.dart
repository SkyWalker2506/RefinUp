import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:refinup_model_registry/refinup_model_registry.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize model registry
  final registry = ModelRegistry();
  await registry.initialize();

  runApp(
    // ProviderScope is required for Riverpod
    const ProviderScope(
      child: RefinUpApp(),
    ),
  );
}

class RefinUpApp extends StatelessWidget {
  const RefinUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RefinUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
