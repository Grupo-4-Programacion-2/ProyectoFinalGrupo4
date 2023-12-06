import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../models/responde_api.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  void register(BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (isValidForm(email, name, lastname, phone, password, confirmPassword)) {
      //This "if" is for register data
      if (kDebugMode) {
        print('Email = $email');
        print('Nombres = $name');
        print('Apellidos = $lastname');
        print('telefono = $phone');
        print('password = $password');
        print('confirmacion password = $confirmPassword');
      }

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "REDIRECCIONANDO...");

      User user = User(
        name: name,
        lastname: lastname,
        phone: phone,
        email: email,
        password: password
      );

      Stream stream = await usersProvider.createWithImage(user, imageFile!);
      stream.listen((res) {

        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);

          print(responseApi.data);// DATOS DEL USUARIO EN SESION
             //clear(); //Use for clear the fields
             goToHomePage();
        }
        else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }

      });
    }
  }

  bool isValidForm(String email, String name, String lastname, String phone,
      String password, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Correo Electronico Requerido');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('INFORMACION', 'El Correo Electronico no es valido');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Nombres Requerido');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Apellidos Requerido');
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar('INFORMACION', 'Campo Telefono Requerido');
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

    if (imageFile == null) {
      //validation image
      Get.snackbar('INFORMACION', 'Seleccione Una Imagen, Por Favor');
      return false;
    }

    return true;
  }

  void goToHomePage() {
    // Get.offNamedUntil('/login', (route) => false);
    Get.toNamed('/register/codes');
  }

  Future selectImage(ImageSource imageSource) async {
    //selected image
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    //Go gallery or take a photo
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: Text(
          'IR A GALERIA',
          style: TextStyle(color: Colors.black),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: Text(
          'IR A CAMARA',
          style: TextStyle(color: Colors.black),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void goToVerificationPage() {
    Get.toNamed('/register/codes'); //This is for verification code
  }

  void clear() {
    nameController.text = "";
    lastnameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
  }
}
