/// Agent model definitions

class Agent {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> capabilities;
  final String? primaryModel;
  final List<String> fallbackModels;
  final int maxToolCalls;
  final String systemPrompt;
  final bool isActive;

  Agent({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.capabilities,
    this.primaryModel,
    required this.fallbackModels,
    required this.maxToolCalls,
    required this.systemPrompt,
    this.isActive = true,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      capabilities: List<String>.from(json['capabilities'] as List? ?? []),
      primaryModel: json['primaryModel'] as String?,
      fallbackModels: List<String>.from(json['fallbackModels'] as List? ?? []),
      maxToolCalls: json['maxToolCalls'] as int? ?? 10,
      systemPrompt: json['systemPrompt'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'capabilities': capabilities,
      'primaryModel': primaryModel,
      'fallbackModels': fallbackModels,
      'maxToolCalls': maxToolCalls,
      'systemPrompt': systemPrompt,
      'isActive': isActive,
    };
  }

  Agent copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    List<String>? capabilities,
    String? primaryModel,
    List<String>? fallbackModels,
    int? maxToolCalls,
    String? systemPrompt,
    bool? isActive,
  }) {
    return Agent(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      capabilities: capabilities ?? this.capabilities,
      primaryModel: primaryModel ?? this.primaryModel,
      fallbackModels: fallbackModels ?? this.fallbackModels,
      maxToolCalls: maxToolCalls ?? this.maxToolCalls,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CustomAgent extends Agent {
  final String baseAgentId;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<String> feedbackApplied;
  final double averageScore;

  CustomAgent({
    required String id,
    required String name,
    required String category,
    required String description,
    required List<String> capabilities,
    required String? primaryModel,
    required List<String> fallbackModels,
    required int maxToolCalls,
    required String systemPrompt,
    required this.baseAgentId,
    required this.createdAt,
    required this.lastModified,
    required this.feedbackApplied,
    required this.averageScore,
    bool isActive = true,
  }) : super(
    id: id,
    name: name,
    category: category,
    description: description,
    capabilities: capabilities,
    primaryModel: primaryModel,
    fallbackModels: fallbackModels,
    maxToolCalls: maxToolCalls,
    systemPrompt: systemPrompt,
    isActive: isActive,
  );

  factory CustomAgent.fromAgent(
    Agent agent, {
    required String baseAgentId,
  }) {
    return CustomAgent(
      id: agent.id,
      name: agent.name,
      category: agent.category,
      description: agent.description,
      capabilities: agent.capabilities,
      primaryModel: agent.primaryModel,
      fallbackModels: agent.fallbackModels,
      maxToolCalls: agent.maxToolCalls,
      systemPrompt: agent.systemPrompt,
      baseAgentId: baseAgentId,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      feedbackApplied: [],
      averageScore: 0.0,
      isActive: agent.isActive,
    );
  }

  factory CustomAgent.fromJson(Map<String, dynamic> json) {
    return CustomAgent(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      capabilities: List<String>.from(json['capabilities'] as List? ?? []),
      primaryModel: json['primaryModel'] as String?,
      fallbackModels: List<String>.from(json['fallbackModels'] as List? ?? []),
      maxToolCalls: json['maxToolCalls'] as int? ?? 10,
      systemPrompt: json['systemPrompt'] as String,
      baseAgentId: json['baseAgentId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      feedbackApplied: List<String>.from(json['feedbackApplied'] as List? ?? []),
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'baseAgentId': baseAgentId,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'feedbackApplied': feedbackApplied,
      'averageScore': averageScore,
    };
  }

  CustomAgent copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    List<String>? capabilities,
    String? primaryModel,
    List<String>? fallbackModels,
    int? maxToolCalls,
    String? systemPrompt,
    String? baseAgentId,
    DateTime? createdAt,
    DateTime? lastModified,
    List<String>? feedbackApplied,
    double? averageScore,
    bool? isActive,
  }) {
    return CustomAgent(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      capabilities: capabilities ?? this.capabilities,
      primaryModel: primaryModel ?? this.primaryModel,
      fallbackModels: fallbackModels ?? this.fallbackModels,
      maxToolCalls: maxToolCalls ?? this.maxToolCalls,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      baseAgentId: baseAgentId ?? this.baseAgentId,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      feedbackApplied: feedbackApplied ?? this.feedbackApplied,
      averageScore: averageScore ?? this.averageScore,
      isActive: isActive ?? this.isActive,
    );
  }
}
