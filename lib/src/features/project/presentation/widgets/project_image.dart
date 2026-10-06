import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/transparent_image.dart';
import 'package:portfolio/src/features/project/domain/project.dart';
import 'package:portfolio/src/utils/icon_helper.dart';

class ProjectImage extends ConsumerWidget {
  const ProjectImage({
    super.key,
    required this.project,
    required this.isHovered,
  });

  final Project project;
  final bool isHovered;

  /// The Hero tag shared by a project's card and its case-study page, so the image flies
  /// from one to the other. Project names are unique in `en.json`.
  static String heroTag(Project project) => 'project-image-${project.name}';

  /// Marks the framed image, so a test can follow it through the Hero flight.
  static const frameKey = ValueKey('project-image-frame');

  /// Every screenshot in `assets/images` is 1024 x 500; the frame keeps that shape, so a
  /// card of any width shows the whole image, undistorted.
  static const aspectRatio = 1024 / 500;

  /// The frame stops growing here, so it is never taller than 400 px.
  static const maxWidth = 400 * aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // It used to be a box of 520-600 px pinned to the left, which left an empty strip
    // beside it in a wide card. Now it fills the card's width, centred, up to [maxWidth].
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: _frame(context),
      ),
    );
  }

  Widget _frame(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: heroTag(project),
          child: Container(
            key: frameKey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 4,
                color: Theme.of(context).colorScheme.tertiary.withAlpha(100),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return AnimatedContainer(
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          tileMode: TileMode.decal,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            isHovered ? Colors.black12 : Colors.transparent,
                            isHovered ? Colors.black26 : Colors.transparent,
                            isHovered ? Colors.black54 : Colors.transparent,
                          ],
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate,
                      transform: isHovered
                          ? (Matrix4.identity()
                              ..translate(0.5 * width, 0.5 * width)
                              ..scale(1.2)
                              ..translate(0.5 * -width, 0.5 * -width))
                          : Matrix4.identity(),
                      child: _buildScreenshotImage(context),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: SizedBox.square(
            dimension: 32,
            child: AnimatedCrossFade(
              alignment: Alignment.center,
              firstCurve: Curves.decelerate,
              secondCurve: Curves.decelerate,
              sizeCurve: Curves.decelerate,
              crossFadeState: isHovered
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(seconds: 1),
              reverseDuration: const Duration(milliseconds: 500),
              firstChild: const SizedBox.shrink(),
              secondChild: _buildIcon(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreenshotImage(BuildContext context) {
    final screenshotPath = project.screenshotPath;
    if (screenshotPath == null) return const Icon(Icons.code);
    return FadeInImage(
      placeholder: MemoryImage(transparentImage),
      image: AssetImage(screenshotPath),
      imageErrorBuilder: (_, __, ___) => const Placeholder(),
      fit: BoxFit.fill,
      placeholderFit: BoxFit.fill,
    );
  }

  Widget _buildIcon() {
    final projectIconCodePoint = project.iconCodePoint;
    final projectIconFontFamily = project.iconFontFamily;
    final projectIconFontPackage = project.iconFontPackage;
    if (projectIconCodePoint != null &&
        projectIconFontFamily != null &&
        projectIconFontPackage != null) {
      final projectIconCodePointHexa = int.tryParse(projectIconCodePoint);
      if (projectIconCodePointHexa != null) {
        final iconData = IconHelper.createIconData(
          projectIconCodePointHexa,
          projectIconFontFamily,
          projectIconFontPackage,
        );
        return Icon(color: Colors.white, size: 32, iconData);
      }
    }
    return const SizedBox.shrink();
  }
}
