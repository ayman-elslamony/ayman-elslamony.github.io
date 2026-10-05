import 'package:freezed_annotation/freezed_annotation.dart';

part 'link.freezed.dart';
part 'link.g.dart';

@freezed
abstract class Link with _$Link {
  const factory Link({
    String? url,
    String? display,
    String? iconCodePoint,
    String? iconFontFamily,
    String? iconFontPackage,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
