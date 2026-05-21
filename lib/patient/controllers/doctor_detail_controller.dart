import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DoctorDetailController extends GetxController {
  DoctorDetailsClass? doctorDetailsClass;
  String id = Get.arguments['id'];
  RxBool isLoading = true.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isErrorInLoading = false.obs;

  fetchDoctorDetails() async {
    isLoading.value = true;

    final response = await get(
            Uri.parse("${Apis.ServerAddress}/api/viewdoctor?doctor_id=${id}"))
        .catchError((e) {
      isErrorInLoading.value = true;
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      doctorDetailsClass = DoctorDetailsClass.fromJson(jsonResponse);
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoggedIn.value =
        StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;
    fetchDoctorDetails();
  }

  processPayment() async {
    if (isLoggedIn.value) {
      Get.toNamed(Routes.makeAppointmentScreen, arguments: {
        'id': id,
        'name': doctorDetailsClass!.data!.name ?? "",
        'consultationFee': doctorDetailsClass!.data!.consultationFee,
      });
    } else {
      Get.toNamed(Routes.loginUserScreen, arguments: {
        "isBack": true,
      })?.then((value) {
        if (value ?? false) {
          isLoggedIn.value = true;
          Get.toNamed(Routes.makeAppointmentScreen, arguments: {
            'id': id,
            'name': doctorDetailsClass!.data!.name ?? "",
            'consultationFee': doctorDetailsClass!.data!.consultationFee,
          });
        }
      });
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}


