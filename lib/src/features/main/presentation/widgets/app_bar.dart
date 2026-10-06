import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/utils/analytics.dart';
import 'package:portfolio/src/common/data/language_repository.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/main/presentation/section_navigation.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar_button.dart';
import 'package:portfolio/src/features/main/presentation/widgets/dark_mode_switch.dart';
import 'package:portfolio/src/features/main/presentation/widgets/locale_button.dart';
import 'package:portfolio/src/features/main/presentation/widgets/whatsapp_button.dart';
import 'package:portfolio/src/features/main/provider/section_key_provider.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class MyAppBar extends ConsumerWidget {
  const MyAppBar({super.key, this.showBack = false});

  /// A back arrow before the logo, for a page above the portfolio (a case study). Back
  /// pops; on a direct visit with nothing to pop it opens the portfolio instead.
  final bool showBack;

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
        automaticallyImplyLeading: false,
        leading: showBack
            ? BackButton(
                onPressed: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.pop();
                  } else {
                    navigator.pushReplacementNamed('/');
                  }
                },
              )
            : null,
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
                      _onAppBarButtonTap(
                        context,
                        ref.watch(aboutSectionKeyProvider),
                        section: 'about',
                      );
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.experienceSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(
                        context,
                        ref.watch(experienceSectionKeyProvider),
                        section: 'experience',
                      );
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.skillsSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(
                        context,
                        ref.watch(skillsSectionKeyProvider),
                        section: 'skills',
                      );
                    },
                  ),
                  AppBarButton(
                    title: tr(LocaleKeys.projectsSectionTitle),
                    onPressed: () {
                      _onAppBarButtonTap(
                        context,
                        ref.watch(projectSectionKeyProvider),
                        section: 'projects',
                      );
                    },
                  ),
                  gapW8,
                  const WhatsAppButton(),
                  gapW8,
                  _buildLocaleButton(context, ref),
                  gapW8,
                  const DarkModeSwitch(),
                  gapW8,
                ],
              ),
            )
          else ...[
            const WhatsAppButton(),
            // A non-empty `actions` list replaces the drawer button AppBar would otherwise
            // add by itself, so it is listed here explicitly.
            const EndDrawerButton(),
          ],
        ],
      ),
    );
  }

  void _scrollToTop(BuildContext context, WidgetRef ref) {
    if (Responsive.isDesktop(context)) {
      _onAppBarButtonTap(context, ref.watch(aboutSectionKeyProvider));
    } else {
      _onAppBarButtonTap(context, ref.watch(homeSectionKeyProvider));
    }
  }

  void _onAppBarButtonTap(
    BuildContext context,
    GlobalKey sectionKey, {
    String? section,
  }) {
    if (section != null) {
      Analytics.event('nav_click', {'section': section});
    }
    goToSection(context, sectionKey);
  }

  Widget _buildLocaleButton(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(languageRepositoryProvider).getLanguages();
    if (languages.length > 1) return const LocaleButton();
    return const SizedBox.shrink();
  }
}
