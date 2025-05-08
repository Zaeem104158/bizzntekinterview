import 'dart:developer';

import 'package:get/get.dart';

import '../repository/product_category_repository.dart';

class ProductCategoryController extends GetxController {
  final ProductCategoryRepository repository;

  ProductCategoryController({required this.repository});

  Rx<RxStatus> categoryStatus = Rx<RxStatus>(RxStatus.loading());
  RxList<dynamic> categoriesList = <dynamic>[].obs;
  Rx<RxStatus> productStatus = Rx<RxStatus>(RxStatus.loading());
  RxList<dynamic> productList = <dynamic>[].obs;
  var filteredProducts = <dynamic>[].obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() async {
    await fetchProductCategory();
    await fetchProduct();
    super.onInit();
  }

  Future<void> fetchProductCategory() async {
    categoryStatus.value = RxStatus.loading();

    try {
      categoriesList.value = await repository.fetchCategories();

      if (categoriesList.isEmpty) {
        categoryStatus.value = RxStatus.empty();
      } else {
        log("Controller Data: $categoriesList");
        categoryStatus.value = RxStatus.success();
      }
    } catch (e) {
      categoryStatus.value = RxStatus.error(e.toString());
    }
  }

  Future<void> fetchProduct() async {
    productStatus.value = RxStatus.loading();

    try {
      productList.value = await repository.fetchProducts();

      if (productList.isEmpty) {
        productStatus.value = RxStatus.empty();
      } else {
        log("Controller Data: $productList");
        filterByCategory("all");
        productStatus.value = RxStatus.success();
      }
    } catch (e) {
      productStatus.value = RxStatus.error(e.toString());
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'all') {
      filteredProducts.assignAll(productList);
    } else {
      filteredProducts.assignAll(
        productList
            .where((filterableProducts) =>
                filterableProducts['category'] == category)
            .toList(),
      );
    }
  }

  final cartItems = <int, int>{}.obs;
  final cartList = <Map<String, dynamic>>[].obs;

// Add product
  void incrementProduct(Map<String, dynamic> product) {
    final id = product['id'];
    final stock = product['rating']['count'];
    final current = cartItems[id] ?? 0;

    if (current < stock) {
      cartItems[id] = current + 1;

      // Add to cartList if not present
      if (!cartList.any((p) => p['id'] == id)) {
        cartList.add(product);
      }
    }
  }

// Remove product
  void decrementProduct(Map<String, dynamic> product) {
    final id = product['id'];
    final current = cartItems[id] ?? 0;

    if (current > 0) {
      cartItems[id] = current - 1;

      if (cartItems[id] == 0) {
        cartItems.remove(id);
        cartList.removeWhere((p) => p['id'] == id);
      }
    }
  }

  // Get total cart price
  double get totalPrice {
    double total = 0;
    for (var product in cartList) {
      final quantity = cartItems[product['id']] ?? 0;
      total += product['price'] * quantity;
    }
    return total;
  }
}
