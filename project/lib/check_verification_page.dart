import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckVerification extends StatelessWidget {
  const CheckVerification({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userID = user.uid;
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('verification').doc(userID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Verification Status"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Verification Status"),
              ),
              body: Center(
                child: Text("Error occurred"),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null && data['valid'] == true) {
              return VerifiedPage();
            } else {
              return NotVerifiedPage();
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Verification Status"),
              ),
              body: Center(
                child: Text("No data found"),
              ),
            );
          }
        },
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Verification Status"),
        ),
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }
  }
}

class VerifiedPage extends StatelessWidget {
  const VerifiedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Status"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 16),
            Text(
              "You are a verified student!",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "You can get items at 15% off.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NotVerifiedPage extends StatelessWidget {
  const NotVerifiedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Status"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
            SizedBox(height: 16),
            Text(
              "Sorry, you are not verified yet.",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "You can try uploading a new image or wait a few more days.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}