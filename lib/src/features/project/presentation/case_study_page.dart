import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';
import 'package:portfolio/src/common/widgets/scroll_extras.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/common/widgets/surface_card.dart';
import 'package:portfolio/src/common/widgets/technology_wrap_chips.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/main/presentation/widgets/end_drawer.dart';
import 'package:portfolio/src/features/main/presentation/widgets/safe_area.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/book_call_button.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_button.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/case_study.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Analytics.event('open_case_study', {'project': widget.slug});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // `Title` writes the tab title only when it builds, and the portfolio under this page is
    // not rebuilt when it comes back - so the tab would keep this project's title.
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(label: tr(LocaleKeys.name)),
    );
    super.dispose();
  }

  Future<void> _copyLink(BuildContext context) async {
    final link = Uri.base
        .resolve('${CaseStudyPage.path(widget.slug)}/')
        .toString();
    Analytics.event('share_case_study', {'project': widget.slug});
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(LocaleKeys.caseStudyLinkCopied))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projects = ref.watch(projectRepositoryProvider).getProjects();
    final project = CaseStudyPage.find(projects, widget.slug);
    final caseStudy = project?.caseStudy;
    final info = ref.watch(personalInfoRepositoryProvider);

    final page = Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(showBack: true),
      ),
      endDrawer: const MySafeArea(child: EndDrawer()),
      body: MySafeArea(
        child: Column(
          children: [
            ReadingProgress(controller: _scrollController),
            Expanded(
              child: Stack(
                children: [
                  MySelectionArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            Sizes.p24,
                            Sizes.p24,
                            Sizes.p24,
                            88,
                          ),
                          children: project == null || caseStudy == null
                              ? [
                                  Text(
                                    tr(LocaleKeys.caseStudyNotFound),
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ]
                              : [
                                  // Outside the fade: a Hero's target has to be in place
                                  // for the flight from the card to land on it.
                                  Center(
                                    child: ProjectImage(
                                      project: project,
                                      isHovered: false,
                                    ),
                                  ),
                                  gapH24,
                                  AnimatedFadeSlide(
                                    offset: const Offset(0, 64),
                                    child: _Body(
                                      project: project,
                                      caseStudy: caseStudy,
                                      info: info,
                                      onCopyLink: () => _copyLink(context),
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: BackToTopButton(controller: _scrollController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (project == null) return page;
    return Title(
      title: '${project.name} · ${tr(LocaleKeys.name)}',
      color: theme.colorScheme.primary,
      child: page,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.project,
    required this.caseStudy,
    required this.info,
    required this.onCopyLink,
  });

  final Project project;
  final CaseStudy caseStudy;
  final PersonalInfoRepository info;
  final VoidCallback onCopyLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                project.name ?? '',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            IconButton(
              tooltip: tr(LocaleKeys.caseStudyCopyLink),
              color: theme.colorScheme.primary,
              icon: const Icon(Icons.link),
              onPressed: onCopyLink,
            ),
          ],
        ),
        gapH12,
        Text(project.description ?? '', style: theme.textTheme.bodyLarge),
        gapH32,
        _Section(
          title: tr(LocaleKeys.caseStudyProblem),
          text: caseStudy.problem,
        ),
        gapH24,
        Text(tr(LocaleKeys.caseStudyBuilt), style: theme.textTheme.titleLarge),
        gapH12,
        for (final part in caseStudy.built) ...[
          SurfaceCard(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part.title ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH8,
                  Text(part.text ?? '', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
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
            const BookCallButton(),
            ContactBar(contacts: info.getContacts()),
          ],
        ),
      ],
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
        Text(title, style: theme.textTheme.titleLarge),
        gapH8,
        Text(text ?? '', style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
