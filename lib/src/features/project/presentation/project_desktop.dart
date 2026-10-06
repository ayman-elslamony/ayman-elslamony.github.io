import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project_filter.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_card.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_filter_chips.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class ProjectDesktop extends ConsumerWidget {
  const ProjectDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProjects = ref.watch(projectRepositoryProvider).getProjects();
    final projects =
        filterProjects(allProjects, ref.watch(projectFilterProvider));

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
        ...projects.mapIndexed((index, project) {
          return Column(
            children: [
              ProjectCard(key: ValueKey(project.name), project: project),
              if (index != projects.length - 1) gapH24,
            ],
          );
        }),
      ],
    );
  }
}
