import 'package:portfolio/src/utils/file_download_stub.dart'
    if (dart.library.js_interop) 'package:portfolio/src/utils/file_download_web.dart'
    as impl;
import 'package:portfolio/src/utils/launch_url_helper.dart';

/// Opens [url], saving it as a file when it points at a PDF.
///
/// The resume is served by this site (`web/cv/<file>`), so a click downloads it
/// under its own name instead of opening another tab. Any other URL is launched
/// as before.
class FileDownloadHelper {
  FileDownloadHelper._();

  static Future<void> open(String url) {
    final path = Uri.parse(url).path.toLowerCase();
    if (path.endsWith('.pdf')) return impl.downloadFile(url);
    return LaunchUrlHelper.launchURL(url);
  }
}
