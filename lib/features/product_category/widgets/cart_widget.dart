import 'package:bizzinterview/features/product_category/controller/product_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductCategoryController>();
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Obx(() {
        if (controller.cartList.isEmpty) {
          return Center(child: Text("Cart is empty"));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartList.length,
                itemBuilder: (context, index) {
                  final product = controller.cartList[index];
                  final quantity = controller.cartItems[product['id']]!;
                  final price = product['price'] * quantity;

                  return ListTile(
                    leading:
                        Image.network(product['image'], width: 50, height: 50),
                    title: Text(product['title'], maxLines: 1),
                    subtitle: Text(
                        "Qty: $quantity x \$${product['price'].toStringAsFixed(2)}"),
                    trailing: Text("\$${price.toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Text(
                    "Total: \$${controller.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        );
      }),
    );
  }
}
