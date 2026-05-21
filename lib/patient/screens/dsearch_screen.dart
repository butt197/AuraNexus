import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DoctorSearchScreen extends GetView<DoctorSearchController> {
  final DoctorSearchController searchController =
      Get.put(DoctorSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.transparentColor,
        toolbarHeight: kToolbarHeight + 62,
        flexibleSpace: Obx(() => CustomSearchScreenAppBar(
          title: 'search_doctor_appbar1'.tr,
          title1: 'search_doctor_appbar2'.tr,
          textController: searchController.textController,
          valueColor: searchController.isLoading.value
              ? AlwaysStoppedAnimation(Theme.of(context).hintColor)
              : AlwaysStoppedAnimation(AppColors.transparentColor),
          onSubmitted: (val) {
            searchController.searchKeyword.value = val;
            searchController.onSubmit(val);
          },
          onPressed: () {
            Get.focusScope?.unfocus();
            searchController.onSubmit(searchController.textController.text);
          },
          isBackArrow: true,
          onPressed1: () => Get.back(),
        )),
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      body: Obx(() => Stack(
            children: [
              searchController.isErrorInLoading.value
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
                      controller: searchController.scrollController,
                      child: searchController.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).hintColor),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                                  child: ListView.builder(
                                    itemCount: searchController.newData.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Get.toNamed(
                                                  Routes.doctorDetailScreen,
                                                  arguments: {
                                                    'id':
                                                        "${searchController.newData[index].id}"
                                                  });
                                              Get.delete<
                                                  DoctorDetailController>();
                                            },
                                            child: Container(
                                              //height: 90,
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 10),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.WHITE,
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: CachedNetworkImage(
                                                      imageUrl: searchController
                                                              .newData[index]
                                                              .image ??
                                                          "",
                                                      height: 70,
                                                      width: 70,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Image.asset(
                                                            AppImages
                                                                .tab3dUnselect,
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, err) =>
                                                          Container(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20.0),
                                                                child:
                                                                    Image.asset(
                                                                  AppImages
                                                                      .tab3dUnselect,
                                                                  height: 20,
                                                                  width: 20,
                                                                ),
                                                              )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppTextWidgets
                                                                  .mediumText(
                                                                text: searchController
                                                                        .newData[
                                                                            index]
                                                                        .name ??
                                                                    "",
                                                                color: AppColors
                                                                    .BLACK,
                                                                size: 13,
                                                              ),
                                                              AppTextWidgets.regularText(
                                                                  text: searchController
                                                                          .newData[
                                                                              index]
                                                                          .departmentName ??
                                                                      "",
                                                                  size: 11,
                                                                  color: AppColors
                                                                      .BLACK),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(height: 10,),
                                                        Container(
                                                          child: AppTextWidgets
                                                              .regularText(
                                                            text: searchController
                                                                    .newData[
                                                                        index]
                                                                    .address ??
                                                                "",
                                                            size: 10,
                                                            color: AppColors
                                                                .LIGHT_GREY_TEXT,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                searchController.isLoadingMore.value
                                    ?  Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text("loading".tr,style: const TextStyle(
                                              fontFamily: AppFontStyleTextStrings.regular
                                            )),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                    ),
            ],
          )),
    );
  }
}


