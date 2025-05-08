import 'package:bizzinterview/http/api_services.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
  }
}
