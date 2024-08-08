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
import 'package:central_heating_control/app/presentation/screens/setup/sequences/theme.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequence {
  final int listOrder;
  final String title;
  final Widget className;
  final bool isCompleted;
  SetupSequence({
    required this.listOrder,
    required this.title,
    required this.className,
    required this.isCompleted,
  });

  factory SetupSequence.language() {
    return SetupSequence(
      listOrder: 1,
      title: 'Language'.tr,
      className: const SetupSequenceLanguageSection(),
      isCompleted: Box.getBool(key: Keys.didLanguageSelected),
    );
  }

  factory SetupSequence.timezone() {
    return SetupSequence(
      listOrder: 2,
      title: 'Timezone'.tr,
      className: const SetupSequenceTimezoneSection(),
      isCompleted: Box.getBool(key: Keys.didTimezoneSelected),
    );
  }

  factory SetupSequence.dateFormat() {
    return SetupSequence(
      listOrder: 3,
      title: 'Date Format'.tr,
      className: const SetupSequenceDateFormatSection(),
      isCompleted: true,
    );
  }

  factory SetupSequence.theme() {
    return SetupSequence(
      listOrder: 4,
      title: 'Theme'.tr,
      className: const SetupSequenceThemeSection(),
      isCompleted: Box.getBool(key: Keys.didThemeSelected),
    );
  }

  factory SetupSequence.registerDevice() {
    return SetupSequence(
      listOrder: 5,
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
      account = Account(
        id: '',
        createdAt: '',
        email: '',
        displayName: '',
        status: 0,
        token: '',
      );
    }
    return SetupSequence(
      listOrder: 6,
      title: 'Sign In'.tr,
      className: const SetupSequenceSignInSection(),
      isCompleted: account.id.isNotEmpty,
    );
  }

  factory SetupSequence.activation() {
    return SetupSequence(
      listOrder: 7,
      title: 'Activation'.tr,
      className: const SetupSequenceActivationSection(),
      isCompleted: Box.getBool(key: Keys.didActivated),
    );
  }

  factory SetupSequence.subscriptionResult() {
    return SetupSequence(
      listOrder: 8,
      title: 'Subscription Result'.tr,
      className: const SetupSequenceSubscriptionResultSection(),
      isCompleted: Box.getBool(key: Keys.didSubscriptionResultReceived),
    );
  }

  factory SetupSequence.techSupport() {
    return SetupSequence(
      listOrder: 9,
      title: 'Tech Support'.tr,
      className: const SetupSequenceTechSupportSection(),
      isCompleted: Box.getBool(key: Keys.didTechSupportUserCreated),
    );
  }

  factory SetupSequence.adminUser() {
    return SetupSequence(
      listOrder: 10,
      title: 'Admin User'.tr,
      className: const SetupSequenceAdminUserSection(),
      isCompleted: Box.getBool(key: Keys.didAdminUserCreated),
    );
  }
}
