import 'dart:ui' show Locale, PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:portfolio/src/common/widgets/scroll_extras.dart';
import 'package:portfolio/src/common/widgets/surface_card.dart';
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar_button.dart';
import 'package:portfolio/src/features/main/provider/scroll_controller.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/book_call_button.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/open_to_work_badge.dart';
import 'package:portfolio/src/features/project/domain/project_filter.dart';
import 'package:portfolio/src/features/project/presentation/case_study_page.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_description.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image.dart';
import 'package:portfolio/src/features/testimonials/domain/testimonial.dart';
import 'package:portfolio/src/features/testimonials/presentation/testimonials_section.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/utils/campaign.dart';

import '../helpers/test_app.dart';

const _slug = 'shared-architecture';
final _project = CaseStudyPage.find(enProjects, _slug)!;

RouteFactory get _routes => (s) {
      final slug = CaseStudyPage.slugFrom(s.name);
      return slug == null ? null : CaseStudyPage.route(slug);
    };

/// The site's own wiring: the portfolio at `/`, case studies at `/projects/<slug>`.
Widget _site({String? initialRoute, List<Override>? overrides}) => siteApp(
      overrides: overrides ?? siteOverrides(),
      home: initialRoute == null ? const MainSection() : null,
      initialRoute: initialRoute,
      onGenerateRoute: _routes,
      onGenerateInitialRoutes: initialRoute == null
          ? null
          : (r) => CaseStudyPage.initialRoutes(r, (s) => CaseStudyPage.find(enProjects, s) != null),
    );

Future<void> _openPage(WidgetTester tester) async {
  tester.state<NavigatorState>(find.byType(Navigator)).pushNamed(CaseStudyPage.path(_slug));
  await tester.pumpAndSettle();
}

/// Captures the calls the framework makes on the platform channel (clipboard, tab title).
List<MethodCall> _platformCalls(WidgetTester tester) {
  final calls = <MethodCall>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      calls.add(call);
      return null;
    },
  );
  addTearDown(() => tester.binding.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, null));
  return calls;
}

