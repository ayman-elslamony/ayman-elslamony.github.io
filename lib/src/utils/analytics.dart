import 'package:portfolio/src/utils/analytics_stub.dart'
    if (dart.library.js_interop) 'package:portfolio/src/utils/analytics_web.dart'
    as impl;

/// Sends GA4 events through the `gtag` function that `web/index.html` defines.
///
/// The site is drawn on a canvas, so GA4's own click tracking (enhanced
/// measurement) never sees a link: every click is reported from here instead.
/// Event names say what was clicked, so the Events report reads without any
/// setup in the GA4 UI; `link_url` and `link_text` carry the detail.
/// With GA blocked or absent, nothing happens.
class Analytics {
  Analytics._();

  static void event(String name, [Map<String, String> params = const {}]) =>
      impl.sendEvent(name, params);

  /// One event per outbound link, named by where it goes.
  static void link(String url, {String? text}) {
    event(linkEventName(url), {
      'link_url': url,
      if (text != null && text.isNotEmpty) 'link_text': text,
    });
  }

  static String linkEventName(String url) {
    final uri = Uri.tryParse(url);
    final host = (uri?.host ?? '').toLowerCase();
    return switch (uri?.scheme ?? '') {
      'mailto' => 'click_email',
      'tel' => 'click_phone',
      _ when host == 'wa.me' || host.endsWith('whatsapp.com') =>
        'click_whatsapp',
      _ when host.endsWith('linkedin.com') => 'click_linkedin',
      _ when host == 'github.com' => 'click_github',
      _ when host == 'play.google.com' => 'click_google_play',
      _ when host == 'apps.apple.com' => 'click_app_store',
      _ when host == 'pub.dev' => 'click_pub_dev',
      _ => 'click_other_link',
    };
  }
}
