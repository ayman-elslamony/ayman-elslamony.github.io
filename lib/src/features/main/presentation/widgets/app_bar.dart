import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/data/language_repository.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar_button.dart';
import 'package:portfolio/src/features/main/presentation/widgets/dark_mode_switch.dart';
import 'package:portfolio/src/features/main/presentation/widgets/locale_button.dart';
import 'package:portfolio/src/features/main/provider/section_key_provider.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class MyAppBar extends ConsumerWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MySelectionArea(
      child: AppBar(
        // Flat, on the page's own surface, separated by a hairline instead of a shadow.
        // The elevation 5 / scrolledUnderElevation 10 pair drew a raised slab in a tint
        // that belonged to neither the page nor the cards.
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        // The hairline is the app bar's own SHAPE, not a `bottom:` widget. `bottom:` makes
        // AppBar lay its toolbar out inside a Column with an Expanded, which needs a
        // bounded height - and MyAppBar sits in an unbounded Column on desktop
        // (main_section_desktop.dart) and in a fixed-extent SliverPersistentHeader on
        // tablet (sliver_app_bar.dart). A border in the shape adds no height at all, so
        // both hosts keep working and the sliver's extent stays kToolbarHeight.
        shape: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _scrollToTop(context, ref),
            child: SizedBox(
              height: kToolbarHeight,
              child: SelectionContainer.disabled(
                child: AnimatedFadeSlide(
                  offset: const Offset(-64, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.laptopCode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(tr(LocaleKeys.portfolio)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          if (Responsive.isDesktop(context))
            AnimatedFadeSlide(
              offset: const Offset(64, 0),
              child: Row(
                children: [
                  AppBarButton(
                    title: tr(LocaleKeys.aboutSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(ref.watch(aboutSectionKeyProvider));
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.experienceSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(
                        ref.watch(experienceSectionKeyProvider),
                      );
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.projectsSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(ref.watch(projectSectionKeyProvider));
                    },
                  ),
                  _buildLocaleButton(context, ref),
                  gapW8,
                  const DarkModeSwitch(),
                  gapW8,
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _scrollToTop(BuildContext context, WidgetRef ref) {
    if (Responsive.isDesktop(context)) {
      _onAppBarButtonTap(ref.watch(aboutSectionKeyProvider));
    } else {
      _onAppBarButtonTap(ref.watch(homeSectionKeyProvider));
    }
  }

  void _onAppBarButtonTap(GlobalKey sectionKey) {
    final sectionKeyCurrentContext = sectionKey.currentContext;
    if (sectionKeyCurrentContext != null) {
      Scrollable.ensureVisible(
        sectionKeyCurrentContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }

  Widget _buildLocaleButton(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(languageRepositoryProvider).getLanguages();
    if (languages.length > 1) return const LocaleButton();
    return const SizedBox.shrink();
  }
}
