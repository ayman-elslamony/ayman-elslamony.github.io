import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/surface_card.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/testimonials/data/testimonial_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Recommendations from people he worked with. With none in `en.json` the section draws
/// nothing at all - not even its title - so it can never show an empty heading.
class TestimonialsSection extends ConsumerWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonials =
        ref.watch(testimonialRepositoryProvider).getTestimonials();
    if (testimonials.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 20),
            child: Text(
              tr(LocaleKeys.testimonialsSectionTitle),
              style: theme.textTheme.titleLarge,
            ),
          ),
          for (final t in testimonials) ...[
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote, color: theme.colorScheme.primary),
                  gapH8,
                  Text(t.quote, style: theme.textTheme.bodyMedium),
                  gapH12,
                  Text(
                    t.name,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (t.role != null && t.role!.isNotEmpty)
                    Text(t.role!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            gapH24,
          ],
        ],
      ),
    );
  }
}
