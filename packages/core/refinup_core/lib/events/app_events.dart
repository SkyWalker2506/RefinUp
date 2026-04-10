/// Application-level events for RefinUp

abstract class AppEvent {
  const AppEvent();
}

// Session lifecycle events
class SessionCreatedEvent extends AppEvent {
  final String sessionId;
  final String seedText;

  const SessionCreatedEvent({
    required this.sessionId,
    required this.seedText,
  });
}

class SessionClarificationGeneratedEvent extends AppEvent {
  final String sessionId;
  final List<String> options;
  final int step;

  const SessionClarificationGeneratedEvent({
    required this.sessionId,
    required this.options,
    required this.step,
  });
}

class SessionClarificationSelectedEvent extends AppEvent {
  final String sessionId;
  final int step;
  final String selectedOption;

  const SessionClarificationSelectedEvent({
    required this.sessionId,
    required this.step,
    required this.selectedOption,
  });
}

class SessionRefinementStartedEvent extends AppEvent {
  final String sessionId;
  final List<String> selectedRoles;

  const SessionRefinementStartedEvent({
    required this.sessionId,
    required this.selectedRoles,
  });
}

class SessionRefinementCompletedEvent extends AppEvent {
  final String sessionId;
  final Map<String, String> roleOutputs;

  const SessionRefinementCompletedEvent({
    required this.sessionId,
    required this.roleOutputs,
  });
}

// Plan update events
class PlanUpdatedEvent extends AppEvent {
  final String sessionId;
  final String? title;
  final List<String>? goals;
  final List<String>? constraints;
  final List<String>? nextSteps;

  const PlanUpdatedEvent({
    required this.sessionId,
    this.title,
    this.goals,
    this.constraints,
    this.nextSteps,
  });
}

// Agent feedback events
class AgentFeedbackCollectedEvent extends AppEvent {
  final String sessionId;
  final String agentId;
  final double score;
  final List<String> strengths;
  final List<String> weaknesses;

  const AgentFeedbackCollectedEvent({
    required this.sessionId,
    required this.agentId,
    required this.score,
    required this.strengths,
    required this.weaknesses,
  });
}

// Error events
class ErrorEvent extends AppEvent {
  final String message;
  final String? context;
  final StackTrace? stackTrace;

  const ErrorEvent({
    required this.message,
    this.context,
    this.stackTrace,
  });
}
