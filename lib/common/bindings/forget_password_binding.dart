import 'package:videocalling/common/utils/app_imports.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
          () => ForgetPasswordController(),
    );
  }
}

