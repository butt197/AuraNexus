import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class MakeAppointment extends GetView<MakeAppointmentController> {
  final MakeAppointmentController makeAppointmentController = Get.put(
    MakeAppointmentController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: makeAppointmentController.name,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: Obx(
        () => Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                onTap: () {
                  makeAppointmentController.processPayment(context: context);
                },
                btnText: 'make_an_appointment'.tr,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: SingleChildScrollView(
                controller: makeAppointmentController.scrollController,
                child: Column(
                  children: [
                    Container(
                      height: 130,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 30,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              if (makeAppointmentController
                                      .previousSelectedIndex
                                      .value ==
                                  i)
                                return;
                              if (i == 0) {
                                makeAppointmentController.isToday.value = true;
                              } else {
                                makeAppointmentController.isToday.value = false;
                              }
                              makeAppointmentController
                                      .isSelected[makeAppointmentController
                                          .previousSelectedIndex
                                          .value]
                                      .value =
                                  false;
                              makeAppointmentController.isSelected[i].value =
                                  !makeAppointmentController
                                      .isSelected[i]
                                      .value;
                              makeAppointmentController
                                      .previousSelectedIndex
                                      .value =
                                  i;
                              makeAppointmentController.date =
                                  DateFormat('yyyy-MM-dd').format(
                                    makeAppointmentController.dateTime.add(
                                      Duration(days: i),
                                    ),
                                  );

                              makeAppointmentController.checkIfHoliday(
                                makeAppointmentController.date,
                                false,
                                i: i,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                              decoration: BoxDecoration(
                                color:
                                    makeAppointmentController
                                        .isSelected[i]
                                        .value
                                    ? AppColors.AMBER
                                    : AppColors.WHITE,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                10,
                                10,
                                10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextWidgets.mediumText(
                                    text:
                                        makeAppointmentController
                                            .days[makeAppointmentController
                                            .dateTime
                                            .add(Duration(days: i))
                                            .weekday],
                                    color:
                                        makeAppointmentController
                                            .isSelected[i]
                                            .value
                                        ? AppColors.WHITE
                                        : AppColors.BLACK,
                                    size: 10,
                                  ),
                                  AppTextWidgets.mediumText(
                                    text: makeAppointmentController.dateTime
                                        .add(Duration(days: i))
                                        .day
                                        .toString(),
                                    color:
                                        makeAppointmentController
                                            .isSelected[i]
                                            .value
                                        ? AppColors.WHITE
                                        : AppColors.LIGHT_GREY_TEXT,
                                    size: 20,
                                  ),
                                  Container(
                                    width: 50,
                                    child: Divider(
                                      color:
                                          makeAppointmentController
                                              .isSelected[i]
                                              .value
                                          ? AppColors.WHITE
                                          : AppColors.LIGHT_GREY_TEXT,
                                      height: 20,
                                    ),
                                  ),
                                  AppTextWidgets.mediumText(
                                    text:
                                        "${makeAppointmentController.months[makeAppointmentController.dateTime.add(Duration(days: i)).month - 1]}, ${makeAppointmentController.dateTime.add(Duration(days: i)).year}",
                                    color:
                                        makeAppointmentController
                                            .isSelected[i]
                                            .value
                                        ? AppColors.WHITE
                                        : AppColors.LIGHT_GREY_TEXT,
                                    size: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    !makeAppointmentController.isLoading.value ||
                            !makeAppointmentController.isLoading1.value
                        ? makeAppointmentController.isNoSlot.value
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: AppTextWidgets.regularText(
                                      text: 'no_slot_available'.tr,
                                      size: 15,
                                      color: AppColors.LIGHT_GREY_TEXT,
                                    ),
                                  ),
                                )
                              : makeAppointmentController.isChecked.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : makeAppointmentController
                                    .checkHolidayFuture
                                    .value
                              ? Column(
                                  children: [
                                    const SizedBox(height: 200),
                                    AppTextWidgets.mediumTextWithSize(
                                      text: 'doc_on_leave_title'.tr,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        'doc_on_leave_description'.trParams({
                                          'date':
                                              makeAppointmentController.date,
                                        }),
                                        style: TextStyle(
                                          color: AppColors.LIGHT_GREY_TEXT,
                                          fontSize: 14,
                                          fontFamily:
                                              AppFontStyleTextStrings.regular,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )
                              : Obx(
                                  () => Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          0,
                                          10,
                                          0,
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: makeAppointmentController
                                              .makeAppointmentClass!
                                              .data!
                                              .length,
                                          itemBuilder: (context, i) {
                                            return InkWell(
                                              onTap: () {
                                                makeAppointmentController
                                                        .selectedSlot[makeAppointmentController
                                                            .previousSelectedSlot
                                                            .value]
                                                        .value =
                                                    false;
                                                makeAppointmentController
                                                        .selectedSlot[i]
                                                        .value =
                                                    !makeAppointmentController
                                                        .selectedSlot[i]
                                                        .value;
                                                makeAppointmentController
                                                        .previousSelectedSlot
                                                        .value =
                                                    i;
                                                makeAppointmentController
                                                    .initializeTimeSlots(i);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                height: 90,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                      8,
                                                      10,
                                                      8,
                                                      10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      makeAppointmentController
                                                          .selectedSlot[i]
                                                          .value
                                                      ? AppColors.AMBER
                                                      : AppColors.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      height: 45,
                                                      width: 45,
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            makeAppointmentController
                                                                .selectedSlot[i]
                                                                .value
                                                            ? AppColors.WHITE
                                                            : AppColors
                                                                  .LIGHT_GREY_SCREEN_BACKGROUND,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          makeAppointmentController
                                                                  .selectedSlot[i]
                                                                  .value
                                                              ? AppImages
                                                                    .dayActive
                                                              : AppImages
                                                                    .dayUnActive,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    AppTextWidgets.regularText(
                                                      text:
                                                          makeAppointmentController
                                                              .makeAppointmentClass!
                                                              .data![i]
                                                              .title ??
                                                          "",
                                                      color:
                                                          makeAppointmentController
                                                              .selectedSlot[i]
                                                              .value
                                                          ? AppColors.WHITE
                                                          : AppColors.BLACK,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      GridView.count(
                                        crossAxisCount: 3,
                                        padding: const EdgeInsets.all(10),
                                        shrinkWrap: true,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: 1.8,
                                        physics: const ClampingScrollPhysics(),
                                        children: List.generate(
                                          makeAppointmentController
                                                  .makeAppointmentClass!
                                                  .data![makeAppointmentController
                                                      .currentSlotsIndex
                                                      .value]
                                                  .slottime
                                                  ?.length ??
                                              0,
                                          (ind) {
                                            int i = ind;
                                            List<Slottime>
                                            list = makeAppointmentController
                                                .makeAppointmentClass!
                                                .data![makeAppointmentController
                                                    .currentSlotsIndex
                                                    .value]
                                                .slottime!;
                                            return InkWell(
                                              onTap: () {
                                                if (list[i].isBook == "1") {
                                                  Fluttertoast.showToast(
                                                    msg: 'no_slot_available'.tr,
                                                    timeInSecForIosWeb: 2,
                                                  );
                                                } else if (makeAppointmentController
                                                    .isPastSlot(list[i])) {
                                                  Fluttertoast.showToast(
                                                    msg: 'past_time_slots'.tr,
                                                    timeInSecForIosWeb: 2,
                                                  );
                                                } else {
                                                  makeAppointmentController
                                                      .slotId
                                                      .value = list[i].id
                                                      .toString();
                                                  makeAppointmentController
                                                          .slotName
                                                          .value =
                                                      list[i].name!;
                                                  makeAppointmentController
                                                          .selectedTimingSlot[makeAppointmentController
                                                                      .previousSelectedTimingSlot >
                                                                  list.length
                                                              ? 0
                                                              : makeAppointmentController
                                                                    .previousSelectedTimingSlot
                                                                    .value]
                                                          .value =
                                                      false;
                                                  makeAppointmentController
                                                          .selectedTimingSlot[i]
                                                          .value =
                                                      !makeAppointmentController
                                                          .selectedTimingSlot[i]
                                                          .value;
                                                  makeAppointmentController
                                                          .previousSelectedTimingSlot
                                                          .value =
                                                      i;
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                height: 90,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                      5,
                                                      5,
                                                      5,
                                                      5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      (list[i].isBook == "1" ||
                                                          makeAppointmentController
                                                              .isPastSlot(
                                                                list[i],
                                                              ))
                                                      ? AppColors.grey
                                                            .withOpacity(0.1)
                                                      : makeAppointmentController
                                                            .selectedTimingSlot[i]
                                                            .value
                                                      ? AppColors.AMBER
                                                      : AppColors.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      list[i].isBook == "1"
                                                          ? AppImages
                                                                .timeUnActive
                                                          : makeAppointmentController
                                                                .selectedTimingSlot[i]
                                                                .value
                                                          ? AppImages.timeActive
                                                          : AppImages
                                                                .timeUnActive,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: AppTextWidgets.mediumText(
                                                        text:
                                                            list[i].name ?? "",
                                                        color:
                                                            (list[i].isBook ==
                                                                    "1" ||
                                                                makeAppointmentController
                                                                    .isPastSlot(
                                                                      list[i],
                                                                    ))
                                                            ? AppColors.grey
                                                                  .withOpacity(
                                                                    0.5,
                                                                  )
                                                            : makeAppointmentController
                                                                  .selectedTimingSlot[i]
                                                                  .value
                                                            ? AppColors.WHITE
                                                            : AppColors.BLACK,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          0,
                                        ),
                                        child: Column(
                                          children: [
                                            EditTextField(
                                              editingController:
                                                  makeAppointmentController
                                                      .textEditingController,
                                              labelText: 'phone_number'.tr,
                                              errorText:
                                                  makeAppointmentController
                                                      .isPhoneError
                                                      .value
                                                  ? 'mobile_error_2'.trParams({
                                                      'length': PHONE_LENGTH
                                                          .toString(),
                                                    })
                                                  : null,
                                              keyboardType: TextInputType.phone,
                                              onChanged: (val) {
                                                makeAppointmentController
                                                        .isPhoneError
                                                        .value =
                                                    false;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            EditTextField(
                                              editingController:
                                                  makeAppointmentController
                                                      .textEditingController1,
                                              labelText: 'description'.tr,
                                              errorText:
                                                  makeAppointmentController
                                                      .isDescriptionEmpty
                                                      .value
                                                  ? 'common_textfield_error'.tr
                                                  : null,
                                              keyboardType: TextInputType.name,
                                              onChanged: (val) {
                                                makeAppointmentController
                                                        .isDescriptionEmpty
                                                        .value =
                                                    false;
                                                makeAppointmentController
                                                        .description
                                                        .value =
                                                    val;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        : const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
