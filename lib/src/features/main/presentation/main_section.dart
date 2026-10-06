import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/features/main/presentation/main_section_desktop.dart';
import 'package:portfolio/src/features/main/presentation/main_section_tablet.dart';
import 'package:portfolio/src/features/main/presentation/widgets/end_drawer.dart';
import 'package:portfolio/src/features/main/presentation/widgets/safe_area.dart';

class MainSection extends ConsumerStatefulWidget {
  const MainSection({super.key});

  @override
  ConsumerState<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends ConsumerState<MainSection> {
  /// Whether the portfolio has been on screen yet. On a direct visit to a case study it
  /// is built under that page without ever being laid out, and its selection regions
  /// then measure texts that have no size ("RenderBox was not laid out"). So until it is
  /// first shown it builds nothing; the first time its route is current, it builds as
  /// usual. A visit that starts here is shown at once, so nothing changes for it.
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    _shown = _shown || (ModalRoute.of(context)?.isCurrent ?? true);
    if (!_shown) return const Scaffold();
    return const Scaffold(
      //Theme.of(context).colorScheme.secondary,
      endDrawer: MySafeArea(
        child: EndDrawer(),
      ),
      body: MySafeArea(
        child: Stack(
          children: [
            Responsive(
              desktop: MainDesktop(),
              tablet: MainTablet(),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomBanner(),
            // )
          ],
        ),
      ),
    );
  }
}
