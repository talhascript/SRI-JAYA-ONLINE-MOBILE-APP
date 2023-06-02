import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({Key? key});

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  Future<Map<String, List<Map<String, dynamic>>>> getOrderRequests() async {
    final QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('requested')
        .where('status', isEqualTo: 'pending')
        .get();

    final Map<String, List<Map<String, dynamic>>> requestsByUser = {};

    for (final DocumentSnapshot doc in requestSnapshot.docs) {
      final String requestId = doc.id;
      final String userId = doc.get('userId');
      final List<dynamic> productIds = doc.get('productIds');
      final List<dynamic> quantities = doc.get('quantities');
      final int totalPrice = doc.get('totalPrice');

      final List<Map<String, dynamic>> requests = [];

      for (int i = 0; i < productIds.length; i++) {
        final String productId = productIds[i];
        final int quantity = quantities[i];

        final DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          final String productName = productSnapshot.get('pname');
          final int productPrice = productSnapshot.get('price');

          final Map<String, dynamic> request = {
            'requestId': requestId,
            'productId': productId,
            'productName': productName,
            'quantity': quantity,
            'productPrice': productPrice,
          };

          requests.add(request);
        }
      }

      if (requestsByUser.containsKey(userId)) {
        requestsByUser[userId]!.addAll(requests);
      } else {
        requestsByUser[userId] = requests;
      }
    }

    return requestsByUser;
  }

  Future<String> getUsername(String userId) async {
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      return userSnapshot.get('name');
    }

    return '';
  }

  Future<void> updateOrderStatus(String requestId, String newStatus) async {
    final DocumentReference requestRef = FirebaseFirestore.instance
        .collection('requested')
        .doc(requestId);

    await requestRef.update({'status': newStatus});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Requests"),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: getOrderRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving order requests'),
            );
          }

          final requestsByUser = snapshot.data;

          if (requestsByUser == null || requestsByUser.isEmpty) {
            return Center(
              child: Text('No order requests found'),
            );
          }

          return Column(
            children: requestsByUser.entries.map((entry) {
              final userId = entry.key;
              final usernameFuture = getUsername(userId);
              final requests = entry.value;

              return FutureBuilder<String>(
                future: usernameFuture,
                builder: (context, usernameSnapshot) {
                  if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (usernameSnapshot.hasError) {
                    return Text('Error retrieving username');
                  }

                  final username = usernameSnapshot.data ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Username: $username',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            IconButton(
                              icon: Icon(Icons.check),
                              
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Shipping'),
                                    content: Text('Are you sure you want to ship the products for $username?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          for (final request in requests) {
                                            final String requestId = request['requestId'];
                                            await updateOrderStatus(requestId, 'shipping');
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Cancellation'),
                                    content: Text('Are you sure you want to cancel the order request for $username?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          for (final request in requests) {
                                            final String requestId = request['requestId'];
                                            await updateOrderStatus(requestId, 'cancelled');
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ...requests.map((request) {
                        final requestId = request['requestId'];
                        final productName = request['productName'];
                        final quantity = request['quantity'];
                        final productPrice = request['productPrice'];
                        final totalPrice = quantity * productPrice;

                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              //   child: Text('Request ID: $requestId'),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Product Name: $productName',style: TextStyle( fontSize: 16),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Quantity: $quantity',style: TextStyle( fontSize: 16),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Price: RM $productPrice Each',style: TextStyle( fontSize: 16),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Total Price: RM $totalPrice',style: TextStyle( fontSize: 16),),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}