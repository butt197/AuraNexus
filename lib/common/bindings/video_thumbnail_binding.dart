import 'package:videocalling/common/utils/app_imports.dart';

class MyVideoThumbnailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyVideoThumbnailController>(
          () => MyVideoThumbnailController(url: ''),
    );
  }
}

