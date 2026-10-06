import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/testimonials/domain/testimonial.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';

final testimonialRepositoryProvider =
    Provider<TestimonialRepository>((ref) => TestimonialRepository(ref));

class TestimonialRepository {
  TestimonialRepository(this._ref);

  final Ref _ref;

  List<Testimonial> getTestimonials() {
    final locale = _ref.watch(localeControllerProvider).locale;
    return trList(locale, LocaleKeys.testimonials)
        .map(Testimonial.fromJson)
        .toList();
  }
}