void main() {
  setUpAll(setUpSite);

  group('routing', () {
    test('slugFrom reads /projects/<slug> with or without the trailing slash', () {
      expect(CaseStudyPage.slugFrom('/projects/shared-architecture/'), _slug);
      expect(CaseStudyPage.slugFrom('/projects/shared-architecture'), _slug);
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
      expect(CaseStudyPage.find(enProjects, _slug), isNotNull);
    });

    testWidgets('opening the page reports its path to the browser address bar', (tester) async {
      final reported = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.navigation,
        (call) async {
          if (call.method == 'routeInformationUpdated') reported.add(call.arguments);
          return null;
        },
      );
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      expect(
        reported.map((a) => (a as Map)['uri'] ?? a['location']).map((u) => u.toString()),
        contains('/projects/shared-architecture'),
      );
    });
  });

  group('the page is part of the portfolio', () {
    for (final width in [360.0, 1280.0]) {
      testWidgets('it lays out without overflow at $width px', (tester) async {
        setSize(tester, Size(width, 900));
        await tester.pumpWidget(_site());
        await tester.pumpAndSettle();
        await _openPage(tester);
        expect(find.byType(CaseStudyPage), findsOneWidget);
        final scrollable = find
            .descendant(of: find.byType(CaseStudyPage), matching: find.byType(Scrollable))
            .first;
        await tester.scrollUntilVisible(find.text('One versioned core package'), 200,
            scrollable: scrollable);
        await tester.scrollUntilVisible(find.text('A Figma-to-code design pipeline'), 200,
            scrollable: scrollable);
        await tester.scrollUntilVisible(
            find.descendant(of: find.byType(CaseStudyPage), matching: find.byType(ContactBar)),
            200,
            scrollable: scrollable);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('1. it has the portfolio bar with a back arrow; the home bar has none',
        (tester) async {
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsNothing);
      await _openPage(tester);
      final page = find.byType(CaseStudyPage);
      expect(find.descendant(of: page, matching: find.byType(MyAppBar)), findsOneWidget);
      expect(find.descendant(of: page, matching: find.byType(BackButton)), findsOneWidget);
    });

    Future<void> pressProjects(WidgetTester tester) async {
      final button = find.descendant(
        of: find.byType(CaseStudyPage),
        matching: find.widgetWithText(AppBarButton, 'Projects'),
      );
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    double homeOffset(WidgetTester tester) => ProviderScope.containerOf(
          tester.element(find.byType(MainSection, skipOffstage: false)),
        ).read(scrollControllerProvider).offset;

    testWidgets('2a. Projects on the page returns to the portfolio and scrolls (after a push)',
        (tester) async {
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      await pressProjects(tester);
      expect(find.byType(CaseStudyPage), findsNothing);
      expect(homeOffset(tester), greaterThan(0));
    });

    testWidgets('2b. the same from a direct visit, where the portfolio was built underneath',
        (tester) async {
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site(initialRoute: '/projects/shared-architecture/'));
      await tester.pumpAndSettle();
      expect(find.byType(CaseStudyPage), findsOneWidget);
      await pressProjects(tester);
      expect(find.byType(CaseStudyPage), findsNothing);
      expect(homeOffset(tester), greaterThan(0));
    });

    testWidgets('2c. on a phone, the drawer on the page returns to the portfolio and scrolls',
        (tester) async {
      setSize(tester, const Size(390, 844));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      final page = find.byType(CaseStudyPage);
      await tester.tap(find.descendant(of: page, matching: find.byType(EndDrawerButton)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: page, matching: find.text('Projects')).last);
      await tester.pumpAndSettle();
      expect(find.byType(CaseStudyPage), findsNothing);
      expect(homeOffset(tester), greaterThan(0));
    });

    testWidgets('3. the image flies from the card to the page (Hero)', (tester) async {
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      final card = find.byKey(ValueKey(_project.name));
      await tester.scrollUntilVisible(card, 300, scrollable: find.byType(Scrollable).last);
      await tester.pumpAndSettle();
      final start = tester.getRect(
          find.descendant(of: card, matching: find.byKey(ProjectImage.frameKey)));
      await tester.tap(find.descendant(of: card, matching: find.byType(InkWell)).first);
      await tester.pump(); // the route starts
      await tester.pump(const Duration(milliseconds: 150)); // mid-flight
      final mid = tester
          .widgetList(find.byKey(ProjectImage.frameKey, skipOffstage: false))
          .map((w) => tester.getRect(find.byWidget(w, skipOffstage: false)))
          .toList();
      await tester.pumpAndSettle();
      final end = tester.getRect(find.descendant(
          of: find.byType(CaseStudyPage), matching: find.byKey(ProjectImage.frameKey)));
      expect(start, isNot(end));
      expect(mid.any((r) => r != start && r != end), isTrue,
          reason: 'during the transition the image is between the card and the page');
    });

    testWidgets('4/15. a "What I built" card (no action) shows the hover tint', (tester) async {
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      final part = find.ancestor(
        of: find.text('One versioned core package'),
        matching: find.byType(SurfaceCard),
      );
      await tester.scrollUntilVisible(part, 200,
          scrollable: find
              .descendant(of: find.byType(CaseStudyPage), matching: find.byType(Scrollable))
              .first);
      await tester.pumpAndSettle(); // let the scroll finish, or the card moves under the mouse
      final inkWell = find.descendant(of: part, matching: find.byType(InkWell));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(part));
      await tester.pumpAndSettle();
      final ink = Material.of(tester.element(inkWell));
      // InkHighlight paints the colour with an integer alpha (0.06 * 255 -> 15), not 0.06.
      final hover = Theme.of(tester.element(part)).colorScheme.primary.withValues(alpha: 0.06);
      final painted = hover.withAlpha((hover.a * 255).round());
      expect(ink, paints..rrect(color: painted));
    });

    testWidgets('6. the card says "Case study" instead of the external-link icon',
        (tester) async {
      final other = enProjects.firstWhere((p) => p.caseStudy == null);
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(siteApp(
        overrides: siteOverrides(),
        home: Scaffold(
          body: Column(children: [
            ProjectDescription(project: _project),
            ProjectDescription(project: other),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Case study'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget); // the other project only
    });

    testWidgets('7. copy link puts the page address on the clipboard and says so',
        (tester) async {
      final calls = _platformCalls(tester);
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();
      final copied = calls.where((c) => c.method == 'Clipboard.setData').toList();
      expect(copied, isNotEmpty);
      expect((copied.last.arguments as Map)['text'] as String,
          endsWith('/projects/shared-architecture/'));
      expect(find.text('Link copied'), findsOneWidget);
    });

    testWidgets('8. the tab title follows the page, and comes back on Back', (tester) async {
      final calls = _platformCalls(tester);
      setSize(tester, const Size(1280, 900));
      await tester.pumpWidget(_site());
      await tester.pumpAndSettle();
      await _openPage(tester);
      final title = tester.widget<Title>(find.descendant(
          of: find.byType(CaseStudyPage), matching: find.byType(Title)));
      expect(title.title, startsWith(_project.name!));
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      final labels = calls
          .where((c) => c.method == 'SystemChrome.setApplicationSwitcherDescription')
          .map((c) => (c.arguments as Map)['label'])
          .toList();
      expect(labels.last, 'Ayman Elslamony');
    });
  });

  group('additions', () {
    testWidgets('9. the badge shows its text, and nothing when switched off', (tester) async {
      await tester.pumpWidget(siteApp(
        overrides: siteOverrides(),
        home: const Scaffold(
          body: Column(children: [
            OpenToWorkBadge(visible: true),
            OpenToWorkBadge(visible: false),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Open to Senior Flutter roles · Remote or relocation'), findsOneWidget);
    });

    test('10. the company name comes from the campaign tag', () {
      expect(Campaign.companyName('knowteq'), 'Knowteq');
      expect(Campaign.companyName('al-belad'), 'Al Belad');
      expect(Campaign.companyName('al_belad'), 'Al Belad');
      for (final none in ['public', 'test', 'readme', 'PUBLIC', '', null]) {
        expect(Campaign.companyName(none), isNull, reason: '$none');
      }
    });

    test('11a. the readers survive an empty list, a missing key and an empty link', () {
      // An empty list in the generated const map is a List<dynamic>; a plain downcast throws.
      const Object emptyFromConstMap = <dynamic>[];
      expect(listOfMaps(emptyFromConstMap), isEmpty);
      expect(trList(const Locale('en'), 'no-such-key'), isEmpty);
      expect(trList(const Locale('en'), 'testimonials'), isNotEmpty);
      expect(trValue(const Locale('en'), 'bookCallUrl'), '');
      expect(trValue(const Locale('en'), 'no-such-key'), '');
    });

    Future<void> pumpBlocks(WidgetTester tester, List<Override> overrides) async {
      await tester.pumpWidget(siteApp(
        overrides: overrides,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [TestimonialsSection(), BookCallButton()]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('11b. empty testimonials and an empty link draw nothing', (tester) async {
      await pumpBlocks(tester, siteOverrides());
      expect(find.text('What people say'), findsNothing);
      expect(find.text('Book a call'), findsNothing);
    });

    testWidgets('11c. with data they appear', (tester) async {
      await pumpBlocks(
        tester,
        siteOverrides(
          bookCallUrl: 'https://calendly.com/x',
          testimonials: const [
            Testimonial(quote: 'Q', name: 'N', role: 'R', url: 'https://www.linkedin.com/x'),
          ],
        ),
      );
      expect(find.text('What people say'), findsOneWidget);
      expect(find.text('Q'), findsOneWidget);
      expect(find.text('Read the full recommendation on LinkedIn'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.text('Book a call'), findsOneWidget);
    });

    test('12. the filter offers the shared techs and narrows by value', () {
      final counts = <String, int>{};
      for (final p in enProjects) {
        for (final t in {...?p.technologies}) {
          counts[t] = (counts[t] ?? 0) + 1;
        }
      }
      final tags = filterTags(enProjects);
      expect(tags.toSet(), {for (final e in counts.entries) if (e.value >= 2) e.key});
      final flutter = filterProjects(enProjects, 'Flutter');
      expect(flutter.length, counts['Flutter']);
      expect(flutter.every((p) => p.technologies!.contains('Flutter')), isTrue);
      expect(filterProjects(enProjects, null).length, enProjects.length);
    });

    testWidgets('14. back to top appears past one screen and returns to the top',
        (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      setSize(tester, const Size(800, 600));
      await tester.pumpWidget(siteApp(
        overrides: siteOverrides(),
        home: Scaffold(
          body: Stack(children: [
            ListView(controller: controller, children: [const SizedBox(height: 5000)]),
            Positioned(right: 0, bottom: 0, child: BackToTopButton(controller: controller)),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      double opacity() => tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;
      expect(opacity(), 0);
      controller.jumpTo(700);
      await tester.pumpAndSettle();
      expect(opacity(), 1);
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pumpAndSettle();
      expect(controller.offset, 0);
    });
  });
}
