import 'package:portfolio/src/utils/launch_url_helper.dart';

/// Non-web builds have no anchor element to click; open the URL instead.
Future<void> downloadFile(String url) => LaunchUrlHelper.launchURL(url);
