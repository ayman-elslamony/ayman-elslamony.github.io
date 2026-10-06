import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/project/domain/project.dart';

/// The technologies worth filtering by: those used by at least [minProjects] projects,
/// most used first. A technology on a single project would filter down to one card, which
/// is not a filter. Computed from the projects, never typed.
List<String> filterTags(List<Project> projects, {int minProjects = 2}) {
  final counts = <String, int>{};
  for (final project in projects) {
    for (final tech in {...?project.technologies}) {
      counts[tech] = (counts[tech] ?? 0) + 1;
    }
  }
  final tags = counts.entries.where((e) => e.value >= minProjects).toList()
    ..sort((a, b) {
      final byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });
  return [for (final e in tags) e.key];
}

/// The projects that list [tag]; every project when [tag] is null.
List<Project> filterProjects(List<Project> projects, String? tag) => tag == null
    ? projects
    : [for (final p in projects) if (p.technologies?.contains(tag) ?? false) p];

/// The selected technology, stored by its name (never by its position in the chip row);
/// null means "All".
class ProjectFilter extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? tag) => state = tag;
}

final projectFilterProvider =
    NotifierProvider<ProjectFilter, String?>(ProjectFilter.new);
