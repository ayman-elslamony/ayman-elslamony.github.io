import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/technology_wrap_chips.dart';
import 'package:portfolio/src/common/widgets/wrap_links.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/experience/presentation/widgets/experience_date_text.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class ExperienceCard extends ConsumerWidget {
  const ExperienceCard({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // The fill used to be `tertiary.withAlpha(50)`. tertiary is the steel blue sampled from
    // the banner, and 20% of it over a white page is a muddy grey-blue that belongs to no
    // part of the palette - which is why light mode read as a set of unrelated colours.
    // A card is a surface: it takes `surface`, and the page behind it is `scaffoldBackground`.
    // The separation comes from the border, not from a tint.
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        mouseCursor: MaterialStateMouseCursor.textable,
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(20),
        hoverColor: theme.colorScheme.primary.withValues(alpha: 0.06),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.10),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        child: MouseRegion(
          cursor: SystemMouseCursors.basic,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        experience.job ?? "",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    gapW24,
                    if (!Responsive.isMobile(context))
                      ExperienceDateText(experience: experience),
                  ],
                ),
                if (Responsive.isMobile(context))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.company ?? "",
                        style: theme.textTheme.titleMedium,
                      ),
                      gapH4,
                      ExperienceDateText(experience: experience),
                    ],
                  )
                else
                  Text(
                    experience.company ?? "",
                    style: theme.textTheme.titleMedium,
                  ),
                gapH8,
                experience.description == null || experience.description == ''
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              experience.description ?? "",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                experience.description == null || experience.description == ''
                    ? const SizedBox()
                    : gapH12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLinks(),
                    if (experience.links?.isNotEmpty == true) gapH12 else gapH4,
                    _buildChips(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    final url = experience.url;
    if (url == null) return;
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }

  Widget _buildChips() {
    final experienceTechnologies = experience.technologies;
    if (experienceTechnologies == null) return const SizedBox.shrink();
    return TechnologyWrapChips(titles: experienceTechnologies);
  }

  Widget _buildLinks() {
    final experienceLinks = experience.links;
    if (experienceLinks == null) return const SizedBox.shrink();
    return WrapLinks(links: experienceLinks);
  }
}
