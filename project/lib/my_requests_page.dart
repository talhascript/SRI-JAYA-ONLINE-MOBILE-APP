import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({Key? key}) : super(key: key);

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    final String? userId = await getCurrentUserId();
    if (userId != null) {
      final QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('requested')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      final List<Map<String, dynamic>> orders = [];

      for (final DocumentSnapshot doc in requestSnapshot.docs) {
        final List<dynamic> productIds = doc.get('productIds');
        final List<dynamic> quantities = doc.get('quantities');

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

            final Map<String, dynamic> order = {
              'orderId': doc.id,
              'productName': productName,
              'quantity': quantity,
              'price': productPrice,
            };

            orders.add(order);
          }
        }
      }

      return orders;
    } else {
      return [];
    }
  }

  Future<int> getTotalPrice() async {
    final String? userId = await getCurrentUserId();
    if (userId != null) {
      final QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('requested')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      int totalPrice = 0;

      for (final DocumentSnapshot doc in requestSnapshot.docs) {
        final int docTotalPrice = doc.get('totalPrice');
        totalPrice += docTotalPrice;
      }

      return totalPrice;
    } else {
      return 0;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Cancel'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      try {
        await FirebaseFirestore.instance.collection('requested').doc(orderId).delete();
        final totalPrice = await getTotalPrice();
        setState(() {
          // Update total price
        });
      } catch (error) {
        print('Error cancelling order: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving user orders'),
            );
          }

          final orders = snapshot.data;

          if (orders == null || orders.isEmpty) {
            return Center(
              child: Text('No orders found'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final String orderId = order['orderId'];
                      final String productName = order['productName'];
                      final int quantity = order['quantity'];
                      final int price = order['price'];

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListTile(
                        shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          title: Text('Product Name: $productName'),
                          subtitle: Text('Quantity: $quantity ||  Price: RM $price'),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () => cancelOrder(orderId),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FutureBuilder<int>(
                  future: getTotalPrice(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error calculating total price');
                    }

                    final totalPrice = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Price: RM $totalPrice',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}