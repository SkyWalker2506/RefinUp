/// Model registry for managing available AI models

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:refinup_ai_interface/refinup_ai_interface.dart';

class DomainConfig {
  final String id;
  final String name;
  final List<String> preferredModels;
  final String leaderElection;

  DomainConfig({
    required this.id,
    required this.name,
    required this.preferredModels,
    required this.leaderElection,
  });

  factory DomainConfig.fromJson(Map<String, dynamic> json) {
    return DomainConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      preferredModels: List<String>.from(json['preferredModels'] as List),
      leaderElection: json['leaderElection'] as String,
    );
  }
}

/// Singleton registry for all available models and domains
class ModelRegistry {
  static final ModelRegistry _instance = ModelRegistry._internal();

  late Map<String, IModel> _models;
  late Map<String, DomainConfig> _domains;
  bool _initialized = false;

  ModelRegistry._internal();

  factory ModelRegistry() {
    return _instance;
  }

  /// Initialize the registry (load from assets)
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString(
        'packages/refinup_model_registry/assets/model_registry.json',
      );
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Load models
      _models = {};
      final modelsList = json['models'] as List;
      for (var modelJson in modelsList) {
        final model = Model.fromJson(modelJson as Map<String, dynamic>);
        _models[model.id] = model;
      }

      // Load domains
      _domains = {};
      final domainsList = json['domains'] as List;
      for (var domainJson in domainsList) {
        final domain = DomainConfig.fromJson(domainJson as Map<String, dynamic>);
        _domains[domain.id] = domain;
      }

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize ModelRegistry: $e');
    }
  }

  /// Get all available models
  Map<String, IModel> get models {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _models;
  }

  /// Get a specific model by ID
  IModel? getModel(String id) {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _models[id];
  }

  /// Get all models by provider
  List<IModel> getModelsByProvider(String provider) {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _models.values
        .where((m) => m.provider == provider)
        .toList();
  }

  /// Get models with specific capability
  List<IModel> getModelsByCapability(String capability) {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _models.values
        .where((m) => m.capabilities.contains(capability))
        .toList();
  }

  /// Get domain configuration
  DomainConfig? getDomain(String id) {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _domains[id];
  }

  /// Get all domains
  Map<String, DomainConfig> get domains {
    if (!_initialized) {
      throw Exception('ModelRegistry not initialized. Call initialize() first.');
    }
    return _domains;
  }

  /// Reset registry (mainly for testing)
  void reset() {
    _initialized = false;
    _models = {};
    _domains = {};
  }
}
