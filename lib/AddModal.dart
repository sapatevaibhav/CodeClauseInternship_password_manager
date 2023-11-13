// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:flutter/material.dart';

class AddModal extends StatefulWidget {
  final Function(String, String, String) onAddPassword;

  AddModal({
    Key? key,
    required this.onAddPassword,
  }) : super(key: key);

  @override
  State<AddModal> createState() => _AddModalState();
}

class _AddModalState extends State<AddModal> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    usernameController.text = '';
    descriptionController.text = '';
    passwordController.text = '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
      child: SingleChildScrollView(
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                formHeading("Username"),
                formTextField(
                    "Enter Username", Icons.person, usernameController),
                formHeading("Description"),
                formTextField(
                  "Enter Description",
                  Icons.description,
                  descriptionController,
                ),
                formHeading("Password"),
                formTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  passwordController,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: screenHeight * 0.06,
              width: screenWidth * 0.3,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5),
                  shadowColor:
                      MaterialStateProperty.all(
                      Color.fromARGB(255, 55, 114, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(color: Color.fromARGB(255, 55, 114, 255)),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(
                      Color.fromARGB(255, 55, 114, 255)),
                ),
                onPressed: () async {
                  final username = usernameController.text;
                  final description = descriptionController.text;
                  final password = passwordController.text;

                  

                  widget.onAddPassword(username, description, password);
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok Done",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 270,
            ),
            SizedBox(
              height: 30,
              child: Text(
                "made by sapatevaibhav 🧡",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
              child: Icon(
                icon,
                color: Color.fromARGB(255, 82, 101, 120),
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            hintText: hintText,
            hintStyle: TextStyle(
                color: Color.fromARGB(255, 82, 101, 120), fontWeight: FontWeight.w500),
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

  Widget formHeading(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
