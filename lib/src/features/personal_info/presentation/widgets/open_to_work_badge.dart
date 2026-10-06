import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/attention.dart';
import 'package:portfolio/src/constants/site_settings.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// "Open to work" under the name, shown or hidden by `showOpenToWork` in
/// `lib/src/constants/site_settings.dart`. It uses the accent with the same tint and border
/// as the contact buttons - no new colour, the palette has no green.
///
/// Its dot pulses - a ring that grows and fades - so the eye goes to it without being
/// asked: the familiar "available" signal. With the system's reduce-motion setting on, the
/// dot stays still.
class OpenToWorkBadge extends StatelessWidget {
  const OpenToWorkBadge({super.key, this.visible = showOpenToWork});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final (headline, detail) = splitBadgeText(tr(LocaleKeys.openToWork));
    // Two lines on purpose: one long pill wrapped wherever the width ran out, mid-phrase,
    // and a pill shape cannot hold two lines. A card with rounded corners can.
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centred on the first line's height.
            SizedBox(
              height: 20,
              child: Center(child: PulseDot(color: colors.primary)),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    headline,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      height: 20 / 14,
                    ),
                  ),
                  if (detail != null)
                    Text(
                      detail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `openToWork` from `en.json` split at its first " · ": the headline, then the detail
/// under it; a text with no " · " is all headline.
(String, String?) splitBadgeText(String text) {
  final at = text.indexOf(' · ');
  if (at < 0) return (text, null);
  return (text.substring(0, at), text.substring(at + 3));
}
