import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wechat/screens/api/firebase_api.dart';
import 'package:wechat/screens/auth/Otpscreen.dart';
import 'package:wechat/screens/auth/loginscreen.dart';
import 'package:wechat/screens/chathomescreen.dart';
import 'package:wechat/screens/chatscreen.dart';
import 'package:wechat/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:wechat/screens/splashscreen.dart';
import 'package:wechat/screens/theme_preference.dart';

final navigatorkey=GlobalKey<NavigatorState>();
void main() async{


  WidgetsFlutterBinding.ensureInitialized();


  _initializeFirebase();

  runApp( MyApp());
  await GetStorage.init();
}

class MyApp extends StatelessWidget {

   MyApp({super.key});
  ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      );
  ThemeData darkTheme = ThemeData.dark(useMaterial3: true);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

        title: 'We Chat',
        debugShowCheckedModeBanner: false,

        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        home: MyHomePage());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyC2GxvrPGeO4OyvdM04qeq5nYKz3MwJKG8",
    appId: "com.ronak.chatapp",
    messagingSenderId: "XXX",
    projectId: "wechat-3111c",
  ));

  await FirebaseApi().initNotfications();

  // var result = await FlutterNotificationChannel.registerNotificationChannel(
  //     description: 'For Showing Message Notification',
  //     id: 'chats',
  //     importance: NotificationImportance.IMPORTANCE_HIGH,
  //     name: 'Chats');
  // log('\nNotification Channel Result: $result');
}
