import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/app.dart';
import 'package:portfolio/src/common/widgets/attention.dart';
import 'package:portfolio/src/features/about/presentation/about_desktop.dart';
import 'package:portfolio/src/common/widgets/surface_card.dart';
import 'package:portfolio/src/common/widgets/technology_chip.dart';
import 'package:portfolio/src/features/about/presentation/about_section.dart';
import 'package:portfolio/src/features/experience/presentation/widgets/experience_card.dart';
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/main/presentation/widgets/section_index.dart';
import 'package:portfolio/src/features/main/provider/scroll_controller.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/open_to_work_badge.dart';
import 'package:portfolio/src/features/project/domain/project_filter.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_card.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_image.dart';
import 'package:portfolio/src/features/skills/presentation/skills_section.dart';
import 'package:portfolio/src/features/testimonials/domain/testimonial.dart';
import 'package:portfolio/src/utils/scroll_depth.dart';

import '../helpers/test_app.dart';

/// The home page's scroll extent before plan (p), measured on 2026-10-06 with this same
/// harness (Nunito, the real texts, no images). The plan's goal is measured against it.
const _extentBefore1440 = 11458.0;
const _extentBefore390 = 13715.0;

Widget _home() => siteApp(overrides: siteOverrides(), home: const MainSection());

ScrollController _controller(WidgetTester tester) => ProviderScope.containerOf(
      tester.element(find.byType(MainSection)),
    ).read(scrollControllerProvider);

Future<void> _pumpHome(WidgetTester tester, Size size) async {
  setSize(tester, size);
  await tester.pumpWidget(_home());
  await tester.pumpAndSettle();
}

