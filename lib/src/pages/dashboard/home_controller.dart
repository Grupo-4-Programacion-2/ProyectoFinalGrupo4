import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/remembers.dart';
import '../../models/user.dart';
import '../../providers/push_notifications_provider.dart';

class HomeController extends GetxController {

  var indexTab = 0.obs;

  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  Remembers remembers = Remembers.fromJson(GetStorage().read('remembers') ?? {});

  HomeController() {
    saveToken();
  }

  void saveToken() {
    if (user.id != null) {
      pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}