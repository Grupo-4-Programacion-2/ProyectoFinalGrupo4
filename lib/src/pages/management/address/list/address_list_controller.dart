import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/address.dart';
import '../../../../models/user.dart';

class ClientAddressListController extends GetxController {

  List<Address> address = [];
  //AddressProvider addressProvider = AddressProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  var radioValue = 0.obs;

  ClientAddressListController() {
    print('LA DIRECCION DE SESION ${GetStorage().read('address')}');
  }

  Future<List<Address>> getAddress() async {
    //address = await addressProvider.findByUser(user.id ?? '');
    Address a = Address.fromJson(GetStorage().read('address') ?? {}) ; // DIRECCION SELECCIONADA POR EL USUARIO
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) { // LA DIRECCION DE SESION COINCIDE CON UN DATOS DE LA LISTA DE DIRECCIONES
      radioValue.value = index;
    }

    return address;
  }

  // void createOrder() async {
  //   Get.toNamed('/client/payments/create');
  //   // Address z = Address.fromJson(GetStorage().read('address') ?? {});
  //   //
  //   //
  //   // print(z.lat);
  //   // print(z.lng);
  //   // print(z.id);
  // }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    print('VALOR SELECCIONADO ${value}');
    GetStorage().write('address', address[value].toJson());
    update();
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }

}