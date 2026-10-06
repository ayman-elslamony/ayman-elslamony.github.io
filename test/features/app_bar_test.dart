import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/data/language_repository.dart';
import 'package:portfolio/src/common/domain/language.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/main/presentation/widgets/whatsapp_button.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';

final _data = jsonDecode(File('assets/translations/en.json').readAsStringSync())
    as Map<String, dynamic>;

class _Info extends PersonalInfoRepository {
  _Info(super.ref);
  @override
  List<Contact> getContacts() => (_data['contacts'] as List)
      .map((c) => Contact.fromJson(c as Map<String, dynamic>))
      .toList();
}

class _OneLanguage extends LanguageRepository {
  _OneLanguage(super.ref);
  @override
  List<Language> getLanguages() => const [];
}

final _whatsAppIcon = find.descendant(
  of: find.byType(WhatsAppButton),
  matching: find.byType(FaIcon),
);

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      personalInfoRepositoryProvider.overrideWith((ref) => _Info(ref)),
      languageRepositoryProvider.overrideWith((ref) => _OneLanguage(ref)),
    ],
    child: const MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(),
        ),
        endDrawer: Drawer(),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  test('the WhatsApp contact is found by its wa.me link', () {
    final container = ProviderContainer(overrides: [
      personalInfoRepositoryProvider.overrideWith((ref) => _Info(ref)),
    ]);
    addTearDown(container.dispose);
    final url = container.read(personalInfoRepositoryProvider).getWhatsApp()?.url;
    expect(url, startsWith('https://wa.me/'));
  });

  testWidgets('desktop app bar shows the WhatsApp button with its label', (tester) async {
    await _pump(tester, const Size(1920, 900));
    expect(_whatsAppIcon, findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.byType(EndDrawerButton), findsNothing);
  });

  testWidgets('phone app bar shows the WhatsApp icon and keeps the drawer button', (tester) async {
    await _pump(tester, const Size(390, 800));
    expect(_whatsAppIcon, findsOneWidget);
    expect(find.text('WhatsApp'), findsNothing);
    expect(find.byType(EndDrawerButton), findsOneWidget);
  });
}
