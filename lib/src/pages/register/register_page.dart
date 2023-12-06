import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/register/register_controller.dart';

class RegisterPage extends StatelessWidget {
   RegisterPage({super.key});

  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageUser(context),
          _buttonBack()
        ],
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.40,
      color: Colors.deepPurple,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
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
            _textFieldEmail(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(context)
          ],
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return  Container (
      margin: EdgeInsets.symmetric(horizontal: 40),
      child:  TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration:  InputDecoration(
            hintText: 'Correo Electronico',
            prefixIcon: Icon(Icons.email)
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
      child:  TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombres',
            prefixIcon: Icon(Icons.person)
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
      child:  TextField(
        controller: controller.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellidos',
            prefixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
      child:  TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            prefixIcon: Icon(Icons.phone)
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
      child:  TextField(
        controller: controller.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock)
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
      child:  TextField(
        controller: controller.confirmPasswordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            prefixIcon: Icon(Icons.lock_outline)
        ),
      ),
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: ElevatedButton(
          onPressed: () => controller.register(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text(
            'REGISTRAR',
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
        child: GestureDetector(
            onTap: () => controller.showAlertDialog(context),
            child: GetBuilder<RegisterController> (
              builder: (value) => CircleAvatar(
                backgroundImage: controller.imageFile != null
                    ? FileImage(controller.imageFile!)
                    : AssetImage('assets/img/user_profile.png') as ImageProvider,
                radius: 75,
                backgroundColor: Colors.white,
              ),
            )
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30),
      child: const Text(
        'REGISTRARSE',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18
        ),
      ),
    );
  }

}