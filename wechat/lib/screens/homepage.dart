import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("We Chat",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(onPressed: () {

        },icon: Icon(CupertinoIcons.home)),
        actions: [
          IconButton(onPressed: () {

          },icon: Icon(CupertinoIcons.search)),
          IconButton(onPressed: () {

          },icon: Icon(Icons.more_vert))

        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {

      },


      child: Icon(CupertinoIcons.chat_bubble_fill),),
    );
  }
}
