import 'package:videocalling/common/utils/app_imports.dart';

class MyVideoPlayerController extends GetxController {
  String url = Get.arguments['url'];
  int type = Get.arguments['type'];
  late VideoPlayerController controller;

  RxBool isLoaded = false.obs;
  RxBool isPaused = true.obs;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    controller.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = (type == 1)
        ? VideoPlayerController.file(
            File(url),
          )
        : VideoPlayerController.networkUrl(
            Uri.parse(url),
          );

    controller.setLooping(true);
    controller.initialize().then((value) {
      isLoaded.value = true;
    });
    controller.play();
  }
}


