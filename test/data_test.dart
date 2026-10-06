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
}
