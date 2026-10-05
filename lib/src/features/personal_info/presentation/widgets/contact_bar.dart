import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/utils/icon_helper.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class ContactBar extends ConsumerWidget {
  const ContactBar({super.key, required this.contacts});

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    // The contacts used to be bare IconButtons - four glyphs floating on the page with
    // nothing holding them. They are the only call to action in the left column, so each
    // one now sits in its own outlined circle, in the accent colour, with real spacing.
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: contacts.map((contact) {
        final iconData = _getIconData(contact);
        final contactTooltip = contact.tooltip;
        final contactUrl = contact.url;
        if (contactTooltip == null || contactUrl == null) {
          return const SizedBox.shrink();
        }
        return IconButton(
          tooltip: contact.tooltip,
          iconSize: 20,
          style: IconButton.styleFrom(
            foregroundColor: colors.primary,
            backgroundColor: colors.primary.withValues(alpha: 0.08),
            side: BorderSide(color: colors.primary.withValues(alpha: 0.35)),
            // StadiumBorder, not CircleBorder: a contact with no icon code point falls
            // back below to an icon + its tooltip TEXT, and a circle around a wide row
            // stretches into an ellipse. A stadium is identical to a circle when the
            // content is square, and a pill when it is not - correct for both branches.
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () async {
            try {
              await LaunchUrlHelper.launchURL(contactUrl);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessengerHelper.showLaunchUrlError(
                  context,
                  url: contactUrl,
                );
              }
            }
          },
          icon: iconData != null
              ? Icon(iconData)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link),
                    const SizedBox(width: 4),
                    Text(contactTooltip),
                  ],
                ),
        );
      }).toList(),
    );
  }

  IconData? _getIconData(Contact contact) {
    final contactIconCodePoint = contact.iconCodePoint;
    final contactIconFontFamily = contact.iconFontFamily;
    final contactIconFontPackage = contact.iconFontPackage;
    if (contactIconCodePoint != null &&
        contactIconFontFamily != null &&
        contactIconFontPackage != null) {
      var contactIconCodePointHexa = int.tryParse(contactIconCodePoint);
      if (contactIconCodePointHexa != null) {
        var iconData = IconHelper.createIconData(
          contactIconCodePointHexa,
          contactIconFontFamily,
          contactIconFontPackage,
        );
        return iconData;
      }
    }
    return null;
  }
}
