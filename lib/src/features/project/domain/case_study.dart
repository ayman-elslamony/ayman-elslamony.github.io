import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study.freezed.dart';
part 'case_study.g.dart';

/// The long story of one project, shown on its own page at `/projects/<slug>`.
@freezed
abstract class CaseStudy with _$CaseStudy {
  const factory CaseStudy({
    required String slug,
    String? problem,
    @Default(<CaseStudyPart>[]) List<CaseStudyPart> built,
    String? result,
  }) = _CaseStudy;

  factory CaseStudy.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyFromJson(json);
}

@freezed
abstract class CaseStudyPart with _$CaseStudyPart {
  const factory CaseStudyPart({String? title, String? text}) = _CaseStudyPart;

  factory CaseStudyPart.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyPartFromJson(json);
}
