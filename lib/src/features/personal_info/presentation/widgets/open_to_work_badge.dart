import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/site_settings.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// "Open to work" under the name, shown or hidden by `showOpenToWork` in
/// `lib/src/constants/site_settings.dart`. It uses the accent with the same tint and border
/// as the contact buttons - no new colour, the palette has no green.
class OpenToWorkBadge extends StatelessWidget {
  const OpenToWorkBadge({super.key, this.visible = showOpenToWork});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tr(LocaleKeys.openToWork),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: colors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
