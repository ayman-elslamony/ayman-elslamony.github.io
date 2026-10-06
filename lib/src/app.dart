import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/themes.dart' as themes;
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/presentation/case_study_page.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

import 'features/main/provider/dark_mode_controller.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) => tr(LocaleKeys.name),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Ayman Elslamony',
      theme: themes.lightTheme,
      darkTheme: themes.darkTheme,
      themeMode: ref.watch(darkModeProvider).maybeWhen(
            data: (darkMode) => darkMode ? ThemeMode.dark : ThemeMode.light,
            orElse: () => ThemeMode.light,
          ),
      home: const MainSection(),
      // `/projects/<slug>` opens a case study. A direct visit builds [portfolio, case study],
      // so Back returns to the portfolio instead of leaving the site; an unknown slug opens
      // the portfolio.
      onGenerateRoute: (settings) {
        final slug = CaseStudyPage.slugFrom(settings.name);
        if (slug == null || !_hasCaseStudy(ref, slug)) return null;
        return CaseStudyPage.route(slug);
      },
      onGenerateInitialRoutes: (initialRoute) => CaseStudyPage.initialRoutes(
        initialRoute,
        (slug) => _hasCaseStudy(ref, slug),
      ),
    );
  }

  bool _hasCaseStudy(WidgetRef ref, String slug) => CaseStudyPage.find(
        ref.read(projectRepositoryProvider).getProjects(),
        slug,
      ) != null;
}
