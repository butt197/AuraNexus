import 'package:videocalling/common/utils/app_imports.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
          () => ChatController(),
    );
  }
}

