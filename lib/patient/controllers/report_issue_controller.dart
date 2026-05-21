import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class ReportIssueController extends GetxController {
  List<String> issuesList = [
    'report_issue1'.tr,
    'report_issue2'.tr,
    'report_issue3'.tr,
    'report_issue4'.tr,
    'report_issue5'.tr,
  ];

  String description = "";
  RxList<String> title = <String>[].obs;
  RxBool isDescriptionError = false.obs;
  bool isIssuePublished = false;
  String? userId;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userId = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    update();
  }

  reportIssue() async {
    if (description.isEmpty) {
      isDescriptionError.value = true;
    } else if (userId == null) {
      messageDialog('error'.tr, "not_logged_in".tr);
    } else if (title.isEmpty) {
      messageDialog('error'.tr, "reporting_dialog3".tr);
    } else {
      customDialog1(s1: 'reporting_dialog1'.tr, s2: 'reporting_dialog2'.tr);
      final response =
          await post(Uri.parse("${Apis.ServerAddress}/api/Reportspam"), body: {
        "user_id": userId,
        "title": title.join(","),
        "description": description,
      }).timeout(const Duration(seconds: Apis.timeOut));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "0") {
          Get.back();
          messageDialog('error'.tr, "${jsonResponse['register']}}");
        } else {
          ReportSpamData data = ReportSpamData.fromJson(jsonResponse);
          if (data.success == 1) {
            Get.back();
            isIssuePublished = true;
            update();
            messageDialog('success'.tr, "${data.register}");
          }
        }
      }
    }
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () {
        if (isIssuePublished) {
          Get.back();
          Get.back();
        } else {
          Get.back();
        }
      },
    );
  }
}


