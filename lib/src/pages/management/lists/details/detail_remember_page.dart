import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/details/detail_remember_controller.dart';

import '../../../../models/remembers.dart';
import '../../../../models/user.dart';
import '../../record/player_controller.dart';

class RememberDetailPage extends StatelessWidget {

  RememberDetailController con = Get.put(RememberDetailController());

  User users = User();

  late User user = User.fromJson(GetStorage().read('user') ?? {});

  late Remembers remembers = Remembers.fromJson(Get.arguments['remembers']);
  final PlayerController playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Obx(() =>
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: "" == ""
            ? MediaQuery.of(context).size.height * 0.57
            : MediaQuery.of(context).size.height * 0.57,
        // padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            _dataDate(),
            _desRemember(),
            _nameRemember(),
            _nameAudio(),
            _PlayAudio(),
            Row( // Utilizar un Row para alinear los botones
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alinear los botones en el espacio disponible
              children: [
                _buttonGoToOrderMap(),
                _buttonGoToUpdate(),
                _buttonDelete(),
                _buttonCancel()
              ],
            ),
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text(
          'Nota ${remembers.id}',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: _cardProduct()
      );
  }


  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del recordatorio'),
        subtitle: Text('${con.remembers.fechaCita ?? ''}'),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _cardProduct() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 95, vertical: 30),
      child: Row(
        children: [
          _imageProduct()
        ],
      ),
    );
  }

  Widget _imageProduct() {
    return SizedBox(
      height: 200,
      width: 200,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: remembers.notaFoto != null
              ? NetworkImage(remembers.notaFoto!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _desRemember() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Nota de Texto'),
        subtitle: Text(remembers.notaTexto ?? ''),
        trailing: Icon(Icons.description_outlined),
      ),
    );
  }

  Widget _nameAudio() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Reproducir Audio'),
      ),
    );
  }

  Widget _PlayAudio() {
    return Obx(
          () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            playerController.isPlaying.value
                ? TextButton(
              onPressed: () => playerController.stop(),
              child: const Text(
                'Stop',
                style: TextStyle(color: Colors.red),
              ),
            )
                : TextButton(
              onPressed: () => playerController.play(),
              child: const Text('Play'),
            ),
            !playerController.isPaused.value
                ? IconButton(
              onPressed: () => playerController.pause(),
              icon: const Icon(
                Icons.pause_circle,
                size: 40,
              ),
            )
                : Container(),
            playerController.isPaused.value
                ? IconButton(
              onPressed: () => playerController.resume(),
              icon: const Icon(
                Icons.play_circle,
                size: 40,
              ),
            )
                : Container(),
          ],
        );
      },
    );
  }


  Widget _nameRemember() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Nombre'),
        subtitle: Text(user.name ?? ''),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(remembers),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.green
          ),
          child: Text(
            'MAPA',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _buttonGoToUpdate() {
    return ElevatedButton(
        onPressed: () => con.goToUpdateRemember(remembers),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(14),
            backgroundColor: Colors.blueAccent
        ),
        child: Text(
          'ACTUALIZAR',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
  }

  Widget _buttonDelete() {
    return ElevatedButton(
        onPressed: () => con.ToHome(),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(14),
            backgroundColor: Colors.redAccent
        ),
        child: Text(
          'ELIMINAR',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
  }

  Widget _buttonCancel() {
    return ElevatedButton(
        onPressed: () => con.ToBack(),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(14),
            backgroundColor: Colors.amberAccent
        ),
        child: Text(
          'REGRESAR',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
  }

}
