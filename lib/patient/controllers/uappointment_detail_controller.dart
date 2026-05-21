import 'package:videocalling/common/utils/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserAppointmentDetailsController extends GetxController {
  String id = Get.arguments['id'];

  DoctorAppointmentDetailsClass? doctorAppointmentDetailsClass;
  Future? getAppointmentDetails;
  RxBool isErrorInLoading = false.obs;
  RxString doctorSpeciality = "".obs;
  RxString doctorId = "".obs;
  RxString userId = "".obs;
  Timer? countdownTimer;
  Duration myDuration = Duration(hours: 01, seconds: 60);
  RxBool isSecondNagetive = false.obs;

  fetchAppointmentDetails() async {
    final response = await http
        .get(Uri.parse(
            "${Apis.ServerAddress}/api/appointmentdetail?id=${id}&type=1"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInLoading.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse["success"].toString() == "1") {
        doctorAppointmentDetailsClass =
            DoctorAppointmentDetailsClass.fromJson(jsonResponse);
        if (jsonResponse['doctor']['departmentls'] != null) {
          doctorSpeciality.value =
              jsonResponse['doctor']['departmentls']['name'].toString();
        }
        doctorId.value = jsonResponse['data']['doctor_id'].toString();
        userId.value = jsonResponse['data']['user_id'].toString();
      }
    }
  }

  Future<bool> downloadAndSaveImage(String url) async {
    http.Client client = http.Client();
    var req = await client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: Apis.timeOut));
    if (req.statusCode >= 400) {
      Get.back();
      customDialog(
        onPressed: () {
          Get.back();
        },
        s1: 'error'.tr,
        s2: '${req.reasonPhrase}'.tr,
      );
      return false;
    }
    var bytes = req.bodyBytes;
    try {
      String dir = '/storage/emulated/0/Dcim/${url.split("/").last}';
      File file = File(dir);
      await file.writeAsBytes(bytes);
      return true;
    } catch (e) {
      Get.back();
      customDialog(
        onPressed: () {
          Get.back();
        },
        s1: 'error'.tr,
        s2: e.toString(),
      );
      return false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAppointmentDetails = fetchAppointmentDetails();
  }
}


