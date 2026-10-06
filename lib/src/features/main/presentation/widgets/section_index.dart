import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/attention.dart';
import 'package:portfolio/src/common/widgets/scroll_extras.dart';
import 'package:portfolio/src/features/main/presentation/section_navigation.dart';
import 'package:portfolio/src/features/main/provider/scroll_controller.dart';
import 'package:portfolio/src/features/main/provider/section_key_provider.dart';
import 'package:portfolio/src/features/testimonials/data/testimonial_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';

/// The in-page index in the desktop left column: one entry per section, the one on screen
/// highlighted. The app bar keeps its own section buttons - the bar is the site's global
/// navigation, this is the home page's table of contents, and it sits outside the content.
class SectionIndex extends ConsumerStatefulWidget {
  const SectionIndex({super.key});

  /// Below this window height the left column has no room for the index.
  static const minWindowHeight = 760.0;

  @override
  ConsumerState<SectionIndex> createState() => _SectionIndexState();
}

class _Entry {
  const _Entry(this.label, this.key, this.section);

  final String label;
  final GlobalKey key;
  final String section;
}

class _SectionIndexState extends ConsumerState<SectionIndex> {
  late final ScrollController _controller;
  int _active = 0;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(scrollControllerProvider)..addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    super.dispose();
  }

  List<_Entry> _entries() => [
    _Entry(
      tr(LocaleKeys.aboutSectionTitle),
      ref.read(aboutSectionKeyProvider),
      'about',
    ),
    _Entry(
      tr(LocaleKeys.experienceSectionTitle),
      ref.read(experienceSectionKeyProvider),
      'experience',
    ),
    _Entry(
      tr(LocaleKeys.skillsSectionTitle),
      ref.read(skillsSectionKeyProvider),
      'skills',
    ),
    _Entry(
      tr(LocaleKeys.projectsSectionTitle),
      ref.read(projectSectionKeyProvider),
      'projects',
    ),
    if (ref.read(testimonialRepositoryProvider).getTestimonials().isNotEmpty)
      _Entry(
        tr(LocaleKeys.testimonialsSectionTitle),
        ref.read(testimonialsSectionKeyProvider),
        'testimonials',
      ),
  ];

  /// The active section is the last one whose top has passed a line one third down the
  /// viewport.
  void _update() {
    if (!mounted || !hasSinglePosition(_controller)) return;
    final position = _controller.position;
    if (!position.hasViewportDimension) return;
    final line = position.pixels + position.viewportDimension / 3;
    final entries = _entries();
    var active = 0;
    var lastOnPage = 0;
    for (var i = 0; i < entries.length; i++) {
      final box = entries[i].key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      lastOnPage = i;
      final top = RenderAbstractViewport.of(
        box,
      ).getOffsetToReveal(box, 0).offset;
      if (top <= line) active = i;
    }
    // A last section shorter than two thirds of the window never reaches the line, so at
    // the very end of the page the last section is the one being read.
    if (position.pixels >= position.maxScrollExtent - 1) active = lastOnPage;
    if (active != _active) setState(() => _active = active);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeLayoutTickProvider, (_, _) => _update());
    final entries = _entries();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < entries.length; i++)
          _IndexEntry(
            label: entries[i].label,
            index: i,
            count: entries.length,
            active: _active,
            onTap: () {
              Analytics.event('nav_click', {'section': entries[i].section});
              goToSection(context, entries[i].key);
            },
          ),
      ],
    );
  }
}

/// One step: a dot on a vertical line, then the label. Steps up to the active one are
/// drawn in the accent, so the line reads as progress down the page.
class _IndexEntry extends StatelessWidget {
  const _IndexEntry({
    required this.label,
    required this.index,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int index;
  final int count;
  final int active;
  final VoidCallback onTap;

  static const height = 44.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final muted = theme.colorScheme.outlineVariant;
    final isActive = index == active;
    return Semantics(
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: isActive ? 1 : 0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, t, _) => CustomPaint(
                          painter: _StepPainter(
                            lineAbove: index > 0,
                            lineBelow: index < count - 1,
                            reached: index <= active,
                            passed: index < active,
                            emphasis: t,
                            accent: accent,
                            muted: muted,
                            background: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    // The step being read pulses, like the open-to-work dot.
                    if (isActive)
                      PulseDot(color: accent, size: 14, showDot: false),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isActive
                      ? accent
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepPainter extends CustomPainter {
  const _StepPainter({
    required this.lineAbove,
    required this.lineBelow,
    required this.reached,
    required this.passed,
    required this.emphasis,
    required this.accent,
    required this.muted,
    required this.background,
  });

  final bool lineAbove;
  final bool lineBelow;

  /// This step is the active one or above it.
  final bool reached;

  /// This step is above the active one, so the line below it is reached too.
  final bool passed;

  /// 0 for a plain step, 1 for the active one; animated in between.
  final double emphasis;
  final Color accent;
  final Color muted;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final line = Paint()..strokeWidth = 2;
    if (lineAbove) {
      line.color = reached ? accent : muted;
      canvas.drawLine(Offset(center.dx, 0), center, line);
    }
    if (lineBelow) {
      line.color = passed ? accent : muted;
      canvas.drawLine(center, Offset(center.dx, size.height), line);
    }
    final radius = 5 + 2 * emphasis;
    if (emphasis > 0) {
      canvas.drawCircle(
        center,
        radius + 5 * emphasis,
        Paint()..color = accent.withValues(alpha: 0.18 * emphasis),
      );
    }
    canvas.drawCircle(center, radius, Paint()..color = background);
    canvas.drawCircle(
      center,
      radius,
      reached
          ? (Paint()..color = accent)
          : (Paint()
              ..color = muted
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2),
    );
  }

  @override
  bool shouldRepaint(_StepPainter old) =>
      old.reached != reached ||
      old.passed != passed ||
      old.emphasis != emphasis ||
      old.accent != accent ||
      old.muted != muted ||
      old.background != background ||
      old.lineAbove != lineAbove ||
      old.lineBelow != lineBelow;
}
