import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/developer/developer_screen.dart';

final getPages = [
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: Routes.developer,
    page: () => const DeveloperScreen(),
  ),
];
