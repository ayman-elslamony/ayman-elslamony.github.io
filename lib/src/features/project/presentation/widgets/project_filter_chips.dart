import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/project/domain/project_filter.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';

/// "All" plus one chip per shared technology; picking one narrows the project list.
class ProjectFilterChips extends ConsumerWidget {
  const ProjectFilterChips({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tags.isEmpty) return const SizedBox.shrink();
    final selected = ref.watch(projectFilterProvider);
    final colors = Theme.of(context).colorScheme;

    Widget chip(String label, String? tag) => FilterChip(
          label: Text(label),
          selected: selected == tag,
          showCheckmark: false,
          selectedColor: colors.primary.withValues(alpha: 0.16),
          side: BorderSide(color: colors.primary.withValues(alpha: 0.35)),
          shape: const StadiumBorder(),
          onSelected: (_) {
            ref.read(projectFilterProvider.notifier).select(tag);
            if (tag != null) Analytics.event('filter_projects', {'tag': tag});
          },
        );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(tr(LocaleKeys.filterAll), null),
        for (final tag in tags) chip(tag, tag),
      ],
    );
  }
}
