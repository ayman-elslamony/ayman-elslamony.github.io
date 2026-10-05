import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_language_dialog.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumeButton extends ConsumerStatefulWidget {
  const ResumeButton({super.key, required this.resumes});

  final List<Resume> resumes;

  @override
  ConsumerState<ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends ConsumerState<ResumeButton> {
  bool _isHovered = false;
  void _hoverEffectOn() => setState(() => _isHovered = true);
  void _hoverEffectOff() => setState(() => _isHovered = false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _hoverEffectOn(),
      onExit: (_) => _hoverEffectOff(),
      child: GestureDetector(
        onLongPress: _hoverEffectOn,
        onLongPressUp: _hoverEffectOff,
        // This is the only primary action on the page, and it was an OUTLINED button in
        // the tertiary grey - the weakest treatment the theme offers, on a black page.
        // It is now filled in the accent, which is what iOS does with a primary action:
        // one solid accent-coloured control per screen, everything else quiet.
        //
        // `elevation: 16` is gone too. It painted a shadow no other surface on the page
        // has, and a shadow that dark on a black background reads as a smudge, not depth.
        child: SelectionContainer.disabled(
          child: AnimatedScale(
            scale: _isHovered ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                textStyle: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _onPressed(context, ref),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.filePdf, size: 18),
                  gapW12,
                  Text(
                    tr(LocaleKeys.resume),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    if (widget.resumes.length > 1) {
      showAdaptiveDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ResumeLanguageDialog(resumes: widget.resumes),
      );
    } else if (widget.resumes.length == 1) {
      final resumeFirstUrl = widget.resumes.first.url;
      if (resumeFirstUrl == null) {
        ScaffoldMessengerHelper.showLaunchUrlError(context);
      } else {
        try {
          await LaunchUrlHelper.launchURL(resumeFirstUrl);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessengerHelper.showLaunchUrlError(
              context,
              url: resumeFirstUrl,
            );
          }
        }
      }
    } else {
      ScaffoldMessengerHelper.showLaunchUrlError(context);
    }
  }
}
