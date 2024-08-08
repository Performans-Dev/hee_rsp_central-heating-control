import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/activation.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/admin.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/date_format.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/device_register.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/language.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/signin.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/subscription.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/tech_support.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/terms.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/theme.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequence {
  final String title;
  final Widget className;
  final bool isCompleted;
  SetupSequence({
    required this.title,
    required this.className,
    required this.isCompleted,
  });

  factory SetupSequence.language() {
    return SetupSequence(
      title: 'Language'.tr,
      className: const SetupSequenceLanguageSection(),
      isCompleted: Box.getBool(key: Keys.didLanguageSelected),
    );
  }

  factory SetupSequence.timezone() {
    return SetupSequence(
      title: 'Timezone'.tr,
      className: const SetupSequenceTimezoneSection(),
      isCompleted: Box.getBool(key: Keys.didTimezoneSelected),
    );
  }

  factory SetupSequence.dateFormat() {
    return SetupSequence(
      title: 'Date Format'.tr,
      className: const SetupSequenceDateFormatSection(),
      isCompleted: Box.getBool(key: Keys.didDateFormatSelected),
    );
  }

  factory SetupSequence.theme() {
    return SetupSequence(
      title: 'Theme'.tr,
      className: const SetupSequenceThemeSection(),
      isCompleted: Box.getBool(key: Keys.didThemeSelected),
    );
  }

  factory SetupSequence.terms() {
    return SetupSequence(
      title: 'Terms of Use'.tr,
      className: const SetupSequenceTermsOfUseSection(),
      isCompleted: Box.getBool(key: Keys.didTermsAccepted),
    );
  }

  factory SetupSequence.registerDevice() {
    return SetupSequence(
      title: 'Register Device'.tr,
      className: const SetupSequenceRegisterDeviceSection(),
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
      className: const SetupSequenceSignInSection(),
      isCompleted: account.id.isNotEmpty,
    );
  }

  factory SetupSequence.activation() {
    return SetupSequence(
      title: 'Activation'.tr,
      className: const SetupSequenceActivationSection(),
      isCompleted: Box.getBool(key: Keys.didActivated),
    );
  }

  factory SetupSequence.subscriptionResult() {
    return SetupSequence(
      title: 'Subscription Result'.tr,
      className: const SetupSequenceSubscriptionResultSection(),
      isCompleted: Box.getBool(key: Keys.didSubscriptionResultReceived),
    );
  }

  factory SetupSequence.techSupport() {
    return SetupSequence(
      title: 'Tech Support'.tr,
      className: const SetupSequenceTechSupportSection(),
      isCompleted: Box.getBool(key: Keys.didTechSupportUserCreated),
    );
  }

  factory SetupSequence.adminUser() {
    return SetupSequence(
      title: 'Admin User'.tr,
      className: const SetupSequenceAdminUserSection(),
      isCompleted: Box.getBool(key: Keys.didAdminUserCreated),
    );
  }
}
