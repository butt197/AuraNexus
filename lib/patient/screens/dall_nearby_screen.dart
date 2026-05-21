import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DAllNearbyScreen extends GetView<DAllNearbyController> {
  final DAllNearbyController nearbyController = Get.put(DAllNearbyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        flexibleSpace: CustomAppBar(
          title: 'nearby_doctors'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      body: Obx(() => nearbyController.isErrorInLoading.value
          ? Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 100,
                      color: AppColors.LIGHT_GREY_TEXT,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'unable_to_load_data'.tr,
                      style: const TextStyle(
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    )
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              controller: nearbyController.scrollController,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    nearbyController.isNearbyLoading.value
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height - 50,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : nearbyController.list.isEmpty
                            ? nearbyController.isErrorInNearby.value
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      AppTextWidgets.regularText(
                                          text: 'turn_on_location_and_retry'
                                              .tr,
                                          size: 12,
                                          color: AppColors.BLACK),
                                    ],
                                  ),
                                )
                                : Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).hintColor),
                                      strokeWidth: 2,
                                    ),
                                  )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 0.75,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: nearbyController.list.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return InkWell(
                                    onTap: () async {
                                      await Get.toNamed(
                                          Routes.doctorDetailScreen,
                                          arguments: {
                                            'id': nearbyController
                                                .list[index].id
                                                .toString()
                                          });
                                      Get.delete<DoctorDetailController>();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.WHITE,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding:
                                          const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: nearbyController
                                                        .list[index].image ??
                                                    "",
                                                fit: BoxFit.cover,
                                                width: 250,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  child: Center(
                                                    child: Image.asset(
                                                      AppImages.tab3dUnselect,
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, err) =>
                                                        Container(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  child: Center(
                                                    child: Image.asset(
                                                      AppImages.tab3dUnselect,
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  //child: Padding(
                                                  //   padding: const EdgeInsets.all(20.0),
                                                  // )
                                                  //
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AppTextWidgets.mediumText(
                                            text: nearbyController
                                                    .list[index].name ??
                                                "",
                                            color: AppColors.BLACK,
                                            size: 13,
                                          ),
                                          AppTextWidgets.mediumText(
                                            text: nearbyController.list[index]
                                                    .departmentName ??
                                                "",
                                            color: AppColors.LIGHT_GREY_TEXT,
                                            size: 9.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    nearbyController.nextUrl.value == "null"
                        ? Container()
                        : const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                    nearbyController.isLoadingMore.value
                        ? const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: LinearProgressIndicator(),
                          )
                        : Container(
                            height: 50,
                          )
                  ],
                ),
              ))),
    );
  }
}


