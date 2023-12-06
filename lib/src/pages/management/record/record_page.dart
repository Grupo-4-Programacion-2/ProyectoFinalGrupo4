import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/audio_controller.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/player_controller.dart';

class RecordPage extends StatelessWidget {
  final PlayerController playerController = Get.find();
  RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grabador de nota de voz'),
      ),
      body: GetBuilder<AudioController>(
        builder: (controller) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      backgroundColor:
                      controller.isRecording ? Colors.red : Colors.white,
                      foregroundColor:
                      controller.isRecording ? Colors.white : Colors.black,
                    ),
                    onPressed: () async => await controller.toggleRecording(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(controller.isRecording ? Icons.stop : Icons.mic),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(controller.isRecording ? 'STOP' : 'START')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // controller.isEnable ?
                  Obx(
                        () {
                      return Center(
                        child: Row(
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
                        ),
                      );
                    },
                  )
                  // : Container()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// //import 'package:pm2_pf_grupo_4/src/pages/management/record/record_controller.dart';
//
// class RecordPage extends StatelessWidget {
//
//   //RecordController controller = Get.put(RecordController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
//         children: [
//           _backgroundCover(context),
//           _boxForm(context),
//           _textNewCategory(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _backgroundCover(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.35,
//       color: Colors.deepPurpleAccent,
//     );
//   }
//
//   Widget _boxForm(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.45,
//       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.29, left: 50, right: 50),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//                 color: Colors.black54,
//                 blurRadius: 15,
//                 offset: Offset(0, 0.75)
//             )
//           ]
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             _textYourInfo(),
//             _buttonGrabar(context),
//             _buttonDetener(context)
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _textFieldDescription() {
//   //   return Form(
//   //     //key: controller.defendingFormPage5Key,
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: <Widget>[
//   //         TextFormField(
//   //           keyboardType: TextInputType.multiline,
//   //           //controller: controller.storyController,
//   //           //validator: controller.validatorStory,
//   //           maxLines: 12,
//   //           decoration: const InputDecoration(
//   //             filled: true,
//   //             fillColor: Color.fromRGBO(255, 255, 255, 1),
//   //             border: OutlineInputBorder(),
//   //             labelText: '1. Breve relato de los sucesos',
//   //           ),
//   //         ),
//   //         const SizedBox(height: 50),
//   //         const Text(
//   //           'Grabar audio relato de los sucesos',
//   //           textAlign: TextAlign.start,
//   //           style: TextStyle(fontSize: 16),
//   //         ),
//   //         const SizedBox(height: 50),
//   //         //RecordingAudioWidget(),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buttonGrabar(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
//       child: ElevatedButton(
//           onPressed: ()  {
//             //controller.recording();
//           },
//           style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 15)
//           ),
//           child: Text(
//             'GRABAR AUDIO',
//             style: TextStyle(
//                 color: Colors.white
//             ),
//           )
//       ),
//     );
//   }
//
//   Widget _buttonDetener(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
//       child: ElevatedButton(
//           onPressed: ()  {
//             //controller.recording();
//           },
//           style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 15)
//           ),
//           child: Text(
//             'DETENER GRABACION',
//             style: TextStyle(
//                 color: Colors.white
//             ),
//           )
//       ),
//     );
//   }
//
//   Widget _textNewCategory(BuildContext context) {
//     return SafeArea(
//       child: Container(
//           margin: EdgeInsets.only(top: 15),
//           alignment: Alignment.topCenter,
//           child: Column(
//             children: [
//               Icon(Icons.multitrack_audio_outlined, size: 120, color: Colors.white,),
//               Text(
//                 'NUEVO AUDIO',
//                 style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//             ],
//           )
//       ),
//     );
//   }
//
//   Widget _textYourInfo() {
//     return Container(
//       margin: EdgeInsets.only(top: 40, bottom: 30),
//       child: Text(
//         'CREAR GRABACION DE AUDIO',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
// }
