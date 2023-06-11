import 'package:flutter/material.dart';
import 'package:project/check_verification_page.dart';
import 'package:project/upload_image_page.dart';

class StudentVerification extends StatelessWidget {
  const StudentVerification({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300, // Set a specific width for the buttons
               height: 70,
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Verify That You Are A Student" button press
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadIMG(),
                ),
              );
                },
                child: Text(
                  "Verify That You Are A Student",
                  style: TextStyle(fontSize: 20), // Set font size to 20
                ),
              ),
            ),
            SizedBox(height: 16), // Add some spacing between the buttons
            SizedBox(
              width: 300, 
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Check Verification Status" button press
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckVerification(),
                ),
              );
                 
                },
                child: Text(
                  "Check Verification Status",
                  style: TextStyle(fontSize: 20), // Set font size to 20
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}