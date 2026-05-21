import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class ManageHolidayScreen extends GetView<HolidayManageController> {
  final HolidayManageController manageController =
      Get.put(HolidayManageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        flexibleSpace: CustomAppBar(
          title: manageController.holidayId == 0
              ? 'add_holiday'.tr
              : 'update_holiday'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Obx(() => Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppTextWidgets.semiBoldText(
                          text: 'select_date'.tr,
                          color: AppColors.BLACK,
                          size: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppTextWidgets.mediumText(
                          text: 'select_date_desc'.tr,
                          color: AppColors.LIGHT_GREY_TEXT,
                          size: 12,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.grey.withOpacity(0.8)),
                        ),
                        child: SfDateRangePicker(
                          controller: manageController.controller,
                          enablePastDates: false,
                          maxDate: DateTime.now().add(const Duration(days: 30)),
                          view: DateRangePickerView.month,
                          selectionMode: DateRangePickerSelectionMode.range,
                          onSelectionChanged:
                              (dateRangePickerSelectionChangedArgs) {},
                          initialSelectedRange:
                              manageController.controller.selectedRange,
                          rangeSelectionColor:
                              AppColors.AMBER_NORMAL.withOpacity(0.6),
                          todayHighlightColor: AppColors.AMBER_NORMAL,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            EditTextField(
                              editingController:
                                  manageController.descController,
                              labelText: 'description'.tr,
                              errorText:
                                  manageController.isDescriptionError.value
                                      ? 'common_textfield_error'.tr
                                      : null,
                              onChanged: (p0) {
                                if (p0.isEmpty) {
                                  manageController.isDescriptionError.value =
                                      false;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Visibility(
                          visible: manageController.holidayId != 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: InkWell(
                                  onTap: () {
                                    manageController.removeHoliday();
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.LIGHT_GREY_TEXT
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Center(
                                          child: AppTextWidgets.mediumText(
                                            text: 'remove'.tr,
                                            color: AppColors.BLACK,
                                            size: 15,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          )),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: InkWell(
                          onTap: () {
                            Get.focusScope?.unfocus();
                            manageController.addHoliday();
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.color1,
                                        AppColors.color2,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Center(
                                child: AppTextWidgets.mediumText(
                                  text: manageController.holidayId == 0
                                      ? 'add_holiday'.tr
                                      : 'update_holiday'.tr,
                                  color: AppColors.WHITE,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}


