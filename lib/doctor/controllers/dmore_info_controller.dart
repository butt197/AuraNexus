import 'package:videocalling/common/utils/app_imports.dart';

import '../utils/doctor_imports.dart';

class DMoreInfoController extends GetxController {
  List<String> optionList = [
    'change_password_str'.tr,
    'subscription_str'.tr,
    'bank_details'.tr,
    'income_report_str'.tr,
    'logout_title'.tr
  ];

  RxString doctorId = "".obs;
  RxBool isErrorInLoading = false.obs;
  RxBool isLoaded = false.obs;

  DoctorProfileWithRating? doctorProfileWithRating;

  fetchDoctorDetails() async {
    isErrorInLoading.value = false;
    isLoaded.value = false;
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/doctordetail?doctor_id=${doctorId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInLoading.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      doctorProfileWithRating = DoctorProfileWithRating.fromJson(jsonResponse);
      isLoaded.value = true;
    } else {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    doctorId.value =
        StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    fetchDoctorDetails();
  }
}


