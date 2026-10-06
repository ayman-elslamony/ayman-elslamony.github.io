import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/skills/domain/skill_group.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';

final skillRepositoryProvider =
    Provider<SkillRepository>((ref) => SkillRepository(ref));

class SkillRepository {
  SkillRepository(this._ref);

  final Ref _ref;

  List<SkillGroup> getSkillGroups() {
    final locale = _ref.watch(localeControllerProvider).locale;
    return trList(locale, LocaleKeys.skills).map(SkillGroup.fromJson).toList();
  }
}
