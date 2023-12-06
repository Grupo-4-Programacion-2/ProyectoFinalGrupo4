import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/profile/info_controller.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../models/responde_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/user_provider.dart';

class UserProfileUpdateController extends GetxController{

  User user = User.fromJson(GetStorage().read('user'));

  InfoController userProfileInfoController = Get.find();

  UsersProvider usersProvider = UsersProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;


  UserProfileUpdateController() {
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }


  void Update(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;

    if (isValidForm(name, lastname, phone)) {

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "Actualizando Datos...");

      User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        sessionToken: user.sessionToken,
      );


      if(imageFile == null){
        ResponseApi responseApi = await usersProvider.update(myUser);
        print("Response Api Update: ${responseApi.data}");
        Get.snackbar('Actualizacion Exitosa', responseApi.message ?? '');
        progressDialog.close();
        if(responseApi.success == true){
          GetStorage().write('user', responseApi.data);
          userProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
          goToDashboard();
        }
      }else{
        Stream stream = await usersProvider.updateWithImage(myUser, imageFile!);

        stream.listen((res) {

          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Actualizacion Exitosa', responseApi.message ?? '');
          print("Response Api Update: ${responseApi.data}");
          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            userProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
            goToDashboard();
          }
          else {
            Get.snackbar('Actualizacion Fallida', responseApi.message ?? '');
          }

        });
      }

    }
  }

  bool isValidForm(
      String name,
      String lastname,
      String phone
      ) {

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

    return true;
  }

  void goToDashboard(){
    Get.toNamed("/home");
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: const Text(
          'IR A GALERIA',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: const Text(
          'IR A CAMARA',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona una opcion'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

}