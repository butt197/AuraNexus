import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class MedicinseScreen extends GetView<AddMedicineToAppointmentController> {
  final List<MedicineData> ll;
  final int? id;
  final bool updateValue;
  final bool updateValue2;
  final String? oldData;
  final int? updateRepeatDays;
  final List<List<TimeOfDay>>? timeList;

  MedicinseScreen({
    super.key,
    required this.ll,
    this.id,
    this.updateValue = false,
    this.timeList,
    this.updateValue2 = false,
    this.oldData,
    this.updateRepeatDays,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'medicine_str'.tr,
          textStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 22,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          isBackArrow: true,
          onPressed: () => Get.back(result: "false"),
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: GetBuilder<AddMedicineToAppointmentController>(
        init: AddMedicineToAppointmentController(
          oldData: oldData,
          updateValue ? 1 : ll.length,
          timeList: timeList,
          nameController: ll
              .map((e) => TextEditingController(text: e.name))
              .toList(),
          appointmentID: id,
          medicineID: ll.map((e) => e.id.toString()).toList(),
          selectedValue: List.generate(
            updateValue ? 1 : ll.length,
            (index) => updateValue2 ? (updateRepeatDays ?? 0) - 1 : 2,
          ),
          dosageController: List.generate(
            updateValue ? 1 : ll.length,
            (index) => TextEditingController(
              text: updateValue
                  ? ""
                  : (ll[index].dosage == "" ||
                        ll[index].dosage.toString() == "null")
                  ? ""
                  : "${ll[index].dosage}",
            ),
          ),
          typeController: List.generate(updateValue ? 1 : ll.length, (index) {
            final String initialType = updateValue
                ? ''
                : (ll[index].medicineType?.split(',').first.trim() ?? '');

            return TextEditingController(text: initialType);
          }),
          customTypeController: List.generate(
            updateValue ? 1 : ll.length,
            (index) => TextEditingController(),
          ),
        ),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: updateValue ? 1 : ll.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    List<String>? V = null;
                    if (!updateValue) {
                      V =
                          ll[i].medicineType?.split(",") ??
                          [ll[i].medicineType ?? ","];
                    }
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.iconColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          updateValue
                              ? const SizedBox(height: 0)
                              : const SizedBox(height: 5),
                          CommonTextField1(
                            textInputType: TextInputType.name,
                            labelStyle: const TextStyle(
                              color: AppColors.BLACK,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                            mainStyle: const TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                            labelText: 'name_label'.tr,
                            errorText: 'search_medicine_error'.tr,
                            controller: controller.nameController![i],
                          ),

                          Column(
                            children: [
                              const SizedBox(height: 20),

                              Builder(
                                builder: (_) {
                                  final String currentType = controller
                                      .typeController[i]
                                      .text
                                      .trim();
                                  final List<String> typeOptions = controller
                                      .getMedicineTypeOptions(currentType);

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    // icon: const SizedBox(),
                                    value: currentType.isEmpty
                                        ? null
                                        : currentType,
                                    items: typeOptions.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily:
                                                AppFontStyleTextStrings.regular,
                                            color: AppColors.BLACK,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue == null) return;

                                      controller.typeController[i].text =
                                          newValue.trim();

                                      if (newValue.trim() !=
                                          AddMedicineToAppointmentController
                                              .otherMedicineType) {
                                        controller.customTypeController![i]
                                            .clear();
                                      }

                                      controller.update();
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'type_label'.tr,
                                      labelStyle: const TextStyle(
                                        color: AppColors.BLACK,
                                        fontFamily:
                                            AppFontStyleTextStrings.regular,
                                      ),

                                      suffixIcon: Transform.rotate(
                                        angle: pi / 2,
                                        child: const Icon(
                                          Icons.navigate_next_sharp,
                                          color: AppColors.BLACK,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 11.0,
                                            horizontal: 15,
                                          ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.color1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color:
                                              AppColors.noPrescriptionTextColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (controller.typeController[i].text.trim() ==
                                  AddMedicineToAppointmentController
                                      .otherMedicineType)
                                const SizedBox(height: 20),
                              if (controller.typeController[i].text.trim() ==
                                  AddMedicineToAppointmentController
                                      .otherMedicineType) ...[
                                const SizedBox(height: 12),
                                CommonTextField1(
                                  textInputType: TextInputType.text,
                                  labelStyle: const TextStyle(
                                    color: AppColors.BLACK,
                                    fontFamily: AppFontStyleTextStrings.regular,
                                  ),
                                  mainStyle: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFontStyleTextStrings.regular,
                                  ),
                                  labelText: 'Enter custom medicine type',
                                  errorText: 'type_error'.tr,
                                  controller:
                                      controller.customTypeController![i],
                                ),
                              ],
                              const SizedBox(height: 20),
                              CommonTextField1(
                                textInputType: TextInputType.text,
                                labelStyle: const TextStyle(
                                  color: AppColors.BLACK,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                                mainStyle: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                                labelText: 'dosage_label'.tr,
                                errorText: 'dosage_error'.tr,
                                controller: controller.dosageController[i],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 20,
                            child: Divider(
                              color: AppColors.LIGHT_GREY_TEXT,
                              thickness: 1,
                            ),
                          ),
                          AppTextWidgets.regularText(
                            text: 'medicine_param_5'.tr,
                            color: AppColors.reportTextColor,
                            size: 16,
                          ),
                          Container(
                            alignment: Alignment.center,
                            // height: 65,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (
                                    int j = 0;
                                    j < controller.items.length;
                                    j++
                                  )
                                    GestureDetector(
                                      onTap: () {
                                        controller.selectedValue[i] = j;
                                        controller.update();
                                      },
                                      child: Container(
                                        height: 85,
                                        width: 65,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 5,
                                        ),
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          border: Border.all(
                                            color:
                                                controller.selectedValue[i] ==
                                                    (j)
                                                ? AppColors.color1
                                                : AppColors.grey,
                                            width:
                                                controller.selectedValue[i] ==
                                                    (j)
                                                ? 2
                                                : 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              j == 9
                                                  ? controller.items[j]
                                                        .split(" ")
                                                        .first
                                                  : "0${controller.items[j].split(" ").first}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily:
                                                    controller
                                                            .selectedValue[i] ==
                                                        (j)
                                                    ? AppFontStyleTextStrings
                                                          .medium
                                                    : AppFontStyleTextStrings
                                                          .regular,
                                                color:
                                                    controller
                                                            .selectedValue[i] ==
                                                        (j)
                                                    ? AppColors.color1
                                                    : AppColors.BLACK,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: SizedBox(
                                                height: 15,
                                                child: Divider(
                                                  color:
                                                      AppColors.LIGHT_GREY_TEXT,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              controller.items[j]
                                                  .split(" ")
                                                  .last,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily:
                                                    controller
                                                            .selectedValue[i] ==
                                                        (j)
                                                    ? AppFontStyleTextStrings
                                                          .medium
                                                    : AppFontStyleTextStrings
                                                          .regular,
                                                color:
                                                    controller
                                                            .selectedValue[i] ==
                                                        (j)
                                                    ? AppColors.color1
                                                    : AppColors.BLACK,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Divider(
                              color: AppColors.LIGHT_GREY_TEXT,
                              thickness: 1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppTextWidgets.regularText(
                                text: 'medicine_param_3'.tr,
                                color: AppColors.reportTextColor,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 2.8,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 8,
                                      ),
                                  itemCount: controller.timeList[i].length + 1,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.timeList[i].length) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.addTimeController(
                                            context,
                                            index: i,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: AppColors
                                                      .noPrescriptionTextColor,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: AppColors
                                                    .noPrescriptionTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.color1,
                                        ),
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () async {
                                            var time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                hour: controller
                                                    .timeList[i][index]
                                                    .hour,
                                                minute: controller
                                                    .timeList[i][index]
                                                    .minute,
                                              ),
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    Widget? child,
                                                  ) {
                                                    return MediaQuery(
                                                      data:
                                                          MediaQuery.of(
                                                            context,
                                                          ).copyWith(
                                                            alwaysUse24HourFormat:
                                                                false,
                                                          ),
                                                      child: child!,
                                                    );
                                                  },
                                            );
                                            if (time == null) return;
                                            controller.timeList[i][index] =
                                                time;
                                            controller.update();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppTextWidgets.regularText(
                                                text: DateFormat.jm().format(
                                                  DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    controller
                                                        .timeList[i][index]
                                                        .hour,
                                                    controller
                                                        .timeList[i][index]
                                                        .minute,
                                                  ),
                                                ),
                                                color:
                                                    AppColors.reportTextColor,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () {
                                                  controller.timeList[i]
                                                      .removeAt(index);
                                                  controller.update();
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 22,
                                                  color: AppColors.color1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 0);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    updateValue2
                        ? controller.getMedicalApi(isUpdate: true)
                        : controller.getMedicalApi(isUpdate: false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.color1, AppColors.color2],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            width: Get.width,
                          ),
                        ),
                        Center(
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              AppTextWidgets.regularText(
                                text: updateValue2
                                    ? 'edit_data_btn'.tr
                                    : 'add_to_prescription_btn'.tr,
                                color: AppColors.WHITE,
                                size: 18,
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.navigate_next_rounded,
                                color: AppColors.WHITE,
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        },
      ),
    );
  }
}
