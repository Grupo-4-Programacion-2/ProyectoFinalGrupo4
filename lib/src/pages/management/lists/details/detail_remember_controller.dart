import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';
import 'package:pm2_pf_grupo_4/src/providers/remember_provider.dart';

import '../../../../models/user.dart';
import '../../../../providers/user_provider.dart';

class RememberDetailController extends GetxController {
  late Remembers remembers = Remembers.fromJson(Get.arguments['remembers']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  RememberProvider rememberProvider = RememberProvider();

  List<User> users = <User>[].obs;

  RememberDetailController() {
    print('Recordatorio: ${remembers.toJson()}');
  }

  void goToOrderMap(Remembers remembers) {
    Get.toNamed('/remember/list/map',
        arguments: {'remembers': remembers.toJson()});
  }

  void Delete() async {
    return await rememberProvider.deleteTask(remembers.id);
  }

  void ToHome() {
    Delete();
    //Get.toNamed('/home');
    Get.offNamedUntil('/home', (route) => false);
  }

  void ToBack() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void goToUpdateRemember(Remembers remembers) {
    Get.toNamed('/remember/list/detail/update',
        arguments: {'remembers': remembers.toJson()});
  }
}
