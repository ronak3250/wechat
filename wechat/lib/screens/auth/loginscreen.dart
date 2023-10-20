import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat/screens/auth/registrationscreen.dart';
import 'package:wechat/screens/chathomescreen.dart';

import 'Otpscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

var _formKey = GlobalKey<FormState>();
var isLoading = false;

Future<void> signup(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await _auth.signInWithCredential(authCredential);
    User? user = result.user;
    print(result.user!.email);

    if (result != null) {
      if ((await ChatHomeScreen.userExists("",""))) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatHomeScreen()));
      } else {
        await ChatHomeScreen.createUser("","").then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ChatHomeScreen()));
        });
      }
    } // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }
}

var showSpinner = false;

final _auth = FirebaseAuth.instance;
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      showSpinner = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatHomeScreen(),
            ));
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      showSpinner = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo/chat.png"))),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                  TextSpan(
                                      text:
                                          "\nwelcome back! Login with your credentials",
                                      style: TextStyle(
                                          fontSize: 16,
                                          ))
                                ],
                                    text: "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,))),
                          ),
                          //styling
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (value) {
                              //Validator
                            },
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                return 'Enter a valid email!';
                              }
                              return null;
                            },
                          ),
                          //box styling
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          //text input
                          TextFormField(
                            controller: password,
                            decoration: InputDecoration(labelText: 'Password'),
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (value) {},
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid password!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          ElevatedButton(
                            child: Text(
                              "Submit",
                            ),
                            onPressed: () => _submit(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle( fontWeight: FontWeight.w500),
                        text: "Don't have an account?",
                        children: [
                          TextSpan(
                              text: "Sign Up",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen(),
                                      ),
                                      (route) => false);
                                },
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OTPScreen(),
                                ),
                                (route) => false);
                          },
                          icon: Icon(CupertinoIcons.phone),
                          label: Text("Login with Phone ")),
                      ElevatedButton.icon(
                          onPressed: () {
                            signup(context);
                          },
                          icon: Image.asset(
                            "assets/logo/google.png",
                            height: 30,
                            width: 30,
                          ),
                          label: Text("Sign In")),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
