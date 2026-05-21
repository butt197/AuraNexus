import 'package:videocalling/common/utils/app_imports.dart';

import 'package:videocalling/patient/utils/patient_imports.dart';

class ReviewController extends GetxController {
  String id = Get.arguments['id'];

  RxInt starCount = 0.obs;
  RxString message = "".obs;
  String? user_id = "";
  String doctor_id = "";
  RxString description = "".obs;
  RxBool showSheet = false.obs;
  ReviewsClass? reviewsClass;
  TextEditingController textEditingController = TextEditingController();
  RxBool isReviewExist = false.obs;
  RxBool isErrorInReview = false.obs;
  RxBool isReviewLoaded = false.obs;
  RxBool isLoggedIn = false.obs;

  RxBool isChangesMade = false.obs;

  fetchReviews() async {
    isReviewLoaded.value = false;
    isReviewExist.value = false;
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/reviewlistbydoctor?doctor_id=$id"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInReview.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == 1) {
        reviewsClass = ReviewsClass.fromJson(jsonResponse);
        isReviewExist.value = true;
        isReviewLoaded.value = true;
      } else {
        isReviewLoaded.value = true;
        isReviewExist.value = false;
      }
    } else {
      isErrorInReview.value = true;
    }
  }

  uploadReview() async {
    Get.back();
    customDialog1(s1: 'uploading_review'.tr, s2: 'wait_for_while'.tr);
    final response =
        await post(Uri.parse("${Apis.ServerAddress}/api/addreview"), body: {
      "user_id": user_id,
      "rating": starCount.value.toString(),
      "doc_id": id,
      "description": message.value,
    }).timeout(const Duration(seconds: Apis.timeOut)).catchError((e) {
      Get.back();
      customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse["success"] == 1) {
        Get.back();
        textEditingController.text = "";
        starCount.value = 0;
        isChangesMade.value = true;
        fetchReviews();
      } else {
        Get.back();
        customDialog(s1: 'error'.tr, s2: jsonResponse["register"]);
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoggedIn.value =
        StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;
    user_id = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    fetchReviews();
  }
}


