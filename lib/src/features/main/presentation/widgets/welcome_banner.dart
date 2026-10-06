import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/campaign.dart';

/// "Hi `Company` team" for a visitor who opened a company's CV copy. Shows nothing for
/// everyone else. Closing it keeps it closed for the rest of the visit.
class WelcomeBanner extends StatefulWidget {
  const WelcomeBanner({super.key, this.company});

  /// The company to greet; defaults to the one this visit came from.
  final String? company;

  @override
  State<WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<WelcomeBanner> {
  late String? _company = widget.company ?? Campaign.company();

  @override
  Widget build(BuildContext context) {
    final company = _company;
    if (company == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      width: double.infinity,
      color: colors.primary.withValues(alpha: 0.08),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Row(
        children: [
          Icon(Icons.waving_hand_outlined, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tr(LocaleKeys.welcomeCompany, args: [company]),
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.primary),
            ),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            iconSize: 18,
            color: colors.primary,
            icon: const Icon(Icons.close),
            onPressed: () {
              Campaign.dismiss();
              setState(() => _company = null);
            },
          ),
        ],
      ),
    );
  }
}
