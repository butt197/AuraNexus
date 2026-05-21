import 'package:videocalling/common/utils/app_imports.dart';

class MyAppScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAppController>(
      () => MyAppController(),
    );
  }
}

