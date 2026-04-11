/// Agent feedback model

class AgentFeedback {
  final String id;
  final String agentId;
  final String agentName;
  final String modelId;
  final String role;
  final double performanceScore; // 1-10
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> improvements;
  final DateTime timestamp;
  final String sessionId;

  AgentFeedback({
    required this.id,
    required this.agentId,
    required this.agentName,
    required this.modelId,
    required this.role,
    required this.performanceScore,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
    required this.timestamp,
    required this.sessionId,
  });

  factory AgentFeedback.fromJson(Map<String, dynamic> json) {
    return AgentFeedback(
      id: json['id'] as String,
      agentId: json['agentId'] as String,
      agentName: json['agentName'] as String,
      modelId: json['modelId'] as String,
      role: json['role'] as String,
      performanceScore: (json['performanceScore'] as num).toDouble(),
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      improvements: List<String>.from(json['improvements'] as List),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sessionId: json['sessionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agentId': agentId,
      'agentName': agentName,
      'modelId': modelId,
      'role': role,
      'performanceScore': performanceScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'improvements': improvements,
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
    };
  }
}
