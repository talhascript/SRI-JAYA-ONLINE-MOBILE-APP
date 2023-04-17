import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePageTEST extends StatelessWidget {
  const HomePageTEST({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("App Testing"),
        ),
        
        body: Column(
          children: [
            SizedBox(height: 50,),
            Center(
                child: Text(
              "email@gmail.com",
              style: TextStyle(fontSize: 50),
            )),
            SizedBox(height: 500,),
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: const DecorationImage(
                    image: AssetImage("img/button2.jpg"), fit: BoxFit.cover),
              ),
              child: const Center(
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ],
        ));
  }
}
