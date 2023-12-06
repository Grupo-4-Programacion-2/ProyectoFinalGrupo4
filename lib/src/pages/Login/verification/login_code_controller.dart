import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/user_provider.dart';

class LoginCodeController extends GetxController {
  TextEditingController codeController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void validateCode() async {
    String code = codeController.text;
    if (isValidForm(code)) {
      Response response = await usersProvider.findByCode(code);
      print(response.body);
      if (response.statusCode == 404) {
        Get.snackbar(
            'CODIGO INCORRECTO', 'Su codigo es incorrecto, digitelo bien');
      } else {
        Get.snackbar('INFORMACION', 'Listo para cambiar tu contraseña59');
        goToChangePassword();
      }
    }
  }

  bool isValidForm(String code) {
    if (code.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Codigo Requerido');
      return false;
    }
    return true;
  }

  void goToChangePassword() {
    Get.toNamed('/login/changePassword');
  }
}
