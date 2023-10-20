import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wechat/screens/chathomescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _about = TextEditingController();
  var uservalue;
  var status;
  var name;
@override

  void initState() {

  for(int i=0;i<list.length;i++)
    {
      if(list[i].id==ChatHomeScreen.auth.currentUser!.uid)
        {
          uservalue=i;
        }
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: Text("User Profile"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 3.5,
                  backgroundImage: NetworkImage(
                    ChatHomeScreen.auth.currentUser!.photoURL.toString(),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
onChanged: (value) {
  name=value;
},
                  initialValue:list[uservalue].name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      label: Text("Enter the User Name")),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter The Name";
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {

                    status=value;
                  },
                  initialValue:  list[uservalue].about,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      label: Text("Enter the Current Status")),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter The Name";
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 13,
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                    onPressed: ()async {
                       await ChatHomeScreen.userUpdate(name??list[uservalue].name,status??list[uservalue].name);
                       Get.snackbar(

                           "Update Details","It's will be Update Within Second");
                       Get.to(ChatHomeScreen());
                    },
                    child: Center(
                      child: Text("Update Profile"),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
