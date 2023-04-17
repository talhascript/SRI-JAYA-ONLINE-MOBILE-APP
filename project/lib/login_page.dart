import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:project/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: w,
            height: h * 0.33,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/SRI JAYA ONLINE.png"),
                    fit: BoxFit.cover)),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 15,
                bottom: 40,
                right: 20,
                top: 10), //You can use EdgeInsets like above
            margin: const EdgeInsets.only(left: 15, bottom: 40, right: 20, top: 10),
            child: Column(
              children: [
                const Text(
                  "WELCOME",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Sign in to your account",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextField(
                  //  hintText: 'PLACE HOLDER TEXT'
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular((50)))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    // labelText: 'PLACE HOLDER TEXT FOR PASSWORD'
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular((50)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 15, 0, 0),
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: w * 0.5,
            height: h * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                  image: AssetImage("img/button2.jpg"), fit: BoxFit.cover),
            ),
            child: const Center(
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.08,
          ),
          RichText(
            text: TextSpan(
                text: "Don't have an account?",
                style: TextStyle(color: Colors.grey[500], fontSize: 20),
                children: [TextSpan(
                recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage()),
                text: "Create",
                style: TextStyle(color: Colors.grey[900], fontSize: 20))]),
                
             
          )
        ],
      ),
    );
  }
}