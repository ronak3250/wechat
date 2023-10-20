import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wechat/main.dart';
import 'package:wechat/screens/chathomescreen.dart';

class FirebaseApi{
  final _fireabaseMessaging=FirebaseMessaging.instance;
  Future<void> initNotfications() async{
    await _fireabaseMessaging.requestPermission();
    final fCMToken=await _fireabaseMessaging.getToken();
  print('token:$fCMToken');
    initPushNotification();
  }

  void handleMessage(RemoteMessage? message)
  {
  if(message==null) return;
  navigatorkey.currentState?.push(MaterialPageRoute(builder: (context) => ChatHomeScreen(message),));


  }
  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
  
  FirebaseMessaging.instance.getInitialMessage().then((handleMessage) );

 FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
Future<void> handleBackgroundMessage(RemoteMessage message)async{
  print('Title:${message.notification?.title}');
  print('Body:${message.notification?.body}');

  print('Payload:${message.data}');

}