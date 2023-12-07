import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../environment/environment.dart';
import '../models/responde_api.dart';
import '../models/user.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';


class RememberProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';
  String url2 = '${Environment.API_URL}api/records';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<Stream> registerRemember(Remembers remembers, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/records/create');
    print('URL ---> $uri');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['remembers'] = json.encode(remembers);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<List<Remembers>> getRemembersData(String userId, String status) async {
    print('$url/getAll/$userId/$status');
    Response response = await get(
        '$url/getAll/$userId/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Remembers> remembers = Remembers.fromJsonList(response.body);

    return remembers;
  }

  Future<void> deleteTask(String? rememberId) async {
    print('$url2/delete/$rememberId');
    Response response = await delete(
      '$url2/delete/$rememberId',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion denegada',
        'Tu usuario no tiene permitido realizar esta operación',
      );
    } else if (response.statusCode == 200) {
      Get.snackbar('INFORMACION', 'El recordatorio se eliminó correctamente');
    } else {
      Get.snackbar(
        'Error',
        'Hubo un error al intentar eliminar el recordatorio',
      );
    }
  }

  Future<ResponseApi> update(Remembers remembers) async {
    Response response = await put(
        '$url2/updateWithoutImage',
        remembers.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    print('$url2/updateWithoutImage');
    print(response.body);

    if(response.body == null){
      Get.snackbar("ERROR", "No se pudo actualizar la informacion");
      return ResponseApi();
    }

    if(response.statusCode == 401){
      Get.snackbar("ERROR", "No Esta Autorizado Para Realizar Esta Peticion");
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Stream> updateWithImage(Remembers remembers, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/records/update');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization']= userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields['remembers'] = json.encode(remembers);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }


}