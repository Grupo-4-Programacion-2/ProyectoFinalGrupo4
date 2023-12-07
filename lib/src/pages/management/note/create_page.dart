import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/note/create_controller.dart';

import '../address/create/create_address_page.dart';
import '../record/audio_controller.dart';
import '../record/player_controller.dart';


class CreatePage extends StatelessWidget {

  CreateController controller = Get.put(CreateController());
  final PlayerController playerController = Get.put(PlayerController());

  DateTime? selectedDate;
  TimeOfDay? selectedTime;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      controller.setDate(picked); // Ajusta esta función según tus necesidades
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      controller.setTime(picked, context); // Ajusta esta función según tus necesidades
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageUser(context)
        ],
      ),
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
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.24, left: 50, right: 50),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75),
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldBirthdate(context),
            _textFieldTime(context),
            _textFieldRefPoint(context),
            // _textFieldLat(),
            // _textFieldLgn(),
            _textFieldDescription(),
            _audio(),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }


  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: TextField(
        controller: controller.descripcionController,
        keyboardType: TextInputType.text,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: 'DESCRIPCION',
            prefixIcon: Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Icon(Icons.description))
        ),
      ),
    );
  }

  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        onTap: () => controller.openGoogleMaps(context),
        controller: controller.refPointController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Ubicacion', prefixIcon: Icon(Icons.map)),
      ),
    );
  }

  Widget _textFieldTime(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        style: TextStyle(
          color: Colors.black
        ),
        controller: controller.timeController,
        readOnly: true,
        onTap: () => _selectTime(context),
        decoration: InputDecoration(
          hintText: 'Hora',
          prefixIcon: Icon(Icons.access_time)
        ),
      ),
    );
  }

  Widget _textFieldBirthdate(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: controller.birthdateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          hintText: 'Fecha',
          prefixIcon: Icon(Icons.calendar_today),
        ),
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
            child: GetBuilder<CreateController> (
              builder: (value) => CircleAvatar(
                backgroundImage: controller.imageFile != null
                    ? FileImage(controller.imageFile!)
                    : AssetImage('assets/img/user_profile.png') as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white,
              ),
            )
        ),
      ),
    );
  }


  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      child: ElevatedButton(
          onPressed: ()  {
            controller.registerRemember(context);
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR NOTA',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 30),
      child: Text(
        'CREAR NOTA DE TEXTO',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _audio() {
    return GetBuilder<AudioController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<RecordingDisposition>(
                stream: controller.audioRecorder,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');

                  final minutes = twoDigits(duration.inMinutes);
                  final seconds =
                  twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$minutes:$seconds',
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor:
                  controller.isRecording ? Colors.red : Colors.white12,
                  foregroundColor:
                  controller.isRecording ? Colors.white : Colors.black,
                ),
                onPressed: () async => await controller.toggleRecording(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(controller.isRecording ? Icons.stop : Icons.mic,
                    color: Colors.black,),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(controller.isRecording ? 'STOP' : 'START',
                    style: TextStyle(
                      color: Colors.black
                    ),)
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // controller.isEnable ?
              // Obx(
              //       () {
              //     return Center(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           playerController.isPlaying.value
              //               ? TextButton(
              //             onPressed: () => playerController.stop(),
              //             child: const Text(
              //               'Stop',
              //               style: TextStyle(color: Colors.red),
              //             ),
              //           )
              //               : TextButton(
              //             onPressed: () => playerController.play(),
              //             child: const Text('Play'),
              //           ),
              //           !playerController.isPaused.value
              //               ? IconButton(
              //             onPressed: () => playerController.pause(),
              //             icon: const Icon(
              //               Icons.pause_circle,
              //               size: 40,
              //             ),
              //           )
              //               : Container(),
              //           playerController.isPaused.value
              //               ? IconButton(
              //             onPressed: () => playerController.resume(),
              //             icon: const Icon(
              //               Icons.play_circle,
              //               size: 40,
              //             ),
              //           )
              //               : Container(),
              //         ],
              //       ),
              //     );
              //   },
              // )
              //  : Container()
            ],
          ),
        );
      },
    );
  }

}
