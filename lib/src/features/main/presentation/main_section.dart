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
  @override
  Widget build(BuildContext context) {
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
