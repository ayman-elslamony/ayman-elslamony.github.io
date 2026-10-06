import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The site's attention motion: the pulsing "open to work" dot, the pulse on the section
/// the reader is in, the wave through the contact buttons and the About numbers, and the
/// glint on Resume and Book a call. All of it loops for as long
/// as the page is open - his request, 2026-10-06 - and all of it stops when the system's
/// reduce-motion setting is on.
abstract final class Attention {
  /// Tests turn the motion off: an endless animation never lets `pumpAndSettle` settle.
  @visibleForTesting
  static bool enabled = true;

  static bool of(BuildContext context) =>
      enabled && !MediaQuery.disableAnimationsOf(context);
}

/// Runs [controller] on repeat while [Attention.of] allows it, and holds it still otherwise.
mixin _AttentionLoop<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  Duration get period;

  late final controller = AnimationController(vsync: this, duration: period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!Attention.of(context)) {
      controller
        ..stop()
        ..value = 0;
    } else if (!controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// A ring that grows out of a [size] dot and fades, once every 1.6 s; the dot itself is
/// drawn too unless [showDot] is false (when the caller paints its own).
class PulseDot extends StatefulWidget {
  const PulseDot({
    super.key,
    required this.color,
    this.size = 8,
    this.showDot = true,
  });

  final Color color;
  final double size;
  final bool showDot;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin, _AttentionLoop {
  @override
  Duration get period => const Duration(milliseconds: 1600);

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Its own layer: without it, every frame of an endless animation repaints
          // everything up to the nearest boundary - the whole scrolling page on a phone.
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final t = Curves.easeOut.transform(controller.value);
                return Transform.scale(
                  scale: 1 + 1.8 * t,
                  child: Opacity(
                    opacity: controller.isAnimating ? 0.6 * (1 - t) : 0,
                    child: dot,
                  ),
                );
              },
            ),
          ),
          if (widget.showDot) dot,
        ],
      ),
    );
  }
}

/// [children] in a [Wrap], with a wave running through them: each one in turn lifts and
/// settles, then all rest, every 4 s.
class AttentionWave extends StatefulWidget {
  const AttentionWave({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  /// How far a child lifts, in px.
  static const lift = 6.0;

  @override
  State<AttentionWave> createState() => _AttentionWaveState();
}

class _AttentionWaveState extends State<AttentionWave>
    with SingleTickerProviderStateMixin, _AttentionLoop {
  @override
  Duration get period => const Duration(seconds: 4);

  /// Child [index]'s lift, 0..1, at cycle time [t]: a half sine 0.18 of the cycle long,
  /// each child starting 0.1 after the one before.
  static double bump(double t, int index) {
    final start = 0.1 * index;
    final local = (t - start) / 0.18;
    if (local <= 0 || local >= 1) return 0;
    return math.sin(local * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: [
            for (var i = 0; i < widget.children.length; i++)
              Transform.translate(
                offset: Offset(
                  0,
                  -AttentionWave.lift * bump(controller.value, i),
                ),
                child: widget.children[i],
              ),
          ],
        ),
      ),
    );
  }
}

/// A band of [color] that sweeps across a pill-shaped [child] once every 4 s - the glint
/// on a call-to-action button. [phase] (0..1) shifts it in the cycle, so two buttons side
/// by side shine one after the other. It never takes a tap: the band ignores pointers.
class AttentionShine extends StatefulWidget {
  const AttentionShine({
    super.key,
    required this.child,
    required this.color,
    this.phase = 0,
  });

  final Widget child;
  final Color color;
  final double phase;

  @override
  State<AttentionShine> createState() => _AttentionShineState();
}

class _AttentionShineState extends State<AttentionShine>
    with SingleTickerProviderStateMixin, _AttentionLoop {
  @override
  Duration get period => const Duration(seconds: 4);

  /// Where the band is, -1 (off the left edge) to 1 (off the right), or null while it
  /// rests: it crosses in the first 0.3 of its cycle.
  double? _sweep() {
    final t = (controller.value - widget.phase) % 1;
    if (t >= 0.3) return null;
    return -1 + 2 * Curves.easeInOut.transform(t / 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final x = controller.isAnimating ? _sweep() : null;
                    if (x == null) return const SizedBox.expand();
                    return FractionalTranslation(
                      translation: Offset(x, 0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-1, -0.4),
                            end: const Alignment(1, 0.4),
                            colors: [
                              widget.color.withValues(alpha: 0),
                              widget.color,
                              widget.color.withValues(alpha: 0),
                            ],
                            stops: const [0.35, 0.5, 0.65],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
