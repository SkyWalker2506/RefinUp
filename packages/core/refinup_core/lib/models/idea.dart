/// Core idea model representing a user's concept from seed to refined plan

class IdeaSeed {
  final String text;
  final DateTime createdAt;

  IdeaSeed({
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ClarificationQuestion {
  final String question;
  final String? selectedAnswer;

  ClarificationQuestion({
    required this.question,
    this.selectedAnswer,
  });
}

class IdeaPlan {
  final String title;
  final List<String> goals;
  final List<String> constraints;
  final List<String> questions;
  final List<String> nextSteps;
  final String? detectedDomain;

  IdeaPlan({
    required this.title,
    required this.goals,
    required this.constraints,
    required this.questions,
    required this.nextSteps,
    this.detectedDomain,
  });

  IdeaPlan copyWith({
    String? title,
    List<String>? goals,
    List<String>? constraints,
    List<String>? questions,
    List<String>? nextSteps,
    String? detectedDomain,
  }) {
    return IdeaPlan(
      title: title ?? this.title,
      goals: goals ?? this.goals,
      constraints: constraints ?? this.constraints,
      questions: questions ?? this.questions,
      nextSteps: nextSteps ?? this.nextSteps,
      detectedDomain: detectedDomain ?? this.detectedDomain,
    );
  }
}

class RefiningSession {
  final String id;
  final IdeaSeed seed;
  final IdeaPlan currentPlan;
  final List<ClarificationQuestion> clarifications;
  final Map<String, String> roleOutputs; // role -> output
  final DateTime createdAt;
  final DateTime? completedAt;

  RefiningSession({
    required this.id,
    required this.seed,
    required this.currentPlan,
    required this.clarifications,
    required this.roleOutputs,
    required this.createdAt,
    this.completedAt,
  });

  bool get isCompleted => completedAt != null;

  RefiningSession copyWith({
    String? id,
    IdeaSeed? seed,
    IdeaPlan? currentPlan,
    List<ClarificationQuestion>? clarifications,
    Map<String, String>? roleOutputs,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return RefiningSession(
      id: id ?? this.id,
      seed: seed ?? this.seed,
      currentPlan: currentPlan ?? this.currentPlan,
      clarifications: clarifications ?? this.clarifications,
      roleOutputs: roleOutputs ?? this.roleOutputs,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
