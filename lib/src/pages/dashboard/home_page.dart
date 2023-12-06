import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/profile/info_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/note/create_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/record_page.dart';

import '../../providers/push_notifications_provider.dart';
import '../../utils/custom_animated_bottom_bar.dart';
import '../../utils/firebase_config.dart';
import '../management/lists/list_page.dart';
import 'home_controller.dart';

PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  print('Recibiendo notificaciones ${message.messageId}');
  pushNotificationsProvider.showNotification(message);
}

class HomePage extends StatelessWidget {

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: controller.indexTab.value,
          children: [
            RemembersListPage(),
            CreatePage(),
            //RecordPage(),
            InfoPage()
          ],
        ))
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.deepPurple,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: controller.indexTab.value,
      onItemSelected: (index) => controller.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: const Icon(Icons.list),
            title: const Text('Recordatorios'),
            activeColor: Colors.white,
            inactiveColor: Colors.white
        ),
        BottomNavyBarItem (
            icon: const Icon(Icons.note),
            title: const Text('Notas'),
            activeColor: Colors.white,
            inactiveColor: Colors.white
        ),
        // BottomNavyBarItem(
        //     icon: const Icon(Icons.multitrack_audio),
        //     title: const Text('Audio'),
        //     activeColor: Colors.white,
        //     inactiveColor: Colors.white
        // ),
        BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.white
        ),
      ],
    ));
  }
}
