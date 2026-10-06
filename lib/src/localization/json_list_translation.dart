import 'dart:ui';

import 'package:portfolio/src/localization/generated/locale_json.g.dart';

/// A list value from `en.json`, read from the generated map.
///
/// The map is `const Map<String, dynamic>`, so an empty `[]` there is a `List<dynamic>`; a
/// plain implicit downcast to `List<Map<String, dynamic>>` throws on it. `cast` does not,
/// and a missing key reads as an empty list.
List<Map<String, dynamic>> trList(Locale locale, String key) {
  final mapValue = CodegenLoader.mapLocales[locale.languageCode]?[key];
  return (mapValue as List?)?.cast<Map<String, dynamic>>().toList() ?? const [];
}

/// A plain string value from `en.json` that may be empty on purpose, such as a link that is
/// not set yet. Read from the generated map rather than with `tr()`, because `tr()` answers
/// a missing value with the key itself - which would turn "no link" into a link to the
/// text of the key. A missing key reads as ''.
String trValue(Locale locale, String key) {
  final value = CodegenLoader.mapLocales[locale.languageCode]?[key];
  return value is String ? value : '';
}