Future<void> _scrollToEnd(WidgetTester tester) async {
  final c = _controller(tester);
  c.jumpTo(c.position.maxScrollExtent);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(setUpSite);

  // The other tests build their own MaterialApp; this one runs the site's, so a routing
  // setup Flutter rejects (it once had both `home` and `onGenerateInitialRoutes`, a red
  // screen under `flutter run`) fails here.
  testWidgets('the real app starts on the portfolio', (tester) async {
    setSize(tester, const Size(1440, 900));
    await tester.pumpWidget(ProviderScope(overrides: siteOverrides(), child: localized(const MyApp())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(MainSection), findsOneWidget);
  });

  testWidgets('the open-to-work dot pulses, and stays still with reduce motion', (tester) async {
    Attention.enabled = true;
    addTearDown(() => Attention.enabled = false);
    Future<List<double>> opacities() async {
      final seen = <double>[];
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 300));
        seen.add(tester
            .widget<Opacity>(find.descendant(
              of: find.byType(OpenToWorkBadge),
              matching: find.byType(Opacity),
            ))
            .opacity);
      }
      return seen;
    }

    await tester.pumpWidget(siteApp(overrides: siteOverrides(), home: const OpenToWorkBadge(visible: true)));
    expect((await opacities()).toSet().length, greaterThan(1), reason: 'the ring changes');

    await tester.pumpWidget(siteApp(
      overrides: siteOverrides(),
      home: const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: OpenToWorkBadge(visible: true),
      ),
    ));
    expect((await opacities()).toSet(), {0.0});
  });

  group('About', () {
    test('every highlight has a bold lead, and only its headline', () {
      final about = enJson['aboutDescription'] as String;
      final bullets = '\u2192'.allMatches(about).length;
      final leads = highlightLead.allMatches(about).map((m) => m.group(0)!).toList();
      expect(leads.length, bullets);
      expect(leads.first, 'Designed the shared architecture two apps now run on');
      expect(leads, contains('Published a native iOS/Android Flutter Plugin on Pub.dev'));
      expect(leads.where((l) => l.contains('\n') || l.contains(' — ')), isEmpty);
    });

    testWidgets('the numbers from en.json show under the intro', (tester) async {
      await _pumpHome(tester, const Size(1440, 900));
      final stats = (enJson['aboutStats'] as List).cast<Map<String, dynamic>>();
      expect(find.byType(AboutStat), findsNWidgets(stats.length));
      for (final s in stats) {
        expect(find.text(s['value'] as String), findsWidgets);
      }
      expect(
        tester.getTopLeft(find.byType(AboutStat).first).dy,
        lessThan(tester.getTopLeft(find.textContaining('What makes', findRichText: true)).dy),
      );
    });
  });

  group('fewer scrolls', () {
    testWidgets('at 1440x900 the page is at least 50 % shorter', (tester) async {
      await _pumpHome(tester, const Size(1440, 900));
      final extent = _controller(tester).position.maxScrollExtent;
      expect(extent, lessThanOrEqualTo(_extentBefore1440 * 0.5), reason: 'extent $extent');
    });

    testWidgets('at 390x844 the page is shorter too', (tester) async {
      await _pumpHome(tester, const Size(390, 844));
      final extent = _controller(tester).position.maxScrollExtent;
      expect(extent, lessThan(_extentBefore390), reason: 'extent $extent');
    });

    for (final width in [390.0, 800.0, 1024.0, 1280.0, 1440.0, 1920.0]) {
      testWidgets('no overflow at $width px, top to bottom', (tester) async {
        await _pumpHome(tester, Size(width, 900));
        expect(tester.takeException(), isNull);
        await _scrollToEnd(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('resizing across the breakpoints throws nothing', (tester) async {
    await _pumpHome(tester, const Size(1440, 900));
    for (final size in [const Size(800, 900), const Size(390, 844), const Size(1440, 900)]) {
      setSize(tester, size);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'at ${size.width}');
    }
  });

  group('desktop frame', () {
    testWidgets('text keeps to 680 px at 1920', (tester) async {
      await _pumpHome(tester, const Size(1920, 1080));
      expect(tester.getSize(find.byType(AboutSection)).width, lessThanOrEqualTo(680));
      expect(tester.getSize(find.byType(ExperienceCard).first).width, lessThanOrEqualTo(680));
      // The grids take the wider column.
      expect(tester.getSize(find.byType(SkillsSection)).width, greaterThan(680));
    });

    testWidgets('project cards sit two to a row at 1440, one at 1024 and 390', (tester) async {
      Future<bool> sideBySide(Size size) async {
        await _pumpHome(tester, size);
        // By name: the finder walks the tree, so in two columns its second card is the
        // left column's second, not the second project.
        Finder card(int i) => find.byKey(ValueKey(enProjects[i].name));
        return tester.getTopLeft(card(0)).dy == tester.getTopLeft(card(1)).dy;
      }

      expect(await sideBySide(const Size(1440, 900)), isTrue);
      expect(await sideBySide(const Size(1024, 900)), isFalse);
      expect(await sideBySide(const Size(390, 844)), isFalse);
    });
  });

  testWidgets('the two cards of a row share their top and their bottom', (tester) async {
    await _pumpHome(tester, const Size(1440, 900));
    void level(Finder a, Finder b) {
      expect(tester.getTopLeft(a).dy, tester.getTopLeft(b).dy);
      expect(tester.getBottomLeft(a).dy, tester.getBottomLeft(b).dy);
    }

    final skillCards = find.descendant(
      of: find.byType(SkillsSection),
      matching: find.byType(SurfaceCard),
    );
    for (var i = 0; i + 1 < skillCards.evaluate().length; i += 2) {
      level(skillCards.at(i), skillCards.at(i + 1));
    }
    for (var i = 0; i + 1 < firstProjects; i += 2) {
      level(
        find.byKey(ValueKey(enProjects[i].name)),
        find.byKey(ValueKey(enProjects[i + 1].name)),
      );
    }
  });

  for (final size in [const Size(1280, 900), const Size(1440, 900), const Size(800, 1000), const Size(390, 844)]) {
    testWidgets('the project image fills its card, centred, at ${size.width}', (tester) async {
      await _pumpHome(tester, size);
      final card = find.byKey(ValueKey(enProjects[0].name));
      final frame = find.descendant(of: card, matching: find.byKey(ProjectImage.frameKey));
      final cardBox = tester.getRect(card);
      final frameBox = tester.getRect(frame);
      // Centred in the card, whatever its width.
      expect((frameBox.center.dx - cardBox.center.dx).abs(), lessThan(1), skip: size.width >= 640 && size.width < 1024);
      // The image's own shape: 1024 x 500 plus the 4 px border.
      expect((frameBox.width - 8) / (frameBox.height - 8), closeTo(ProjectImage.aspectRatio, 0.02));
    });
  }

  group('Show all projects', () {
    testWidgets('6 first, then all of them after the button', (tester) async {
      await _pumpHome(tester, const Size(1440, 900));
      expect(find.byType(ProjectCard), findsNWidgets(firstProjects));
      final button = find.text('Show all ${enProjects.length} projects');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(ProjectCard), findsNWidgets(enProjects.length));
      expect(button, findsNothing);
    });

    testWidgets('a selected technology shows every match, with no button', (tester) async {
      await _pumpHome(tester, const Size(390, 844));
      final chip = find.widgetWithText(FilterChip, 'Bloc');
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
      final matches = filterProjects(enProjects, 'Bloc').length;
      expect(matches, greaterThan(firstProjects), reason: 'the case needs more than 6 matches');
      expect(find.byType(ProjectCard), findsNWidgets(matches));
      expect(find.textContaining('Show all'), findsNothing);
    });

    test('visibleProjects', () {
      expect(visibleProjects(enProjects, tag: null, showAll: false), enProjects.take(6));
      expect(visibleProjects(enProjects, tag: null, showAll: true), enProjects);
      expect(visibleProjects(enProjects.take(4).toList(), tag: null, showAll: false).length, 4);
    });
  });

  group('Read more on the first job', () {
    for (final size in [const Size(1440, 900), const Size(390, 844)]) {
      testWidgets('at ${size.width}', (tester) async {
        await _pumpHome(tester, size);
        final card = find.byType(ExperienceCard).first;
        final more = find.descendant(
          of: card,
          matching: find.textContaining('Read more', findRichText: true),
        );
        expect(more, findsOneWidget);
        final last = enJson['experiences'][0]['description'].toString().split('\n').last;
        expect(
          find.descendant(of: card, matching: find.textContaining(last, findRichText: true)),
          findsNothing,
        );
        await tester.ensureVisible(more);
        await tester.pumpAndSettle();
        await tester.tapOnText(find.textRange.ofSubstring('Read more', descendentOf: card));
        await tester.pumpAndSettle();
        expect(
          find.descendant(of: card, matching: find.textContaining(last, findRichText: true)),
          findsOneWidget,
        );
      });
    }

    test('the cut falls on a line break', () {
      final text = enJson['experiences'][0]['description'] as String;
      final cut = trimAtLine(text);
      expect(text[cut], '\n');
      expect(cut, lessThanOrEqualTo(420));
      expect(trimAtLine('short'), 5);
    });
  });

  testWidgets('skill chips carry no icon', (tester) async {
    await _pumpHome(tester, const Size(1440, 900));
    final chips = find.descendant(
      of: find.byType(SkillsSection),
      matching: find.byType(TechnologyChip),
    );
    expect(chips, findsWidgets);
    expect(find.descendant(of: chips, matching: find.byType(Icon)), findsNothing);
  });

  group('section index', () {
    Finder entry(String label) =>
        find.descendant(of: find.byType(SectionIndex), matching: find.text(label));

    bool isActive(WidgetTester tester, String label) =>
        tester.widget<Text>(entry(label)).style?.fontWeight == FontWeight.bold;

    testWidgets('present at 1440x900, absent at 1440x700 and on a phone', (tester) async {
      await _pumpHome(tester, const Size(1440, 900));
      expect(find.byType(SectionIndex), findsOneWidget);
      await _pumpHome(tester, const Size(1440, 700));
      expect(find.byType(SectionIndex), findsNothing);
      await _pumpHome(tester, const Size(390, 844));
      expect(find.byType(SectionIndex), findsNothing);
    });

    testWidgets('follows the scroll, and a click scrolls there', (tester) async {
      await _pumpHome(tester, const Size(1440, 900));
      expect(isActive(tester, 'About'), isTrue);

      await tester.tap(entry('Projects'));
      await tester.pumpAndSettle();
      expect(isActive(tester, 'Projects'), isTrue);
      expect(isActive(tester, 'About'), isFalse);

      await tester.tap(entry('Skills'));
      await tester.pumpAndSettle();
      expect(isActive(tester, 'Skills'), isTrue);
      final skillsTop = tester.getTopLeft(find.byType(SkillsSection)).dy;
      expect(skillsTop, lessThan(900 / 3), reason: 'Skills is scrolled to the top');
    });
  });

  group('section index, end of page', () {
    const quote = Testimonial(quote: 'Good work.', name: 'A', role: 'B', url: 'https://example.com');
    Widget withTestimonial() => siteApp(
          overrides: siteOverrides(testimonials: const [quote]),
          home: const MainSection(),
        );
    Finder entry(String label) =>
        find.descendant(of: find.byType(SectionIndex), matching: find.text(label));
    bool isActive(WidgetTester tester, String label) =>
        tester.widget<Text>(entry(label)).style?.fontWeight == FontWeight.bold;

    testWidgets('the last step is active at the very end, and pulses', (tester) async {
      setSize(tester, const Size(1440, 900));
      await tester.pumpWidget(withTestimonial());
      await tester.pumpAndSettle();
      await _scrollToEnd(tester);
      expect(isActive(tester, 'What people say'), isTrue);
      expect(
        find.descendant(of: find.byType(SectionIndex), matching: find.byType(PulseDot)),
        findsOneWidget,
        reason: 'only the active step pulses',
      );
    });

    testWidgets('a fold opening re-checks the active step without a scroll', (tester) async {
      setSize(tester, const Size(1440, 900));
      await tester.pumpWidget(withTestimonial());
      await tester.pumpAndSettle();
      await _scrollToEnd(tester);
      expect(isActive(tester, 'What people say'), isTrue);
      // Show all from code, so no scroll happens: 13 more cards push the last section
      // far below, and the reader is now in Projects.
      ProviderScope.containerOf(tester.element(find.byType(MainSection)))
          .read(showAllProjectsProvider.notifier)
          .open();
      await tester.pumpAndSettle();
      expect(isActive(tester, 'Projects'), isTrue);
    });
  });

  testWidgets('a wave runs through the contact buttons', (tester) async {
    Attention.enabled = true;
    addTearDown(() => Attention.enabled = false);
    setSize(tester, const Size(1440, 900));
    await tester.pumpWidget(_home());
    await tester.pump(const Duration(seconds: 1));
    // Two waves on the page: the About numbers and the contact buttons.
    expect(find.byType(AttentionWave), findsNWidgets(2));
    final wave = find.ancestor(of: find.byType(IconButton).last, matching: find.byType(AttentionWave));
    expect(
      find.ancestor(of: find.byType(AboutStat).first, matching: find.byType(AttentionWave)),
      findsOneWidget,
    );
    final lifts = <double>{};
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final moves = tester.widgetList<Transform>(
        find.descendant(of: wave, matching: find.byType(Transform)),
      );
      lifts.add(moves.first.transform.getTranslation().y);
    }
    expect(lifts.length, greaterThan(1), reason: 'the first button moves');
    expect(lifts.reduce((a, b) => a < b ? a : b), closeTo(-AttentionWave.lift, 0.5));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a glint crosses Resume, then Book a call; neither stops a tap', (tester) async {
    Attention.enabled = true;
    addTearDown(() => Attention.enabled = false);
    setSize(tester, const Size(1440, 900));
    await tester.pumpWidget(siteApp(
      overrides: siteOverrides(bookCallUrl: 'https://calendar.app.google/x'),
      home: const MainSection(),
    ));
    await tester.pump(const Duration(seconds: 1));
    final shines = find.byType(AttentionShine);
    expect(shines, findsNWidgets(2));
    bool shining(int i) => find
        .descendant(of: shines.at(i), matching: find.byType(FractionalTranslation))
        .evaluate()
        .isNotEmpty;
    final seen = <String>{};
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      seen.add('${shining(0)}${shining(1)}');
    }
    expect(seen, containsAll(['truefalse', 'falsetrue']), reason: 'each shines, at its own time');
    expect(seen, isNot(contains('truetrue')));
    await tester.pumpWidget(const SizedBox());
  });

  group('scroll depth', () {
    Future<List<String>> run(
      WidgetTester tester,
      double contentHeight,
      Future<void> Function(ScrollController c) scroll,
    ) async {
      final events = <String>[];
      final controller = ScrollController();
      addTearDown(controller.dispose);
      setSize(tester, const Size(400, 1000));
      await tester.pumpWidget(MaterialApp(
        home: ScrollDepthReporter(
          controller: controller,
          page: 'test',
          report: (name, params) => events.add('$name ${params['percent']} ${params['page']}'),
          child: SingleChildScrollView(
            controller: controller,
            child: SizedBox(height: contentHeight),
          ),
        ),
      ));
      await scroll(controller);
      return events;
    }

    testWidgets('25, 50 and 75 once each, in order', (tester) async {
      final events = await run(tester, 5000, (c) async {
        c.jumpTo(c.position.maxScrollExtent * 0.3);
        await tester.pump();
        c.jumpTo(c.position.maxScrollExtent * 0.8);
        await tester.pump();
        c.jumpTo(0);
        await tester.pump();
        c.jumpTo(c.position.maxScrollExtent);
        await tester.pump();
      });
      expect(events, [
        'scroll_depth 25 test',
        'scroll_depth 50 test',
        'scroll_depth 75 test',
      ]);
    });

    testWidgets('a page that cannot scroll sends nothing', (tester) async {
      final events = await run(tester, 500, (c) async {
        c.jumpTo(0);
        await tester.pump();
      });
      expect(events, isEmpty);
    });

    for (final size in [const Size(1440, 900), const Size(390, 844)]) {
      testWidgets('the home page reports as "home" at ${size.width}', (tester) async {
        await _pumpHome(tester, size);
        final reporter = tester.widget<ScrollDepthReporter>(find.byType(ScrollDepthReporter));
        expect(reporter.page, 'home');
        expect(reporter.controller, same(_controller(tester)));
      });
    }
  });
}
