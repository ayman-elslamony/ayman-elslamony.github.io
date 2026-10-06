import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// "Book a call", beside Resume. It exists only once `bookCallUrl` in `en.json` holds a
/// link; until then it draws nothing. The click is reported by `LaunchUrlHelper`, as
/// `click_book_call` for the known scheduling hosts.
class BookCallButton extends ConsumerWidget {
  const BookCallButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(personalInfoRepositoryProvider).getBookCallUrl();
    if (url.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        textStyle:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        try {
          await LaunchUrlHelper.launchURL(url);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
          }
        }
      },
      icon: const Icon(Icons.event, size: 18),
      label: Text(tr(LocaleKeys.bookCall)),
    );
  }
}
