import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
            height: h * 0.37,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/SIGN UP.png"), fit: BoxFit.cover)),
            child: Column(
              children: [
                SizedBox(height: h * 0.20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("img/avatar.png"),
                  backgroundColor: Colors.white60,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 15,
                bottom: 10,
                right: 20,
                top: 10), //You can use EdgeInsets like above
            margin:
                const EdgeInsets.only(left: 15, bottom: 40, right: 20, top: 10),
            child: Column(
              children: [
                TextField(
                  //  hintText: 'PLACE HOLDER TEXT'
                  decoration: InputDecoration(
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular((50)))),
                ),

                SizedBox(
                  height: 20,
                ),
                TextField(
                  //  hintText: 'PLACE HOLDER TEXT'
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular((50)))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                  child: TextField(
                    // labelText: 'PLACE HOLDER TEXT FOR PASSWORD'
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular((50)))),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: w * 0.5,
            height: h * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                  image: AssetImage("img/button2.jpg"), fit: BoxFit.cover),
            ),
            child: const Center(
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Sign up using one of the following methods",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                backgroundImage: AssetImage("img/g.png"),radius: 30,
              ),
              SizedBox(width: 30),
              CircleAvatar(
                backgroundImage: AssetImage("img/f.png"),radius: 30,
              )
            ]),
          )
        ],
      ),
    );
  }
}
