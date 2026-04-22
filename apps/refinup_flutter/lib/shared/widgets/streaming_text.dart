import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Displays streaming AI text with an animated cursor.
/// Falls back to a thinking indicator when text is empty.
/// WCAG 2.1 AA: announces content to screen readers when complete.
class StreamingText extends StatefulWidget {
  final String text;
  final bool isStreaming;
  final TextStyle? style;

  const StreamingText({
    super.key,
    required this.text,
    required this.isStreaming,
    this.style,
  });

  @override
  State<StreamingText> createState() => _StreamingTextState();
}

class _StreamingTextState extends State<StreamingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursorController;
  late final Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _cursorOpacity = _cursorController.drive(Tween(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        widget.style ?? AppTextStyles.bodyLarge.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );

    if (widget.text.isEmpty && widget.isStreaming) {
      return _ThinkingIndicator();
    }

    return Semantics(
      liveRegion: widget.isStreaming,
      label: widget.isStreaming ? 'AI is responding' : widget.text,
      child: RichText(
        text: TextSpan(
          style: effectiveStyle,
          children: [
            TextSpan(text: widget.text),
            if (widget.isStreaming)
              WidgetSpan(
                child: FadeTransition(
                  opacity: _cursorOpacity,
                  child: Container(
                    width: 2,
                    height: effectiveStyle.fontSize ?? 16,
                    margin: const EdgeInsets.only(left: 1),
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThinkingIndicator extends StatefulWidget {
  @override
  State<_ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<_ThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AI is thinking',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final offset = (i * 0.33);
              final t = ((_controller.value + offset) % 1.0);
              final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
