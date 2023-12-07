import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/audio_controller.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';

import '../../../models/responde_api.dart';
import '../../../models/user.dart';
import '../../../providers/remember_provider.dart';
import '../address/map/create_map_page.dart';

class CreateController extends GetxController {
  TextEditingController birthdateController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  RememberProvider rememberProvider = RememberProvider();
  AudioController audioController = Get.put(AudioController());

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  ImagePicker picker = ImagePicker();
  File? imageFile;
  double latRefPoint = 0.000000;
  double lngRefPoint = 0.000000;

  void openGoogleMaps(BuildContext context) async {
    Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientAddressMapPage(),
        isDismissible: false,
        enableDrag: false);

    print('REF POINT MAP ${refPointMap}');
    refPointController.text = refPointMap['address'];
    latRefPoint = refPointMap['lat'];
    lngRefPoint = refPointMap['lng'];
    print('LATITUDE $latRefPoint');
    print('LONGITUDE $lngRefPoint');
  }

  void registerRemember(BuildContext context) async {
    String fecha = birthdateController.text;
    String descripcion = descripcionController.text.trim();
    String hora = timeController.text.trim();

    if (isValidForm(fecha, descripcion)) {
      //This "if" is for register data

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "REDIRECCIONANDO...");

      Remembers remembers = Remembers(
          fechaCita: fecha,
          horaCita: hora,
          userId: userSession.id,
          notaTexto: descripcion,
          notaVoz: audioController.pathToAudio,
          latitud: latRefPoint,
          longitud: lngRefPoint);
      //
      if (kDebugMode) {
        print('id = ${remembers.userId}');
        print('Description = ${remembers.notaTexto}');
        print('Nota Voz = ${remembers.notaVoz}');
        print('Date = ${remembers.fechaCita}');
        print('Hora = ${remembers.horaCita}');
        print('lat = ${remembers.latitud}');
        print('lgn = ${remembers.longitud}');
      }

      Stream stream =
          await rememberProvider.registerRemember(remembers, imageFile!);
      stream.listen((res) {
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          print(responseApi.data); // DATOS DEL USUARIO EN SESION
          Get.snackbar('Registro Exitoso', responseApi.message ?? '');
          clear();
        } else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }
      });
    }
  }

  bool isValidForm(String fecha, String descripcion) {
    if (descripcion.isEmpty) {
      Get.snackbar('INFORMACION', 'CAMPO DESCRIPCION REQURIDO');
      return false;
    }

    if (descripcion.isEmpty) {
      Get.snackbar('INFORMACION', 'CAMPO DESCRIPCION REQURIDO');
      return false;
    }

    if (fecha.isEmpty) {
      Get.snackbar('INFORMACION', 'CAMPO FECHA REQURIDO');
      return false;
    }

    if (imageFile == null) {
      //validation image
      Get.snackbar('INFORMACION', 'CAMPO IMAGEN REQUERIDO');
      return false;
    }

    return true;
  }

  void setDate(DateTime date) {
    selectedDate = date;
    birthdateController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  void setTime(TimeOfDay time, BuildContext context) {
    selectedTime = time;
    timeController.text = time
        .format(context); // Puedes ajustar el formato según tus preferencias
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
          style: TextStyle(color: Colors.white),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: Text(
          'IR A CAMARA',
          style: TextStyle(color: Colors.white),
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

  void clear() {
    refPointController.text = '';
    descripcionController.text = "";
    birthdateController.text = "";
    timeController.text = "";
    imageFile = File('assets/img/foto.png');
    update();
  }
}
