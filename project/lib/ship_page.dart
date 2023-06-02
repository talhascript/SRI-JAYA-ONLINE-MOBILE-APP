import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShipPage extends StatelessWidget {
  const ShipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Ship"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getShippingOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving shipping orders'),
            );
          }

          final orders = snapshot.data;

          if (orders == null || orders.isEmpty) {
            return Center(
              child: Text('No items to ship'),
            );
          }

          return ListView.builder(
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
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<List<Map<String, dynamic>>>(
        future: getShippingOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          }

          final orders = snapshot.data;

          if (orders != null && orders.isNotEmpty) {
            return Container(
              color: Colors.green,
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Your item will be arriving within 1 week',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getShippingOrders() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('requested')
        .where('status', isEqualTo: 'shipping')
        .where('userId', isEqualTo: userId)
        .get();

    final List<Map<String, dynamic>> orders = [];

    for (final DocumentSnapshot doc in requestSnapshot.docs) {
      final List<dynamic> productIds = doc.get('productIds');
      final List<dynamic> quantities = doc.get('quantities');

      for (int i = 0; i < productIds.length; i++) {
        final String productId = productIds[i];
        final int quantity = quantities[i];

        final DocumentSnapshot productSnapshot =
            await FirebaseFirestore.instance.collection('products').doc(productId).get();

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
  }
}