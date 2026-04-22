/// PostHog event taxonomy for RefinUp.
/// Source of truth: docs/analytics/event-taxonomy.md
/// Rule: Never add tracking code without a corresponding event constant here.
class AppEvents {
  AppEvents._();

  // Idea Input
  static const String ideaStarted = 'idea_started';
  static const String ideaSubmitted = 'idea_submitted';
  static const String ideaInputCleared = 'idea_input_cleared';

  // Refinement Flow
  static const String refinementStarted = 'refinement_started';
  static const String roundStarted = 'round_started';
  static const String roundCompleted = 'round_completed';
  static const String refinementCompleted = 'refinement_completed';
  static const String refinementError = 'refinement_error';

  // Sharing (top growth lever per MASTER_ANALYSIS)
  static const String shareInitiated = 'share_initiated';
  static const String shareCopied = 'share_link_copied';
  static const String shareVia = 'share_via_channel';

  // Onboarding
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String howItWorksOpened = 'how_it_works_opened';

  // Navigation
  static const String screenViewed = 'screen_viewed';

  // Errors
  static const String inputValidationError = 'input_validation_error';
  static const String apiError = 'api_error';
  static const String quotaExceeded = 'quota_exceeded';
}

/// Standard property keys for events
class AppEventProps {
  AppEventProps._();

  static const String screenName = 'screen_name';
  static const String ideaLength = 'idea_length';
  static const String roundNumber = 'round_number';
  static const String roundRole = 'round_role';
  static const String modelId = 'model_id';
  static const String durationMs = 'duration_ms';
  static const String errorCode = 'error_code';
  static const String shareChannel = 'share_channel';
  static const String sessionId = 'session_id';
  static const String quotaTier = 'quota_tier';
}
