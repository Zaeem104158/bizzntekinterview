import 'package:bizzinterview/features/product_category/dependency/product_category_binding.dart';
import 'package:get/get.dart';

import 'features/product_category/screen/product_category_screen.dart';
import 'route_names.dart';

List<GetPage> routePages = [
  GetPage(
    name: RouteNames.category,
    page: () => const ProductCategoryScreen(),
    binding: ProductCategoryBinding(),
  ),
];
