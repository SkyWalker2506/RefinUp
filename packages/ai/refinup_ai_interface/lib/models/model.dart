/// AI model interface and implementations

abstract class IModel {
  /// Unique identifier for this model (e.g., "gpt-4o", "claude-opus-4")
  String get id;

  /// Provider ID (e.g., "openai", "anthropic")
  String get provider;

  /// Context window size in tokens
  int get contextWindow;

  /// List of capabilities (e.g., ["lead", "debate", "summarize"])
  List<String> get capabilities;

  /// Capability score 1-10
  int get capabilityScore;

  /// Input cost per million tokens
  double get inputCostPerMTok;

  /// Output cost per million tokens
  double get outputCostPerMTok;

  /// Whether this model supports streaming
  bool get supportsStreaming;

  /// Optional endpoint for local models (e.g., Ollama)
  String? get endpoint;
}

class Model implements IModel {
  @override
  final String id;

  @override
  final String provider;

  @override
  final int contextWindow;

  @override
  final List<String> capabilities;

  @override
  final int capabilityScore;

  @override
  final double inputCostPerMTok;

  @override
  final double outputCostPerMTok;

  @override
  final bool supportsStreaming;

  @override
  final String? endpoint;

  Model({
    required this.id,
    required this.provider,
    required this.contextWindow,
    required this.capabilities,
    required this.capabilityScore,
    required this.inputCostPerMTok,
    required this.outputCostPerMTok,
    this.supportsStreaming = true,
    this.endpoint,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'] as String,
      provider: json['provider'] as String,
      contextWindow: json['contextWindow'] as int,
      capabilities: List<String>.from(json['capabilities'] as List),
      capabilityScore: json['capabilityScore'] as int,
      inputCostPerMTok: (json['pricing']['inputMTok'] as num).toDouble(),
      outputCostPerMTok: (json['pricing']['outputMTok'] as num).toDouble(),
      supportsStreaming: json['supportsStreaming'] as bool? ?? true,
      endpoint: json['endpoint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'contextWindow': contextWindow,
      'capabilities': capabilities,
      'capabilityScore': capabilityScore,
      'pricing': {
        'inputMTok': inputCostPerMTok,
        'outputMTok': outputCostPerMTok,
      },
      'supportsStreaming': supportsStreaming,
      'endpoint': endpoint,
    };
  }
}
