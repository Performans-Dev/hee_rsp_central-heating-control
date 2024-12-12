import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
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

  factory SetupSequence.welcome() {
    return SetupSequence(
      title: 'Welcome'.tr,
      route: Routes.setupStart,
      contentIsExpanded: false,
      isCompleted: false,
    );
  }

  factory SetupSequence.thanks() {
    return SetupSequence(
      title: 'Thanks'.tr,
      route: Routes.setupFinish,
      contentIsExpanded: false,
      isCompleted: false,
    );
  }

  factory SetupSequence.language() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Language'.tr,
      route: Routes.setupLanguage,
      contentIsExpanded: false,
      isCompleted: app.preferencesDefinition.didSelectedLanguage,
    );
  }

  factory SetupSequence.timezone() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Timezone'.tr,
      route: Routes.setupTimezone,
      contentIsExpanded: false,
      isCompleted: app.preferencesDefinition.didSelectedTimezone,
    );
  }

  factory SetupSequence.dateFormat() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Date Format'.tr,
      route: Routes.setupDateTime,
      contentIsExpanded: false,
      isCompleted: app.preferencesDefinition.didSelectedDateFormat,
    );
  }

  factory SetupSequence.theme() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Theme'.tr,
      route: Routes.setupTheme,
      contentIsExpanded: true,
      isCompleted: app.preferencesDefinition.didSelectedTheme,
    );
  }

  factory SetupSequence.terms() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Terms of Use'.tr,
      route: Routes.setupTerms,
      contentIsExpanded: true,
      isCompleted: app.heethingsAccount?.termsConsentStatus == true,
    );
  }

  factory SetupSequence.privacy() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Privacy Policy'.tr,
      route: Routes.setupPrivacy,
      contentIsExpanded: true,
      isCompleted: app.heethingsAccount?.privacyConsentStatus == true,
    );
  }

  factory SetupSequence.signIn() {
    final AppController app = Get.find();
    return SetupSequence(
        title: 'Sign In'.tr,
        route: Routes.setupSignin,
        contentIsExpanded: true,
        isCompleted: app.heethingsAccount != null &&
            app.heethingsAccount!.id.isNotEmpty);
  }

  factory SetupSequence.subscriptionResult() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Subscription Status'.tr,
      route: Routes.setupSubscriptionResult,
      contentIsExpanded: true,
      isCompleted: app.heethingsAccount?.subscriptionResult != null,
    );
  }

  factory SetupSequence.techSupport() {
    final AppController app = Get.find();
    return SetupSequence(
      title: 'Tech Support'.tr,
      route: Routes.setupTechSupport,
      contentIsExpanded: false,
      isCompleted: app.hasTechSupportUser,
    );
  }

  factory SetupSequence.adminUser() {
    final AppController app = Get.find();
    return SetupSequence(
        title: 'Admin User'.tr,
        route: Routes.setupAdminUser,
        contentIsExpanded: false,
        isCompleted: app.hasAdminUser);
  }
}
