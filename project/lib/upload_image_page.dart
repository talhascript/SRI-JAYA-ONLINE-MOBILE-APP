import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadIMG extends StatefulWidget {
  const UploadIMG({Key? key});

  @override
  _UploadIMGState createState() => _UploadIMGState();
}

class _UploadIMGState extends State<UploadIMG> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isImageUploaded = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (_image == null) {
      // No image selected
      return;
    }

    try {
      final String fileName = path.basename(_image!.path);
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final File imageFile = File(_image!.path);

      final TaskSnapshot uploadTask = await firebaseStorageRef.putFile(imageFile);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userID = user.uid;
        final verificationData = {
          'userID': userID,
          'url': downloadUrl,
          'valid': false, // Set the valid field as false
        };

        await FirebaseFirestore.instance
            .collection('verification')
            .doc(userID)
            .set(verificationData);
      }

      setState(() {
        _isImageUploaded = true;
      });

      // TODO: Handle the success of the upload, e.g., display a success message or navigate to a new screen

    } on FirebaseException catch (e) {
      // TODO: Handle any errors that occur during the upload, e.g., display an error message
      print(e);
    }
  }

  void _resetImage() {
    setState(() {
      _image = null;
      _isImageUploaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Student Verification Photo"),
      ),
      body: Center(
        child: _isImageUploaded
            ? SuccessPage(resetImage: _resetImage)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    iconSize: 100,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _uploadImageToFirebaseStorage,
                    child: Text("Upload Photo", style: TextStyle(fontSize: 28)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Upload a recent student registration slip with your name and date",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "If you get verified as a student, all items are 15% off !!!",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final VoidCallback resetImage;

  const SuccessPage({Key? key, required this.resetImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Success"),
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
              "Successfully uploaded picture",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Waiting for verification",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: resetImage,
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}