import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class HolidayManageController extends GetxController {
  int holidayId = Get.arguments['holidayId'];
  DateTime startDate = Get.arguments['startDate'];
  DateTime endDate = Get.arguments['endDate'];
  String description = Get.arguments['description'];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (holidayId != 0) {
      controller.selectedRange = PickerDateRange(startDate, endDate);
      descController.text = description;
    }

    kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
  }

  final kToday = DateTime.now();
  var kFirstDay;
  var kLastDay;
  List<dynamic> Function(DateTime)? events;
  DateRangePickerController controller = DateRangePickerController();
  TextEditingController descController = TextEditingController();
  HData? data;

  RxBool isDescriptionError = false.obs;

  removeHoliday() async {
    customDialog1(s1: 'reporting_dialog1'.tr, s2: 'while_saving_changes'.tr);

    var response = await get(Uri.parse(
            '${Apis.ServerAddress}/api/deleteholiday?id=${holidayId}'))
        .timeout(const Duration(seconds: Apis.timeOut));

    Get.back();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == '1') {
        Get.back(result: true);
      } else {
        customDialog(s1: 'error'.tr, s2: jsonResponse['msg']);
      }
    } else {
      customDialog(s1: 'error'.tr, s2: response.reasonPhrase!);
    }
    Client().close();
  }

  addHoliday() async {
    if (controller.selectedRange == null) {
      customDialog(s1: 'error'.tr, s2: 'add_date_error'.tr);
    } else if (descController.text.isEmpty) {
      isDescriptionError.value = true;
    } else {
      customDialog1(s1: 'reporting_dialog1'.tr, s2: 'while_saving_changes'.tr);
      var response =
          await post(Uri.parse('${Apis.ServerAddress}/api/saveholiday'), body: {
        'doctor_id': StorageService.readData(key: LocalStorageKeys.userId),
        'id': holidayId.toString(),
        'start_date':
            controller.selectedRange!.startDate.toString().substring(0, 10),
        'end_date': controller.selectedRange!.endDate == null
            ? controller.selectedRange!.startDate.toString().substring(0, 10)
            : controller.selectedRange!.endDate.toString().substring(0, 10),
        'description': descController.text
      }).timeout(const Duration(seconds: Apis.timeOut));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        Get.back();

        if (jsonResponse['success'].toString() == "1") {
          data = HData.fromJson(jsonResponse);
          Get.back(result: true);
        } else {
          customDialog(s1: 'error'.tr, s2: jsonResponse['msg']);
        }
      } else {
        Get.back();
        customDialog(s1: 'error'.tr, s2: response.reasonPhrase!);
      }
      Client().close();
    }
  }
}


