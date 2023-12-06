import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/user_provider.dart';

class LoginSendController extends GetxController {
  TextEditingController sendCodeController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  late String email;
  void updateCodeForgot() async {
    email = sendCodeController.text.trim();
    if (isValidForm(email)) {
      await usersProvider.updateCode(email);
      sendCodeController.text = "";
      goToVerificationCode();
    }
  }

  bool isValidForm(String code) {
    if (code.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Codigo Requerido');
      return false;
    }
    return true;
  }

  void goToVerificationCode() {
    Get.toNamed('/login/codes');
  }
}
