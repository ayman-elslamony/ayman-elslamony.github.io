import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_group.freezed.dart';
part 'skill_group.g.dart';

/// One group of the skills section, copied from the CV's Technical Skills.
/// `en.json` → `skills`.
@freezed
abstract class SkillGroup with _$SkillGroup {
  const factory SkillGroup({
    required String title,
    @Default(<Skill>[]) List<Skill> items,
  }) = _SkillGroup;

  factory SkillGroup.fromJson(Map<String, dynamic> json) =>
      _$SkillGroupFromJson(json);
}

/// A skill; [icon] is a simple_icons name that `IconHelper.brandIcon` resolves.
@freezed
abstract class Skill with _$Skill {
  const factory Skill({required String name, String? icon}) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}
