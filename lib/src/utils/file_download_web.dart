import 'package:portfolio/src/utils/analytics.dart';
import 'package:web/web.dart' as web;

/// Clicks a temporary `<a download>` so the browser saves the file under its
/// own name. Works for same-origin URLs only, which the resume is.
Future<void> downloadFile(String url) async {
  final name = Uri.parse(url).pathSegments.last;
  // GA4's own event name for a download, with its standard parameters.
  Analytics.event('file_download', {
    'file_name': name,
    'file_extension': name.split('.').last,
    'link_url': url,
  });
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = name;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
