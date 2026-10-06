import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/attention.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:readmore/readmore.dart';

/// The headline of a highlight: after the arrow, up to the first " — ", " (" or the
/// closing full stop. Bold, so a reader skimming the list gets one line per highlight.
final highlightLead = RegExp(r'(?<=→ )[^\n]+?(?= —| \(|\.(?:\n|$))');

class AboutDesktop extends ConsumerWidget {
  const AboutDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final about = tr(LocaleKeys.aboutDescription);
    // The first paragraph is always shown; the numbers follow it; the highlights fold.
    final split = about.indexOf('\n\n');
    final intro = split > 0 ? about.substring(0, split) : about;
    final rest = split > 0 ? about.substring(split + 2) : '';
    // Collapse at the first bullet, so "Read more" always hides the list and never
    // cuts a word. A fixed trimLength cannot do this: it was 235 against a 230-char
    // intro, which rendered as "-> Des... Read more".
    final firstBullet = rest.indexOf('\u2192');
    final trimAt = firstBullet > 0 ? firstBullet : rest.length;
    final stats = trList(context.locale, LocaleKeys.aboutStats);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            tr(LocaleKeys.aboutSectionTitleAlt),
            style: theme.textTheme.titleLarge,
          ),
        ),
        Text(intro, style: theme.textTheme.bodyLarge),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: 20),
          // The same wave as the contact buttons (see Attention).
          AttentionWave(
            children: [
              for (final s in stats)
                AboutStat(
                  value: s['value'] as String? ?? '',
                  label: s['label'] as String? ?? '',
                ),
            ],
          ),
        ],
        if (rest.isNotEmpty) ...[
          const SizedBox(height: 20),
          ReadMoreText(
            rest,
            trimLength: trimAt,
            trimMode: TrimMode.Length,
            trimCollapsedText: 'Read more',
            trimExpandedText: 'Read less',
            style: theme.textTheme.bodyLarge,
            moreStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
            annotations: [
              Annotation(
                regExp: highlightLead,
                spanBuilder: ({required String text, TextStyle? textStyle}) =>
                    TextSpan(
                      text: text,
                      style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// One number from `aboutStats` in `en.json`: the value large in the accent, its label
/// under it. Same tint and border as the contact buttons and the open-to-work badge.
class AboutStat extends StatelessWidget {
  const AboutStat({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
