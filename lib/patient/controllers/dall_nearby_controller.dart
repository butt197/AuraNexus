import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DAllNearbyController extends GetxController {
  RxBool isErrorInNearby = false.obs;
  RxBool isNearbyLoading = true.obs;
  RxList<NearbyData> list = <NearbyData>[].obs;
  RxBool isLoadingMore = false.obs;
  RxString nextUrl = "".obs;
  RxBool isErrorInLoading = false.obs;
  RxString lat = "".obs;
  RxString lon = "".obs;
  NearbyDoctorsClass? nearbyDoctorsClass;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _getLocationStart();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreFunc();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }

  loadMoreFunc() async {
    if (nextUrl.value != "null") {
      final response =
          await get(Uri.parse("${nextUrl.value}&lat=$lat&lon=$lon"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
        nextUrl.value = nearbyDoctorsClass!.data!.nextPageUrl!;
        list.addAll(nearbyDoctorsClass!.data!.nearbyData!);
      }
    }
  }

  callApi({double? latitude, double? longitude}) async {
    final response = await get(Uri.parse(Platform.isIOS
            ? "${Apis.ServerAddress}/api/nearbydoctor?lat=${0.0}&lon=${0.0}"
            : "${Apis.ServerAddress}/api/nearbydoctor?lat=$latitude&lon=$longitude"))
        .catchError((e) {
      isErrorInNearby.value = true;
      customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
    });
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      lat.value = latitude.toString();
      lon.value = longitude.toString();
      nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
      list.addAll(nearbyDoctorsClass!.data!.nearbyData!);
      nextUrl.value = nearbyDoctorsClass!.data!.nextPageUrl!;
      isNearbyLoading.value = false;
    } else {
      isErrorInNearby.value = true;
      customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
    }
  }

  void _getLocationStart() async {
    isErrorInNearby.value = false;
    isNearbyLoading.value = true;
    if (Platform.isIOS) {
      callApi(latitude: 0.0, longitude: 0.0);
    } else {
      Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      callApi(latitude: position.latitude, longitude: position.longitude);
    }
  }
}


