import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Whether [controller] is attached to exactly one scroll view. For one frame while the
/// window crosses a layout breakpoint, the old layout and the new one both hold the home
/// controller, and `position` then throws - a red screen in debug, a broken frame in release.
bool hasSinglePosition(ScrollController controller) =>
    controller.positions.length == 1;

/// A 2 px bar in the accent that fills as [controller] scrolls to the end.
class ReadingProgress extends StatelessWidget {
  const ReadingProgress({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        var value = 0.0;
        if (hasSinglePosition(controller) &&
            controller.position.hasContentDimensions) {
          final max = controller.position.maxScrollExtent;
          value = max <= 0 ? 0 : (controller.offset / max).clamp(0.0, 1.0);
        }
        return LinearProgressIndicator(
          value: value,
          minHeight: 2,
          color: colors.primary,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}

/// A small button that appears once [controller] is more than one screen down, and
/// scrolls back to the top.
class BackToTopButton extends StatelessWidget {
  const BackToTopButton({super.key, required this.controller});

  final ScrollController controller;

  static bool isShown(ScrollController controller) =>
      hasSinglePosition(controller) &&
      controller.position.hasContentDimensions &&
      controller.offset > controller.position.viewportDimension;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final shown = isShown(controller);
        return IgnorePointer(
          ignoring: !shown,
          child: AnimatedOpacity(
            opacity: shown ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton.small(
              heroTag: null,
              tooltip: tr(LocaleKeys.backToTop),
              onPressed: () => controller.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
              ),
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        );
      },
    );
  }
}
