import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorTabsScreen extends GetView<DoctorTabController> {
  const DoctorTabsScreen({super.key});

  Future<bool> _handleBackPress(DoctorTabController tabController) async {
    if (Navigator.of(Get.context!).canPop()) {
      Navigator.of(Get.context!).pop();
      return false;
    }

    if (tabController.index.value != 0) {
      tabController.index.value = 0;
      tabController.update();
      return false;
    }

    final shouldExit = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit Sky Telehealth?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Exit'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    DoctorTabController tabController = Get.put(DoctorTabController());

    return WillPopScope(
      onWillPop: () => _handleBackPress(tabController),
      child: Scaffold(
        body: Obx(() => tabController.getPage(tabController.index.value)),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: AppColors.color1,
              boxShadow: [
                BoxShadow(
                  color: AppColors.BLACK.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppColors.color1,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.WHITE,
                unselectedItemColor: AppColors.WHITE.withOpacity(0.65),
                selectedLabelStyle: const TextStyle(
                  color: AppColors.WHITE,
                  fontSize: 8,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
                unselectedLabelStyle: TextStyle(
                  color: AppColors.WHITE.withOpacity(0.65),
                  fontSize: 7,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 0
                          ? AppImages.tab1Select
                          : AppImages.tab1Unselect,
                      height: 25,
                      width: 25,
                    ),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 1
                          ? AppImages.tab2Select
                          : AppImages.tab2Unselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'appointment'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 2
                          ? AppImages.tab3dSelect
                          : AppImages.tab3dUnselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'edit_profile'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 3
                          ? AppImages.tab4Select
                          : AppImages.tab4Unselect,
                      height: 25,
                      width: 35,
                    ),
                    label: 'recent_chats'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 4
                          ? AppImages.tab5Select
                          : AppImages.tab5Unselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'more'.tr,
                  ),
                ],
                onTap: (i) {
                  if (tabController.index.value == i) return;

                  if (i == 0) {
                    Get.lazyPut<DoctorDashboardController>(
                      () => DoctorDashboardController(),
                    );
                  } else if (i == 1) {
                    Get.lazyPut<DoctorPastAppointmentsController>(
                      () => DoctorPastAppointmentsController(),
                    );
                  } else if (i == 2) {
                    Get.lazyPut<DoctorProfileController>(
                      () => DoctorProfileController(),
                    );
                  } else if (i == 3) {
                    Get.lazyPut<DMoreInfoController>(
                      () => DMoreInfoController(),
                    );
                  } else if (i == 4) {
                    Get.lazyPut<DoctorChatListController>(
                      () => DoctorChatListController(),
                    );
                  }

                  if (tabController.index.value == 0) {
                    Get.delete<DoctorDashboardController>();
                  } else if (tabController.index.value == 1) {
                    Get.delete<DoctorPastAppointmentsController>();
                  } else if (tabController.index.value == 2) {
                    Get.delete<DoctorProfileController>();
                  } else if (tabController.index.value == 3) {
                    Get.delete<DMoreInfoController>();
                  } else if (tabController.index.value == 4) {
                    Get.delete<DoctorChatListController>();
                  }

                  tabController.index.value = i;
                  tabController.update();
                },
                currentIndex: tabController.index.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
