import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserPastAppointmentsScreen
    extends GetView<UserPastAppointmentsController> {
  final UserPastAppointmentsController pastAppointmentsController =
      Get.put(UserPastAppointmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'all_appointment'.tr,
        ),
        leading: Container(),
        elevation: 0,
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          controller: pastAppointmentsController.scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              5.hs,
              Obx(
                () => pastAppointmentsController.isErrorInLoading.value
                    ? SizedBox(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              20.hs,
                              Icon(
                                Icons.search_off_rounded,
                                size: 100,
                                color: AppColors.LIGHT_GREY_TEXT,
                              ),
                              10.hs,
                              Text(
                                'unable_to_load_data'.tr,
                                style: const TextStyle(
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                              ),
                              20.hs,
                            ],
                          ),
                        ),
                      )
                    : pastAppointmentsController.isLoaded.value
                        ? pastAppointmentsController.isAppointmentExist.value
                            ? ListView.builder(
                                itemCount: pastAppointmentsController.nextUrl ==
                                        "null"
                                    ? pastAppointmentsController.list.length
                                    : pastAppointmentsController.list.length +
                                        1,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (pastAppointmentsController.list.length ==
                                      index) {
                                    return const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: LinearProgressIndicator(),
                                    );
                                  } else {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Get.toNamed(
                                            Routes.uAppointmentDetailScreen,
                                            arguments: {
                                              'id': pastAppointmentsController
                                                  .list[index].id
                                                  .toString()
                                            });
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
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
                                                  BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    pastAppointmentsController
                                                        .list[index].image!,
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Image.asset(
                                                      AppImages.tab3dUnselect,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url,
                                                        err) =>
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
                                                        )),
                                              ),
                                            ),
                                            10.ws,
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AppTextWidgets
                                                            .mediumText(
                                                          text:
                                                              pastAppointmentsController
                                                                      .list[
                                                                          index]
                                                                      .name ??
                                                                  "",
                                                          color:
                                                              AppColors.BLACK,
                                                          size: 13,
                                                        ),
                                                        AppTextWidgets.regularText(
                                                            text: pastAppointmentsController
                                                                    .list[index]
                                                                    .departmentName ??
                                                                "",
                                                            size: 11,
                                                            color: AppColors
                                                                .BLACK),
                                                      ],
                                                    ),
                                                  ),
                                                  3.hs,
                                                  Text(
                                                    pastAppointmentsController
                                                            .list[index]
                                                            .address ??
                                                        "",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily:
                                                          AppFontStyleTextStrings
                                                              .regular,
                                                      color: AppColors
                                                          .LIGHT_GREY_TEXT,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            10.ws,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  AppImages.calender,
                                                  height: 17,
                                                  width: 17,
                                                ),
                                                5.hs,
                                                AppTextWidgets.regularText(
                                                    text:
                                                        "${pastAppointmentsController.list[index].date.toString().substring(8)}-${pastAppointmentsController.list[index].date.toString().substring(5, 7)}-${pastAppointmentsController.list[index].date.toString().substring(0, 4)}",
                                                    size: 11,
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT),
                                                AppTextWidgets.regularText(
                                                  text:
                                                      pastAppointmentsController
                                                              .list[index]
                                                              .slot ??
                                                          "",
                                                  color: AppColors.BLACK,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(30.0),
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.noAppointment,
                                    ),
                                    15.hs,
                                    AppTextWidgets.blackTextWithSize(
                                      text: 'not_appointment1'.tr,
                                      size: 11,
                                    ),
                                    3.hs,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppTextWidgets.mediumTextWithSize(
                                          text: 'not_appointment2'.tr,
                                          size: 10,
                                        ),
                                        3.ws,
                                        InkWell(
                                          onTap: () async {
                                            await Get.toNamed(
                                                Routes.specialityScreen);
                                            Get.delete<SpecialityController>();
                                          },
                                          child: AppTextWidgets.blackText(
                                            text: 'not_appointment3'.tr,
                                            size: 10,
                                            color: AppColors.AMBER,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


