// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:password_manager/Model/password_model.dart';
// import 'package:password_manager/AddModal.dart';
// import 'package:password_manager/Model/password_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<passwords> passwordData = [];

//   @override
//   void initState() {
//     super.initState();
//     loadPasswordData();
//   }

//   @override
//   void dispose() {
//     savePasswordData();
//     super.dispose();
//   }

// Future<void> loadPasswordData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonData = prefs.getString('passwordData');

//     if (jsonData != null) {
//       final Iterable decoded = jsonDecode(jsonData);
//       List<passwords> loadedData =
//           decoded.map((e) => passwords.fromMap(e)).toList();

//       setState(() {
//         passwordData = loadedData;
//       });
//     }
//   }

//   void savePasswordData() async {
//     // Save the 'passwordData' list to a persistent storage method.
//     // You need to implement this part to save data properly.
//   }

//   void addPassword(passwords password) {
//     setState(() {
//       passwordData.add(password);
//     });
//   }

//   void deletePassword(int index) {
//     if (index >= 0 && index < passwordData.length) {
//       setState(() {
//         passwordData.removeAt(index);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         // ... Your existing scaffold setup
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
//             child: Column(
//               children: [
//                 // ... Your existing UI elements
//                 Container(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: passwordData.length,
//                     itemBuilder: (context, index) {
//                       final password = passwordData[index];
//                       return Dismissible(
//                         key: Key(password.userName),
//                         onDismissed: (direction) {
//                           deletePassword(index);
//                         },
//                         background: Container(
//                           color: Colors.red,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Icon(Icons.arrow_back, color: Colors.white),
//                               Icon(Icons.delete, color: Colors.white),
//                             ],
//                           ),
//                         ),
//                         child: PasswordTile(
//                           password,
//                           index,
//                           context,
//                           () {
//                             deletePassword(index);
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Your existing PasswordTile, showPasswordDialog, and other widget functions

//   // The rest of your code for handling user interface elements
// }
