import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/audio_controller.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/player_controller.dart';

class AudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioController());
    Get.lazyPut(() => PlayerController());
  }
}
