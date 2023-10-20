import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat/msgmodel.dart';
import 'package:wechat/screens/auth/loginscreen.dart';
import 'dart:math' as math;
import 'package:wechat/screens/auth/registrationscreen.dart';

import 'package:wechat/screens/chatscreen.dart';
import 'package:wechat/screens/profileScreen.dart';
import 'package:wechat/screens/theme_preference.dart';

import 'auth/profilescreen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen(RemoteMessage message, {Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();

  static Future<bool> userExists(String? username, String? status) async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future userUpdate(String? username, String? status) async {
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .update({"name": username, "about": status}));
  }

  static Future<void> createUser(String? username, String? status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', user.uid);

    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = MessageModel(
        id: user.uid,
        name: user.displayName.toString() == "null" ||
                user.displayName.toString() == user.displayName.toString()
            ? username.toString()
            : user.displayName.toString(),
        email: user.email.toString(),
        about: status.toString() == ''
            ? "Hey, I'm using We Chat!"
            : status.toString(),
        image: user.photoURL.toString(),
        createdat: time,
        isonline: false,
        lastactive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static FirebaseAuth auth = FirebaseAuth.instance;
  static MessageModel me = MessageModel(
      id: user.uid,
      name: user.displayName.toString() == 'null'
          ? "User"
          : user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdat: '',
      isonline: false,
      lastactive: '',
      pushToken: '');

// to return current user
  static User get user => ChatHomeScreen.auth.currentUser!;
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;
List<MessageModel> list = [];

clearshareprefernce() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString("stringValue");
  print(stringValue);
}

// for storing self information
class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              "assets/logo/chat.png",
              height: 30,
              width: 30,
            )),
        actions: [
          Icon(CupertinoIcons.search),
          SizedBox(
            width: 10,
          ),
          PopupMenuButton(
            offset: Offset(0, 0),

            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Text("Change Theme"),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 2,
                // row with two children
                child: Text("Profile"),
              ),
              PopupMenuItem(
                value: 3,
                // row with two children
                child: Text("Linked Devices"),
              ),
              PopupMenuItem(
                value: 4,
                // row with two children
                child: Text("Started Messages"),
              ),

              PopupMenuItem(
                value: 5,
                // row with two children
                child: Text(
                  "Payment",
                ),
              ),
              PopupMenuItem(
                value: 6,
                // row with two children
                child: Text("Log out"),
              ),
            ],

            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                ThemeService().switchTheme();
                // if value 2 show dialog
              } else if (value == 2) {
                Get.to(ProfileScreen());
              } else if (value == 3) {
                print("its 3");
              } else if (value == 4) {
                print("its 4");
              } else if (value == 5) {
                print("its 5");
              } else if (value == 6) {
                clearshareprefernce();
                getStringValuesSF();

                ChatHomeScreen.auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              }
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "We Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
            stream: firestore
                .collection("users")
                .orderBy("lastactive", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              print(snapshot.connectionState.toString());
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return Text("error");
                } else if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  list =
                      data.map((e) => MessageModel.fromJson(e.data())).toList();
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return (ChatHomeScreen.auth.currentUser?.uid !=
                                list[index].id)
                            ? InkWell(
                                onTap: () {
                                  var userDoc = list[index].id;
                                  var userdocIndex = list[index].name;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          doc: userdocIndex,
                                          docid: userDoc,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height/10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(colors: [
                                    Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.2),
                                    Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.2),
                                    Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.2),
                                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2),Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2)

                                  ])),
                                  child: ListTile(
                                    // trailing: Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(list[index].createdat),
                                    //     // Container(
                                    //     //   height: 20,
                                    //     //   width: 20,
                                    //     //   child: Center(child: Text('1')),
                                    //     //   decoration: BoxDecoration(
                                    //     //       color: Colors.green,
                                    //     //       shape: BoxShape.circle),
                                    //     // )
                                    //   ],
                                    // ),
                                    leading: list[index].image == 'null'
                                        ? CircleAvatar(
                                            child: Icon(Icons.person),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                list[index].image)),
                                    subtitle: Text(list[index].about),
                                    title: Text(list[index].name),
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: list.length);
                } else {
                  return Text("empty data");
                }
              } else {
                return Text(snapshot.connectionState.toString());
              }
            },
          )),
    );
  }
}
