import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'new_page.dart';
import 'my_requests_page.dart';
import 'cancelled_page.dart';
import 'ship_page.dart'; // Import the ShipPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _displayNameFuture;
  late Future<String> _phoneNumberFuture;
  late Future<String> _addressFuture;

  @override
  void initState() {
    super.initState();
    _displayNameFuture = getCurrentUserDisplayName();
    _phoneNumberFuture = getCurrentUserPhone();
    _addressFuture = getCurrentUserAddress();
  }

  Future<String> getCurrentUserDisplayName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }

    if (userSnapshot.exists) {
      String name = userSnapshot.get('name');
      return name;
    } else {
      return 'Unknown';
    }
  }

  Future<String> getCurrentUserPhone() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }

    if (userSnapshot.exists) {
      String phoneNumber = userSnapshot.get('phoneNumber');
      return phoneNumber;
    } else {
      return 'Unknown';
    }
  }

  Future<String> getCurrentUserAddress() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }

    if (userSnapshot.exists) {
      String address = userSnapshot.get('address');
      return address;
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<String>(
        future: _displayNameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving user data'),
            );
          }

          final displayName = snapshot.data;

          return FutureBuilder<String>(
            future: _phoneNumberFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error retrieving user data'),
                );
              }

              final phoneNumber = snapshot.data;

              return FutureBuilder<String>(
                future: _addressFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error retrieving user data'),
                    );
                  }

                  final address = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Center(
                          child: CircleAvatar(
                            backgroundImage: AssetImage('img/avatar.png'),
                            radius: 80,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Name: $displayName',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Phone Number: $phoneNumber',
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Address: $address',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SizedBox(height: 60),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewPage(),
                                  ),
                                );
                              },
                              child: Text('Edit Profile', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyRequestsPage(),
                                  ),
                                );
                              },
                              child: Text('My Requests', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CancelledPage(),
                                  ),
                                );
                              },
                              child: Text('Cancelled Orders', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShipPage(),
                                  ),
                                );
                              },
                              child: Text('To Ship', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}