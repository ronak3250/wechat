import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat/screens/auth/loginscreen.dart';
import 'package:wechat/screens/chathomescreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var _formKey = GlobalKey<FormState>();
  var showSpinner = false;

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController username=TextEditingController();
  void _submit(String? username) async{
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await ChatHomeScreen.auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      if (newUser != null) {
        const snackBar = SnackBar(
          content: Text('Registration Successfullly'),
        );
        email.text = '';
        password.text = '';
        //
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChatHomeScreen(),), (route) => false);
        if ((await ChatHomeScreen.userExists(username,""))) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatHomeScreen()));
        } else {
          await ChatHomeScreen.createUser(username,"").then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatHomeScreen()));
          });
        }
// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
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
          child: Container(
padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(


              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height*.3,

                  decoration: BoxDecoration(

                      image: DecorationImage(image: AssetImage("assets/logo/chat.png"))
                  ),),

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
                                        "\nCreate an Account its free",
                                        style: TextStyle(
                                            fontSize: 16,
                                                              ))
                                  ],
                                  text: "Sign Up",
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
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                        ),
                        TextFormField(

                          controller: username,
                          decoration: InputDecoration(labelText: 'Username'),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {},
                         // obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a username';
                            }
                            return null;
                          },
                        ), SizedBox(
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
                        TextFormField(
                          decoration: InputDecoration(labelText: 'ReEntered Password'),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {},
                          obscureText: true,
                          validator: (value) {
                            if (value != password.text) {
                              return 'Password not Match';
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
                          onPressed: () => _submit( username.text),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      text: "Already have an account?",

                      children: [
                        TextSpan(
                            text: "Sign In",
                            recognizer: TapGestureRecognizer()..onTap=(){
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
                            },
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ]),
                ), SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),

              ],),
          ),
        ),

      ),
    );
  }
}
