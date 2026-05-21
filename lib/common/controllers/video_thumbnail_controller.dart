import 'package:videocalling/common/utils/app_imports.dart';

class MyVideoThumbnailController extends GetxController{
  String url;
  MyVideoThumbnailController({required this.url});
  late VideoPlayerController videoPlayerController1;

  Future<void> initializePlayer() async {
    videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse(url));
    await videoPlayerController1.initialize();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    videoPlayerController1.dispose();
  }
}

