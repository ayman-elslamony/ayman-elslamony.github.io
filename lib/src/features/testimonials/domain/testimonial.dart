import 'package:freezed_annotation/freezed_annotation.dart';

part 'testimonial.freezed.dart';
part 'testimonial.g.dart';

/// One real recommendation, quoted as given. `en.json` → `testimonials`.
@freezed
abstract class Testimonial with _$Testimonial {
  const factory Testimonial({
    required String quote,
    required String name,
    String? role,
  }) = _Testimonial;

  factory Testimonial.fromJson(Map<String, dynamic> json) =>
      _$TestimonialFromJson(json);
}
