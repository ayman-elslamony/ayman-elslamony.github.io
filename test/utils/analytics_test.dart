@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/utils/analytics.dart';

void main() {
  group('linkEventName', () {
    final cases = {
      'mailto:aymanelslamony17@gmail.com': 'click_email',
      'tel:+201552844195': 'click_phone',
      'https://wa.me/201552844195?text=Hi': 'click_whatsapp',
      'https://www.linkedin.com/in/ayman-elslamony': 'click_linkedin',
      'https://github.com/ayman-elslamony/Es3fni': 'click_github',
      'https://play.google.com/store/apps/details?id=x': 'click_google_play',
      'https://apps.apple.com/us/app/awon/id1483782795': 'click_app_store',
      'https://pub.dev/packages/hyperpay_plugin': 'click_pub_dev',
      'https://example.com': 'click_other_link',
    };
    cases.forEach((url, name) {
      test(url, () => expect(Analytics.linkEventName(url), name));
    });
  });

  test('sends gtag("event", name, params) when gtag exists', () {
    final calls = <List<Object?>>[];
    globalContext['gtag'] = ((JSString a, JSString b, JSObject p) {
      calls.add([a.toDart, b.toDart, (p['link_url'] as JSString?)?.toDart]);
    }).toJS;
    Analytics.link('https://wa.me/201552844195');
    expect(calls, [
      ['event', 'click_whatsapp', 'https://wa.me/201552844195'],
    ]);
    globalContext.delete('gtag'.toJS);
  });

  test('does nothing when gtag is absent', () {
    globalContext.delete('gtag'.toJS);
    expect(() => Analytics.event('x'), returnsNormally);
  });
}
