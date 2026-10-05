import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/common/widgets/link.dart';
import 'package:portfolio/src/utils/icon_helper.dart';

class WrapLinks extends ConsumerWidget {
  const WrapLinks({
    super.key,
    required this.links,
  });

  final List<Link> links;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: links.where((link) => link.url != null).map((link) {
        final iconData = _getIconData(link);
        final projectLinkUrl = link.url;
        final projectLinkDisplay = link.display;
        if (projectLinkUrl == null) return const SizedBox.shrink();
        return LinkWidget(
          url: projectLinkUrl,
          iconData: iconData,
          displayLink: projectLinkDisplay ?? projectLinkUrl,
          displayLeadingIcon: true,
        );
      }).toList(),
    );
  }

  IconData? _getIconData(Link link) {
    final iconCodePoint = link.iconCodePoint;
    final iconFontFamily = link.iconFontFamily;
    final iconFontPackage = link.iconFontPackage;
    if (iconCodePoint != null &&
        iconFontFamily != null &&
        iconFontPackage != null) {
      var contactIconCodePointHexa = int.tryParse(iconCodePoint);
      if (contactIconCodePointHexa != null) {
        var iconData = IconHelper.createIconData(
          contactIconCodePointHexa,
          iconFontFamily,
          iconFontPackage,
        );
        return iconData;
      }
    }
    return null;
  }
}
