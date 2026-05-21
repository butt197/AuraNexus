import 'package:videocalling/common/utils/app_imports.dart';

class PatientMoreScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialize();
  }

  List<String> list = [
    'title1'.tr,
    'title2'.tr,
    'title3'.tr,
    'title4'.tr,
    'title5'.tr
  ];

  RxString userId = "".obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString profileImage = "".obs;
  RxBool isLoaded = false.obs;
  RxBool isLoggedIn = false.obs;

  initialize() async {
    isLoaded.value = true;
    update();
    isLoggedIn.value =
        StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;
    userId.value = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    name.value = StorageService.readData(key: LocalStorageKeys.name) ?? "";
    email.value = StorageService.readData(key: LocalStorageKeys.email) ?? "";
    profileImage.value =
        StorageService.readData(key: LocalStorageKeys.profileImage) ?? "";
    isLoaded.value = true;
  }
}


