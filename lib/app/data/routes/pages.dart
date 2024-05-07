import 'package:central_heating_control/app/data/middlewares/setup.dart';
import 'package:central_heating_control/app/data/middlewares/user.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/activation/activation_screen.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

final List<GetPage> getPages = [
  GetPage(
    name: Routes.pin,
    page: () => const PinScreen(),
    middlewares: [
      SetupMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    middlewares: [
      SetupMiddleware(),
      UserMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.activation,
    page: () => ActivationScreen(),
  ),
  GetPage(
    name: Routes.splash,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.setupLanguage,
    page: () => const SetupLanguageScreen(),
  ),
  GetPage(
    name: Routes.setupTimezone,
    page: () => const SetupTimezoneScreen(),
  ),
];
