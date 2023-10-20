// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:wechat/msgmodel.dart';
//
//
// //profile screen -- to show signed in user info
// class ProfileScreen extends StatefulWidget {
//   final MessageModel user;
//
//   const ProfileScreen({super.key, required this.user});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? _image;
//
//   @override
//   Widget build(BuildContext context) {
//     var mq=MediaQuery.of(context).size;
//     return GestureDetector(
//       // for hiding keyboard
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         //app bar
//           appBar: AppBar(title: const Text('Profile Screen')),
//
//           //floating button to log out
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: FloatingActionButton.extended(
//                 backgroundColor: Colors.redAccent,
//                 onPressed: () async {
//                   //for showing progress dialog
//
//                 },
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Logout')),
//           ),
//
//           //body
//           body: Form(
//             key: _formKey,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // for adding some space
//                     SizedBox(width: mq.width, height: mq.height * .03),
//
//                     //user profile picture
//                     Stack(
//                       children: [
//                         //profile picture
//                         _image != null
//                             ?
//
//                         //local image
//                         ClipRRect(
//                             borderRadius:
//                             BorderRadius.circular(mq.height * .1),
//                             child: Image.file(File(_image!),
//                                 width: mq.height * .2,
//                                 height: mq.height * .2,
//                                 fit: BoxFit.cover))
//                             :
//
//                         //image from server
//                         ClipRRect(
//                           borderRadius:
//                           BorderRadius.circular(mq.height * .1),
//                           child: CachedNetworkImage(
//                             width: mq.height * .2,
//                             height: mq.height * .2,
//                             fit: BoxFit.cover,
//                             imageUrl: widget.user.image,
//                             errorWidget: (context, url, error) =>
//                             const CircleAvatar(
//                                 child: Icon(CupertinoIcons.person)),
//                           ),
//                         ),
//
//                         //edit image button
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: MaterialButton(
//                             elevation: 1,
//                             onPressed: () {
//                               _showBottomSheet();
//                             },
//                             shape: const CircleBorder(),
//                             color: Colors.white,
//                             child: const Icon(Icons.edit, color: Colors.blue),
//                           ),
//                         )
//                       ],
//                     ),
//
//                     // for adding some space
//                     SizedBox(height: mq.height * .03),
//
//                     // user email label
//                     Text(widget.user.email,
//                         style: const TextStyle(
//                             color: Colors.black54, fontSize: 16)),
//
//                     // for adding some space
//                     SizedBox(height: mq.height * .05),
//
//                     // name input field
//                     TextFormField(
//                       initialValue: widget.user.name,
//                    //   onSaved: (val) => APIs.me.name = val ?? '',
//                       validator: (val) => val != null && val.isNotEmpty
//                           ? null
//                           : 'Required Field',
//                       decoration: InputDecoration(
//                           prefixIcon:
//                           const Icon(Icons.person, color: Colors.blue),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           hintText: 'eg. Happy Singh',
//                           label: const Text('Name')),
//                     ),
//
//                     // for adding some space
//                     SizedBox(height: mq.height * .02),
//
//                     // about input field
//                     TextFormField(
//                       initialValue: widget.user.about,
//                    //   onSaved: (val) => Chats.me.about = val ?? '',
//                       validator: (val) => val != null && val.isNotEmpty
//                           ? null
//                           : 'Required Field',
//                       decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.info_outline,
//                               color: Colors.blue),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           hintText: 'eg. Feeling Happy',
//                           label: const Text('About')),
//                     ),
//
//                     // for adding some space
//                     SizedBox(height: mq.height * .05),
//
//                     // update profile button
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           shape: const StadiumBorder(),
//                           minimumSize: Size(mq.width * .5, mq.height * .06)),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           _formKey.currentState!.save();
//
//                         }
//                       },
//                       icon: const Icon(Icons.edit, size: 28),
//                       label:
//                       const Text('UPDATE', style: TextStyle(fontSize: 16)),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
//
//   // bottom sheet for picking a profile picture for user
//   void _showBottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         builder: (_) {
//           return ListView(
//             shrinkWrap: true,
//             padding:
//             EdgeInsets.only(top: MediaQuery.of(context).size.height * .03, bottom: MediaQuery.of(context).size.height * .05),
//             children: [
//               //pick profile picture label
//               const Text('Pick Profile Picture',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
//
//               //for adding some space
//               SizedBox(height: MediaQuery.of(context).size.height * .02),
//
//               //buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   //pick from gallery button
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: const CircleBorder(),
//                           fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
//                       onPressed: () async {
//
//
//
//                       },
//                       child: Image.asset('images/add_image.png')),
//
//                   //take picture from camera button
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: const CircleBorder(),
//                           fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
//                       onPressed: () async {
//           },
//                       child: Image.asset('images/camera.png')),
//                 ],
//               )
//             ],
//           );
//         });
//   }
// }
