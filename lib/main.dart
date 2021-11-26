// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:app_1/loginpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {'login': (context) => MyHomePage()}),
  );
}
