# RefinUp Design System Tokens

**Date:** 2026-04-06  
**Status:** Draft  
**Jira:** RFU-10

---

## Color Palette

### Brand Colors

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color.primary` | `#6366F1` (Indigo 500) | `#818CF8` (Indigo 400) | CTAs, active states |
| `color.primary.container` | `#E0E7FF` (Indigo 100) | `#3730A3` (Indigo 800) | Chip backgrounds |
| `color.secondary` | `#10B981` (Emerald 500) | `#34D399` (Emerald 400) | Success, AI complete |
| `color.tertiary` | `#F59E0B` (Amber 500) | `#FCD34D` (Amber 300) | Warnings, streaks |

### Surface Colors

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `color.surface` | `#FFFFFF` | `#0F172A` (Slate 900) | Card backgrounds |
| `color.surface.variant` | `#F8FAFC` (Slate 50) | `#1E293B` (Slate 800) | Input backgrounds |
| `color.background` | `#F1F5F9` (Slate 100) | `#020617` (Slate 950) | Page background |

### Semantic Colors

| Token | Light | Dark | WCAG Contrast |
|-------|-------|------|---------------|
| `color.on.surface` | `#0F172A` (Slate 900) | `#F8FAFC` (Slate 50) | 19.1:1 ✅ |
| `color.on.surface.variant` | `#475569` (Slate 600) | `#94A3B8` (Slate 400) | 5.9:1 ✅ |
| `color.error` | `#EF4444` (Red 500) | `#FCA5A5` (Red 300) | 4.5:1 ✅ |
| `color.outline` | `#CBD5E1` (Slate 300) | `#334155` (Slate 700) | Borders |

### AI Round Role Colors

| Role | Color | Token |
|------|-------|-------|
| Critic | `#EF4444` (Red) | `color.role.critic` |
| Optimist | `#10B981` (Emerald) | `color.role.optimist` |
| Pragmatist | `#6366F1` (Indigo) | `color.role.pragmatist` |
| Devil's Advocate | `#F59E0B` (Amber) | `color.role.devil` |

---

## Typography Scale

Based on Material 3 type scale.

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `text.display.large` | 57sp | 400 | 64sp | Hero headings |
| `text.display.medium` | 45sp | 400 | 52sp | Section headings |
| `text.headline.large` | 32sp | 400 | 40sp | Card titles |
| `text.headline.medium` | 28sp | 400 | 36sp | Dialog titles |
| `text.headline.small` | 24sp | 400 | 32sp | Section labels |
| `text.title.large` | 22sp | 500 | 28sp | List item primary |
| `text.title.medium` | 16sp | 500 | 24sp | Subtitle |
| `text.title.small` | 14sp | 500 | 20sp | Chip label |
| `text.body.large` | 16sp | 400 | 24sp | Primary content |
| `text.body.medium` | 14sp | 400 | 20sp | Secondary content |
| `text.body.small` | 12sp | 400 | 16sp | Captions |
| `text.label.large` | 14sp | 500 | 20sp | Button text |
| `text.label.medium` | 12sp | 500 | 16sp | Badge text |
| `text.label.small` | 11sp | 500 | 16sp | Overline |

**Font Family:** Inter (web), System font fallback (mobile)

---

## Spacing Scale (4px Grid)

| Token | Value | Usage |
|-------|-------|-------|
| `space.1` | 4px | Icon padding, micro gaps |
| `space.2` | 8px | Component internal padding |
| `space.3` | 12px | Compact list items |
| `space.4` | 16px | Standard padding |
| `space.5` | 20px | Section internal padding |
| `space.6` | 24px | Card padding |
| `space.8` | 32px | Section gaps |
| `space.10` | 40px | Large section gaps |
| `space.12` | 48px | Page section gaps |
| `space.16` | 64px | Hero section gaps |

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radius.xs` | 4px | Chips, tags |
| `radius.sm` | 8px | Buttons, inputs |
| `radius.md` | 12px | Cards, modals |
| `radius.lg` | 16px | Bottom sheets |
| `radius.xl` | 24px | Large cards |
| `radius.full` | 9999px | Pills, avatars |

---

## Elevation / Shadow

| Token | dp | Usage |
|-------|-----|-------|
| `elevation.0` | 0 | Flat cards |
| `elevation.1` | 1 | Cards at rest |
| `elevation.2` | 3 | Raised cards |
| `elevation.3` | 6 | Dropdowns |
| `elevation.4` | 8 | Modals, drawers |
| `elevation.5` | 12 | Navigation bar |

---

## Animation Durations

| Token | Value | Usage |
|-------|-------|-------|
| `duration.fast` | 100ms | Micro interactions |
| `duration.normal` | 200ms | Standard transitions |
| `duration.slow` | 300ms | Page transitions |
| `duration.stream` | 50ms | Streaming text chunk delay |

---

## Dart Implementation

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  static const primary = Color(0xFF6366F1);
  static const primaryContainer = Color(0xFFE0E7FF);
  static const secondary = Color(0xFF10B981);
  // ...
  
  static const roleCritic = Color(0xFFEF4444);
  static const roleOptimist = Color(0xFF10B981);
  static const rolePragmatist = Color(0xFF6366F1);
}

// lib/core/theme/app_text_styles.dart
class AppTextStyles {
  static const bodyLarge = TextStyle(fontSize: 16, height: 1.5);
  static const labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  // ...
}

// lib/core/theme/app_spacing.dart
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
```
