import 'dart:developer';

import 'package:get/get.dart';

import '../../../http/api_endpoints.dart';
import '../../../http/api_exception.dart';
import '../../../http/api_services.dart';

class ProductCategoryRepository {
  final _apiService = Get.find<ApiService>();

  Future<dynamic> fetchCategories() async {
    try {
      return await _apiService.get(ApiEndPoints.productCategories);
    } on ApiException catch (e, stack) {
      log('An error occurred from network', error: e, stackTrace: stack);
      throw Exception(e.message); // Rethrow api error
    } catch (e, stack) {
      log('An error occurred from repository', error: e, stackTrace: stack);
      throw Exception("Something went wrong");
    }
  }

  Future<dynamic> fetchProducts() async {
    try {
      return await _apiService.get(ApiEndPoints.products);
    } on ApiException catch (e, stack) {
      log('An error occurred from network', error: e, stackTrace: stack);
      throw Exception(e.message); // Rethrow api error
    } catch (e, stack) {
      log('An error occurred from repository', error: e, stackTrace: stack);
      throw Exception("Something went wrong");
    }
  }
}
