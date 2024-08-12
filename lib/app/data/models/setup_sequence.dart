import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:get/get.dart';

class SetupSequence {
  final String title;
  final String route;
  final bool contentIsExpanded;
  final bool isCompleted;
  SetupSequence({
    required this.title,
    required this.route,
    required this.contentIsExpanded,
    required this.isCompleted,
  });

  factory SetupSequence.language() {
    return SetupSequence(
      title: 'Language'.tr,
      // className: const SetupSequenceLanguageSection(),
      route: Routes.setupLanguage,
      contentIsExpanded: false,
      isCompleted: Box.getBool(key: Keys.didLanguageSelected),
    );
  }

  factory SetupSequence.timezone() {
    return SetupSequence(
      title: 'Timezone'.tr,
      // className: const SetupSequenceTimezoneSection(),
      route: Routes.setupTimezone,
      contentIsExpanded: false,
      isCompleted: Box.getBool(key: Keys.didTimezoneSelected),
    );
  }

  factory SetupSequence.dateFormat() {
    return SetupSequence(
      title: 'Date Format'.tr,
      // className: const SetupSequenceDateFormatSection(),
      route: Routes.setupDateTime,
      contentIsExpanded: false,
      isCompleted: Box.getBool(key: Keys.didDateFormatSelected),
    );
  }

  factory SetupSequence.theme() {
    return SetupSequence(
      title: 'Theme'.tr,
      // className: const SetupSequenceThemeSection(),
      route: Routes.setupTheme,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didThemeSelected),
    );
  }

  factory SetupSequence.terms() {
    return SetupSequence(
      title: 'Terms of Use'.tr,
      // className: const SetupSequenceTermsOfUseSection(),
      route: Routes.setupTerms,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didTermsAccepted),
    );
  }

  factory SetupSequence.privacy() {
    return SetupSequence(
      title: 'Privacy Policy'.tr,
      route: Routes.setupPrivacy,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didPrivacyAccepted),
    );
  }

  factory SetupSequence.registerDevice() {
    return SetupSequence(
      title: 'Register Device'.tr,
      // className: const SetupSequenceRegisterDeviceSection(),
      route: Routes.setupRegisterDevice,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didRegisteredDevice),
    );
  }

  factory SetupSequence.signIn() {
    late Account account;
    try {
      account = Account.fromJson(Box.getString(key: Keys.account));
    } on Exception catch (_) {
      account = Account.empty();
    }
    return SetupSequence(
      title: 'Sign In'.tr,
      // className: const SetupSequenceSignInSection(),
      route: Routes.setupSignin,
      contentIsExpanded: true,
      isCompleted: account.id.isNotEmpty,
    );
  }

  factory SetupSequence.activation() {
    return SetupSequence(
      title: 'Activation'.tr,
      // className: const SetupSequenceActivationSection(),
      route: Routes.setupActivation,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didActivated),
    );
  }

  factory SetupSequence.subscriptionResult() {
    return SetupSequence(
      title: 'Subscription Status'.tr,
      // className: const SetupSequenceSubscriptionResultSection(),
      route: Routes.setupSubscriptionResult,
      contentIsExpanded: true,
      isCompleted: Box.getBool(key: Keys.didSubscriptionResultReceived),
    );
  }

  factory SetupSequence.techSupport() {
    return SetupSequence(
      title: 'Tech Support'.tr,
      // className: const SetupSequenceTechSupportSection(),
      route: Routes.setupTechSupport,
      contentIsExpanded: false,
      isCompleted: Box.getBool(key: Keys.didTechSupportUserCreated),
    );
  }

  factory SetupSequence.adminUser() {
    return SetupSequence(
      title: 'Admin User'.tr,
      // className: const SetupSequenceAdminUserSection(),
      route: Routes.setupAdminUser,
      contentIsExpanded: false,
      isCompleted: Box.getBool(key: Keys.didAdminUserCreated),
    );
  }
}
