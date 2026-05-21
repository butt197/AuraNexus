import 'package:videocalling/common/utils/app_imports.dart';

class MyPhotoViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPhotoViewerController>(
          () => MyPhotoViewerController(),
    );
  }
}

