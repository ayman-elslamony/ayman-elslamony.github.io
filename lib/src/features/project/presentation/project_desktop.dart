import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/two_column_grid.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project_filter.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_card.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_filter_chips.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';

class ProjectDesktop extends ConsumerWidget {
  const ProjectDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProjects = ref.watch(projectRepositoryProvider).getProjects();
    final tag = ref.watch(projectFilterProvider);
    final projects = visibleProjects(
      allProjects,
      tag: tag,
      showAll: ref.watch(showAllProjectsProvider),
    );
    final hidden = filterProjects(allProjects, tag).length - projects.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 20),
          child: Text(
            tr(LocaleKeys.projectsSectionTitle),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 20),
          child: ProjectFilterChips(tags: filterTags(allProjects)),
        ),
        // Two cards a row on desktop only; the tablet keeps one, as before.
        TwoColumnGrid(
          spacing: Sizes.p24,
          minTwoColumnWidth: Responsive.isDesktop(context)
              ? 760
              : double.infinity,
          children: [
            for (final project in projects)
              ProjectCard(key: ValueKey(project.name), project: project),
          ],
        ),
        if (hidden > 0) ...[
          gapH24,
          Center(
            child: OutlinedButton(
              onPressed: () {
                ref.read(showAllProjectsProvider.notifier).open();
                Analytics.event('show_all_projects', {'hidden': '$hidden'});
              },
              child: Text(
                tr(
                  LocaleKeys.showAllProjects,
                  args: ['${filterProjects(allProjects, tag).length}'],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
