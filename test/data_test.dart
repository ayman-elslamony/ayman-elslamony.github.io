import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/utils/icon_helper.dart';

/// The site's content is data in `assets/translations/en.json`; these tests guard what a typo
/// there breaks on the live page without any error.
void main() {
  final data = jsonDecode(File('assets/translations/en.json').readAsStringSync())
      as Map<String, dynamic>;
  final contacts = (data['contacts'] as List).cast<Map<String, dynamic>>();
  final projects = (data['projects'] as List).cast<Map<String, dynamic>>();

  bool okScheme(String url) {
    final uri = Uri.parse(url);
    if (uri.scheme == 'tel') return !url.startsWith('tel://');
    return uri.scheme == 'https' || uri.scheme == 'mailto';
  }

  test('every contact and project url uses https:, mailto: or tel:', () {
    final urls = [
      ...contacts.map((c) => c['url'] as String?),
      ...projects.map((p) => p['url'] as String?),
    ].whereType<String>();
    expect(urls.where((u) => !okScheme(u)), isEmpty);
  });

  test('every icon code point in en.json is bundled', () {
    final points = <String>[];
    void collect(Object? node) {
      if (node is Map) {
        final cp = node['iconCodePoint'];
        if (cp is String) points.add(cp);
        node.values.forEach(collect);
      } else if (node is List) {
        node.forEach(collect);
      }
    }

    collect(data);
    expect(points, isNotEmpty);
    expect(
      points.where((p) => !IconHelper.isBundled(int.parse(p))),
      isEmpty,
      reason: 'add the code point to IconHelper._usedIcons',
    );
  });

  test('a case study, when present, is complete', () {
    for (final p in projects) {
      final cs = p['caseStudy'] as Map<String, dynamic>?;
      if (cs == null) continue;
      expect(cs['slug'], matches(RegExp(r'^[a-z0-9-]+$')), reason: p['name'] as String?);
      expect((cs['problem'] as String?)?.trim(), isNotEmpty);
      expect((cs['result'] as String?)?.trim(), isNotEmpty);
      final built = (cs['built'] as List?) ?? const [];
      expect(built, isNotEmpty);
      for (final part in built.cast<Map<String, dynamic>>()) {
        expect((part['title'] as String?)?.trim(), isNotEmpty);
        expect((part['text'] as String?)?.trim(), isNotEmpty);
      }
    }
  });

  test('every counted number in aboutStats is one the About text states', () {
    // The numbers are typed twice - in the text and in the strip - so this keeps them equal.
    final about = data['aboutDescription'] as String;
    final stats = (data['aboutStats'] as List).cast<Map<String, dynamic>>();
    expect(stats, isNotEmpty);
    for (final s in stats) {
      final value = s['value'] as String;
      if (RegExp(r'[+%]').hasMatch(value)) {
        expect(about, contains(value), reason: 'aboutStats "$value" is not in aboutDescription');
      }
    }
  });

  test('the icons draw the same mark as the pre-boot loader', () {
    // tools/make_icons.py and the loader in web/index.html each hold the mark's geometry;
    // this fails when one is changed without the other.
    final svg = File('web/icons/icon.svg').readAsStringSync();
    final loader = File('web/index.html').readAsStringSync();
    final shapes = RegExp(r'(x="[^"]*" y="[^"]*" width="[^"]*" height="[^"]*" rx="[^"]*")|d="([^"]*)"')
        .allMatches(svg)
        .map((m) => m.group(0)!)
        .toList();
    expect(shapes, hasLength(3));
    for (final shape in shapes) {
      expect(loader, contains(shape));
    }
  });

  test('testimonials are complete, and a booking link, once set, is https', () {
    for (final t in (data['testimonials'] as List).cast<Map<String, dynamic>>()) {
      expect((t['quote'] as String?)?.trim(), isNotEmpty);
      expect((t['name'] as String?)?.trim(), isNotEmpty);
      final url = t['url'] as String?;
      if (url != null) expect(Uri.parse(url).scheme, 'https');
    }
    final booking = (data['bookCallUrl'] as String).trim();
    if (booking.isNotEmpty) expect(Uri.parse(booking).scheme, 'https');
  });
}
