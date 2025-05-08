import 'package:bizzinterview/features/product_category/controller/product_category_controller.dart';
import 'package:bizzinterview/features/product_category/widgets/product_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/cart_widget.dart';

class ProductCategoryScreen extends GetView<ProductCategoryController> {
  const ProductCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Category"),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Navigate to cart
                  Get.to(() => CartWidget());
                },
              ),
              Obx(() {
                final count = controller.cartList.length;
                return count > 0
                    ? Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$count",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.categoryStatus.value.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.categoryStatus.value.isError) {
              return Text(controller.categoryStatus.value.errorMessage!);
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.categoriesList.map((category) {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) =>
                            controller.filterByCategory(category),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }),
          Obx(() {
            if (controller.productStatus.value.isLoading) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else if (controller.productStatus.value.isError) {
              return Text(controller.productStatus.value.errorMessage!);
            } else {
              return Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];

                    final id = product['id'];
                    final stock = product['rating']['count'];
                    return GestureDetector(
                      onTap: () => Get.to(
                        () => ProductDetailsWidget(product: product),
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Hero(
                                  tag: 'productImage_${product['id']}',
                                  child: Image.network(
                                    product['image'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("\$${product['price']}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text("${product['rating']['rate']}"),
                                ],
                              ),
                            ),
                            Obx(() {
                              final inCart = controller.cartItems[id] ?? 0;
                              final isOutOfStock = stock == 0;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Stock: $stock",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            size: 14,
                                          ),
                                          onPressed: inCart > 0
                                              ? () => controller
                                                  .decrementProduct(product)
                                              : null,
                                        ),
                                        Text(
                                          "$inCart",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            size: 14,
                                          ),
                                          onPressed:
                                              !isOutOfStock && inCart < stock
                                                  ? () => controller
                                                      .incrementProduct(product)
                                                  : null,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
