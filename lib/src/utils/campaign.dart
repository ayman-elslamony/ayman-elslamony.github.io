import 'package:portfolio/src/utils/campaign_stub.dart'
    if (dart.library.js_interop) 'package:portfolio/src/utils/campaign_web.dart'
    as impl;

/// The company a visitor came from, by the `utm_campaign` tag of the CV copy they opened.
///
/// `web/index.html` strips the `utm_` tags from the address bar before Flutter starts, so
/// it first stores the campaign in `sessionStorage`; this reads it from there.
class Campaign {
  Campaign._();

  /// Tags that are not a company: the public CV, a test link, and the GitHub profile.
  static const notCompanies = {'public', 'test', 'readme'};

  static const _dismissedKey = 'welcome_dismissed';

  /// The company name for this visit, or null when the visit has no company tag or the
  /// visitor already closed the welcome.
  static String? company() {
    if (impl.readSession(_dismissedKey) == '1') return null;
    return companyName(impl.readSession('utm_campaign'));
  }

  static void dismiss() => impl.writeSession(_dismissedKey, '1');

  /// `knowteq` -> `Knowteq`, `al-belad` -> `Al Belad`; null for a non-company tag.
  static String? companyName(String? tag) {
    final value = tag?.trim() ?? '';
    if (value.isEmpty || notCompanies.contains(value.toLowerCase())) return null;
    final words = value
        .split(RegExp(r'[-_\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1));
    final name = words.join(' ');
    return name.isEmpty ? null : name;
  }
}
