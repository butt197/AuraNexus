import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorAppointmentDetails extends GetView<DAppointmentDetailsController> {
  final DAppointmentDetailsController detailsController = Get.put(
    DAppointmentDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: detailsController.willPopScope,
      child: Scaffold(
        backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: CustomAppBar(
            title: 'appointment'.tr,
            isBackArrow: true,
            onPressed: () =>
                Get.back(result: detailsController.areChangesMade.value),
            textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeightDelta: 5,
            ),
          ),
          leading: Container(),
        ),
        body: Obx(
          () => detailsController.isErrorInLoading.value
              ? Container(
                  height: Get.height * .25,
                  alignment: Alignment.center,
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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ],
                  ),
                )
              : detailsController.isLoaded.value
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: detailsController
                                            .doctorAppointmentDetailsClass
                                            .data!
                                            .userImage!,
                                        height: 75,
                                        width: 75,
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  detailsController
                                                      .doctorAppointmentDetailsClass
                                                      .data!
                                                      .userName!,
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
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                              .apStatus
                                                              .value ==
                                                          0
                                                      ? 'appointment_status_1'
                                                            .tr
                                                      : detailsController
                                                                .apStatus
                                                                .value ==
                                                            1
                                                      ? 'appointment_status_2'
                                                            .tr
                                                      : detailsController
                                                                .apStatus
                                                                .value ==
                                                            2
                                                      ? 'appointment_status_3'
                                                            .tr
                                                      : detailsController
                                                                .apStatus
                                                                .value ==
                                                            3
                                                      ? 'appointment_status_4'
                                                            .tr
                                                      : detailsController
                                                                .apStatus
                                                                .value ==
                                                            4
                                                      ? 'appointment_status_5'
                                                            .tr
                                                      : 'appointment_status_6'
                                                            .tr,
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
                                        const SizedBox(height: 5),
                                        Text(
                                          "${detailsController.doctorAppointmentDetailsClass.data!.date.toString().substring(8)}-${detailsController.doctorAppointmentDetailsClass.data!.date.toString().substring(5, 7)}-${detailsController.doctorAppointmentDetailsClass.data!.date.toString().substring(0, 4)}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        Text(
                                          detailsController
                                              .doctorAppointmentDetailsClass
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
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                ),
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
                                                  .doctorAppointmentDetailsClass
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
                                                    .doctorAppointmentDetailsClass
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
                                                    .doctorAppointmentDetailsClass
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
                                                      .doctorAppointmentDetailsClass
                                                      .data!
                                                      .userImage!
                                                      .isNotEmpty
                                                  ? detailsController
                                                        .doctorAppointmentDetailsClass
                                                        .data!
                                                        .userImage!
                                                  : AppImages.defaultUser),
                                            );

                                            StorageService.writeStringData(
                                              key: LocalStorageKeys.callerImage,
                                              value:
                                                  (detailsController
                                                      .doctorAppointmentDetailsClass
                                                      .data!
                                                      .doctorImage!
                                                      .isNotEmpty
                                                  ? detailsController
                                                        .doctorAppointmentDetailsClass
                                                        .data!
                                                        .doctorImage!
                                                  : AppImages.defaultDoctor),
                                            );

                                            StorageService.writeStringData(
                                              key: LocalStorageKeys
                                                  .callReceiverName,
                                              value:
                                                  detailsController
                                                      .doctorAppointmentDetailsClass
                                                      .data!
                                                      .userName ??
                                                  '',
                                            );

                                            callOptionDialog(
                                              callId: detailsController
                                                  .doctorAppointmentDetailsClass
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
                                                    .doctorAppointmentDetailsClass
                                                    .data!
                                                    .userName,
                                                'uid':
                                                    '117${detailsController.userId.value}',
                                                'isUser': true,
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
                              const SizedBox(height: 12),
                              detailsController.apStatus.value == 4
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            shrinkWrap: true,
                                            reverse: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].medicine_name}",
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .reportTextColor,
                                                                height: 1.2,
                                                                fontFamily:
                                                                    AppFontStyleTextStrings
                                                                        .regular,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppTextWidgets.regularText(
                                                              text:
                                                                  'medicine_param_1'
                                                                      .tr,
                                                              color: AppColors
                                                                  .noPrescriptionTextColor,
                                                              size: 12,
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              "${detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].type.toString()[0].toUpperCase()}${detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].type.toString().substring(1)}",
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                height: 1.2,
                                                                color: AppColors
                                                                    .reportTextColor,
                                                                fontFamily:
                                                                    AppFontStyleTextStrings
                                                                        .regular,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppTextWidgets.regularText(
                                                              text:
                                                                  'medicine_param_2'
                                                                      .tr,
                                                              color: AppColors
                                                                  .noPrescriptionTextColor,
                                                              size: 12,
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              "${detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].dosage}",
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                height: 1.2,
                                                                color: AppColors
                                                                    .reportTextColor,
                                                                fontFamily:
                                                                    AppFontStyleTextStrings
                                                                        .regular,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppTextWidgets.regularText(
                                                              text:
                                                                  'medicine_param_3'
                                                                      .tr,
                                                              color: AppColors
                                                                  .noPrescriptionTextColor,
                                                              size: 12,
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            GridView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    4,
                                                                childAspectRatio:
                                                                    2.5,
                                                                mainAxisSpacing:
                                                                    10,
                                                                crossAxisSpacing:
                                                                    10,
                                                              ),
                                                              itemCount: detailsController
                                                                  .doctorAppointmentDetailsClass
                                                                  .prescription!
                                                                  .medicine![i]
                                                                  .time!
                                                                  .length,
                                                              itemBuilder: (context, index) {
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                    border: Border.all(
                                                                      color: AppColors
                                                                          .noPrescriptionTextColor,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        AppTextWidgets.regularText(
                                                                          text: DateFormat.jm().format(
                                                                            DateFormat.Hm().parse(
                                                                              detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].time![index].tTime!,
                                                                            ),
                                                                          ),
                                                                          color:
                                                                              AppColors.reportTextColor,
                                                                          size:
                                                                              14,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 11),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AppTextWidgets.regularText(
                                                            text:
                                                                'medicine_param_4'
                                                                    .tr,
                                                            color: AppColors
                                                                .noPrescriptionTextColor,
                                                            size: 12,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${detailsController.doctorAppointmentDetailsClass.prescription!.medicine![i].repeatDays} Days",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontFamily:
                                                                  AppFontStyleTextStrings
                                                                      .regular,
                                                              color: AppColors
                                                                  .reportTextColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              List<TimeOfDay>
                                                              timeListLocal = detailsController
                                                                  .doctorAppointmentDetailsClass
                                                                  .prescription!
                                                                  .medicine![i]
                                                                  .time!
                                                                  .map(
                                                                    (
                                                                      e,
                                                                    ) => TimeOfDay(
                                                                      hour: int.parse(
                                                                        e.tTime?.split(":").first ??
                                                                            "00",
                                                                      ),
                                                                      minute: int.parse(
                                                                        e.tTime?.split(":").last.split(" ").first ??
                                                                            "00",
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList();
                                                              int
                                                              repeatDaysLocal = detailsController
                                                                  .doctorAppointmentDetailsClass
                                                                  .prescription!
                                                                  .medicine![i]
                                                                  .repeatDays!;

                                                              MedicineData
                                                              medicineDataLocal = MedicineData(
                                                                name: detailsController
                                                                    .doctorAppointmentDetailsClass
                                                                    .prescription!
                                                                    .medicine![i]
                                                                    .medicine_name,
                                                                id: detailsController
                                                                    .doctorAppointmentDetailsClass
                                                                    .prescription!
                                                                    .medicine![i]
                                                                    .medicineId,
                                                                dosage: detailsController
                                                                    .doctorAppointmentDetailsClass
                                                                    .prescription!
                                                                    .medicine![i]
                                                                    .dosage,
                                                                medicineType: detailsController
                                                                    .doctorAppointmentDetailsClass
                                                                    .prescription!
                                                                    .medicine![i]
                                                                    .type
                                                                    .toString(),
                                                              );
                                                              detailsController
                                                                      .localData =
                                                                  detailsController
                                                                      .doctorAppointmentDetailsClass
                                                                      .prescription!
                                                                      .medicine!;
                                                              detailsController
                                                                  .localData
                                                                  .removeAt(i);
                                                              List<
                                                                Map<
                                                                  String,
                                                                  dynamic
                                                                >
                                                              >?
                                                              jsonData = detailsController
                                                                  .localData
                                                                  .map(
                                                                    (e) => {
                                                                      "time":
                                                                          e.time?.map((
                                                                            e,
                                                                          ) {
                                                                            var h = e.tTime?.split(
                                                                              ":",
                                                                            );
                                                                            var m = h?.last
                                                                                .split(
                                                                                  " ",
                                                                                )
                                                                                .first;
                                                                            return {
                                                                              "t_time": "${h?.first.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}",
                                                                            };
                                                                          }).toList() ??
                                                                          [],
                                                                      "medicine_name": e
                                                                          .medicine_name
                                                                          .toString(),
                                                                      "repeat_days": e
                                                                          .repeatDays
                                                                          .toString(),
                                                                      "dosage": e
                                                                          .dosage
                                                                          .toString(),
                                                                      "type": e
                                                                          .type
                                                                          .toString(),
                                                                    },
                                                                  )
                                                                  .toList();

                                                              Get.to(
                                                                MedicinseScreen(
                                                                  updateValue2:
                                                                      true,
                                                                  updateRepeatDays:
                                                                      repeatDaysLocal,
                                                                  timeList: [
                                                                    timeListLocal,
                                                                  ],
                                                                  ll: [
                                                                    medicineDataLocal,
                                                                  ],
                                                                  id: int.parse(
                                                                    detailsController
                                                                        .id,
                                                                  ),
                                                                  oldData: jsonEncode(
                                                                    jsonData.isEmpty
                                                                        ? "No Data"
                                                                        : jsonData,
                                                                  ),
                                                                ),
                                                              )!.then((value) {
                                                                Get.delete<
                                                                  AddMedicineToAppointmentController
                                                                >();
                                                                if (value !=
                                                                    "false") {
                                                                  detailsController
                                                                      .fetchAppointmentDetails();
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              width: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      15,
                                                                    ),
                                                                gradient: const LinearGradient(
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
                                                              ),
                                                              child: SizedBox(
                                                                height: 25,
                                                                width: 25,
                                                                child: SvgPicture.asset(
                                                                  AppImages
                                                                      .editIconSvg,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Get.dialog(
                                                                AlertDialog(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .WHITE,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          5,
                                                                        ),
                                                                  ),
                                                                  title: Center(
                                                                    child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: AppTextWidgets.regularText(
                                                                        text: 'confirmation'
                                                                            .tr,
                                                                        color: AppColors
                                                                            .BLACK,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  content: Text(
                                                                    'delete_medicine'
                                                                        .tr,
                                                                    style: const TextStyle(
                                                                      color: AppColors
                                                                          .BLACK,
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          AppFontStyleTextStrings
                                                                              .regular,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
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
                                                                                gradient: const LinearGradient(
                                                                                  colors: [
                                                                                    AppColors.color1,
                                                                                    AppColors.color2,
                                                                                  ],
                                                                                  begin: Alignment.bottomLeft,
                                                                                  end: Alignment.topRight,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(
                                                                                  8.71,
                                                                                ),
                                                                              ),
                                                                              child: AppTextWidgets.regularText(
                                                                                text: 'cancel'.tr,
                                                                                color: AppColors.WHITE,
                                                                                size: 18,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              detailsController.localData = detailsController.doctorAppointmentDetailsClass.prescription!.medicine!;
                                                                              detailsController.localData.removeAt(
                                                                                i,
                                                                              );
                                                                              List<
                                                                                Map<
                                                                                  String,
                                                                                  dynamic
                                                                                >
                                                                              >?
                                                                              jsonData = detailsController.localData
                                                                                  .map(
                                                                                    (
                                                                                      e,
                                                                                    ) => {
                                                                                      "time":
                                                                                          e.time?.map(
                                                                                            (
                                                                                              e,
                                                                                            ) {
                                                                                              var h = e.tTime?.split(
                                                                                                ":",
                                                                                              );
                                                                                              var m = h?.last
                                                                                                  .split(
                                                                                                    " ",
                                                                                                  )
                                                                                                  .first;
                                                                                              return {
                                                                                                "t_time": "${h?.first.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}",
                                                                                              };
                                                                                            },
                                                                                          ).toList() ??
                                                                                          [],
                                                                                      "medicine_name": e.medicine_name.toString(),
                                                                                      "repeat_days": e.repeatDays.toString(),
                                                                                      "dosage": e.dosage.toString(),
                                                                                      "type": e.type.toString(),
                                                                                    },
                                                                                  )
                                                                                  .toList();

                                                                              Get.back();
                                                                              detailsController.deleteMedicine(
                                                                                jsonData: jsonData,
                                                                              );
                                                                            },
                                                                            child: Container(
                                                                              alignment: Alignment.center,
                                                                              height: 50,
                                                                              width: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                gradient: const LinearGradient(
                                                                                  colors: [
                                                                                    AppColors.color1,
                                                                                    AppColors.color2,
                                                                                  ],
                                                                                  begin: Alignment.bottomLeft,
                                                                                  end: Alignment.topRight,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(
                                                                                  8.71,
                                                                                ),
                                                                              ),
                                                                              child: Text(
                                                                                'delete'.tr,
                                                                                maxLines: 1,
                                                                                style: const TextStyle(
                                                                                  color: AppColors.WHITE,
                                                                                  fontSize: 18,
                                                                                  fontFamily: AppFontStyleTextStrings.regular,
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
                                                            child: Container(
                                                              height: 40,
                                                              width: 45,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      15,
                                                                    ),
                                                                gradient: const LinearGradient(
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
                                                              ),
                                                              child: SizedBox(
                                                                height: 25,
                                                                width: 25,
                                                                child: SvgPicture.asset(
                                                                  AppImages
                                                                      .deleteIconSvg,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                height: 25,
                                                child: Divider(
                                                  color:
                                                      AppColors.LIGHT_GREY_TEXT,
                                                  thickness: 1,
                                                ),
                                              );
                                            },
                                            itemCount:
                                                detailsController
                                                    .doctorAppointmentDetailsClass
                                                    .prescription
                                                    ?.medicine
                                                    ?.length ??
                                                0,
                                          ),
                                          ((detailsController
                                                          .doctorAppointmentDetailsClass
                                                          .prescription
                                                          ?.medicine
                                                          ?.length ??
                                                      0) ==
                                                  0)
                                              ? const SizedBox()
                                              : SizedBox(
                                                  height: 25,
                                                  child: Divider(
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    thickness: 1,
                                                  ),
                                                ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                List<Map<String, dynamic>>?
                                                jsonData = detailsController
                                                    .doctorAppointmentDetailsClass
                                                    .prescription
                                                    ?.medicine
                                                    ?.map(
                                                      (e) => {
                                                        "time":
                                                            e.time?.map((e) {
                                                              var h = e.tTime
                                                                  ?.split(":");
                                                              var m = h?.last
                                                                  .split(" ")
                                                                  .first;
                                                              return {
                                                                "t_time":
                                                                    "${h?.first.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}",
                                                              };
                                                            }).toList() ??
                                                            [],
                                                        "medicine_name": e
                                                            .medicine_name
                                                            .toString(),
                                                        "repeat_days": e
                                                            .repeatDays
                                                            .toString(),
                                                        "dosage": e.dosage
                                                            .toString(),
                                                        "type": e.type
                                                            .toString(),
                                                      },
                                                    )
                                                    .toList();

                                                await Get.toNamed(
                                                  Routes.dSearchMedicineScreen,
                                                  arguments: {
                                                    'medicineMap':
                                                        jsonData == null
                                                        ? null
                                                        : jsonEncode(
                                                            jsonData.isEmpty
                                                                ? "No Data"
                                                                : jsonData,
                                                          ),
                                                    'id': int.parse(
                                                      detailsController.id,
                                                    ),
                                                  },
                                                )?.then((value) {
                                                  if ((value != "false")) {
                                                    detailsController
                                                        .fetchAppointmentDetails();
                                                  }
                                                  Get.delete<
                                                    SearchMedicineController
                                                  >();
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 32,
                                                    width: 32,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                            colors: [
                                                              AppColors.color1,
                                                              AppColors.color2,
                                                            ],
                                                            begin: Alignment
                                                                .bottomLeft,
                                                            end: Alignment
                                                                .topRight,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AppImages.medicineIcon,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'add_prescription'.tr,
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
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'd_add_prescription_msg'
                                                              .tr,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .noPrescriptionTextColor,
                                                            height: 1,
                                                            fontFamily:
                                                                AppFontStyleTextStrings
                                                                    .regular,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    height: 22,
                                                    width: 22,
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons
                                                          .navigate_next_rounded,
                                                      color: AppColors
                                                          .reportTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 12),
                              detailsController.apStatus.value == 4
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                      ),
                                      child: Column(
                                        children: [
                                          GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 0.78,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                ),
                                            itemCount: detailsController
                                                .imageList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  await Get.toNamed(
                                                    Routes.photoViewerScreen,
                                                    arguments: {
                                                      'url':
                                                          ("${Apis.reportImagePath}${detailsController.imageList[index].image}"),
                                                      'id': detailsController
                                                          .imageList[index]
                                                          .id
                                                          .toString(),
                                                      'isDeleteShown': true,
                                                      'reportName':
                                                          detailsController
                                                              .imageList[index]
                                                              .name,
                                                    },
                                                  )?.then((value) {
                                                    Get.delete<
                                                      MyPhotoViewerController
                                                    >();
                                                    if (value ?? false) {
                                                      detailsController
                                                          .fetchAppointmentDetails();
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              ("${Apis.reportImagePath}${detailsController.imageList[index].image}"),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      detailsController
                                                              .imageList[index]
                                                              .name ??
                                                          "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .reportTextColor,
                                                        fontFamily:
                                                            AppFontStyleTextStrings
                                                                .regular,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          detailsController.imageList.isNotEmpty
                                              ? SizedBox(
                                                  height: 25,
                                                  child: Divider(
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    thickness: 1,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Material(
                                            child: InkWell(
                                              onTap: () {
                                                detailsController
                                                    .textEditingController
                                                    .clear();
                                                detailsController.fImage = null;
                                                detailsController
                                                    .showUploadPrescriptionSheetNew();
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 32,
                                                    width: 32,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .appointmentDetailsReportBgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AppImages.reportIcon,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'add_reports'.tr,
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
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'd_add_report_msg'.tr,
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
                                                  Container(
                                                    height: 22,
                                                    width: 22,
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons
                                                          .navigate_next_rounded,
                                                      color: AppColors
                                                          .reportTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        detailsController.button(context: context),
                      ],
                    ),
                    detailsController.button(context: context),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
