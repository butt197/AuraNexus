import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class SearchMedicineScreen extends GetView<SearchMedicineController> {
  final SearchMedicineController medicineController =
      Get.put(SearchMedicineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'add_prescription'.tr,
          textStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 22,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          isBackArrow: true,
          onPressed: () => Get.back(result: "false"),
        ),
        leading: Container(),
      ),
      body: Obx(() => Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 52,
                      child: TextField(
                        style: const TextStyle(
                          height: 1.25,
                          fontSize: 15,
                          fontFamily: AppFontStyleTextStrings.medium,
                        ),
                        controller: medicineController.searchMedicineController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          Get.focusScope?.unfocus();
                          if (value.isEmpty) {
                            medicineController.isSearchMedicineEmpty.value =
                                true;
                            Fluttertoast.showToast(
                                msg: 'search_medicine_error'.tr,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColors.WHITE,
                                textColor: AppColors.BLACK,
                                fontSize: 16.0);
                          } else {
                            medicineController.searchMedicineApi(
                                medicineName: value);
                          }
                        },
                        cursorHeight: 20,
                        decoration: InputDecoration(
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            filled: true,
                            labelText: 'search_medicine_hint'.tr,
                            labelStyle: const TextStyle(
                                fontFamily: AppFontStyleTextStrings.regular),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                Get.focusScope?.unfocus();
                                if (medicineController
                                    .searchMedicineController.text.isEmpty) {
                                  medicineController
                                      .isSearchMedicineEmpty.value = true;
                                  Fluttertoast.showToast(
                                      msg: 'search_medicine_error'.tr,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColors.WHITE,
                                      textColor: AppColors.BLACK,
                                      fontSize: 16.0);
                                } else {
                                  medicineController.searchMedicineApi(
                                      medicineName: medicineController
                                          .searchMedicineController.text);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  AppImages.searchIconPng,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            )),
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            medicineController.isSearchMedicineEmpty.value =
                                false;
                          } else {
                            medicineController.isSearch.value = false;
                            medicineController.cnt.value = 0;

                            for (int i = 0;
                                i <
                                    medicineController
                                        .mostUsedMedicineCheak.length;
                                i++) {
                              if (medicineController.mostUsedMedicineCheak[i]) {
                                medicineController.cnt.value++;
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    medicineController.isSearch.value
                        ? (medicineController
                                .searchMedicineController.text.isEmpty
                            ? const SizedBox()
                            : !medicineController.isLoadingSearchMedicine.value
                                ? SizedBox(
                                    height: Get.height * 0.3,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : medicineController.ll.isEmpty
                                    ? Container(
                                        height: Get.height * 0.3,
                                        alignment: Alignment.center,
                                        child: AppTextWidgets.regularText(
                                          text: 'data_not_found'.tr,
                                          color: AppColors.BLACK,
                                          size: 18,
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              medicineController.ll.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                medicineController
                                                            .cheak[index] ==
                                                        true
                                                    ? medicineController
                                                        .cnt.value--
                                                    : medicineController
                                                        .cnt.value++;
                                                medicineController
                                                        .cheak[index] =
                                                    !medicineController
                                                        .cheak[index];
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    0, 5, 0, 5),
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColors.iconColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            medicineController.ll[index].name ?? "",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  AppFontStyleTextStrings
                                                                      .medium,
                                                              color: AppColors
                                                                  .reportTextColor,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            medicineController.ll[index].description ?? "",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppFontStyleTextStrings
                                                                      .regular,
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .reportTextColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Checkbox(
                                                      side: const BorderSide(
                                                          color:
                                                              AppColors.color1,
                                                          width: 1.5),
                                                      fillColor: medicineController
                                                                      .cheak[
                                                                  index] ==
                                                              true
                                                          ? const MaterialStatePropertyAll(
                                                              AppColors.color1)
                                                          : const MaterialStatePropertyAll(
                                                              Colors
                                                                  .transparent),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                      onChanged: (val) {
                                                        medicineController
                                                                        .cheak[
                                                                    index] ==
                                                                true
                                                            ? medicineController
                                                                .cnt.value--
                                                            : medicineController
                                                                .cnt.value++;
                                                        medicineController
                                                                .cheak[index] =
                                                            !medicineController
                                                                .cheak[index];
                                                        medicineController
                                                            .update();
                                                      },
                                                      value: medicineController
                                                          .cheak[index],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ))
                        : !medicineController.isMostUsedMedicineLoaded.value
                            ? SizedBox(
                                height: Get.height * 0.3,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : medicineController.mostUsedMedicineList.isEmpty
                                ? Container(
                                    height: Get.height * 0.3,
                                    alignment: Alignment.center,
                                    child: AppTextWidgets.regularText(
                                      text: 'data_not_found'.tr,
                                      color: AppColors.BLACK,
                                      size: 18,
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: medicineController
                                          .mostUsedMedicineList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            medicineController
                                                            .mostUsedMedicineCheak[
                                                        index] ==
                                                    true
                                                ? medicineController.cnt.value--
                                                : medicineController
                                                    .cnt.value++;
                                            medicineController
                                                        .mostUsedMedicineCheak[
                                                    index] =
                                                !medicineController
                                                        .mostUsedMedicineCheak[
                                                    index];
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.iconColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        medicineController.mostUsedMedicineList[index].name ?? "",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              AppFontStyleTextStrings
                                                                  .medium,
                                                          color: AppColors
                                                              .reportTextColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        medicineController.mostUsedMedicineList[index].description ?? "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppFontStyleTextStrings
                                                                  .regular,
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .reportTextColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Checkbox(
                                                  side: const BorderSide(
                                                      color: AppColors.color1,
                                                      width: 1.5),
                                                  fillColor: medicineController
                                                                  .mostUsedMedicineCheak[
                                                              index] ==
                                                          true
                                                      ? const MaterialStatePropertyAll(
                                                          AppColors.color1,
                                                        )
                                                      : MaterialStatePropertyAll(
                                                          AppColors
                                                              .transparentColor,
                                                        ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  onChanged: (val) {
                                                    medicineController
                                                                    .mostUsedMedicineCheak[
                                                                index] ==
                                                            true
                                                        ? medicineController
                                                            .cnt.value--
                                                        : medicineController
                                                            .cnt.value++;
                                                    medicineController
                                                            .mostUsedMedicineCheak[
                                                        index] = !medicineController
                                                            .mostUsedMedicineCheak[
                                                        index];
                                                  },
                                                  value: medicineController
                                                          .mostUsedMedicineCheak[
                                                      index],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (medicineController.isLoadingSearchMedicine.value ||
                            medicineController.isMostUsedMedicineLoaded.value)
                        ? GestureDetector(
                            onTap: medicineController.isSearch.value
                                ? () {
                                    List<MedicineData> ll1 = [];
                                    for (int i = 0;
                                        i < medicineController.cheak.length;
                                        i++) {
                                      if (medicineController.cheak[i]) {
                                        ll1.add(medicineController.ll[i]);
                                      }
                                    }
                                    if (ll1.isEmpty) {
                                      if (medicineController
                                          .searchMedicineController
                                          .text
                                          .isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter medicine name",
                                          backgroundColor: AppColors.WHITE,
                                          textColor: AppColors.BLACK,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        return;
                                      }
                                      ll1.add(
                                        MedicineData(
                                          name: medicineController
                                              .searchMedicineController.text,
                                        ),
                                      );
                                      Get.to(
                                        MedicinseScreen(
                                          ll: ll1,
                                          oldData:
                                              medicineController.medicineMap,
                                          id: medicineController.id,
                                          updateValue: true,
                                        ),
                                      );
                                    } else {
                                      Get.to(
                                        MedicinseScreen(
                                          ll: ll1,
                                          oldData:
                                              medicineController.medicineMap,
                                          id: medicineController.id,
                                          updateValue: false,
                                        ),
                                      );
                                    }
                                  }
                                : () {
                                    List<MedicineData> ll1 = [];
                                    for (int i = 0;
                                        i <
                                            medicineController
                                                .mostUsedMedicineCheak.length;
                                        i++) {
                                      if (medicineController
                                          .mostUsedMedicineCheak[i]) {
                                        ll1.add(medicineController
                                            .mostUsedMedicineList[i]);
                                      }
                                    }
                                    if (ll1.isEmpty) {
                                      if (medicineController
                                          .searchMedicineController
                                          .text
                                          .isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter medicine name",
                                          backgroundColor: AppColors.WHITE,
                                          textColor: AppColors.BLACK,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        return;
                                      }
                                      ll1.add(
                                        MedicineData(
                                          name: medicineController
                                              .searchMedicineController.text,
                                        ),
                                      );
                                      Get.to(
                                        MedicinseScreen(
                                          ll: ll1,
                                          oldData:
                                              medicineController.medicineMap,
                                          id: medicineController.id,
                                          updateValue: true,
                                        ),
                                      );
                                    } else {
                                      Get.to(
                                        MedicinseScreen(
                                          ll: ll1,
                                          oldData:
                                              medicineController.medicineMap,
                                          id: medicineController.id,
                                          updateValue: false,
                                        ),
                                      );
                                    }
                                  },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.color1,
                                    AppColors.color2,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      medicineController.cnt.value == 0
                                          ? 'add_new_medicine'.tr
                                          : 'add_medicine'.tr,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily:
                                            AppFontStyleTextStrings.regular,
                                        color: AppColors.WHITE,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.navigate_next_rounded,
                                    color: AppColors.WHITE,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              )
            ],
          )),
    );
  }
}


