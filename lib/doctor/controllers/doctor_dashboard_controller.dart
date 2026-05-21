import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

import '../utils/doctor_imports.dart';

class DoctorDashboardController extends GetxController {
  DoctorPastAppointmentsClass? doctorAppointmentsClass;
  DoctorProfileWithRating? doctorProfileWithRating;

  RxString doctorId = "".obs;

  RxBool isAppointmentAvailable = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isErrorInLoading = false.obs;

  RxBool isErrorInProfileLoading = false.obs;
  RxBool isProfileLoaded = false.obs;

  final incomingCallManager = Get.put(IncomingManageController());

  fetchDoctorAppointment() async {
    isAppointmentAvailable.value = false;
    isLoaded.value = false;
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/doctoruappointment?doctor_id=${doctorId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInLoading.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        doctorAppointmentsClass =
            DoctorPastAppointmentsClass.fromJson(jsonResponse);
        isLoaded.value = true;
        isAppointmentAvailable.value = true;
      } else {
        isLoaded.value = true;
        isAppointmentAvailable.value = false;
      }
    } else {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  fetchDoctorDetails() async {
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/doctordetail?doctor_id=${doctorId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      try {
        if (jsonResponse['success'].toString() == "1") {
          doctorProfileWithRating =
              DoctorProfileWithRating.fromJson(jsonResponse);

          if (doctorProfileWithRating!.data!.isSubscription == "0") {
            Get.toNamed(Routes.chooseYourPlanScreen, arguments: {
              'doctorUrl': doctorProfileWithRating!.data!.image.toString()
            });
          }

          isProfileLoaded.value = true;
        } else {
          isErrorInProfileLoading.value = true;
        }
      } catch (E) {
        isErrorInProfileLoading.value = true;
      }
    } else {
      isErrorInProfileLoading.value = true;
    }
    Client().close();
  }

  Future<bool> dialogPop() async {
    StorageService.removeData(key: LocalStorageKeys.callSessionCS);
    return true;
  }

  dialog() {
    return Get.defaultDialog(
      onWillPop: dialogPop,
      barrierDismissible: true,
      title: 'call_accept_dialog_title'.tr,
      content: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            const CircularProgressIndicator(),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                'call_accept_dialog_subtitle'.tr,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }

  onRefresh() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      fetchDoctorAppointment();
    });
    refreshController.refreshCompleted();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    doctorId.value =
        StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    fetchDoctorAppointment();
    fetchDoctorDetails();
    if (StorageService.readData(key: LocalStorageKeys.callSessionCS) != null) {
      dialog();
    }
  }
}


