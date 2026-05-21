import 'package:videocalling/common/utils/app_imports.dart';

class MyVideoPlayer extends GetView<MyVideoPlayerController> {
  final MyVideoPlayerController videoPlayerController =
      Get.put(MyVideoPlayerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: '',
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
        leading: Container(),
      ),
      body: Center(
          child: Obx(
        () => videoPlayerController.isLoaded.value
            ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      videoPlayerController.controller.value.isPlaying
                          ? videoPlayerController.controller.pause()
                          : videoPlayerController.controller.play();
                      videoPlayerController.update();
                    },
                    child: AspectRatio(
                      aspectRatio:
                          videoPlayerController.controller.value.aspectRatio,
                      child: VideoPlayer(
                        videoPlayerController.controller,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: VideoProgressIndicator(
                      videoPlayerController.controller,
                      allowScrubbing: false,
                      colors: VideoProgressColors(
                        backgroundColor: AppColors.BLUE_GREY,
                        bufferedColor: AppColors.BLUE_GREY,
                        playedColor: AppColors.BLUE_ACCENT,
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (videoPlayerController.isPaused.value) {
            videoPlayerController.controller.pause();
            videoPlayerController.isPaused.value = false;
          } else {
            videoPlayerController.controller.play();
            videoPlayerController.isPaused.value = true;
          }
          videoPlayerController.update();
        },
        child: Obx(
          () => Icon(
            videoPlayerController.isPaused.value
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}


