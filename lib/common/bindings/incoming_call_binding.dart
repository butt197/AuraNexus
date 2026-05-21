import 'package:videocalling/common/utils/app_imports.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
          () => IncomingCallController(),
    );
  }
}

