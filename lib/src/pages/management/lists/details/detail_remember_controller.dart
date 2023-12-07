import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';
import 'package:pm2_pf_grupo_4/src/providers/remember_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../models/user.dart';
import '../../../../providers/user_provider.dart';

class RememberDetailController extends GetxController {
  Remembers remembers = Remembers.fromJson(Get.arguments['remembers']);
  late User user = User.fromJson(GetStorage().read('user') ?? {});

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

  void share(){
    DateTime fecha = DateTime.parse(remembers.fechaCita!);
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
    Share.share('Nota: ${remembers.notaTexto}'
        '\nNombre: ${user.name} ${user.lastname}'
        '\nFecha: $fechaFormateada'
        '\nHora: ${remembers.horaCita}');
  }


  void Delete() async {
    return await rememberProvider.deleteTask(remembers.id);
  }

  void ToHome() {
    Delete();
    Get.offNamed('/home');
  }

  void ToBack() {
    Get.offNamed('/home');
  }

  void goToUpdateRemember(Remembers remembers) {
    Get.toNamed('/remember/list/detail/update',
        arguments: {'remembers': remembers.toJson()});
  }
}
