// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password_manager/AddModal.dart';
import 'package:password_manager/Model/password_model.dart';
import 'package:password_manager/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<passwords> passwordData = [];

  @override
  @override
  void initState() {
    super.initState();
    loadPasswordData();
  }

  @override
  void dispose() {
    savePasswordData();
    super.dispose();
  }

  Future<void> loadPasswordData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('passwordData');

    if (jsonData != null) {
      final Iterable decoded = jsonDecode(jsonData);
      List<passwords> loadedData =
          decoded.map((e) => passwords.fromMap(e)).toList();

      setState(() {
        passwordData = loadedData;
      });
    }
  }

  Future<void> savePasswordData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(passwordData);
    await prefs.setString('passwordData', jsonData);
  }

  // Add a function to delete a password
  void deletePassword(int index) {
    if (index >= 0 && index < passwordData.length) {
      setState(() {
        passwordData.removeAt(index);
      });
    }
  }

  void addPassword(passwords password) {
    setState(() {
      passwordData.add(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => bottomModal(context),
          backgroundColor: Constants.fabBackground,
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
                height: 60,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset("assets/4square.svg"),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/shield.svg")
                    ]))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: Column(
              children: [
                searchText("Search Password"),
                SizedBox(
                  height: 10,
                ),
                HeadingText("Recently Used"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Constants.passwordData.length,
                    itemBuilder: (context, index) {
                      final password = Constants.passwordData[index];
                      return Dismissible(
                        key: Key(password
                            .userName), // Provide a unique key for each item
                        onDismissed: (direction) {
                          // Implement the logic to delete the corresponding password here
                          deletePassword(index);
                        },
                        background: Container(
                          color: Colors
                              .red, // Background color when swiping to delete
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white),
                              Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),

                        child: PasswordTile(password, index, context, () {
                          deletePassword(index);
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget PasswordTile(
    passwords password,
    int index,
    BuildContext context,
    Function onDelete,
  ) {
    return Dismissible(
      key: Key(password.userName),
      onDismissed: (direction) {
        onDelete(); // Call the onDelete function to delete this password
      },
      background: Container(
        color: Colors.red, // Background color when swiping to delete
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle the action when swiping left (back) here
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deletePassword(index);
              },
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          showPasswordDialog(context, password.password);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile row
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          password.userName,
                          style: TextStyle(
                            color: Color.fromARGB(255, 22, 22, 22),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          password.description,
                          style: TextStyle(
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // Delete button
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deletePassword(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPasswordDialog(BuildContext context, String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Password"),
          content: Text(password),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget HeadingText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10, 0, 0),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget searchText(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 5, 5, 5), // add padding to adjust icon
              child: Icon(
                Icons.search,
                color: Constants.searchGrey,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            hintText: hintText,
            hintStyle: TextStyle(
                color: Constants.searchGrey, fontWeight: FontWeight.w500),
            fillColor: Color.fromARGB(247, 232, 235, 237),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(20))),
        style: TextStyle(),
      ),
    );
  }

  Future<void> bottomModal(BuildContext context) async {
    String userName = '';
    String description = '';
    String password = '';

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return AddModal(
          onAddPassword:
              (String newUserName, String newDescription, String newPassword) {
            userName = newUserName;
            description = newDescription;
            password = newPassword;
          },
        );
      },
    );

    if (userName.isNotEmpty && description.isNotEmpty && password.isNotEmpty) {
      addPassword(passwords(
        userName: userName,
        description: description,
        password: password,
      ));
    }
  }

  Widget bottomSheetWidgets(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: screenWidth * 0.4,
              height: 5,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 156, 156, 156),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 60,
                width: 130,
                decoration: BoxDecoration(
                    color: Constants.logoBackground,
                    borderRadius: BorderRadius.circular(20)),
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.5,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Add",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
