import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/technology_wrap_chips.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_button.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/case_study.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';

/// One project's case study, at `/projects/<slug>`. The text is the project's `caseStudy`
/// in `assets/translations/en.json`; adding one to another project needs no code.
class CaseStudyPage extends ConsumerStatefulWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  static const prefix = '/projects/';

  static String path(String slug) => '$prefix$slug';

  /// The slug in a route name such as `/projects/shared-architecture/`, or null.
  static String? slugFrom(String? routeName) {
    if (routeName == null || !routeName.startsWith(prefix)) return null;
    final slug = routeName.substring(prefix.length).replaceAll('/', '');
    return slug.isEmpty ? null : slug;
  }

  static Route<void> route(String slug) => MaterialPageRoute(
        settings: RouteSettings(name: path(slug)),
        builder: (_) => CaseStudyPage(slug: slug),
      );

  /// The routes for a first visit to [initialRoute]: the portfolio, plus the case study when
  /// the path names one that [exists]. Back from a case study therefore stays on the site.
  static List<Route<dynamic>> initialRoutes(
    String initialRoute,
    bool Function(String slug) exists,
  ) {
    final home = MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/'),
      builder: (_) => const MainSection(),
    );
    final slug = slugFrom(initialRoute);
    if (slug == null || !exists(slug)) return [home];
    return [home, route(slug)];
  }

  /// The project whose case study has [slug], or null.
  static Project? find(List<Project> projects, String slug) {
    for (final p in projects) {
      if (p.caseStudy?.slug == slug) return p;
    }
    return null;
  }

  @override
  ConsumerState<CaseStudyPage> createState() => _CaseStudyPageState();
}

class _CaseStudyPageState extends ConsumerState<CaseStudyPage> {
  @override
  void initState() {
    super.initState();
    Analytics.event('open_case_study', {'project': widget.slug});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projects = ref.watch(projectRepositoryProvider).getProjects();
    final project = CaseStudyPage.find(projects, widget.slug);
    final caseStudy = project?.caseStudy;
    final info = ref.watch(personalInfoRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              navigator.pushReplacementNamed('/');
            }
          },
        ),
        title: Text(tr(LocaleKeys.name)),
      ),
      body: SelectionArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(Sizes.p24),
              children: project == null || caseStudy == null
                  ? [Text(tr(LocaleKeys.caseStudyNotFound), style: theme.textTheme.titleMedium)]
                  : [
                      Text(
                        project.name ?? '',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      gapH12,
                      Text(project.description ?? '', style: theme.textTheme.bodyLarge),
                      gapH32,
                      _Section(title: tr(LocaleKeys.caseStudyProblem), text: caseStudy.problem),
                      gapH24,
                      Text(
                        tr(LocaleKeys.caseStudyBuilt),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      gapH12,
                      for (final part in caseStudy.built) ...[
                        _Part(part: part),
                        gapH12,
                      ],
                      gapH12,
                      _Section(title: tr(LocaleKeys.caseStudyResult), text: caseStudy.result),
                      gapH24,
                      TechnologyWrapChips(titles: project.technologies ?? const []),
                      gapH32,
                      Wrap(
                        spacing: Sizes.p16,
                        runSpacing: Sizes.p16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ResumeButton(resumes: info.getResumes()),
                          ContactBar(contacts: info.getContacts()),
                        ],
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});

  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        gapH8,
        Text(text ?? '', style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _Part extends StatelessWidget {
  const _Part({required this.part});

  final CaseStudyPart part;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(part.title ?? '',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          gapH8,
          Text(part.text ?? '', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
