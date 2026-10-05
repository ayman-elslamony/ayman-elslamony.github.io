import 'package:web/web.dart' as web;

/// Clicks a temporary `<a download>` so the browser saves the file under its
/// own name. Works for same-origin URLs only, which the resume is.
Future<void> downloadFile(String url) async {
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = Uri.parse(url).pathSegments.last;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
