import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/addHoursFaculty.dart';
import 'package:myapp/facultyhome.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/reusable.dart';
import 'package:myapp/studenthome.dart';
import 'package:myapp/facultysignup.dart';
import 'package:myapp/viewfaculty.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main',
      theme: ThemeData(
        primaryColor: Color(0xFF55C1EF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => home(),
        'addHoursFaculty': (context) => addHoursFaculty(),
        'facultyhome': (context) => facultyhome(),
        'studenthome': (context) => studenthome(),
        'facultysignup': (context) => facultysignup(),
        'reusable': (context) => reusable(),
        'viewfaculty': (context) => viewfaculty(),
        'login': (context) => login(),
      },
    );
  }
}
