/// Typed parameter object passed via go_router `extra` when navigating to
/// the refinement flow.
///
/// Using a dedicated class instead of a raw String prevents silent
/// breakage if extra payload is extended later (e.g. preferred roles,
/// session resume tokens).
class RefinementParams {
  final String ideaText;

  const RefinementParams({required this.ideaText});

  /// Backward-compatible factory for legacy raw-String extras.
  factory RefinementParams.fromExtra(Object? extra) {
    if (extra is RefinementParams) return extra;
    if (extra is String) return RefinementParams(ideaText: extra);
    return const RefinementParams(ideaText: '');
  }

  @override
  bool operator ==(Object other) =>
      other is RefinementParams && other.ideaText == ideaText;

  @override
  int get hashCode => ideaText.hashCode;

  @override
  String toString() =>
      'RefinementParams(ideaText: ${ideaText.length} chars)';
}
