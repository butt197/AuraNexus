import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:videocalling/common/utils/app_imports.dart';

class IncomeReportScreen extends GetView<IncomeReportController> {
  final IncomeReportController reportController =
      Get.put(IncomeReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          onPressed: () => Get.back(),
          isBackArrow: true,
          title: 'income_report_str'.tr,
          textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
              color: Theme.of(context).scaffoldBackgroundColor, fontWeightDelta: 5),
        ),
        leading: Container(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.incomeReportBgColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reportController.st.value
                          ? reportController.incomeReport.success.toString() ==
                                  "0"
                              ? AppTextWidgets.blackText(
                                  text: "0 $CURRENCY",
                                  color: AppColors.BLACK,
                                  size: 27)
                              : AppTextWidgets.blackText(
                                  text:
                                      "${double.parse("${reportController.incomeReport.data!.totalIncome}").toStringAsFixed(1)} $CURRENCY",
                                  color: AppColors.BLACK,
                                  size: 27)
                          : Container(),
                      Text(
                        'total_income_str'.trParams(
                            {'option': reportController.showOption.value}),
                        style: TextStyle(
                            color: AppColors.totalIncomeTextColor,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () {
                      reportController.optionBottomSheet();
                    },
                    child: Image.asset(
                      AppImages.dotsIcon,
                      width: 25,
                      height: 25,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5),
            child: AppTextWidgets.boldTextWithColor(
              text: 'detailed_report'.tr,
              color: AppColors.BLACK,
              size: 16,
            ),
          ),
          Obx(
            () => reportController.st.value
                ? reportController.incomeReport.success.toString() == "0"
                    ? Container(
                        height: Get.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(
                            'not_any_income_str'.trParams(
                                {'option': reportController.showOption.value}),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                      )
                    : Expanded(
                        child: ListView.builder(
                        itemCount: reportController
                            .incomeReport.data!.incomeRecord!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: AppColors.WHITE,
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${reportController.incomeReport.data!.incomeRecord![index].date.toString().substring(8, 10)}/${reportController.incomeReport.data!.incomeRecord![index].date.toString().substring(5, 7)}/${reportController.incomeReport.data!.incomeRecord![index].date.toString().substring(0, 4)}",
                                    style: TextStyle(
                                        color: AppColors.totalIncomeTextColor,
                                        fontSize: 16),
                                  ),
                                  AppTextWidgets.blackText(
                                    text:
                                        "${double.parse("${reportController.incomeReport.data!.incomeRecord![index].amount}").toStringAsFixed(1)} $CURRENCY",
                                    color: AppColors.BLACK,
                                    size: 19,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                : Container(
                    height: Get.height * 0.5,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: AppColors.color1),
                  ),
          )
        ],
      ),
    );
  }
}


