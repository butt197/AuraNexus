import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorProfile extends GetView<DoctorProfileController> {
  final DoctorProfileController profileController =
      Get.put(DoctorProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: profileController.onWillPopScope,
      child: Scaffold(
        backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Obx(
            () => CustomAppBar(
              isBackArrow: profileController.index > 0 ? true : false,
              onPressed: () => profileController.onWillPopScope(),
              title: 'doctor_dashboard'.tr,
              textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontWeightDelta: 5,
                  ),
            ),
          ),
          leading: Container(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: profileController.index.value >= 0
                                      ? AppColors.AMBER
                                      : Theme.of(context).primaryColorLight),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: profileController.index.value >= 1
                                    ? AppColors.AMBER
                                    : Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.2),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: profileController.index.value >= 2
                                    ? AppColors.AMBER
                                    : Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.2),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: profileController.index.value >= 3
                                    ? AppColors.AMBER
                                    : Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Obx(
                  () => profileController.isErrorInLoading.value
                      ? Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
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
                      : (profileController.isProfileLoaded.value &&
                              profileController.isScheduleLoaded.value)
                          ? FutureBuilder(
                              future: profileController.future,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    profileController.future == null ||
                                    profileController.future2 == null) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Expanded(
                                    child: Obx(() => Stack(
                                          children: [
                                            Visibility(
                                                visible: profileController
                                                        .index.value ==
                                                    0,
                                                child: profileController.step1(
                                                    context: context)),
                                            Visibility(
                                                visible: profileController
                                                        .index.value ==
                                                    1,
                                                child: profileController.step2(
                                                    context: context)),
                                            Visibility(
                                                visible: profileController
                                                        .index.value ==
                                                    2,
                                                child: profileController.step3(
                                                    context: context)),
                                            Visibility(
                                                visible: profileController
                                                        .index.value ==
                                                    3,
                                                child: profileController.step4(
                                                    context: context)),
                                          ],
                                        )),
                                  );
                                } else {
                                  return Container(
                                    height: MediaQuery.of(context).size.height -
                                        170,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                              })
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 70,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Obx(() => InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          if (profileController.index.value == 0) {
                            if ((profileController.doctorProfileDetails?.data
                                            ?.image ==
                                        "profile.png" ||
                                    profileController.doctorProfileDetails?.data
                                            ?.image ==
                                        "user.png") &&
                                profileController.sImage == null) {
                              Fluttertoast.showToast(
                                msg: 'please_select_image'.tr,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColors.WHITE,
                                textColor: AppColors.BLACK,
                                fontSize: 16.0,
                              );
                            } else if (profileController
                                .nameController.text.isEmpty) {
                              profileController.isNameError.value = true;
                            } else if (profileController
                                    .phoneController.text.length <
                                PHONE_LENGTH) {
                              profileController.isPhoneError.value = true;
                            } else if (profileController.selectedValue.value ==
                                null) {
                              profileController.isDepartmentError.value = true;
                            } else if (profileController
                                .worktimeController.text.isEmpty) {
                              profileController.isWorkingTimeError.value = true;
                            } else if (profileController
                                .feeController.text.isEmpty) {
                              profileController.isFeeError.value = true;
                            } else if (profileController
                                .aboutUsController.text.isEmpty) {
                              profileController.isAboutUsError.value = true;
                            } else if (profileController
                                .serviceController.text.isEmpty) {
                              profileController.isServiceError.value = true;
                            } else if (profileController
                                .healthcareController.text.isEmpty) {
                              profileController.isHealthCareError.value = true;
                            } else {
                              profileController.index.value =
                                  profileController.index.value + 1;
                            }
                          } else if (profileController.index.value == 1) {
                            if (profileController
                                .textEditingController.text.isEmpty) {
                              profileController.isAddressError.value = true;
                            } else {
                              FocusScope.of(context).unfocus();
                              profileController.index.value =
                                  profileController.index.value + 1;
                            }
                          } else if (profileController.index.value == 2) {
                            profileController.loadHoliday();
                            profileController.index.value =
                                profileController.index.value + 1;
                          } else if (profileController.index.value == 3) {
                            profileController.uploadData();
                          }
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
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
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Center(
                              child: AppTextWidgets.mediumText(
                                text: profileController.index.value == 3
                                    ? 'update'.tr
                                    : 'next'.tr,
                                color: AppColors.WHITE,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


