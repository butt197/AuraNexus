import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class ReviewsScreen extends GetView<ReviewController> {
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: CustomAppBar(
            title: 'review'.tr,
            isBackArrow: true,
            onPressed: () =>
                Get.back(result: reviewController.isChangesMade.value),
          ),
          leading: Container(),
        ),
        body: Obx(() => Stack(
              children: [
                reviewController.isErrorInReview.value
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
                    : reviewController.isReviewLoaded.value
                        ? reviewController.isReviewExist.value
                            ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        itemCount: reviewController
                                            .reviewsClass!.data!.length,
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            reviewController
                                                                .reviewsClass!
                                                                .data![index]
                                                                .image!,
                                                        height: 50,
                                                        width: 50,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Image.asset(
                                                              AppImages
                                                                  .tab3dUnselect,
                                                              height: 30,
                                                              width: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, err) =>
                                                            Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          15.0),
                                                                  child: Image
                                                                      .asset(
                                                                    AppImages
                                                                        .tab3dUnselect,
                                                                    height: 30,
                                                                    width: 30,
                                                                  ),
                                                                )),
                                                      ),
                                                    ),
                                                    10.ws,
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppTextWidgets
                                                                    .mediumText(
                                                                  text: reviewController
                                                                          .reviewsClass!
                                                                          .data![
                                                                              index]
                                                                          .name ??
                                                                      "",
                                                                  color:
                                                                      AppColors
                                                                          .BLACK,
                                                                  size: 16,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      int.parse(reviewController.reviewsClass!.data![index].rating ??
                                                                                  "0") >=
                                                                              1
                                                                          ? AppImages
                                                                              .starFill
                                                                          : AppImages
                                                                              .starNoFill,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Image.asset(
                                                                      int.parse(reviewController.reviewsClass!.data![index].rating ??
                                                                                  "0") >=
                                                                              2
                                                                          ? AppImages
                                                                              .starFill
                                                                          : AppImages
                                                                              .starNoFill,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Image.asset(
                                                                      int.parse(reviewController.reviewsClass!.data![index].rating ??
                                                                                  "0") >=
                                                                              3
                                                                          ? AppImages
                                                                              .starFill
                                                                          : AppImages
                                                                              .starNoFill,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Image.asset(
                                                                      int.parse(reviewController.reviewsClass!.data![index].rating ??
                                                                                  "0") >=
                                                                              4
                                                                          ? AppImages
                                                                              .starFill
                                                                          : AppImages
                                                                              .starNoFill,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Image.asset(
                                                                      int.parse(reviewController.reviewsClass!.data![index].rating ??
                                                                                  "0") >=
                                                                              5
                                                                          ? AppImages
                                                                              .starFill
                                                                          : AppImages
                                                                              .starNoFill,
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    10.ws,
                                                  ],
                                                ),
                                                10.hs,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AppTextWidgets.regularText(
                                                          text: reviewController
                                                                  .reviewsClass!
                                                                  .data![index]
                                                                  .description ??
                                                              "",
                                                          size: 11,
                                                          color: AppColors
                                                              .LIGHT_GREY_TEXT),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                  height: 20,
                                                  color:
                                                      AppColors.LIGHT_GREY_TEXT,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    80.hs,
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: Center(
                                  child: Text(
                                    'no_review'.tr,
                                    style: const TextStyle(
                                      fontFamily:
                                          AppFontStyleTextStrings.regular,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      onTap: () async {
                        if (reviewController.isLoggedIn.value) {
                          Get.bottomSheet(Obx(() => Container(
                                color: AppColors.WHITE,
                                padding: const EdgeInsets.all(15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppTextWidgets.mediumText(
                                        text: 'add_a_review'.tr,
                                        color: AppColors.BLACK,
                                        size: 15,
                                      ),
                                      15.hs,
                                      AppTextWidgets.mediumText(
                                        text: 'your_rating'.tr,
                                        color: AppColors.BLACK,
                                        size: 18,
                                      ),
                                      5.hs,
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              reviewController.starCount.value =
                                                  1;
                                            },
                                            child: Image.asset(
                                              reviewController
                                                          .starCount.value >=
                                                      1
                                                  ? AppImages.starFill
                                                  : AppImages.starNoFill,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          3.ws,
                                          InkWell(
                                            onTap: () {
                                              reviewController.starCount.value =
                                                  2;
                                            },
                                            child: Image.asset(
                                              reviewController
                                                          .starCount.value >=
                                                      2
                                                  ? AppImages.starFill
                                                  : AppImages.starNoFill,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          3.ws,
                                          InkWell(
                                            onTap: () {
                                              reviewController.starCount.value =
                                                  3;
                                            },
                                            child: Image.asset(
                                              reviewController
                                                          .starCount.value >=
                                                      3
                                                  ? AppImages.starFill
                                                  : AppImages.starNoFill,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          3.ws,
                                          InkWell(
                                            onTap: () {
                                              reviewController.starCount.value =
                                                  4;
                                            },
                                            child: Image.asset(
                                              reviewController
                                                          .starCount.value >=
                                                      4
                                                  ? AppImages.starFill
                                                  : AppImages.starNoFill,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          3.ws,
                                          InkWell(
                                            onTap: () {
                                              reviewController.starCount.value =
                                                  5;
                                            },
                                            child: Image.asset(
                                              reviewController
                                                          .starCount.value >=
                                                      5
                                                  ? AppImages.starFill
                                                  : AppImages.starNoFill,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      10.hs,
                                      TextField(
                                        controller: reviewController
                                            .textEditingController,
                                        decoration: InputDecoration(
                                          labelText: 'enter_message'.tr,
                                          labelStyle: TextStyle(
                                            color: AppColors.LIGHT_GREY_TEXT,
                                            fontFamily:
                                                AppFontStyleTextStrings.regular,
                                          ),
                                          border: const UnderlineInputBorder(),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors
                                                      .LIGHT_GREY_TEXT)),
                                        ),
                                        style: const TextStyle(
                                          color: AppColors.BLACK,
                                          fontFamily:
                                              AppFontStyleTextStrings.regular,
                                        ),
                                        onChanged: (val) {
                                          reviewController.message.value = val;
                                        },
                                      ),
                                      Container(
                                        height: 50,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 20),
                                        child: InkWell(
                                          onTap: () {
                                            Get.focusScope?.unfocus();
                                            reviewController.uploadReview();
                                          },
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        AppColors.color1,
                                                        AppColors.color2,
                                                      ],
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end: Alignment.topRight,
                                                    ),
                                                  ),
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                              ),
                                              Center(
                                                child:
                                                    AppTextWidgets.mediumText(
                                                  text: 'btn_submit'.tr,
                                                  color: AppColors.WHITE,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
                        } else {
                          await Get.toNamed(Routes.loginUserScreen, arguments: {
                            "isBack": false,
                          });
                        }
                      },
                      btnText: reviewController.isLoggedIn.value
                          ? 'add_a_review'.tr
                          : 'login_to_review'.tr,
                    )),
              ],
            )),
      ),
      onWillPop: () {
        Get.back(result: reviewController.isChangesMade.value);
        return Future.value();
      },
    );
  }
}


