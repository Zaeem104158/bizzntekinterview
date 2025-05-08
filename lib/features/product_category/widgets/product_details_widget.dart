import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(product['title'],
              maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'productImage_${product['id']}',
            child: Image.network(
              product['image'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              product['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              product['description'],
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text("\$${product['price']}", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
