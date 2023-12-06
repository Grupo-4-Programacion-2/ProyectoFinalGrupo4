import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/user_provider.dart';
import '../verification/login_send_controller.dart';

class LoginChangeController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  LoginSendController loginSendController = Get.put(LoginSendController());

  void changePassword() async {
    String password = passwordController.text.trim();
    String confirmPassword  = confirmPasswordController.text.trim();

    print(loginSendController.email);

    if (isValidForm(password, confirmPassword)) {
      await usersProvider.updatePassword(loginSendController.email,password);
      Get.snackbar('INFORMACION', 'Inicia Sesion');
      emailController.text = "";
      passwordController.text = "";
      confirmPasswordController.text = "";
      goToLoginPage();
    }
  }

  bool isValidForm(String password, String confirmPassword) {
    if (password.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Contraseña Requerido');
      return false;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Confirmar Contraseña Requerido');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('INFORMACION', 'Las Contraseñas no coinciden');
      return false;
    }

    return true;
  }


  void goToLoginPage() {
    Get.offNamedUntil('/login', (route) => false);
  }
}
