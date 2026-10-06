import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/features/project/presentation/case_study_page.dart';

final _data = jsonDecode(File('assets/translations/en.json').readAsStringSync())
    as Map<String, dynamic>;
final _projects = (_data['projects'] as List)
    .map((p) => Project.fromJson(p as Map<String, dynamic>))
    .toList();

class _Projects extends ProjectRepository {
  _Projects(super.ref);
  @override
  List<Project> getProjects() => _projects;
}

class _Info extends PersonalInfoRepository {
  _Info(super.ref);
  @override
  List<Resume> getResumes() => (_data['resumes'] as List)
      .map((r) => Resume.fromJson(r as Map<String, dynamic>))
      .toList();
  @override
  List<Contact> getContacts() => (_data['contacts'] as List)
      .map((c) => Contact.fromJson(c as Map<String, dynamic>))
      .toList();
}

Widget _app() => ProviderScope(
      overrides: [
        projectRepositoryProvider.overrideWith((ref) => _Projects(ref)),
        personalInfoRepositoryProvider.overrideWith((ref) => _Info(ref)),
      ],
      child: MaterialApp(
        home: const SizedBox(),
        onGenerateRoute: (s) {
          final slug = CaseStudyPage.slugFrom(s.name);
          return slug == null ? null : CaseStudyPage.route(slug);
        },
      ),
    );

void main() {
  test('slugFrom reads /projects/<slug> with or without the trailing slash', () {
    expect(CaseStudyPage.slugFrom('/projects/shared-architecture/'), 'shared-architecture');
    expect(CaseStudyPage.slugFrom('/projects/shared-architecture'), 'shared-architecture');
    expect(CaseStudyPage.slugFrom('/projects/'), isNull);
    expect(CaseStudyPage.slugFrom('/'), isNull);
    expect(CaseStudyPage.slugFrom('/cv/'), isNull);
  });

  test('a direct visit builds [portfolio, case study]; an unknown slug only the portfolio', () {
    final known = CaseStudyPage.initialRoutes('/projects/shared-architecture/', (s) => true);
    expect(known.map((r) => r.settings.name), ['/', '/projects/shared-architecture']);
    final unknown = CaseStudyPage.initialRoutes('/projects/nope/', (s) => false);
    expect(unknown.map((r) => r.settings.name), ['/']);
  });

  test('the real en.json has the shared-architecture case study', () {
    expect(CaseStudyPage.find(_projects, 'shared-architecture'), isNotNull);
  });

  for (final width in [360.0, 1280.0]) {
    testWidgets('the page lays out without overflow at $width px', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app());
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      nav.pushNamed('/projects/shared-architecture');
      await tester.pumpAndSettle();
      expect(find.byType(CaseStudyPage), findsOneWidget);
      // Scroll the whole page, so every block is laid out at least once.
      final scrollable = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(find.text('One versioned core package'), 200,
          scrollable: scrollable);
      await tester.scrollUntilVisible(find.text('A Figma-to-code design pipeline'), 200,
          scrollable: scrollable);
      await tester.scrollUntilVisible(find.byType(ContactBar), 200, scrollable: scrollable);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('opening the page reports its path to the browser address bar', (tester) async {
    final reported = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.navigation,
      (call) async {
        if (call.method == 'routeInformationUpdated') reported.add(call.arguments);
        return null;
      },
    );
    await tester.pumpWidget(_app());
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/projects/shared-architecture');
    await tester.pumpAndSettle();
    expect(
      reported.map((a) => (a as Map)['uri'] ?? a['location']).map((u) => u.toString()),
      contains('/projects/shared-architecture'),
    );
  });
}
