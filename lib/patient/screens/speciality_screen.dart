import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class SpecialityScreen extends GetView<SpecialityController> {
  final SpecialityController specialityController =
      Get.put(SpecialityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'speciality'.tr,
          onPressed: () => Get.back(),
          isBackArrow: true,
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: Obx(() => specialityController.isErrorInLoading.value
          ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 100,
                  color: AppColors.LIGHT_GREY_TEXT,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'unable_to_load_data'.tr,
                  style: const TextStyle(
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                )
              ],
            ),
          )
          : specialityController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: specialityController.list.length > 4
                            ? (specialityController.list.length / 4).ceil()
                            : 1,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              GridView.count(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                physics: const ClampingScrollPhysics(),
                                children: List.generate(4, (index) {
                                  return InkWell(
                                    onTap: () async {
                                      if (index + (i * 4) <=
                                          specialityController.list.length -
                                              1) {
                                        await Get.toNamed(
                                          Routes.specialityDoctorScreen,
                                          arguments: {
                                            'id': specialityController
                                                .list[index + (i * 4)].id
                                                .toString(),
                                            'name': specialityController
                                                .list[index + (i * 4)].name
                                                .toString(),
                                          },
                                        );
                                        Get.delete<
                                            SpecialityDoctorController>();
                                      }
                                    },
                                    child: index + (i * 4) >
                                            specialityController.list.length - 1
                                        ? Container()
                                        : Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Expanded(
                                                    child: Image.asset(
                                                      AppImages.specialityBg,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(13),
                                                      child: Image.network(
                                                        specialityController
                                                            .list[
                                                                index + (i * 4)]
                                                            .icon!,
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    AppTextWidgets.mediumText(
                                                      text: specialityController
                                                              .list[index +
                                                                  (i * 4)]
                                                              .name ??
                                                          "",
                                                      color: AppColors.BLACK,
                                                      size: 15,
                                                    ),
                                                    AppTextWidgets.mediumText(
                                                      text: specialityController
                                                              .list[index +
                                                                  (i * 4)]
                                                              .totalDoctors
                                                              .toString() +
                                                          "specialist".tr,
                                                      color: AppColors
                                                          .LIGHT_GREY_TEXT,
                                                      size: 13,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )),
    );
  }
}


