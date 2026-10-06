import 'package:flutter/widgets.dart';

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
}
