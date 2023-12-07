import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm2_pf_grupo_4/shared_preferences/preferences.dart';

import '../../../models/user.dart';

class InfoController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;

  void signOut() {
    GetStorage().remove('user');
    Preferences.isSession = false;
    Preferences.userId = '';
    Preferences.name = '';
    Get.offNamedUntil(
        '/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

  void goToProfileUpdate() {
    Get.toNamed('/login/profile/info/update');
  }
}
