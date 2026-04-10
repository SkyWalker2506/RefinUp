import 'package:flutter/material.dart';
import 'package:refinup_model_registry/refinup_model_registry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize model registry
  final registry = ModelRegistry();
  await registry.initialize();

  runApp(const RefinUpApp());
}

class RefinUpApp extends StatelessWidget {
  const RefinUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RefinUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ModelRegistry _registry;
  String? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _registry = ModelRegistry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RefinUp'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to RefinUp v2',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sprint 0: Monorepo Setup Complete',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Display available models
            const Text(
              'Available Models:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _registry.models.length,
                itemBuilder: (context, index) {
                  final model = _registry.models.values.toList()[index];
                  return Card(
                    child: ListTile(
                      title: Text(model.id),
                      subtitle: Text('Provider: ${model.provider}'),
                      trailing: Chip(
                        label: Text('${model.capabilityScore}/10'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
