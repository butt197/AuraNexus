import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class StepThreeDetailsScreen extends GetView<StepThreeDetailsController> {
  final StepThreeDetailsController threeDetailsController =
      Get.find<StepThreeDetailsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: threeDetailsController.onWillPopScope,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          flexibleSpace: CustomAppBar(
            title: 'profile_str'.tr,
            textStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: Theme.of(context).scaffoldBackgroundColor),
            isBackArrow: true,
            onPressed: () => Get.back(),
          ),
          leading: Container(),
        ),
        body: Stack(
          children: [
            Obx(() => threeDetailsController.isErrorInLoading.value
                ? Center(
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
                      )
                    ],
                  ),
                )
                : threeDetailsController.isDataLoaded.value
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount:
                                  threeDetailsController.slotsData.length,
                              itemBuilder: (context, i) {
                                return Visibility(
                                  visible: threeDetailsController.id ==
                                      threeDetailsController.slotsData[i].dayId
                                          .toString(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    color: AppColors.WHITE,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextWidgets.blackText(
                                                    text: 'start_time'.tr,
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.6),
                                                    size: 12,
                                                  ),
                                                  5.hs,
                                                  Stack(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            threeDetailsController
                                                                .textEditingControllerStartTime[i],
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "--:--",
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(10,
                                                                      0, 10, 0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                        0.6)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                        0.6)),
                                                          ),
                                                          suffixIcon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Image.asset(
                                                              AppImages
                                                                  .timeIcon,
                                                              height: 5,
                                                              width: 5,
                                                            ),
                                                          ),
                                                        ),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              5),
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  "[0-9:]")),
                                                          MaskedTextInputFormatter(
                                                            mask: '00:00',
                                                            separator: ':',
                                                          ),
                                                        ],
                                                        onTap: () {
                                                          threeDetailsController
                                                              .selectTime(
                                                                  i, true);
                                                        },
                                                        onChanged: (val) {
                                                          threeDetailsController
                                                                  .startTime[
                                                              i] = val;
                                                          threeDetailsController
                                                                  .isError[i] =
                                                              false.obs;
                                                          threeDetailsController
                                                                  .selectedvValue[
                                                              i] = null;
                                                        },
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            threeDetailsController
                                                                .selectTime(
                                                                    i, true);
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            color: AppColors
                                                                .transparentColor,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            10.ws,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextWidgets.blackText(
                                                    text: 'end_time'.tr,
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.6),
                                                    size: 12,
                                                  ),
                                                  5.hs,
                                                  Stack(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            threeDetailsController
                                                                .textEditingControllerEndTime[i],
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "--:--",
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                                suffixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          15.0),
                                                                  child: Image
                                                                      .asset(
                                                                    AppImages
                                                                        .timeIcon,
                                                                    height: 5,
                                                                    width: 5,
                                                                  ),
                                                                )),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              5),
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  "[0-9:]")),
                                                          MaskedTextInputFormatter(
                                                            mask: '00:00',
                                                            separator: ':',
                                                          ),
                                                        ],
                                                        onTap: () {
                                                          threeDetailsController
                                                              .selectTime(
                                                                  i, false);
                                                        },
                                                        onChanged: (val) {
                                                          threeDetailsController
                                                              .endTime[i] = val;
                                                          threeDetailsController
                                                                  .isError[i] =
                                                              false.obs;
                                                          threeDetailsController
                                                                  .selectedvValue[
                                                              i] = null;
                                                        },
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            threeDetailsController
                                                                .selectTime(
                                                                    i, false);
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            color: AppColors
                                                                .transparentColor,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            10.ws,
                                            InkWell(
                                              onTap: () {
                                                threeDetailsController.slotsData
                                                    .removeAt(i);
                                                threeDetailsController
                                                    .errorMessage
                                                    .removeAt(i);
                                                threeDetailsController.startTime
                                                    .removeAt(i);
                                                threeDetailsController.endTime
                                                    .removeAt(i);
                                                threeDetailsController.slotsList
                                                    .removeAt(i);
                                                threeDetailsController
                                                    .selectedvValue
                                                    .removeAt(i);
                                                threeDetailsController
                                                    .textEditingControllerStartTime
                                                    .removeAt(i);
                                                threeDetailsController
                                                    .textEditingControllerEndTime
                                                    .removeAt(i);
                                              },
                                              child: Image.asset(
                                                AppImages.deleteRectangle,
                                                width: 60,
                                                height: 50,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.hs,
                                        Obx(
                                          () => threeDetailsController
                                                  .isError[i].value
                                              ? Row(
                                                  children: [
                                                    AppTextWidgets.blackText(
                                                      text:
                                                          threeDetailsController
                                                              .errorMessage[i],
                                                      color: AppColors.RED800,
                                                      size: 10,
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ),
                                        10.hs,
                                        Obx(() => Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.4),
                                                    width: 1),
                                              ),
                                              child: DropdownButton(
                                                hint:
                                                    Text("select_interval".tr),
                                                items: threeDetailsController
                                                    .slotsInterval
                                                    .map((x) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      x,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.BLACK),
                                                    ),
                                                    value: x,
                                                  );
                                                }).toList(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                onChanged: (val) {
                                                  threeDetailsController
                                                          .selectedvValue[i] =
                                                      val.toString();
                                                  threeDetailsController
                                                      .slotsDistribution(
                                                          threeDetailsController
                                                              .startTime[i],
                                                          threeDetailsController
                                                              .endTime[i],
                                                          int.parse(val
                                                              .toString()
                                                              .substring(0, 2)),
                                                          i);

                                                  threeDetailsController
                                                      .update();
                                                },
                                                value: threeDetailsController
                                                    .selectedvValue[i],
                                                isExpanded: true,
                                                underline: Container(),
                                                icon: Image.asset(
                                                  AppImages.dropdownIcon,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            )),
                                        15.hs,
                                        Obx(() => GridView.count(
                                              shrinkWrap: true,
                                              physics: const ClampingScrollPhysics(),
                                              crossAxisCount: 4,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 2,
                                              children: List.generate(
                                                  threeDetailsController
                                                      .slotsList[i]
                                                      .length, (index) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark
                                                              .withOpacity(0.5),
                                                          width: 0.5)),
                                                  child: Center(
                                                    child: AppTextWidgets
                                                        .blackText(
                                                      text:
                                                          threeDetailsController
                                                                  .slotsList[i]
                                                                      [index]
                                                                  .slot ??
                                                              "",
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(0.6),
                                                      size: 12,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            20.hs,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  backgroundColor: AppColors.AMBER,
                                  onPressed: () {
                                    threeDetailsController.addValues();
                                    threeDetailsController.totalCards.value =
                                        threeDetailsController
                                                .totalCards.value +
                                            1;
                                    threeDetailsController.update();
                                  },
                                ),
                                20.ws,
                              ],
                            ),
                            150.hs,
                          ],
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height - 50,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                onTap: () {
                  threeDetailsController.generateJson();
                },
                btnText: 'save'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


