import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// WhatsApp in the app bar, so it is one click away on every scroll position - the contact
/// bar sits at the bottom of the left column on desktop and at the top of the page on a
/// phone. Desktop shows the label too; narrower widths show the icon alone, beside the
/// drawer button. The number and message come from the `contacts` entry, never from here.
class WhatsAppButton extends ConsumerWidget {
  const WhatsAppButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(personalInfoRepositoryProvider).getWhatsApp();
    final url = contact?.url;
    if (url == null) return const SizedBox.shrink();

    Future<void> open() async {
      try {
        await LaunchUrlHelper.launchURL(url);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
        }
      }
    }

    const icon = FaIcon(FontAwesomeIcons.whatsapp, size: 18);
    if (Responsive.isDesktop(context)) {
      return FilledButton.tonalIcon(
        onPressed: open,
        icon: icon,
        label: Text(contact?.tooltip ?? 'WhatsApp'),
      );
    }
    return IconButton(
      tooltip: contact?.tooltip,
      onPressed: open,
      color: Theme.of(context).colorScheme.primary,
      icon: icon,
    );
  }
}
