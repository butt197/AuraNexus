import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UAllAppointments extends GetView<UAllAppointmentsController> {
  final UAllAppointmentsController appointmentsController =
      Get.put(UAllAppointmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: CustomAppBar(
            title: 'all_appointment'.tr,
            isBackArrow: true,
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          leading: Container(),
        ),
        backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        body: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            controller: appointmentsController.scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: appointmentsController.loadAppointments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 50,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        appointmentsController.isAppointmentExist.value) {
                      return ListView.builder(
                        itemCount:
                            appointmentsController.nextUrl.value == "null"
                                ? appointmentsController.list.length
                                : appointmentsController.list.length +
                                    1 +
                                    (appointmentsController.list.length / 4)
                                        .floor(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (appointmentsController.list.length == index) {
                            return const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: LinearProgressIndicator(),
                            );
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // appointmentListWidget(index, list),
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Get.toNamed(Routes.uAppointmentDetailScreen,
                                        arguments: {
                                          'id': appointmentsController
                                              .list[index].id
                                              .toString()
                                        });
                                  },
                                  child: Container(
                                    height: 90,
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.WHITE,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: appointmentsController
                                                    .list[index].image ??
                                                "",
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.asset(
                                                  AppImages.tab3dUnselect,
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, err) =>
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
                                                    )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextWidgets.mediumText(
                                                    text:
                                                        appointmentsController
                                                                .list[index]
                                                                .name ??
                                                            "",
                                                    color: AppColors.BLACK,
                                                    size: 13,
                                                  ),
                                                  AppTextWidgets.regularText(
                                                      text: appointmentsController
                                                              .list[index]
                                                              .departmentName ??
                                                          "",
                                                      size: 11,
                                                      color: AppColors.BLACK),
                                                ],
                                              ),
                                                                    5.hs,
                                              Text(
                                                appointmentsController
                                                        .list[index]
                                                        .address ??
                                                    "",
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors
                                                      .LIGHT_GREY_TEXT,
                                                  fontSize: 10,
                                                  fontFamily:
                                                      AppFontStyleTextStrings
                                                          .regular,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
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
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            AppTextWidgets.regularText(
                                                text: "${appointmentsController
                                                        .list[index].date
                                                        .toString()
                                                        .substring(8)}-${appointmentsController
                                                        .list[index].date
                                                        .toString()
                                                        .substring(5, 7)}-${appointmentsController
                                                        .list[index].date
                                                        .toString()
                                                        .substring(0, 4)}",
                                                size: 11,
                                                color:
                                                    AppColors.LIGHT_GREY_TEXT),
                                            AppTextWidgets.regularText(
                                              text: appointmentsController
                                                      .list[index].slot ??
                                                  "",
                                              color: AppColors.BLACK,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        },
                      );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(30.0),
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            Image.asset(AppImages.noAppointment),
                            const SizedBox(
                              height: 15,
                            ),
                            AppTextWidgets.blackTextWithSize(
                              text: 'not_appointment1'.tr,
                              size: 11,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: (Get.width - 95) * 0.75,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'not_appointment2'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontFamily:
                                            AppFontStyleTextStrings.medium,
                                        fontSize: 10),
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Get.toNamed(Routes.specialityScreen);
                                    Get.delete<SpecialityController>();
                                  },
                                  child: SizedBox(
                                    width: (Get.width - 95) * 0.25,
                                    child: AppTextWidgets.blackText(
                                        text: 'not_appointment3'.tr,
                                        size: 10,
                                        color: AppColors.AMBER),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}


