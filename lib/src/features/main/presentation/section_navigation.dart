import 'package:flutter/material.dart';

/// Scrolls the portfolio to the section that [sectionKey] marks, from any page.
///
/// On the portfolio itself it scrolls, as the app bar always did. On a page pushed above
/// it - a case study - it first pops back to the portfolio, and scrolls only once the
/// back transition has finished: on a direct visit the portfolio underneath has never been
/// laid out, and measuring it mid-transition fails.
void goToSection(BuildContext context, GlobalKey sectionKey) {
  void scroll() {
    final sectionContext = sectionKey.currentContext;
    if (sectionContext == null || !sectionContext.mounted) return;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  final route = ModalRoute.of(context);
  if (route == null || route.isFirst) {
    scroll();
    return;
  }
  final sectionContext = sectionKey.currentContext;
  final home = sectionContext == null ? null : ModalRoute.of(sectionContext);
  Navigator.of(context).popUntil((r) => r.isFirst);

  // The portfolio's secondary animation runs back to "dismissed" as the page above it
  // leaves; that is the moment it is fully on screen and laid out.
  final back = home?.secondaryAnimation;
  if (back == null || back.status == AnimationStatus.dismissed) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scroll());
    return;
  }
  void onStatus(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) return;
    back.removeStatusListener(onStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) => scroll());
  }

  back.addStatusListener(onStatus);
}
