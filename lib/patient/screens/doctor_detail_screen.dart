import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DoctorDetailScreen extends GetView<DoctorDetailController> {
  final DoctorDetailController detailController = Get.put(
    DoctorDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          title: 'doctor_detail'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
        leading: Container(),
      ),
      body: Obx(
        () => Stack(
          children: [
            detailController.isErrorInLoading.value
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        10.hs,
                        Icon(
                          Icons.search_off_rounded,
                          size: 100,
                          color: AppColors.LIGHT_GREY_TEXT,
                        ),
                        20.hs,
                        Text(
                          'unable_to_load_data'.tr,
                          style: const TextStyle(
                            fontFamily: AppFontStyleTextStrings.regular,
                          ),
                        ),
                      ],
                    ),
                  )
                : !detailController.isLoading.value
                ? Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                  10,
                                  10,
                                  10,
                                  10,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.WHITE,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: detailController
                                            .doctorDetailsClass!
                                            .data!
                                            .image!,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: Theme.of(
                                                context,
                                              ).primaryColorLight,
                                              child: Center(
                                                child: Image.asset(
                                                  AppImages.tab3dUnselect,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, err) =>
                                            Container(
                                              color: Theme.of(
                                                context,
                                              ).primaryColorLight,
                                              child: Center(
                                                child: Image.asset(
                                                  AppImages.tab3dUnselect,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                            ),
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
                                          AppTextWidgets.mediumText(
                                            text:
                                                detailController
                                                    .doctorDetailsClass!
                                                    .data!
                                                    .name ??
                                                "",
                                            color: AppColors.BLACK,
                                            size: 16,
                                          ),
                                          2.hs,
                                          AppTextWidgets.regularText(
                                            text:
                                                detailController
                                                    .doctorDetailsClass!
                                                    .data!
                                                    .departmentName ??
                                                "",
                                            size: 14,
                                            color: AppColors.LIGHT_GREY_TEXT,
                                          ),
                                          4.hs,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Expanded(
                                                                child: Image.asset(
                                                                  detailController
                                                                              .doctorDetailsClass!
                                                                              .data!
                                                                              .avgratting ==
                                                                          null
                                                                      ? AppImages
                                                                            .starNoFill
                                                                      : detailController.doctorDetailsClass!.data!.avgratting! >=
                                                                            1
                                                                      ? AppImages
                                                                            .starFill
                                                                      : AppImages
                                                                            .starNoFill,
                                                                  height: 17,
                                                                  width: 17,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Image.asset(
                                                                  detailController
                                                                              .doctorDetailsClass!
                                                                              .data!
                                                                              .avgratting ==
                                                                          null
                                                                      ? AppImages
                                                                            .starNoFill
                                                                      : detailController.doctorDetailsClass!.data!.avgratting! >=
                                                                            2
                                                                      ? AppImages
                                                                            .starFill
                                                                      : AppImages
                                                                            .starNoFill,
                                                                  height: 17,
                                                                  width: 17,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Image.asset(
                                                                  detailController
                                                                              .doctorDetailsClass!
                                                                              .data!
                                                                              .avgratting ==
                                                                          null
                                                                      ? AppImages
                                                                            .starNoFill
                                                                      : detailController.doctorDetailsClass!.data!.avgratting! >=
                                                                            3
                                                                      ? AppImages
                                                                            .starFill
                                                                      : AppImages
                                                                            .starNoFill,
                                                                  height: 17,
                                                                  width: 17,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Image.asset(
                                                                  detailController
                                                                              .doctorDetailsClass!
                                                                              .data!
                                                                              .avgratting ==
                                                                          null
                                                                      ? AppImages
                                                                            .starNoFill
                                                                      : detailController.doctorDetailsClass!.data!.avgratting! >=
                                                                            4
                                                                      ? AppImages
                                                                            .starFill
                                                                      : AppImages
                                                                            .starNoFill,
                                                                  height: 17,
                                                                  width: 17,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Image.asset(
                                                                  detailController
                                                                              .doctorDetailsClass!
                                                                              .data!
                                                                              .avgratting ==
                                                                          null
                                                                      ? AppImages
                                                                            .starNoFill
                                                                      : detailController.doctorDetailsClass!.data!.avgratting! >=
                                                                            5
                                                                      ? AppImages
                                                                            .starFill
                                                                      : AppImages
                                                                            .starNoFill,
                                                                  height: 17,
                                                                  width: 17,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          (1.5).hs,
                                                        ],
                                                      ),
                                                    ),
                                                    AppTextWidgets.regularText(
                                                      text:
                                                          " (${detailController.doctorDetailsClass!.data!.totalReview} ${'review_str'.tr})",
                                                      size: 8,
                                                      color: AppColors
                                                          .LIGHT_GREY_TEXT,
                                                    ),
                                                    10.ws,
                                                    InkWell(
                                                      onTap: () async {
                                                        await Get.toNamed(
                                                          Routes
                                                              .doctorReviewScreen,
                                                          arguments: {
                                                            'id': detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .id
                                                                .toString(),
                                                          },
                                                        )?.then((value) {
                                                          Get.delete<
                                                            ReviewController
                                                          >();
                                                          if (value ?? false) {
                                                            detailController
                                                                .fetchDoctorDetails();
                                                          }
                                                        });
                                                      },
                                                      child:
                                                          AppTextWidgets.mediumText(
                                                            text:
                                                                "see_all_review"
                                                                    .tr,
                                                            color: Theme.of(
                                                              context,
                                                            ).hintColor,
                                                            size: 11,
                                                          ),
                                                    ),
                                                    10.ws,
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppColors.WHITE,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .aboutus ==
                                                  null
                                              ? " "
                                              : 'about'.tr,
                                          color: AppColors.BLACK,
                                          size: 15,
                                        ),
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .aboutus ==
                                                  null
                                              ? " "
                                              : detailController
                                                    .doctorDetailsClass!
                                                    .data!
                                                    .aboutus
                                                    .toString(),
                                          color: AppColors.LIGHT_GREY_TEXT,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                    15.hs,
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .address ==
                                                            null
                                                        ? Container()
                                                        : Image.asset(
                                                            AppImages
                                                                .locationPin,
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                    5.ws,
                                                    AppTextWidgets.mediumText(
                                                      text:
                                                          detailController
                                                                  .doctorDetailsClass!
                                                                  .data!
                                                                  .address ==
                                                              null
                                                          ? " "
                                                          : 'address'.tr,
                                                      color: AppColors.BLACK,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                        20,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: AppTextWidgets.mediumText(
                                                    text:
                                                        detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .address ==
                                                            null
                                                        ? " "
                                                        : detailController
                                                              .doctorDetailsClass!
                                                              .data!
                                                              .address
                                                              .toString(),
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    size: 10,
                                                  ),
                                                ),
                                                10.hs,
                                                Row(
                                                  children: [
                                                    detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .workingTime ==
                                                            null
                                                        ? Container()
                                                        : Image.asset(
                                                            AppImages.time,
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                    5.ws,
                                                    AppTextWidgets.mediumText(
                                                      text:
                                                          detailController
                                                                  .doctorDetailsClass!
                                                                  .data!
                                                                  .workingTime ==
                                                              null
                                                          ? " "
                                                          : 'working_time'.tr,
                                                      color: AppColors.BLACK,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                        20,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: AppTextWidgets.mediumText(
                                                    text:
                                                        detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .workingTime ==
                                                            null
                                                        ? " "
                                                        : detailController
                                                              .doctorDetailsClass!
                                                              .data!
                                                              .workingTime
                                                              .toString(),
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    size: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          50.hs,
                                          Expanded(
                                            flex: 2,
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: InkWell(
                                                      onTap: () {
                                                        detailController.openMap(
                                                          double.parse(
                                                            detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .lat!,
                                                          ),
                                                          double.parse(
                                                            detailController
                                                                .doctorDetailsClass!
                                                                .data!
                                                                .lon!,
                                                          ),
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        child: Stack(
                                                          children: [
                                                            detailController
                                                                        .doctorDetailsClass!
                                                                        .data!
                                                                        .address ==
                                                                    null
                                                                ? Container()
                                                                : Image.asset(
                                                                    AppImages
                                                                        .mapIcon,
                                                                    height: 110,
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    15.hs,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .services ==
                                                  null
                                              ? " "
                                              : 'services'.tr,
                                          color: AppColors.BLACK,
                                          size: 15,
                                        ),
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .services ==
                                                  null
                                              ? ""
                                              : detailController
                                                    .doctorDetailsClass!
                                                    .data!
                                                    .services
                                                    .toString(),
                                          color: AppColors.LIGHT_GREY_TEXT,
                                          size: 10,
                                        ),
                                        8.hs,
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .healthcare ==
                                                  null
                                              ? " "
                                              : 'health_care'.tr,
                                          color: AppColors.BLACK,
                                          size: 15,
                                        ),
                                        AppTextWidgets.mediumText(
                                          text:
                                              detailController
                                                      .doctorDetailsClass!
                                                      .data!
                                                      .healthcare ==
                                                  null
                                              ? " "
                                              : detailController
                                                    .doctorDetailsClass!
                                                    .data!
                                                    .healthcare
                                                    .toString(),
                                          color: AppColors.LIGHT_GREY_TEXT,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              80.hs,
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: InkWell(
                            onTap: () {
                              detailController.processPayment();
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
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
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Center(
                                  child: detailController.isLoggedIn.value
                                      ? Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    20,
                                                    5,
                                                    0,
                                                    5,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppTextWidgets.mediumText(
                                                    text:
                                                        "${CURRENCY.trim()}${detailController.doctorDetailsClass!.data!.consultationFee ?? 'not_specified'.tr}",
                                                    color: AppColors.WHITE,
                                                    size: 18,
                                                  ),
                                                  AppTextWidgets.mediumText(
                                                    text: 'book_now'.tr,
                                                    color: AppColors.WHITE,
                                                    size: 9,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            5.ws,
                                            Container(
                                              height: 70,
                                              child: const VerticalDivider(
                                                color: AppColors.WHITE,
                                                indent: 5,
                                                thickness: 0.5,
                                                endIndent: 5,
                                              ),
                                            ),
                                            Expanded(child: 0.ws),
                                            AppTextWidgets.mediumText(
                                              text: 'book_now'.tr,
                                              color: AppColors.WHITE,
                                              size: 16,
                                            ),
                                            3.ws,
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: AppColors.WHITE,
                                              size: 16,
                                            ),
                                            12.ws,
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        20,
                                                        5,
                                                        0,
                                                        5,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppTextWidgets.mediumText(
                                                        text:
                                                            "${CURRENCY.trim()}${detailController.doctorDetailsClass!.data!.consultationFee ?? 'not_specified'.tr}",
                                                        color: AppColors.WHITE,
                                                        size: 18,
                                                      ),
                                                      AppTextWidgets.mediumText(
                                                        text: 'appointment_fee'
                                                            .tr,
                                                        color: AppColors.WHITE,
                                                        size: 9,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                5.ws,
                                                Container(
                                                  height: 70,
                                                  child: const VerticalDivider(
                                                    color: AppColors.WHITE,
                                                    indent: 5,
                                                    thickness: 0.5,
                                                    endIndent: 5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 12,
                                                  left: 10,
                                                ),
                                                child: Text(
                                                  'login_to_book_appointment'
                                                      .tr,
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        AppFontStyleTextStrings
                                                            .medium,
                                                    color: AppColors.WHITE,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
