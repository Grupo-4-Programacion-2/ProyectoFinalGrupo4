import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';

import '../../../../models/responde_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/remember_provider.dart';
import '../../address/map/create_map_page.dart';
import '../../record/resources_audio/audio_controller.dart';
import '../details/detail_remember_controller.dart';

class RememberUpdateController extends GetxController {
  TextEditingController birthdateController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  Remembers remembers = Remembers.fromJson(Get.arguments['remembers']);

  RememberDetailController rememberDetailController = Get.find();

  AudioUpdateController audioUpdateController = Get.put(AudioUpdateController());

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  RememberProvider rememberProvider = RememberProvider();

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  ImagePicker picker = ImagePicker();
  File? imageFile;

  String? id;
  String notas = '';

  double latRefPoint = 0.000000;
  double lngRefPoint = 0.000000;


  RememberUpdateController() {
      imageFile = File(remembers.notaFoto!);
      print(remembers.toJson());
      DateTime fecha = DateTime.parse(remembers.fechaCita!);
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
      print('Fecha original: ${remembers.fechaCita}');
      print('Fecha formateada: $fechaFormateada');

      birthdateController.text = fechaFormateada ?? '';
      descripcionController.text = remembers.notaTexto ?? '';
      timeController.text = remembers.horaCita ?? '';
  }

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

  void goToBackForCancel() {
    update();
    Get.offNamed('/home');
    //Get.offNamedUntil('/home', (route) => false);
  }

  void registerRemember(BuildContext context) async {
    String fecha = birthdateController.text;
    String descripcion = descripcionController.text.trim();
    String hora = timeController.text.trim();

    if (isValidForm(fecha, descripcion)) {
      //This "if" is for register data

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "REDIRECCIONANDO...");

      Remembers remembers22 = Remembers(
          id: remembers.id,
          fechaCita: fecha,
          horaCita: hora,
          userId: userSession.id,
          notaTexto: descripcion,
          notaVoz: audioUpdateController.pathToAudio == '' ? remembers.notaVoz : audioUpdateController.pathToAudio,
          latitud: refPointController.text == '' ? remembers.latitud : latRefPoint,
          longitud: refPointController.text == '' ? remembers.longitud : lngRefPoint);

      if (kDebugMode) {
        print('id = ${remembers22.id}');
        print('id = ${remembers22.userId}');
        print('Description = ${remembers22.notaTexto}');
        print('Nota de Voz = ${remembers22.notaVoz}');
        print('Date = ${remembers22.fechaCita}');
        print('Hora = ${remembers22.horaCita}');
        print('lat = ${remembers22.latitud}');
        print('lgn = ${remembers22.longitud}');
      }

      if (imageFile == null) {
        ResponseApi responseApi = await rememberProvider.update(remembers22);
        print("Response Api Update: ${responseApi.data}");
        Get.snackbar('Actualizacion Exitosa', responseApi.message ?? '');
        progressDialog.close();
        if (responseApi.success == true) {
          goToBackForCancel();
        }
      } else {
        Stream stream = await rememberProvider.updateWithImage(remembers22, imageFile!);

        stream.listen((res) {
          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Actualizacion Exitosa', responseApi.message ?? '');
          print("Response Api Update: ${responseApi.data}");
          if (responseApi.success == true) {
            goToBackForCancel();
          } else {
            Get.snackbar('Actualizacion Fallida', responseApi.message ?? '');
          }
        });
      }
    }
  }

  void goToDashboard() {
    Get.toNamed("/home");
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
  }
}
