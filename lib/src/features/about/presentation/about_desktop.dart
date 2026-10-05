import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:readmore/readmore.dart';

class AboutDesktop extends ConsumerWidget {
  const AboutDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = tr(LocaleKeys.aboutDescription);
    // Collapse at the first bullet, so "Read more" always hides the list and never
    // cuts a word. A fixed trimLength cannot do this: it was 235 against a 230-char
    // intro, which rendered as "-> Des... Read more".
    final firstBullet = about.indexOf('\u2192');
    final trimAt = firstBullet > 0 ? firstBullet : 235;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            tr(LocaleKeys.aboutSectionTitleAlt),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ReadMoreText(
          about,
          trimLength: trimAt,
          trimMode: TrimMode.Length,
          trimCollapsedText: 'Read more',
          trimExpandedText: 'Read less',
          style: Theme.of(context).textTheme.bodyLarge,
          moreStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
