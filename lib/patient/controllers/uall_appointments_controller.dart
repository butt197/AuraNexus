import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UAllAppointmentsController extends GetxController {
  RxList<UAppointmentData> list = <UAppointmentData>[].obs;
  RxString userId = "".obs;
  Future? loadAppointments;
  RxBool isAppointmentExist = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString nextUrl = "".obs;
  UserAAppointmentsClass? userAppointmentsClass;
  ScrollController scrollController = ScrollController();

  fetchUpcomingAppointments() async {
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/usersuappointment?user_id=${userId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        isAppointmentExist.value = true;
        userAppointmentsClass = UserAAppointmentsClass.fromJson(jsonResponse);
        list.addAll(userAppointmentsClass!.data!.appointmentData!);
        nextUrl.value = userAppointmentsClass!.data!.nextPageUrl!;
      } else {
        isAppointmentExist.value = false;
      }
    }
  }

  loadMore() async {
    if (nextUrl.value != "null") {
      final response =
          await get(Uri.parse("${nextUrl.value}&user_id=${userId.value}"))
              .timeout(const Duration(seconds: Apis.timeOut));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "1") {
          userAppointmentsClass = UserAAppointmentsClass.fromJson(jsonResponse);
          list.addAll(userAppointmentsClass!.data!.appointmentData!);
          nextUrl.value = userAppointmentsClass!.data!.nextPageUrl!;
        }
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userId.value = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    loadAppointments = fetchUpcomingAppointments();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }
}


