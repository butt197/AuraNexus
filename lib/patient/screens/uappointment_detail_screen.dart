import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserAppointmentDetailsScreen
    extends GetView<UserAppointmentDetailsController> {
  final UserAppointmentDetailsController detailsController = Get.put(
    UserAppointmentDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'appointment'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
          textStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 22,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: Obx(
        () => detailsController.isErrorInLoading.value
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
                      const SizedBox(height: 20),
                      Text(
                        'unable_to_load_data'.tr,
                        style: const TextStyle(
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : FutureBuilder(
                future: detailsController.getAppointmentDetails,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  } else {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: detailsController
                                      .doctorAppointmentDetailsClass!
                                      .data!
                                      .doctorImage
                                      .toString(),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Image.asset(
                                        AppImages.tab3dUnselect,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, err) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Image.asset(
                                        AppImages.tab3dUnselect,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            detailsController
                                                .doctorAppointmentDetailsClass!
                                                .data!
                                                .doctorName!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .apply(
                                                  fontWeightDelta: 5,
                                                  fontSizeDelta: 2,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    detailsController.doctorSpeciality.isEmpty
                                        ? const SizedBox()
                                        : Text(
                                            detailsController
                                                .doctorSpeciality
                                                .value,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleSmall!,
                                          ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(
                                          context,
                                        ).primaryColorLight,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            AppImages.timeIcon,
                                            height: 13,
                                            width: 13,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .data!
                                                        .status! ==
                                                    0
                                                ? 'appointment_status_1'.tr
                                                : detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .status! ==
                                                      1
                                                ? 'appointment_status_2'.tr
                                                : detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .status! ==
                                                      2
                                                ? 'appointment_status_3'.tr
                                                : detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .status! ==
                                                      3
                                                ? 'appointment_status_4'.tr
                                                : detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .status! ==
                                                      4
                                                ? 'appointment_status_5'.tr
                                                : 'appointment_status_6'.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .apply(
                                                  fontSizeDelta: 0.5,
                                                  fontWeightDelta: 2,
                                                ),
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    AppImages.calender,
                                    height: 17,
                                    width: 17,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${detailsController.doctorAppointmentDetailsClass!.data!.date.toString().substring(8)}-${detailsController.doctorAppointmentDetailsClass!.data!.date.toString().substring(5, 7)}-${detailsController.doctorAppointmentDetailsClass!.data!.date.toString().substring(0, 4)}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    detailsController
                                        .doctorAppointmentDetailsClass!
                                        .data!
                                        .slot!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(fontWeightDelta: 2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    0,
                                    10,
                                    0,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'email_address'.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .apply(
                                                      fontWeightDelta: 1,
                                                      fontSizeDelta: 1.5,
                                                    ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                detailsController
                                                    .doctorAppointmentDetailsClass!
                                                    .data!
                                                    .email!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .apply(
                                                      fontWeightDelta: 2,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(0.5),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              launch(
                                                Uri(
                                                  scheme: 'mailto',
                                                  path: detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .data!
                                                      .email,
                                                ).toString(),
                                              );
                                            },
                                            child: Image.asset(
                                              AppImages.emailIcon,
                                              height: 45,
                                              width: 45,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'description'.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .apply(
                                                        fontWeightDelta: 1,
                                                        fontSizeDelta: 1.5,
                                                      ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .data!
                                                      .description!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .apply(
                                                        fontWeightDelta: 2,
                                                        color: Theme.of(context)
                                                            .primaryColorDark
                                                            .withOpacity(0.5),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              StorageService.writeStringData(
                                                key: LocalStorageKeys
                                                    .callReceiverImage,
                                                value:
                                                    (detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .data!
                                                        .doctorImage!
                                                        .isNotEmpty
                                                    ? detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .doctorImage!
                                                    : AppImages.defaultDoctor),
                                              );

                                              StorageService.writeStringData(
                                                key: LocalStorageKeys
                                                    .callerImage,
                                                value:
                                                    (detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .data!
                                                        .userImage!
                                                        .isNotEmpty
                                                    ? detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .data!
                                                          .userImage!
                                                    : AppImages.defaultUser),
                                              );

                                              StorageService.writeStringData(
                                                key: LocalStorageKeys
                                                    .callReceiverName,
                                                value:
                                                    detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .data!
                                                        .doctorName ??
                                                    '',
                                              );

                                              callOptionDialog(
                                                callId: detailsController
                                                    .doctorAppointmentDetailsClass!
                                                    .data!
                                                    .connectycubeUserId!
                                                    .toInt(),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    AppColors.color1,
                                                    AppColors.color2,
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 40,
                                              width: 45,
                                              child: const Icon(
                                                Icons.video_call,
                                                color: AppColors.WHITE,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () async {
                                              await Get.toNamed(
                                                Routes.chatScreen,
                                                arguments: {
                                                  'userName': detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .data!
                                                      .doctorName,
                                                  'uid':
                                                      '100${detailsController.doctorId.value}',
                                                  'isUser': false,
                                                },
                                              );
                                              Get.delete<ChatController>();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    AppColors.color1,
                                                    AppColors.color2,
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 40,
                                              width: 45,
                                              child: const Icon(
                                                Icons.chat,
                                                color: AppColors.WHITE,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    0,
                                    10,
                                    0,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 32,
                                            width: 32,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppColors.color1,
                                                  AppColors.color2,
                                                ],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              AppImages.medicineIcon,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'prescription'.tr,
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .reportTextColor,
                                                    height: 1,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        AppFontStyleTextStrings
                                                            .semiBold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  (detailsController
                                                                  .doctorAppointmentDetailsClass!
                                                                  .prescription
                                                                  .toString() ==
                                                              "null" ||
                                                          detailsController
                                                              .doctorAppointmentDetailsClass!
                                                              .prescription!
                                                              .medicine!
                                                              .isEmpty)
                                                      ? 'user_no_prescription_msg'
                                                            .tr
                                                      : 'user_no_prescription_msg1'
                                                            .tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFontStyleTextStrings
                                                            .regular,
                                                    color: AppColors
                                                        .noPrescriptionTextColor,
                                                    height: 1,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      !(detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .prescription
                                                      .toString() ==
                                                  "null" ||
                                              detailsController
                                                  .doctorAppointmentDetailsClass!
                                                  .prescription!
                                                  .medicine!
                                                  .isEmpty)
                                          ? SizedBox(
                                              height: 25,
                                              child: Divider(
                                                color:
                                                    AppColors.LIGHT_GREY_TEXT,
                                                thickness: 1,
                                              ),
                                            )
                                          : const SizedBox(),
                                      (detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .prescription
                                                      .toString() ==
                                                  "null" ||
                                              detailsController
                                                  .doctorAppointmentDetailsClass!
                                                  .prescription!
                                                  .medicine!
                                                  .isEmpty)
                                          ? const SizedBox()
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, i) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].medicine_name}",
                                                                  maxLines: 2,
                                                                  style: const TextStyle(
                                                                    fontFamily:
                                                                        AppFontStyleTextStrings
                                                                            .regular,
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .BLACK,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              AppTextWidgets.regularText(
                                                                text:
                                                                    'medicine_param1'
                                                                        .tr,
                                                                color: AppColors
                                                                    .BLACK,
                                                                size: 14,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              AppTextWidgets.regularText(
                                                                text:
                                                                    "${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].type.toString().substring(0, 1).toUpperCase()}${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].type.toString().substring(1).toLowerCase()}",
                                                                color: AppColors
                                                                    .LIGHT_GREY_TEXT,
                                                                size: 14,
                                                              ),
                                                              const Spacer(),
                                                              AppTextWidgets.regularText(
                                                                text:
                                                                    'medicine_param2'
                                                                        .tr,
                                                                color: AppColors
                                                                    .BLACK,
                                                                size: 14,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              AppTextWidgets.regularText(
                                                                text:
                                                                    "${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].dosage}",
                                                                color: AppColors
                                                                    .LIGHT_GREY_TEXT,
                                                                size: 14,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          5,
                                                                    ),
                                                                child: AppTextWidgets.regularText(
                                                                  text:
                                                                      'medicine_param3'
                                                                          .tr,
                                                                  color:
                                                                      AppColors
                                                                          .BLACK,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Wrap(
                                                                      crossAxisAlignment:
                                                                          WrapCrossAlignment
                                                                              .start,
                                                                      runSpacing:
                                                                          15,
                                                                      spacing:
                                                                          8,
                                                                      children: [
                                                                        for (
                                                                          int
                                                                          j = 0;
                                                                          j <
                                                                              detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].time!.length;
                                                                          j++
                                                                        )
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                65,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                5,
                                                                              ),
                                                                              border: Border.all(
                                                                                color: AppColors.color1,
                                                                              ),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 6,
                                                                            ),
                                                                            child: AppTextWidgets.regularText(
                                                                              text: "${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].time![j].tTime}",
                                                                              color: AppColors.BLACK,
                                                                              size: 12,
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          AppTextWidgets.regularText(
                                                            text: 'consume_it_days'
                                                                .trParams({
                                                                  'days':
                                                                      '${detailsController.doctorAppointmentDetailsClass!.prescription!.medicine![i].repeatDays}',
                                                                }),
                                                            color: AppColors
                                                                .LIGHT_GREY_TEXT,
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                    return SizedBox(
                                                      height: 25,
                                                      child: Divider(
                                                        color: AppColors
                                                            .LIGHT_GREY_TEXT,
                                                        thickness: 1,
                                                      ),
                                                    );
                                                  },
                                              itemCount: detailsController
                                                  .doctorAppointmentDetailsClass!
                                                  .prescription!
                                                  .medicine!
                                                  .length,
                                            ),
                                      SizedBox(
                                        height:
                                            (detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .prescription
                                                        .toString() ==
                                                    "null" ||
                                                detailsController
                                                    .doctorAppointmentDetailsClass!
                                                    .prescription!
                                                    .medicine!
                                                    .isEmpty)
                                            ? 0
                                            : 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (detailsController
                                                          .doctorAppointmentDetailsClass!
                                                          .prescription
                                                          .toString() ==
                                                      "null" ||
                                                  detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .prescription!
                                                      .medicine!
                                                      .isEmpty)
                                              ? const SizedBox()
                                              : Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await Get.toNamed(
                                                        Routes
                                                            .uAppointmentPdfScreen,
                                                        arguments: {
                                                          'appointmentId':
                                                              int.parse(
                                                                detailsController
                                                                    .id,
                                                              ),
                                                        },
                                                      );
                                                      Get.delete<
                                                        AppointmentDetailsScreenPdfController
                                                      >();
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                AppColors
                                                                    .color1,
                                                                AppColors
                                                                    .color2,
                                                              ],
                                                              begin: Alignment
                                                                  .bottomLeft,
                                                              end: Alignment
                                                                  .topRight,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.71,
                                                            ),
                                                      ),
                                                      child: AutoSizeText(
                                                        'download_prescription'
                                                            .tr,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              AppFontStyleTextStrings
                                                                  .regular,
                                                          fontSize: 18,
                                                          color:
                                                              AppColors.WHITE,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            (detailsController
                                                        .doctorAppointmentDetailsClass!
                                                        .prescription
                                                        .toString() ==
                                                    "null" ||
                                                detailsController
                                                    .doctorAppointmentDetailsClass!
                                                    .prescription!
                                                    .medicine!
                                                    .isEmpty)
                                            ? 0
                                            : 5,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    0,
                                    10,
                                    0,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 32,
                                            width: 32,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .appointmentDetailsReportBgColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              AppImages.reportIcon,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'report'.tr,
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .reportTextColor,
                                                    height: 1,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        AppFontStyleTextStrings
                                                            .medium,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  (detailsController
                                                                  .doctorAppointmentDetailsClass!
                                                                  .image
                                                                  ?.length ??
                                                              0) ==
                                                          0
                                                      ? 'user_no_report_msg'.tr
                                                      : 'user_no_report_msg1'
                                                            .tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFontStyleTextStrings
                                                            .regular,
                                                    color: AppColors
                                                        .noPrescriptionTextColor,
                                                    height: 1,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                      (detailsController
                                                      .doctorAppointmentDetailsClass!
                                                      .image
                                                      ?.length ??
                                                  0) !=
                                              0
                                          ? SizedBox(
                                              height: 25,
                                              child: Divider(
                                                color:
                                                    AppColors.LIGHT_GREY_TEXT,
                                                thickness: 1,
                                              ),
                                            )
                                          : const SizedBox(),
                                      ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 25,
                                            child: Divider(
                                              color: AppColors.LIGHT_GREY_TEXT,
                                              thickness: 1,
                                            ),
                                          );
                                        },
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            detailsController
                                                .doctorAppointmentDetailsClass!
                                                .image
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, i) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppColors
                                                          .LIGHT_GREY_TEXT,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          ("${Apis.reportImagePath}${detailsController.doctorAppointmentDetailsClass!.image![i].image}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                10.ws,
                                                Expanded(
                                                  child: AppTextWidgets.regularText(
                                                    text:
                                                        "${detailsController.doctorAppointmentDetailsClass!.image![i].name}",
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    size: 18,
                                                  ),
                                                ),
                                                10.ws,
                                                GestureDetector(
                                                  onTap: () async {
                                                    customDialog1(
                                                      s1: 'reporting_dialog1'
                                                          .tr,
                                                      s2: 'please_wait_while_processing'
                                                          .tr,
                                                    );
                                                    await detailsController
                                                        .downloadAndSaveImage(
                                                          ("${Apis.reportImagePath}${detailsController.doctorAppointmentDetailsClass!.image![i].image}"),
                                                        )
                                                        .then((value) {
                                                          if (value) {
                                                            Get.back();
                                                            customDialog(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              s1: 'success'.tr,
                                                              s2: 'image_save_success'
                                                                  .tr,
                                                            );
                                                          }
                                                        });
                                                  },
                                                  child: const Icon(
                                                    Icons.download,
                                                    color: AppColors.color1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
      ),
    );
  }
}
