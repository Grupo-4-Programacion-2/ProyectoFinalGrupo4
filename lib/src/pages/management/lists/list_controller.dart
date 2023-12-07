import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';
import 'package:pm2_pf_grupo_4/src/providers/remember_provider.dart';
import '../../../models/user.dart';

class RemembersListController extends GetxController {

  RememberProvider rememberProvider = RememberProvider();


  List<String> status = <String>['PENDIENTES', 'COMPLETADOS'].obs;

  User user = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Remembers>> getRemembers(String status) async {
    return await rememberProvider.getRemembersData(user.id ?? '0', status);
  }

  void goToOrderDetail (Remembers remembers) {
    Get.toNamed('/remember/list/detail', arguments: {
      'remembers': remembers.toJson()
    });
  }
}