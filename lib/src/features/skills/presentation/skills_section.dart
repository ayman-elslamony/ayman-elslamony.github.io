import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/surface_card.dart';
import 'package:portfolio/src/common/widgets/technology_chip.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/skills/data/skill_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/icon_helper.dart';

/// The CV's Technical Skills, one card per group, with a brand icon where one exists.
class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(skillRepositoryProvider).getSkillGroups();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 20),
          child: Text(
            tr(LocaleKeys.skillsSectionTitle),
            style: theme.textTheme.titleLarge,
          ),
        ),
        for (final group in groups) ...[
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                gapH8,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in group.items)
                      TechnologyChip(
                        name: s.name,
                        icon: IconHelper.brandIcon(s.icon),
                      ),
                  ],
                ),
              ],
            ),
          ),
          gapH12,
        ],
      ],
    );
  }
}
