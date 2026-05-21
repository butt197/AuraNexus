import 'package:videocalling/common/utils/app_imports.dart';

class MyPhotoViewer extends GetView<MyPhotoViewerController> {
  MyPhotoViewerController photoViewer = Get.put(MyPhotoViewerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (photoViewer.isDeleteShown)
          ? AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.color1,
                          AppColors.color2,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    height: 60 + MediaQuery.of(context).padding.top,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SafeArea(
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              AppImages.backIcon,
                              height: 25,
                              width: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AppTextWidgets.mediumText(
                              text: photoViewer.reportName,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: AppColors.WHITE,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  title: Center(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AppTextWidgets.regularText(
                                          text: 'confirmation'.tr,
                                          color: AppColors.BLACK,
                                          size: 24),
                                    ),
                                  ),
                                  content: Text(
                                    'delete_report'.tr,
                                    style: const TextStyle(
                                      color: AppColors.BLACK,
                                      fontSize: 18,
                                      fontFamily:
                                          AppFontStyleTextStrings.regular,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppColors.color1,
                                                borderRadius:
                                                    BorderRadius.circular(8.71),
                                              ),
                                              child: Text(
                                                'cancel'.tr,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: AppColors.WHITE,
                                                  fontFamily:
                                                      AppFontStyleTextStrings
                                                          .regular,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              Get.back();
                                              photoViewer.deletePhoto(
                                                  imageId: photoViewer.id);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppColors.color1,
                                                borderRadius:
                                                    BorderRadius.circular(8.71),
                                              ),
                                              child: Text(
                                                'delete'.tr,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: AppColors.WHITE,
                                                  fontFamily:
                                                      AppFontStyleTextStrings
                                                          .regular,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: AppColors.WHITE,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
          : AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.color1,
                          AppColors.color2,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    height: 60 + MediaQuery.of(context).padding.top,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SafeArea(
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 10),
                              child: Image.asset(
                                AppImages.backIcon,
                                height: 25,
                                width: 22,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AppTextWidgets.mediumText(
                              text: photoViewer.reportName,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
      body: Center(
        child: Hero(
          tag: photoViewer.url,
          child: PhotoView(
            key: photoViewer.sKey,
            imageProvider: CachedNetworkImageProvider(
              photoViewer.url,
            ),
            maxScale: 1.0,
            minScale: 0.2,
          ),
        ),
      ),
    );
  }
}


