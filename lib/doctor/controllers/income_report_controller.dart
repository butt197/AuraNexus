import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class IncomeReportController extends GetxController {
  RxString doctorId = "".obs;
  RxBool st = false.obs;
  RxString showOption = 'income_report_tile_short_text1'.tr.obs;

  getIncomeReport(String duration) async {
    st.value = false;
    final response = await post(
            Uri.parse("${Apis.ServerAddress}/api/income_report"),
            body: {'doctor_id': doctorId.value, 'duration': duration})
        .timeout(const Duration(seconds: Apis.timeOut));

    if (response.statusCode == 200) {
      incomeReport = IncomeReportRes.fromJson(jsonDecode(response.body));
      st.value = true;
    }
    Client().close();
  }

  IncomeReportRes incomeReport = IncomeReportRes();

  optionBottomSheet() {
    Get.bottomSheet(
      Container(
          height: 295,
          decoration: const BoxDecoration(
            color: AppColors.WHITE,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ),
              height: 60,
              // alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextWidgets.blackText(
                          text: "filter_report_by".tr,
                          color: AppColors.totalFilterReportTextColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              AppImages.closeIcon,
                              width: 30,
                              height: 30,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            CustomOptionTile(
                callback: () {
                  Get.back();
                  showOption.value = "income_report_tile_short_text1".tr;
                  getIncomeReport("today");
                },
                text: "income_report_tile_text1".tr),
            CustomOptionTile(
                callback: () {
                  Get.back();
                  showOption.value = "income_report_tile_short_text2".tr;
                  getIncomeReport("last 7 days");
                },
                text: "income_report_tile_text2".tr),
            CustomOptionTile(
                callback: () {
                  Get.back();
                  showOption.value = "income_report_tile_short_text3".tr;
                  getIncomeReport("last 30 days");
                },
                text: "income_report_tile_text3".tr),
            CustomOptionTile(
                callback: () {
                  Get.back();
                  showOption.value = "";
                  _showDateRangePicker(Get.context!);
                },
                text: "income_report_tile_text4".tr),
            const SizedBox(
              height: 5,
            ),
          ])),
      backgroundColor: AppColors.transparentColor,
    );
  }

  DateTimeRange? selectedDateRange;

  void _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().add(const Duration(days: -7)),
      end: DateTime.now().add(const Duration(days: 7)),
    );

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: initialDateRange,
    );

    if (picked != null && picked != selectedDateRange) {
      selectedDateRange = picked;
      makeApi();
    }
  }

  makeApi() {
    showOption.value = "";
    getIncomeReport(
        "${selectedDateRange!.start.toString().substring(0, 10)},${selectedDateRange!.end.toString().substring(0, 10)}");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    doctorId.value =
        StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    getIncomeReport("today");
  }
}


