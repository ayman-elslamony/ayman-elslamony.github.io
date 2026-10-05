import 'package:flutter/material.dart';

/// A technology tag on a project card.
///
/// It used to be a [Card] with a near-invisible fill: `tertiary.withAlpha(30)` in dark
/// mode, and in light mode a white pill with a fully transparent border, so it disappeared
/// into the card behind it. Both modes now use the same recipe - a tinted accent fill with
/// an accent border and accent text - so the chip reads as a deliberate element instead of
/// a faint outline, and the accent stays at full strength rather than being blended away.
class TechnologyChip extends StatelessWidget {
  const TechnologyChip({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.primary.withValues(alpha: isDark ? 0.55 : 0.35),
        ),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
