import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

import 'package:videocalling/patient/utils/patient_imports.dart';

class MoreScreen extends GetView<PatientMoreScreenController> {
  final PatientMoreScreenController moreScreenController =
      Get.put(PatientMoreScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'more'.tr,
        ),
        elevation: 0,
        leading: Container(),
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      body: Obx(() => moreScreenController.isLoaded.value
          ? Column(
              children: [
                Stack(
                  children: [
                    Container(
                      foregroundDecoration:
                          const BoxDecoration(color: AppColors.BLACK45),
                      child: Image.asset(
                        AppImages.bgImage,
                        height: 130,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 130,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: CachedNetworkImage(
                              imageUrl: controller.isLoggedIn.value
                                  ? controller.profileImage.value.isEmpty
                                      ? " "
                                      : controller.profileImage.value
                                  : " ",
                              height: 70,
                              width: 70,
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
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                SharedPreferences.getInstance().then((value) {
                                  value.setString("isBack", "0");
                                });
                                if (!controller.isLoggedIn.value) {
                                  await Get.toNamed(Routes.loginUserScreen,
                                      arguments: {
                                        "isBack": false,
                                      });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextWidgets.semiBoldText(
                                    text: controller.isLoggedIn.value
                                        ? controller.name.value
                                        : 'sign_in_title'.tr,
                                    color: AppColors.WHITE,
                                    size: 17,
                                  ),
                                  AppTextWidgets.mediumText(
                                    text: controller.isLoggedIn.value
                                        ? controller.email.value
                                        : 'sign_in_title_1'.tr,
                                    color: AppColors.WHITE,
                                    size: 11.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          controller.isLoggedIn.value
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await Get.toNamed(
                                            Routes.editProfileScreen);
                                        moreScreenController.initialize();
                                        Get.delete<UserEditController>();
                                      },
                                      child: Image.asset(
                                        AppImages.editIcon,
                                        height: 23,
                                        fit: BoxFit.fill,
                                        width: 23,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    itemCount: controller.isLoggedIn.value
                        ? controller.list.length
                        : controller.list.length - 2,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          if (index == 3) {
                            await Get.toNamed(Routes.reportIssuesScreen);
                            Get.delete<ReportIssueController>();
                          }
                          if (index == 2) {
                            await Get.toNamed(Routes.termsAndConditionScreen);
                            Get.delete<TermAndConditionsController>();
                          }
                          if (index == 1) {
                            await Get.toNamed(Routes.aboutUSScreen);
                            Get.delete<AboutUsController>();
                          }
                          if (index == 0) {
                            await Get.toNamed(Routes.specialityScreen);
                            Get.delete<SpecialityController>();
                          }
                          if (index == 4) {
                            logoutDialog(
                              s1: 'logout_title'.tr,
                              s2: 'logout_description'.tr,
                              onPressed: () async {
                                Get.back();
                                customDialog1(
                                  s1: 'logout_loading_title'.tr,
                                  s2: 'logout_loading_description'.tr,
                                );
                                try {
                                  CallManager.instance.destroy();
                                  CubeChatConnection.instance.destroy();
                                  await PushNotificationsManager.instance
                                      .unsubscribe();
                                  await SharedPrefs.deleteUserData();
                                  await signOut();
                                } catch (e) {}
                                StorageService.writeBoolData(
                                  key: LocalStorageKeys.isLoggedIn,
                                  value: false,
                                );
                                StorageService.writeBoolData(
                                  key: LocalStorageKeys.isLoggedInAsDoctor,
                                  value: false,
                                );
                                String? str = StorageService.readData(
                                  key: LocalStorageKeys.token,
                                );
                                box.erase();
                                if (str != null) {
                                  StorageService.writeBoolData(
                                    key: LocalStorageKeys.isTokenExist,
                                    value: true,
                                  );
                                  StorageService.writeStringData(
                                    key: LocalStorageKeys.token,
                                    value: str,
                                  );
                                }
                                Get.back();
                                Get.offAllNamed(Routes.userTabScreen);
                              },
                            );
                          }
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextWidgets.regularText(
                                  text: controller.list[index],
                                  size: 13,
                                  color: AppColors.BLACK,
                                ),
                                Image.asset(
                                  AppImages.arrowIcon,
                                  height: 15,
                                  fit: BoxFit.fill,
                                  width: 15,
                                ),
                              ],
                            ),
                            7.hs,
                            Divider(
                              thickness: 0.3,
                              color: AppColors.LIGHT_GREY_TEXT,
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            )
          : const LinearProgressIndicator()),
    );
  }
}


