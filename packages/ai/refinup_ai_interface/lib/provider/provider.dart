/// AI provider interface

import '../models/model.dart';

/// Exception thrown by AI providers
class ProviderException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  ProviderException(
    this.message, {
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'ProviderException: $message${code != null ? ' ($code)' : ''}';
}

/// Unified interface for all AI providers
abstract class IProvider {
  /// Unique provider identifier
  String get providerId;

  /// Provider display name
  String get displayName;

  /// Check if provider is properly configured (e.g., API key set)
  Future<bool> isConfigured();

  /// List available models for this provider
  Future<List<IModel>> listModels();

  /// Complete a prompt synchronously
  Future<String> complete(
    String prompt, {
    IModel? model,
    Map<String, dynamic>? options,
  });

  /// Stream completion response
  Stream<String> streamComplete(
    String prompt, {
    IModel? model,
    Map<String, dynamic>? options,
  });

  /// Count tokens in text (if supported by provider)
  Future<int?> countTokens(String text, {IModel? model});

  /// Validate configuration (throw if invalid)
  Future<void> validateConfiguration();

  /// Clean up resources
  Future<void> dispose();
}
