import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/main/presentation/widgets/whatsapp_button.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';

import '../helpers/test_app.dart';

final _whatsAppIcon = find.descendant(
  of: find.byType(WhatsAppButton),
  matching: find.byType(FaIcon),
);

Future<void> _pump(WidgetTester tester, Size size, {bool showBack = false}) async {
  setSize(tester, size);
  await tester.pumpWidget(siteApp(
    overrides: siteOverrides(),
    home: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(showBack: showBack),
      ),
      endDrawer: const Drawer(),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(setUpSite);

  test('the WhatsApp contact is found by its wa.me link', () {
    final container = ProviderContainer(overrides: siteOverrides());
    addTearDown(container.dispose);
    final url = container.read(personalInfoRepositoryProvider).getWhatsApp()?.url;
    expect(url, startsWith('https://wa.me/'));
  });

  // 1024 is the narrowest width that gets the desktop bar (Responsive.isDesktop).
  testWidgets('desktop app bar fits at 1024 px, with WhatsApp labelled and Skills listed',
      (tester) async {
    await _pump(tester, const Size(1024, 800));
    expect(tester.takeException(), isNull);
    expect(_whatsAppIcon, findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.byType(EndDrawerButton), findsNothing);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('phone app bar shows the WhatsApp icon and keeps the drawer button', (tester) async {
    await _pump(tester, const Size(390, 800));
    expect(_whatsAppIcon, findsOneWidget);
    expect(find.text('WhatsApp'), findsNothing);
    expect(find.byType(EndDrawerButton), findsOneWidget);
  });

  testWidgets('showBack adds a back arrow, and only then', (tester) async {
    await _pump(tester, const Size(1024, 800), showBack: true);
    expect(tester.takeException(), isNull);
    expect(find.byType(BackButton), findsOneWidget);
  });
}
