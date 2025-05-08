import 'package:get/get.dart';

import '../controller/product_category_controller.dart';
import '../repository/product_category_repository.dart';

class ProductCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductCategoryController(repository: ProductCategoryRepository()));
  }
}
