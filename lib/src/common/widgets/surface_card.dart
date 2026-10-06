import 'package:flutter/material.dart';

/// The one card of the site: the page's surface, a hairline border, and a light accent
/// tint on hover. Experience, project, case-study, skills and testimonial cards all use it,
/// so they cannot drift apart.
///
/// A card with no action still shows the hover: `InkWell` paints one only while it is
/// enabled, and `onHover` does not enable it - only a tap callback does. So a missing
/// [onTap] becomes an empty one, and the cursor stays a text cursor (the same thing
/// ExperienceCard has always done) so the card does not look like a link.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.mouseCursor,
    this.padding = const EdgeInsets.all(12.0),
  });

  final Widget child;
  final VoidCallback? onTap;
  final MouseCursor? mouseCursor;
  final EdgeInsetsGeometry padding;

  static const radius = 20.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        mouseCursor: mouseCursor ??
            (onTap == null ? WidgetStateMouseCursor.textable : null),
        borderRadius: BorderRadius.circular(radius),
        hoverColor: colors.primary.withValues(alpha: 0.06),
        splashColor: colors.primary.withValues(alpha: 0.10),
        highlightColor: colors.primary.withValues(alpha: 0.05),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
