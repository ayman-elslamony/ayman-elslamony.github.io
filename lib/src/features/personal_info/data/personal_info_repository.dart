import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_info_repository.g.dart';

@riverpod
PersonalInfoRepository personalInfoRepository(Ref ref) {
  return PersonalInfoRepository(ref);
}

class PersonalInfoRepository {
  PersonalInfoRepository(this._ref);

  final Ref _ref;

  List<Resume> getResumes() {
    final locale = _ref.watch(localeControllerProvider).locale;
    final jsonResumes = trList(locale, LocaleKeys.resumes);
    final resumes = jsonResumes.map((jsonResume) {
      return Resume.fromJson(jsonResume);
    }).toList();
    return resumes;
  }

  List<Contact> getContacts() {
    final locale = _ref.watch(localeControllerProvider).locale;
    final jsonContacts = trList(locale, LocaleKeys.contacts);
    final contacts = jsonContacts.map((jsonContact) {
      return Contact.fromJson(jsonContact);
    }).toList();
    return contacts;
  }

  /// The WhatsApp contact, read from the same `contacts` list the contact bar draws, so the
  /// number and the prefilled message have one home. Null when no contact opens wa.me.
  Contact? getWhatsApp() {
    for (final contact in getContacts()) {
      final url = contact.url;
      if (url != null && Uri.tryParse(url)?.host == 'wa.me') return contact;
    }
    return null;
  }
}
