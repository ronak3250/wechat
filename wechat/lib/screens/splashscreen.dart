import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbib_splash_screen/splash_screen.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

import 'auth/loginscreen.dart';
import 'chathomescreen.dart';

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString("stringValue");
    print(stringValue);
    for (var i in list)
      if (stringValue == i.id) {

Get.to(ChatHomeScreen());
      }
    else
      {
        Get.to(LoginScreen());
      }
  }
  @override
  void initState() {

    super.initState();

    getStringValuesSF();
    Future.delayed(const Duration(seconds: 10)).then((value) => setState(() {
      isLoaded = true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateWhere: isLoaded,
      navigateRoute: const LoginScreen(), backgroundColor: Colors.white,
      linearGradient: const LinearGradient(
          colors: [
            Color(0xFF3366FF),
            Color(0xFF00CCFF),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
      text: WavyAnimatedText(
        "We Chat",
        textStyle: const TextStyle(
          color: Colors.yellow,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      imageSrc: "assets/logo/chat.png",
      //  displayLoading: false,
    );
  }
}