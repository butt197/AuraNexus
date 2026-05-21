import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserHomeScreen extends GetView<UserHomeController> {
  final UserHomeController homeController = Get.put(UserHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.transparentColor,
        toolbarHeight: kToolbarHeight + 62,
        flexibleSpace: Obx(() => CustomHomeScreenAppBar(
              title: 'welcome_str'.tr,
              title1: StorageService.readData(key: LocalStorageKeys.name) ??
                  'user_str'.tr,
              textController: homeController.textController,
              valueColor: homeController.isSearching.value &&
                      !homeController.isSearchDataLoaded.value
                  ? AlwaysStoppedAnimation(Theme.of(context).hintColor)
                  : AlwaysStoppedAnimation(AppColors.transparentColor),
              onChanged: (val) {
                homeController.searchKeyword.value = val;
                homeController.onChanged(val);
              },
              onSubmitted: (val) {
                homeController.searchKeyword.value = val;
              },
              onPressed: () async {
                Get.focusScope?.unfocus();
                await Get.toNamed(Routes.dSearchScreen,
                    arguments: {'keyword': homeController.textController.text});
                Get.delete<DoctorSearchController>();
                homeController.newData.clear();
                homeController.textController.clear();
                homeController.searchKeyword.value = "";
                homeController.update();

                if (homeController.searchKeyword.isEmpty && homeController.isSearching.value) {
                  homeController.newData.clear();
                  homeController.isSearching.value = false;
                  homeController.pageController.previousPage(
                    duration: const Duration(milliseconds: 850),
                    curve: Curves.linear,
                  );
                }
              },
            )),
      ),
      body: Obx(
        () => PageView(
          controller: homeController.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              controller: homeController.scrollController2,
              child: Column(
                children: [
                  Obx(() => homeController.isErrorInLoading.value
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              20.hs,
                              Icon(
                                Icons.search_off_rounded,
                                size: 100,
                                color: AppColors.LIGHT_GREY_TEXT,
                              ),
                              10.hs,
                              Text(
                                'unable_to_load_data'.tr,
                                style: const TextStyle(
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                              ),
                              20.hs,
                            ],
                          ),
                        )
                      : homeController.isDataLoaded.value
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CarouselSlider.builder(
                                      carouselController:
                                          homeController.sliderController,
                                      itemCount:
                                          homeController.bannerList.length,
                                      itemBuilder: (context, index, realIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: (Apis.IMAGE +
                                                    homeController
                                                        .bannerList[index]
                                                        .image!),
                                                fit: BoxFit.cover,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                        )),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 220,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .sliderPlaceholder),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, err) =>
                                                        Container(
                                                  height: 220,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                        AppImages.sliderError,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: homeController
                                                          .bannerList
                                                          .asMap()
                                                          .entries
                                                          .map((entry) {
                                                        return GestureDetector(
                                                            child: Container(
                                                          width: 12.0,
                                                          height: 12.0,
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      4.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: homeController
                                                                        .current
                                                                        .value ==
                                                                    entry.key
                                                                ? AppColors
                                                                    .BLACK
                                                                : AppColors
                                                                    .greyShade3,
                                                          ),
                                                        ));
                                                      }).toList()),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        height: Get.width * 0.55,
                                        initialPage: 0,
                                        reverse: false,
                                        autoPlay: true,
                                        onPageChanged: (index, reason) {
                                          homeController.current.value = index;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                homeController.isLoggedIn.value
                                    ? Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('upcoming_appointments'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .apply(
                                                            fontWeightDelta:
                                                                3)),
                                                homeController.appointmentList
                                                        .isNotEmpty
                                                    ? TextButton(
                                                        onPressed: () async {
                                                          Get.focusScope
                                                              ?.unfocus();
                                                          await Get.toNamed(Routes
                                                              .uAllAppointmentsScreen);
                                                          Get.delete<
                                                              UAllAppointmentsController>();
                                                        },
                                                        child: Text(
                                                            'see_all'.tr,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .apply(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                )),
                                                      )
                                                    : Container(
                                                        height: 40,
                                                      )
                                              ],
                                            ),
                                            homeController
                                                    .appointmentList.isEmpty
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30.0),
                                                      child: Column(
                                                        children: [
                                                          Image.asset(AppImages
                                                              .noAppointment),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          AppTextWidgets
                                                              .blackTextWithSize(
                                                            text:
                                                                'not_appointment1'
                                                                    .tr,
                                                            size: 11,
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    (Get.width -
                                                                            95) *
                                                                        0.75,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  'not_appointment2'
                                                                      .tr,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          AppFontStyleTextStrings
                                                                              .medium,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Get.focusScope
                                                                      ?.unfocus();
                                                                  await Get.toNamed(
                                                                      Routes
                                                                          .specialityScreen);
                                                                  Get.delete<
                                                                      SpecialityController>();
                                                                },
                                                                child: SizedBox(
                                                                  width: (Get.width -
                                                                          95) *
                                                                      0.25,
                                                                  child: AppTextWidgets.blackText(
                                                                      text: 'not_appointment3'
                                                                          .tr,
                                                                      size: 10,
                                                                      color: AppColors
                                                                          .AMBER),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    itemCount: homeController
                                                                .appointmentList
                                                                .length >
                                                            2
                                                        ? 2
                                                        : homeController
                                                            .appointmentList
                                                            .length,
                                                    shrinkWrap: true,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        onTap: () {
                                                          Get.focusScope
                                                              ?.unfocus();
                                                          Get.toNamed(
                                                              Routes
                                                                  .uAppointmentDetailScreen,
                                                              arguments: {
                                                                'id': homeController
                                                                    .appointmentList[
                                                                        index]
                                                                    .id
                                                                    .toString()
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 90,
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                AppColors.WHITE,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      "${Apis.doctorImagePath}${homeController.appointmentList[index].doctorls!.image}",
                                                                  height: 70,
                                                                  width: 70,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Container(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorLight,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                      child: Image
                                                                          .asset(
                                                                        AppImages
                                                                            .tab3dUnselect,
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          err) =>
                                                                      Container(
                                                                          color: Theme.of(context)
                                                                              .primaryColorLight,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(20.0),
                                                                            child:
                                                                                Image.asset(
                                                                              AppImages.tab3dUnselect,
                                                                              height: 20,
                                                                              width: 20,
                                                                            ),
                                                                          )),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        AppTextWidgets
                                                                            .mediumText(
                                                                          text: homeController.appointmentList[index].doctorls!.name ??
                                                                              "",
                                                                          color:
                                                                              AppColors.BLACK,
                                                                          size:
                                                                              13,
                                                                        ),
                                                                        AppTextWidgets.regularText(
                                                                            text: homeController.appointmentList[index].departmentName ??
                                                                                "",
                                                                            size:
                                                                                11,
                                                                            color:
                                                                                AppColors.BLACK),
                                                                      ],
                                                                    ),
                                                                    5.hs,
                                                                    Text(
                                                                      homeController
                                                                              .appointmentList[index]
                                                                              .doctorls!
                                                                              .address ??
                                                                          "",
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .LIGHT_GREY_TEXT,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              AppFontStyleTextStrings.regular),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Image.asset(
                                                                    AppImages
                                                                        .calender,
                                                                    height: 17,
                                                                    width: 17,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  AppTextWidgets.regularText(
                                                                      text:
                                                                          "${homeController.appointmentList[index].date.toString().substring(8)}-${homeController.appointmentList[index].date.toString().substring(5, 7)}-${homeController.appointmentList[index].date.toString().substring(0, 4)}",
                                                                      size: 11,
                                                                      color: AppColors
                                                                          .LIGHT_GREY_TEXT),
                                                                  AppTextWidgets
                                                                      .mediumText(
                                                                    text: homeController
                                                                            .appointmentList[index]
                                                                            .slot ??
                                                                        "",
                                                                    color: AppColors
                                                                        .BLACK,
                                                                    size: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'speciality'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .apply(
                                              fontWeightDelta: 3,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 70,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.separated(
                                            itemCount:
                                                homeController.list.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  Get.focusScope?.unfocus();
                                                  await Get.toNamed(
                                                    Routes
                                                        .specialityDoctorScreen,
                                                    arguments: {
                                                      'id': homeController
                                                          .list[index].id
                                                          .toString(),
                                                      'name': homeController
                                                          .list[index].name,
                                                    },
                                                  );
                                                  Get.delete<
                                                      SpecialityDoctorController>();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColors.WHITE,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child: Image.network(
                                                            "${Apis.specialityImagePath}${homeController.list[index].icon}",
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          homeController
                                                                  .list[index]
                                                                  .name ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                AppFontStyleTextStrings
                                                                    .medium,
                                                            color:
                                                                AppColors.BLACK,
                                                            fontSize: 15,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return const SizedBox(
                                                width: 10,
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container(
                              height: Get.height * 0.35,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator())),
                  Obx(() => homeController.isErrorInLoadDoctorData.value
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('nearby_doctors'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(fontWeightDelta: 3)),
                                  TextButton(
                                    onPressed: () async {
                                      Get.focusScope?.unfocus();
                                      await Get.toNamed(
                                          Routes.dAllNearbyScreen);
                                      Get.delete<DAllNearbyController>();
                                    },
                                    child: Text('see_all'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .apply(
                                              color:
                                                  Theme.of(context).hintColor,
                                            )),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 5),
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 0.75,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: homeController.list2.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          var data =
                                              homeController.list2[index];
                                          return InkWell(
                                            onTap: () async {
                                              Get.focusScope?.unfocus();
                                              await Get.toNamed(
                                                  Routes.doctorDetailScreen,
                                                  arguments: {
                                                    'id': data.id.toString()
                                                  });
                                              Get.delete<
                                                  DoctorDetailController>();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 10, 20),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            data.image ?? "",
                                                        fit: BoxFit.cover,
                                                        width: 250,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          child: Center(
                                                            child: Image.asset(
                                                              AppImages
                                                                  .tab3dUnselect,
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, err) =>
                                                            Container(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          child: Center(
                                                            child: Image.asset(
                                                              AppImages
                                                                  .tab3dUnselect,
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    data.name ?? "",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          AppFontStyleTextStrings
                                                              .medium,
                                                      color: AppColors.BLACK,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  AppTextWidgets.mediumText(
                                                    text: data.departmentName ??
                                                        "",
                                                    color: AppColors
                                                        .LIGHT_GREY_TEXT,
                                                    size: 9.5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      homeController.nextUrlDoctor.value ==
                                              "null"
                                          ? Container()
                                          : const Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  !homeController.isSearchDataLoaded.value
                      ? 0.hs
                      : homeController.newData.isNotEmpty
                          ? 0.hs
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 50.0),
                              child: Center(
                                child: Text(
                                  'doctor_not_found'.tr,
                                  style: TextStyle(
                                    fontFamily: AppFontStyleTextStrings.regular,
                                    fontSize: 20,
                                    color: homeController.newData.isEmpty
                                        ? AppColors.BLACK
                                        : AppColors.transparentColor,
                                  ),
                                ),
                              ),
                            ),
                  Expanded(
                    child: ListView.separated(
                        controller: homeController.scrollController,
                        itemCount: homeController.newData.length,
                        separatorBuilder: (context, index) => const Divider(
                              endIndent: 7,
                              indent: 7,
                              thickness: 1,
                            ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await Get.toNamed(Routes.doctorDetailScreen,
                                  arguments: {
                                    'id': homeController.newData[index].id
                                        .toString()
                                  });
                              Get.delete<DoctorDetailController>();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppTextWidgets.regularText(
                                    text: homeController.newData[index].name ??
                                        "",
                                    color: Theme.of(context).primaryColorDark,
                                    size: 14,
                                  ),
                                  const Icon(
                                    Icons.search,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  homeController.isLoadingMore.value
                      ? const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


