import 'package:flutter/widgets.dart';
import 'package:simple_icons/simple_icons.dart';

class IconHelper {
  static const Map<int, IconData> _usedIcons = {
    0xf08c: IconData(0xf08c, fontFamily: 'FontAwesomeBrands', fontPackage: 'font_awesome_flutter'),
    0xf09b: IconData(0xf09b, fontFamily: 'FontAwesomeBrands', fontPackage: 'font_awesome_flutter'),
    0xf0e0: IconData(0xf0e0, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter'),
    0xf095: IconData(0xf095, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter'),
    0xf232: IconData(0xf232, fontFamily: 'FontAwesomeBrands', fontPackage: 'font_awesome_flutter'),
  };

  /// Whether [codePoint] has a const [IconData] here. A code point that is not here still
  /// builds an icon, but its glyph may be missing from the shipped font.
  static bool isBundled(int codePoint) => _usedIcons.containsKey(codePoint);

  static IconData createIconData(int codePoint, String? fontFamily, String? fontPackage) {
    if (_usedIcons.containsKey(codePoint)) {
      return _usedIcons[codePoint]!;
    }
    final IconData Function(int, {String? fontFamily, String? fontPackage, bool matchTextDirection}) builder = IconData.new;
    return builder(codePoint, fontFamily: fontFamily, fontPackage: fontPackage);
  }

  /// The brand icons the skills section names in `en.json` (`skills[].items[].icon`).
  /// `test/data_test.dart` fails if `en.json` names one that is not here.
  static const Map<String, IconData> _brandIcons = {
    'android': SimpleIcons.android,
    'apple': SimpleIcons.apple,
    'appstore': SimpleIcons.appstore,
    'claude': SimpleIcons.claude,
    'cursor': SimpleIcons.cursor,
    'dart': SimpleIcons.dart,
    'fastlane': SimpleIcons.fastlane,
    'figma': SimpleIcons.figma,
    'firebase': SimpleIcons.firebase,
    'flutter': SimpleIcons.flutter,
    'githubactions': SimpleIcons.githubactions,
    'googlegemini': SimpleIcons.googlegemini,
    'googlemaps': SimpleIcons.googlemaps,
    'googleplay': SimpleIcons.googleplay,
    'python': SimpleIcons.python,
    'sqlite': SimpleIcons.sqlite,
    'swift': SimpleIcons.swift,
  };

  static bool hasBrandIcon(String name) => _brandIcons.containsKey(name);

  /// The brand icon named [name], or null for no name or an unknown one.
  static IconData? brandIcon(String? name) =>
      name == null ? null : _brandIcons[name];
}
