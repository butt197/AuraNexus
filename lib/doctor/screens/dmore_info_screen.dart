import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class MoreInfoScreen extends GetView<DMoreInfoController> {
  final DMoreInfoController infoController = Get.put(DMoreInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          title: 'more_info'.tr,
          textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
              color: Theme.of(context).scaffoldBackgroundColor, fontWeightDelta: 5),
        ),
        leading: Container(),
      ),
      body: Column(
        children: [
          Obx(
            () => infoController.isErrorInLoading.value
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
                : infoController.isLoaded.value
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: !(infoController
                                            .doctorProfileWithRating
                                            ?.data
                                            ?.image
                                            ?.contains(Apis.doctorImagePath) ??
                                        false)
                                    ? (Apis.doctorImagePath +
                                        (infoController.doctorProfileWithRating
                                                ?.data?.image ??
                                            ""))
                                    : infoController.doctorProfileWithRating
                                            ?.data?.image ??
                                        "",
                                height: 85,
                                width: 85,
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
                                          infoController.doctorProfileWithRating
                                                  ?.data?.name ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .apply(fontWeightDelta: 2),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              (infoController
                                                          .doctorProfileWithRating
                                                          ?.data
                                                          ?.departmentName
                                                          ?.isEmpty ??
                                                      true)
                                                  ? 'speciality'.tr
                                                  : infoController
                                                          .doctorProfileWithRating
                                                          ?.data
                                                          ?.departmentName ??
                                                      'speciality'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .apply(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                              AppImages.starFill,
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              double.parse(infoController
                                                          .doctorProfileWithRating
                                                          ?.data
                                                          ?.avgratting
                                                          .toString() ??
                                                      "0.0")
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .apply(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      infoController.doctorProfileWithRating
                                              ?.data?.address ??
                                          'no_address'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .apply(
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.4),
                                            fontSizeDelta: 0.1,
                                          ),
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
                      )
                    : const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemBuilder: (context, index) {
                return CustomMoreScreenTile(
                  callback: () async {
                    if (index == 0) {
                      await Get.toNamed(Routes.dChangePasswordScreen);
                      Get.delete<DChangePasswordController>();
                    } else if (index == 1) {
                      await Get.toNamed(Routes.dSubscriptionListScreen);
                      Get.delete<SubscriptionListController>();
                    } else if (index == 2) {
                      await Get.toNamed(Routes.dBankDetailsScreen);
                      Get.delete<BankDetailController>();
                    } else if (index == 3) {
                      await Get.toNamed(Routes.dIncomeReportScreen);
                      Get.delete<IncomeReportController>();
                    } else if (index == 4) {
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
                            await PushNotificationsManager.instance.unsubscribe();
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
                  text: infoController.optionList[index],
                );
              },
              itemCount: infoController.optionList.length,
            ),
          )
        ],
      ),
    );
  }
}


