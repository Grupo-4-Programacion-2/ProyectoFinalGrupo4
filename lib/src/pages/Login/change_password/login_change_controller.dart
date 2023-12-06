import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/user_provider.dart';

class LoginChangeController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();


  void changePassword() async {
    String email  = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword  = confirmPasswordController.text.trim();

    if (isValidForm(email, password, confirmPassword)) {
      await usersProvider.updatePassword(email,password);
      Get.snackbar('INFORMACION', 'Inicia Sesion');
      emailController.text = "";
      passwordController.text = "";
      confirmPasswordController.text = "";
      goToLoginPage();
    }
  }

  bool isValidForm(String email, String password, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Correo Electronico Requerido');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('INFORMACION', 'El Correo Electronico no es valido');
      return false;
    }

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
