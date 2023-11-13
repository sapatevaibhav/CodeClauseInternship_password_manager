// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:password_manager/AddModal.dart';
import 'package:password_manager/DatabaseHelper.dart';
import 'package:password_manager/Model/password_model.dart';
import 'package:password_manager/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_HomePageState> homePageKey = _homePageKey;

  @override
  State<MyApp> createState() => _MyAppState();

  static void refreshHomePage() {
    _homePageKey.currentState?.refresh();
  }
}

final GlobalKey<_HomePageState> _homePageKey = GlobalKey<_HomePageState>();

class _MyAppState extends State<MyApp> {
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
  DatabaseHelper dbHelper = DatabaseHelper();

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadPasswordData();
  }

  Future<void> loadPasswordData() async {
    final List<passwords> loadedData = await dbHelper.getPasswords();
    setState(() {
      passwordData = loadedData;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deletePassword(int index) async {
    if (index >= 0 && index < passwordData.length) {
      await dbHelper.deletePassword(passwordData[index].userName);
      setState(() {
        passwordData.removeAt(index);
      });
    }
  }

  void addPassword(passwords password) {
    dbHelper.insertPassword(password);
    setState(() {
      passwordData.add(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => bottomModal(context),
          backgroundColor: Constants.fabBackground,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: Column(
              children: [
                SizedBox(height: 15),
                headingText("Saved Passwords"),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: passwordData.length,
                  itemBuilder: (context, index) {
                    final password = passwordData[index];
                    return Dismissible(
                      key: Key(password.userName),
                      onDismissed: (direction) {
                        deletePassword(index);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white),
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      child: passwordTile(password, index, context, () {
                        deletePassword(index);
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTile(
    passwords password,
    int index,
    BuildContext context,
    Function onDelete,
  ) {
    return Dismissible(
      key: Key(password.userName),
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {},
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

  Widget headingText(String text) {
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
      MyApp.refreshHomePage();
    }
  }
}
