import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user.dart';

class InfoController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil(
        '/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

  void goToProfileUpdate() {
    Get.toNamed('/login/profile/info/update');
  }
}
