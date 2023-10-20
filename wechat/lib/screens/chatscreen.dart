import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chathomescreen.dart';

class ChatScreen extends StatefulWidget {
  final doc;
  final docid;

  ChatScreen({Key? key, this.docid,this.doc}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textcontroller = TextEditingController();
  var docid=ChatHomeScreen.auth.currentUser!.uid;

  String _orderby = 'defaultsort'; //? here you put what your sorting field name is
  bool _isdescending = true; //
  @override
  Widget build(BuildContext context) {
    List<String> doc1 = widget.docid.toString().split('-');
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.doc.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 80,
        leading: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  )),
            )
          ],
        ),
        actions: [
          Icon(
            Icons.call,
            size: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            CupertinoIcons.videocam_circle_fill,
            size: 40,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.more_vert,
            size: 30,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/logo/chat_back.jpg",
                ),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.9,
                child: StreamBuilder(
                  stream: firestore.collection('chats')
                      .doc(
                      "${widget.docid}-${ChatHomeScreen.auth.currentUser!.uid}")
                      .collection('chats ').orderBy("date", descending: false) //? put the orderby query here
                      .snapshots(),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState.toString());
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasError) {
                        return Text("error");
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        // list =
                        //     data.map((e) => MessageModel.fromJson(e.data())).toList();
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {

                              if (data[index]['uid'].toString()==ChatHomeScreen.auth.currentUser!.uid) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.5),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(5))),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.05,

                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                        child: Text(data[index]['msg'])),
                                  ),);
                              }
                              else {
                                return Align(

                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.05,

                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.5),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(5),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),


                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                        child: Text(data[index]['msg'])),
                                  ),);
                              }
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: data.length);
                      } else {
                        return Text("empty data");
                      }
                    } else {
                      return Text(snapshot.connectionState.toString());
                    }
                  },

                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Transform.translate(

        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),

        child: Container(
          // margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(5),

          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            // color: Colors.purple,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: TextField(
                      controller: textcontroller,
                      decoration: InputDecoration(

                          disabledBorder: InputBorder.none,
                          suffixIcon: IconButton(onPressed: () {},
                            icon: Icon(Icons.linked_camera_rounded),),
                          prefixIcon: IconButton(onPressed: () {},
                            icon: Icon(Icons.emoji_emotions),),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Type a Message")),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                maxRadius: MediaQuery
                    .of(context)
                    .size
                    .width * 0.07,
                child: InkWell(
                  onTap: () {

                    final userDoc = firestore.collection('chats').doc(
                        "${ChatHomeScreen.auth.currentUser!.uid}-${widget
                            .docid}").collection('chats ')
                      ..doc().set({'msg': textcontroller.text,'uid':ChatHomeScreen.auth.currentUser!.uid,'date':DateTime.now()});
                    final userDoc1 = firestore.collection('chats').doc(
                        "${widget.docid}-${ChatHomeScreen.auth.currentUser!
                            .uid}").collection('chats ')
                      ..doc().set({'msg': textcontroller.text,'uid':ChatHomeScreen.auth.currentUser!.uid,'date':DateTime.now()});


                    textcontroller.clear();
                  },
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
