import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/change_password/login_change_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/login_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/profile/info_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/profile/update_profile/update_profile_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/verification/login_code_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/Login/verification/login_send_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/dashboard/home_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/details/detail_remember_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/list_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/maps/note_maps_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/update/remember_update_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/note/create_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/audio_binding.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/record/record_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/register/register_page.dart';
import 'package:pm2_pf_grupo_4/src/pages/register/verification/register_code_page.dart';
import 'package:pm2_pf_grupo_4/src/providers/push_notifications_provider.dart';
import 'package:pm2_pf_grupo_4/src/utils/firebase_config.dart';
import 'package:pm2_pf_grupo_4/shared_preferences/preferences.dart';



PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);

  print('Recibiendo notificaciones ${message.messageId}');
  pushNotificationsProvider.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    // TODO: implement initState
    super.initState();
    pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages:  [
        GetPage(name: '/', page: () => Preferences.isSession == true ? HomePage() : LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/register/codes', page: () => RegisterCodePage()),
        GetPage(name: '/login/recover', page: () => LoginSendPage()),
        GetPage(name: '/login/codes', page: () => LoginCodePage()),
        GetPage(name: '/login/changePassword', page: () => LoginChangePassword()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/create', page: () => CreatePage(), binding: AudioBinding()),
        GetPage(name: '/remember/list', page: () => RemembersListPage()),
        GetPage(name: '/remember/list/detail', page: () => RememberDetailPage()),
        GetPage(name: '/remember/list/map', page: () => noteMapPage()),
        GetPage(name: '/remember/list/detail/update', page: () => RememberUpdatePage()),
        GetPage(name: '/record', page: () => RecordPage(), binding: AudioBinding()), //, binding: AudioBinding()
        GetPage(name: '/login/profile/info', page: () => InfoPage()),
        GetPage(name: '/login/profile/info/update', page: () => UserProfileUpdatePage())
      ],
      theme: ThemeData(
          primaryColor: Colors.amber,
          colorScheme: const ColorScheme(
              primary: Colors.deepPurple,
              secondary: Colors.amberAccent,
              brightness: Brightness.light,
              onBackground: Colors.grey,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.grey,
              error: Colors.grey,
              onError: Colors.grey,
              onSecondary: Colors.grey,
              background: Colors.grey
          )
      ),
    );
  }

}