import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/login_page.dart';
import 'package:project/signup_page.dart';


import 'home_Page.dart';
import 'landing_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),

      
    );
  }
}
