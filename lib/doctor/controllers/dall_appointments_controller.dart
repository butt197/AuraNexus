import 'package:videocalling/common/utils/app_imports.dart';

import '../utils/doctor_imports.dart';

class DAllAppointmentsController extends GetxController {
  DoctorPastAppointmentsClass? doctorPastAppointmentsClass;
  RxString userId = "".obs;
  RxBool isAppointmentAvailable = false.obs;
  RxString nextUrl = "".obs;
  RxBool isLoadingMore = false.obs;
  RxList<DoctorAppointmentData> list = <DoctorAppointmentData>[].obs;
  List<DoctorAppointmentData> list2 = [];
  ScrollController scrollController = ScrollController();
  RxBool isLoaded = false.obs;
  RxBool isErrorInLoading = false.obs;

  fetchPastAppointments() async {
    final response = await get(Uri.parse(
        "${Apis.ServerAddress}/api/doctoruappointment?doctor_id=${userId.value}"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == "1") {
        isLoaded.value = true;
        isAppointmentAvailable.value = true;
        doctorPastAppointmentsClass =
            DoctorPastAppointmentsClass.fromJson(jsonResponse);
        nextUrl.value = doctorPastAppointmentsClass!.data!.nextPageUrl!;
        list.addAll(doctorPastAppointmentsClass!.data!.doctorAppointmentData!);
      } else {
        isLoaded.value = true;
        isAppointmentAvailable.value = false;
      }
    } else {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  loadMore() async {
    if (nextUrl.value != "null") {
      final response =
          await get(Uri.parse("${nextUrl.value}&doctor_id=${userId.value}"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == "1") {
          isLoadingMore.value = false;
          doctorPastAppointmentsClass =
              DoctorPastAppointmentsClass.fromJson(jsonResponse);
          nextUrl.value = doctorPastAppointmentsClass!.data!.nextPageUrl!;
          list2.clear();
          list2.addAll(
              doctorPastAppointmentsClass!.data!.doctorAppointmentData!);
          list.addAll(list2);
        }
      }
      Client().close();
    }
  }

  @override
  void onClose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userId.value = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    fetchPastAppointments();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await loadMore();
      }
    });
  }
}


