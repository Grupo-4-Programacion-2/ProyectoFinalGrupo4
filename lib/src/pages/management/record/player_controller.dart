import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/audio_controller.dart';

import '../lists/details/detail_remember_controller.dart';

class PlayerController extends GetxController {
  final AudioController audioController = Get.put(AudioController());
  final player = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxBool isPaused = false.obs;
  late RememberDetailController rememberDetailController = Get.put(RememberDetailController());

  Future<void> play() async {
    final status = await Permission.storage.request();
    print(rememberDetailController.remembers.notaVoz);
    print(rememberDetailController.remembers.id);
    try {
      if (status != PermissionStatus.granted) {

        throw RecordingPermissionException('Storage Permission Denied');
      }
      try {
        isPlaying.value = true;
        await player.play(
          DeviceFileSource(rememberDetailController.remembers.notaVoz!),
        );
        // await player
        //     .play(DeviceFileSource(Get.find<AudioController>().pathToAudio));
      } catch (e) {
        print('Error playing player: $e');
      }
    } on RecordingPermissionException catch (e) {
      print('Storage permission exception: $e');
    }
  }

  Future<void> pause() async {
    try {
      if (isPlaying.value) {
        await player.pause();
        isPaused.value = true;
        print('paused');
      }
    } catch (e) {
      throw Exception('Error Pausing player $e');
    }
  }

  Future<void> stop() async {
    try {
      if (isPlaying.value) {
        await player.stop();
        isPlaying.value = false;
        print('stopped');
      }
    } catch (e) {
      throw Exception('error stopping player $e');
    }
  }

  Future<void> resume() async {
    try {
      if (isPaused.value) {
        await player.resume();
        isPaused.value = false;
        print('resumed');
      }
    } catch (e) {
      throw Exception('error resuming player $e');
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
