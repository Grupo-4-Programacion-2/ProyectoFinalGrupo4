import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'info_controller.dart';

class InfoPage extends StatelessWidget {

  InfoController controller = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(() => Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageUser(context),
          Column(
            children: [
              _buttonSignOut()
            ],
          )
        ],
      )),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.deepPurple,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.43,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.29, left: 50, right: 50),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textEmail(),
            _textPhone(),
            _buttonUpdate(context)
          ],
        ),
      ),
    );
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
          onPressed: () => controller.goToProfileUpdate(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ACTUALIZAR DATOS',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: controller.user.value.photo != null
              ? NetworkImage(controller.user.value.photo!)
              : AssetImage('assets/img/user_profile.png') as ImageProvider,
          radius: 80,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        leading: Icon(Icons.person),
        subtitle: Text('${controller.user.value.name ?? ''} ${controller.user.value.lastname ?? ''}'),
        title: Text('Nombre del Usuario'),
      ),
    );
  }

  Widget _textEmail() {
    return ListTile(
      leading: Icon(Icons.email),
      subtitle: Text(controller.user.value.email ?? ''),
      title: Text('Correo Electronico'),
    );
  }

  Widget _textPhone() {
    return ListTile(
      leading: Icon(Icons.phone),
      subtitle: Text(controller.user.value.phone ?? ''),
      title: Text('Telefono'),
    );
  }

  Widget _buttonSignOut() {
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 0, top: 20),
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => controller.signOut(),
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
    );
  }
}
