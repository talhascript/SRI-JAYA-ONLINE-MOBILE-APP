import 'dart:io';

import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}

class ECommerceDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ECommerceDashboardState();
}

class _ECommerceDashboardState extends State<ECommerceDashboard> {
  List<Product> filteredProducts = [
    Product(
      name: 'MSI Gaming Laptop',
      imageUrl:
          'https://hnsgsfp.imgix.net/9/images/detailed/78/MSI_GF63_Thin_15.6-inch_Gaming_Laptop_(IMG_1).jpg?fit=fill&bg=0FFF&w=1536&h=900&auto=format,compress',
      price: 1999.99,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add more products here
    filteredProducts.addAll([
      Product(
        name: 'Logitech G102 Lightsync Wired USB Gaming Mouse - Black ',
        imageUrl:
            'https://cdn.shopify.com/s/files/1/1974/9033/products/1_5a7c9552-6e97-4254-802d-b975c33684ae_1024x1024.jpg?v=1634197017',
        price: 61.99,
      ),
      Product(
        name: 'Fantech Pantheon RGB Optical Switch Mechanical Keyboard MK882',
        imageUrl:
            'https://monaliza.com.my/wp-content/uploads/2019/12/FANTECH-MK882-PANTHEON-RGB-OPTICal-SWITCH-MECHANICAL-KEYBOARD.png',
        price: 19.99,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Sri Jaya Online'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  filteredProducts: filteredProducts,
                ),
              );
            }, ////
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
            ),
            title: Text(product.name),
            subtitle: Text('\MYR${product.price.toStringAsFixed(2)}'),
            onTap: () {
              print('Product tapped: ${product.name}');
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle home tap
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('My Cart'),
              onTap: () {
                // Handle cart tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Handle logout tap
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Product> filteredProducts;

  ProductSearchDelegate({required this.filteredProducts});

  List<Product> getSearchResults(String query) {
    return filteredProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  String get searchFieldLabel => 'Search products';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Product> searchResults = getSearchResults(query);
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final product = searchResults[index];
        return ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 80,
            height: 80,
          ),
          title: Text(product.name),
          subtitle: Text('\MYR${product.price.toStringAsFixed(2)}'),
          onTap: () {
            close(context, product.name);
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
}

void main() {
  runApp(MaterialApp(
    title: 'SRI JAYA ONLINE',
    home: ECommerceDashboard(),
  ));
}
