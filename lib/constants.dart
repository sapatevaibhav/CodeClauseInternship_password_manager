// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:password_manager/Model/password_model.dart';

class Constants {
  static Color searchGrey = Color.fromARGB(255, 82, 101, 120);

  static Color darkBlue = Color.fromARGB(255, 135, 170, 255);
  static Color lightBlue = Color.fromARGB(255, 235, 241, 255);

  static Color lightGreen = Color.fromARGB(255, 231, 249, 242);
  static Color darkGreen = Color.fromARGB(255, 113, 217, 179);

  static Color lightRed = Color.fromARGB(255, 253, 237, 241);
  static Color darkRed = Color.fromARGB(255, 245, 145, 169);

  static Color logoBackground = Color.fromARGB(255, 239, 239, 239);

  static Color fabBackground = Color.fromARGB(255, 55, 114, 255);

  static Color buttonBackground = Color.fromARGB(255, 55, 114, 255);

  static List<passwords> passwordData = [
    passwords(
        userName: "user",
        description: "Google Account",
        password: '@E23rfdjdn3532'),
    passwords(
        userName: "user33",
        description: "Netflix Personal",
        password: '!ihw4h34nr4i3'),
    passwords(
        userName: "abc22",
        description: "X main account",
        password: '8dwy8*87&'),
    passwords(
        userName: "ProUser",
        description: "Dribbble",
        password: 'wkn3#R3kndk#@'),
  ];
}
