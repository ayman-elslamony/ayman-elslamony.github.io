import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:portfolio/src/common/data/language_repository.dart';
import 'package:portfolio/src/common/domain/language.dart';
import 'package:portfolio/src/features/experience/data/experience_repository.dart';
import 'package:portfolio/src/features/experience/domain/experience.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/common/widgets/attention.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/skills/data/skill_repository.dart';
import 'package:portfolio/src/features/skills/domain/skill_group.dart';
import 'package:portfolio/src/features/testimonials/data/testimonial_repository.dart';
import 'package:portfolio/src/features/testimonials/domain/testimonial.dart';
import 'package:portfolio/src/localization/generated/locale_json.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The real `assets/translations/en.json`, read from disk.
final enJson = jsonDecode(File('assets/translations/en.json').readAsStringSync())
    as Map<String, dynamic>;

List<Map<String, dynamic>> _list(String key) =>
    (enJson[key] as List).cast<Map<String, dynamic>>();

final enProjects = _list('projects').map(Project.fromJson).toList();

/// Loads the site's own Nunito, so text in tests is measured with the font the site ships
/// rather than the test font, whose every glyph is a wide square.
Future<void> loadSiteFont() async {
  final loader = FontLoader('Nunito');
  for (final f in ['Nunito-Regular.ttf', 'Nunito-Bold.ttf']) {
    final bytes = File('assets/fonts/$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

class _Projects extends ProjectRepository {
  _Projects(super.ref);
  @override
  List<Project> getProjects() => enProjects;
}

class _Info extends PersonalInfoRepository {
  _Info(super.ref, this.bookCallUrl);
  final String bookCallUrl;
  @override
  List<Resume> getResumes() => _list('resumes').map(Resume.fromJson).toList();
  @override
  List<Contact> getContacts() => _list('contacts').map(Contact.fromJson).toList();
  @override
  String getBookCallUrl() => bookCallUrl;
}

class _Experiences extends ExperienceRepository {
  _Experiences(super.ref);
  @override
  List<Experience> getExperiences() => _list('experiences').map(Experience.fromJson).toList();
}

class _Languages extends LanguageRepository {
  _Languages(super.ref);
  @override
  List<Language> getLanguages() => const [];
}

class _Testimonials extends TestimonialRepository {
  _Testimonials(super.ref, this.items);
  final List<Testimonial> items;
  @override
  List<Testimonial> getTestimonials() => items;
}

class _Skills extends SkillRepository {
  _Skills(super.ref);
  @override
  List<SkillGroup> getSkillGroups() => _list('skills').map(SkillGroup.fromJson).toList();
}

/// Every repository the pages read, answered from `en.json` without the locale machinery.
List<Override> siteOverrides({
  String bookCallUrl = '',
  List<Testimonial> testimonials = const [],
}) =>
    [
      projectRepositoryProvider.overrideWith((ref) => _Projects(ref)),
      personalInfoRepositoryProvider.overrideWith((ref) => _Info(ref, bookCallUrl)),
      languageRepositoryProvider.overrideWith((ref) => _Languages(ref)),
      experienceRepositoryProvider.overrideWith((ref) => _Experiences(ref)),
      testimonialRepositoryProvider.overrideWith((ref) => _Testimonials(ref, testimonials)),
      skillRepositoryProvider.overrideWith((ref) => _Skills(ref)),
    ];

final siteTheme = ThemeData(fontFamily: 'Nunito');

void setSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Real English texts in tests: the generated loader, so `tr()` answers with what the site
/// shows instead of the key. Call [initLocalization] once in `setUpAll`.
Future<void> initLocalization() async {
  SharedPreferences.setMockInitialValues({});
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();
}

Widget localized(Widget child) => EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: child,
    );

/// [initLocalization] then the site font.
Future<void> setUpSite() async {
  Attention.enabled = false;
  await initLocalization();
  await loadSiteFont();
}

/// A MaterialApp wired the way `lib/src/app.dart` wires it, for widgets that call `tr()`.
Widget siteApp({
  required List<Override> overrides,
  Widget? home,
  RouteFactory? onGenerateRoute,
  InitialRouteListFactory? onGenerateInitialRoutes,
  String? initialRoute,
}) =>
    ProviderScope(
      overrides: overrides,
      child: localized(
        Builder(
          builder: (context) => MaterialApp(
            theme: siteTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: home,
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
          ),
        ),
      ),
    );
