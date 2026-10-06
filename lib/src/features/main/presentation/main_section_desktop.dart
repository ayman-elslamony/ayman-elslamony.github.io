import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/animated_fade_slide.dart';
import 'package:portfolio/src/common/widgets/scroll_extras.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/features/about/presentation/about_section.dart';
import 'package:portfolio/src/features/experience/presentation/experience_section.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';
import 'package:portfolio/src/features/main/presentation/widgets/welcome_banner.dart';
import 'package:portfolio/src/features/main/provider/scroll_controller.dart';
import 'package:portfolio/src/features/main/provider/section_key_provider.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_section.dart';
import 'package:portfolio/src/features/project/presentation/project_section.dart';
import 'package:portfolio/src/utils/scroll_depth.dart';
import 'package:portfolio/src/features/skills/presentation/skills_section.dart';
import 'package:portfolio/src/features/testimonials/presentation/testimonials_section.dart';

class MainDesktop extends ConsumerWidget {
  const MainDesktop({super.key});

  /// The content column: as wide as the window allows, between these two. The width is
  /// for the grids (Skills, Projects); text keeps to [readingWidth].
  static const minContentWidth = 520.0;
  static const maxContentWidth = 920.0;

  /// Body text reads best at 50-75 characters a line (Baymard); 680 px of Nunito 16 is
  /// about 70.
  static const readingWidth = 680.0;

  static const sectionGap = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return ScrollDepthReporter(
      controller: scrollController,
      page: 'home',
      child: Column(
        children: [
          const MyAppBar(),
          const WelcomeBanner(),
          ReadingProgress(controller: scrollController),
          Expanded(
            // This stack avoid pixel issue where a line is drawn between the two expanded
            child: Stack(
              children: [
                // Container(
                //   color: Theme.of(context).colorScheme.primary,
                // ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Listener(
                        onPointerSignal: (PointerSignalEvent event) {
                          if (event is PointerScrollEvent) {
                            scrollController.position.moveTo(
                              scrollController.position.pixels +
                                  event.scrollDelta.dy,
                            );
                          }
                        },
                        onPointerPanZoomUpdate: (event) {
                          scrollController.position.moveTo(
                            scrollController.position.pixels +
                                event.panDelta.dy,
                          );
                        },
                        child: MySelectionArea(
                          child: Container(
                            // 48 at the sides, not 100: with the 2:3 split, 100 would
                            // leave this column about 210 px wide at 1024.
                            padding: const EdgeInsets.fromLTRB(48, 48, 48, 100),
                            // color: Theme.of(context).colorScheme.primary,
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: AnimatedFadeSlide(
                                offset: Offset(-128, 0),
                                child: PersonalInfoSection(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: MySelectionArea(
                        // Sent after a frame whose content height changed, so a fold
                        // opening tells the section index to look again.
                        child: NotificationListener<ScrollMetricsNotification>(
                          onNotification: (_) {
                            ref.read(homeLayoutTickProvider.notifier).bump();
                            return false;
                          },
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsetsDirectional.only(
                              top: 48,
                              end: 48,
                              bottom: 88,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) => Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: constraints.maxWidth.clamp(
                                    minContentWidth,
                                    maxContentWidth,
                                  ),
                                  child: AnimatedFadeSlide(
                                    offset: const Offset(128, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _ReadingWidth(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: AboutSection(
                                              key: ref.watch(
                                                aboutSectionKeyProvider,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: sectionGap),
                                        _ReadingWidth(
                                          child: ExperienceSection(
                                            key: ref.watch(
                                              experienceSectionKeyProvider,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: sectionGap),
                                        SkillsSection(
                                          key: ref.watch(
                                            skillsSectionKeyProvider,
                                          ),
                                        ),
                                        const SizedBox(height: sectionGap),
                                        ProjectSection(
                                          key: ref.watch(
                                            projectSectionKeyProvider,
                                          ),
                                        ),
                                        _ReadingWidth(
                                          child: TestimonialsSection(
                                            key: ref.watch(
                                              testimonialsSectionKeyProvider,
                                            ),
                                            topGap: sectionGap,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: BackToTopButton(controller: scrollController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps a text block at [MainDesktop.readingWidth], left-aligned, however wide the column.
class _ReadingWidth extends StatelessWidget {
  const _ReadingWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: MainDesktop.readingWidth),
      child: child,
    ),
  );
}
