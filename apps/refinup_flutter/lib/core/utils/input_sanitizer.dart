import 'dart:math';

/// Input sanitization utility.
/// Security rule from CLAUDE.md: strip HTML, limit 5000 chars, prevent prompt injection.
class InputSanitizer {
  InputSanitizer._();

  static const int maxLength = 5000;
  static const int minLength = 10;

  // Patterns that look like prompt injection attempts
  static final _injectionPatterns = [
    RegExp(r'ignore\s+(previous|above|all)\s+instructions?', caseSensitive: false),
    RegExp(r'system\s*prompt', caseSensitive: false),
    RegExp(r'you\s+are\s+now\s+a', caseSensitive: false),
    RegExp(r'disregard\s+your', caseSensitive: false),
    RegExp(r'act\s+as\s+if\s+you', caseSensitive: false),
    RegExp(r'<\|im_start\|>', caseSensitive: false),
    RegExp(r'\[INST\]', caseSensitive: false),
  ];

  // Basic HTML tag pattern
  static final _htmlTagPattern = RegExp(r'<[^>]+>');

  /// Sanitize user idea input.
  /// Returns a [SanitizeResult] with cleaned text or error.
  static SanitizeResult sanitize(String raw) {
    // Strip HTML
    var text = raw.replaceAll(_htmlTagPattern, '');

    // Normalize whitespace
    text = text.trim().replaceAll(RegExp(r'[ \t]{2,}'), ' ');

    // Length checks
    if (text.length < minLength) {
      return SanitizeResult.error(
        'Your idea is too short. Please add at least $minLength characters.',
      );
    }

    if (text.length > maxLength) {
      return SanitizeResult.error(
        'Your idea exceeds $maxLength characters. Please shorten it.',
      );
    }

    // Injection detection
    for (final pattern in _injectionPatterns) {
      if (pattern.hasMatch(text)) {
        return SanitizeResult.error(
          'Your input contains unsupported formatting. Please rephrase your idea.',
        );
      }
    }

    return SanitizeResult.ok(text);
  }

  /// Truncate text for display (adds ellipsis)
  static String truncate(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars)}...';
  }
}

class SanitizeResult {
  final String? text;
  final String? error;

  bool get isOk => error == null;

  const SanitizeResult._({this.text, this.error});

  factory SanitizeResult.ok(String text) => SanitizeResult._(text: text);
  factory SanitizeResult.error(String error) => SanitizeResult._(error: error);
}
