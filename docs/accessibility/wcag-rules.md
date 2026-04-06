# RefinUp Accessibility Rules (WCAG 2.1 AA)

**Date:** 2026-04-06  
**Status:** Accepted  
**Target:** WCAG 2.1 Level AA  
**Jira:** RFU-17

---

## Declared Target

**All RefinUp interfaces must meet WCAG 2.1 Level AA.**  
This is not a nice-to-have. It is a build requirement checked at PR review.

---

## Flutter Semantics API Rules

### Rule 1: Every custom widget must have Semantics

```dart
// ❌ WRONG
class RoundBadge extends StatelessWidget {
  final String role;
  Widget build(BuildContext context) => Container(
    child: Text(role),
  );
}

// ✅ CORRECT
class RoundBadge extends StatelessWidget {
  final String role;
  Widget build(BuildContext context) => Semantics(
    label: 'AI round role: $role',
    child: Container(
      child: Text(role),
    ),
  );
}
```

### Rule 2: Interactive elements need semanticLabel or tooltip

```dart
// ❌ WRONG
IconButton(
  icon: Icon(Icons.share),
  onPressed: _share,
)

// ✅ CORRECT
IconButton(
  icon: Icon(Icons.share),
  tooltip: 'Fikri paylaş',
  onPressed: _share,
)
```

### Rule 3: Streaming text must be announced to screen readers

```dart
// Announce each round completion to screen reader
Semantics(
  liveRegion: true,          // announces changes automatically
  child: StreamingTextWidget(stream: roundStream),
)
```

### Rule 4: Loading states must have labels

```dart
// ❌ WRONG
CircularProgressIndicator()

// ✅ CORRECT
Semantics(
  label: 'Yapay zeka düşünüyor, lütfen bekle',
  child: CircularProgressIndicator(),
)
```

### Rule 5: Focus order must follow reading order

```dart
// Use FocusTraversalOrder for custom layouts
FocusTraversalOrder(
  order: NumericFocusOrder(1.0),
  child: IdeaInputField(),
)
```

---

## Color Contrast Requirements

| Context | Minimum Ratio | Target Ratio |
|---------|--------------|--------------|
| Normal text (< 18pt) | 4.5:1 | 7:1 |
| Large text (≥ 18pt or 14pt bold) | 3:1 | 4.5:1 |
| UI components (borders, icons) | 3:1 | 4.5:1 |
| Decorative elements | None | — |

### Pre-checked combinations from tokens.md:

| Foreground | Background | Ratio | Status |
|-----------|-----------|-------|--------|
| `on.surface` (Slate 900) | `surface` (White) | 19.1:1 | ✅ AAA |
| `on.surface.variant` (Slate 600) | `surface` (White) | 5.9:1 | ✅ AA |
| `primary` (Indigo 500) | `surface` (White) | 4.6:1 | ✅ AA |
| `error` (Red 500) | `surface` (White) | 4.5:1 | ✅ AA |

> **Warning:** Role colors (`role.critic` red, `role.optimist` emerald) must NEVER be the sole indicator. Always pair with text label or icon.

---

## Touch Target Size

Minimum touch target: **48×48dp** (WCAG 2.5.5)

```dart
// ❌ WRONG — icon is 24dp
Icon(Icons.close, size: 24)

// ✅ CORRECT — padded to meet minimum
Padding(
  padding: EdgeInsets.all(12),  // 24 + 24 = 48dp
  child: Icon(Icons.close, size: 24),
)
```

---

## Keyboard Navigation (Web)

All interactions must be reachable and operable via keyboard:

| Key | Action |
|-----|--------|
| Tab | Move to next focusable element |
| Shift+Tab | Move to previous |
| Enter / Space | Activate button |
| Escape | Close modal/bottom sheet |
| Arrow keys | Navigate lists, radio groups |

---

## Screen Reader Test Procedure

Before PR merge for any UI-containing feature:

1. **iOS:** Settings → Accessibility → VoiceOver → ON. Navigate through new screens.
2. **Android:** Accessibility → TalkBack → ON. Verify same.
3. **Web:** Chrome + ChromeVox extension. Tab through all interactive elements.

**Minimum pass criteria:**
- [ ] Every interactive element has a spoken label
- [ ] Loading states are announced
- [ ] Error messages are announced (use `liveRegion: true`)
- [ ] Focus order follows visual reading order
- [ ] No focus traps (except modals — which must have escape)

---

## Checklist for PR Reviews

When reviewing PRs that include UI changes:

- [ ] New custom widgets have `Semantics` wrapper
- [ ] Color contrast verified (use ColorSafe or browser DevTools)
- [ ] Touch targets ≥ 48×48dp
- [ ] No information conveyed by color alone
- [ ] Streaming/live regions use `liveRegion: true`
- [ ] Loading indicators have spoken labels
