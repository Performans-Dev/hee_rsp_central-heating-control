import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/providers/db_provider.dart';
import 'package:get/get.dart';

class AppUserController extends GetxController {
  //
  @override
  void onInit() {
    super.onInit();
    _loadAppUsers();
  }

  final RxList<AppUser> _appUsers = <AppUser>[].obs;
  List<AppUser> get appUsers => _appUsers;

  Future<void> _loadAppUsers() async {
    final data = await DbProvider.db.getAppUsers();
    _appUsers.assignAll(data);
    update();
  }

  Future<void> saveAppUser(AppUser appUser) async {
    final response = await DbProvider.db.saveAppUser(appUser);
    if (response > 0) {
      _loadAppUsers();
    }
  }

  Future<void> insertUser(AppUser appUser) async {
    final response = await DbProvider.db.insertUser(appUser);
    if (response > 0) {
      _loadAppUsers();
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await DbProvider.db.deleteUser(id);
    if (response > 0) {
      _loadAppUsers();
    }
  }
}
