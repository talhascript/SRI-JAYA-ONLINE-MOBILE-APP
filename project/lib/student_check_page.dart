import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCheck extends StatefulWidget {
  const StudentCheck({Key? key}) : super(key: key);

  @override
  _StudentCheckState createState() => _StudentCheckState();
}

class _StudentCheckState extends State<StudentCheck> {
  Future<void> _showConfirmationDialog(
      DocumentSnapshot verificationDoc, bool isCheckButton) async {
    String confirmationMessage = isCheckButton
        ? 'Are you sure you want to make this a student account?'
        : 'Are you sure you want to delete this verification request?';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(confirmationMessage),
          actions: [
            TextButton(
              onPressed: () async {
                if (isCheckButton) {
                  // Update the verification request
                  await verificationDoc.reference.update({'valid': true});
                } else {
                  // Delete the verification request
                  await verificationDoc.reference.delete();
                }
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('verification')
            .where('valid', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No verification requests found"),
            );
          } else {
            final verificationDocs = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: verificationDocs.map((verificationDoc) {
                  final verificationData =
                      verificationDoc.data() as Map<String, dynamic>;
                  final userID = verificationData['userID'];
                  final url = verificationData['url'];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text(userID),
                          subtitle: CircularProgressIndicator(),
                        );
                      } else if (userSnapshot.hasError) {
                        return ListTile(
                          title: Text(userID),
                          subtitle: Text('Error occurred'),
                        );
                      } else if (userSnapshot.hasData) {
                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final userName = userData['name'];

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(userName),
                              subtitle: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        url,
                                        height: 500,
                                        width: 500,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 25),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _showConfirmationDialog(
                                                verificationDoc, true);
                                          },
                                          icon: Icon(Icons.check, size: 25),
                                        ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            _showConfirmationDialog(
                                                verificationDoc, false);
                                          },
                                          icon: Icon(Icons.clear, size: 25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(userID),
                          subtitle: Text('User not found'),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}