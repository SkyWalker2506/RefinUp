import 'package:flutter/material.dart';
import 'package:refinup_model_registry/refinup_model_registry.dart';
import 'core/theme/app_theme.dart';
import 'features/refinement/screens/idea_input_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize model registry
  final registry = ModelRegistry();
  await registry.initialize();

  runApp(const RefinUpApp());
}

class RefinUpApp extends StatelessWidget {
  const RefinUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RefinUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const IdeaInputScreen(),
    );
  }
}
