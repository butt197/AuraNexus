import 'package:videocalling/common/utils/app_imports.dart';

class UserPastAppointmentsController extends GetxController {
  RxList<AppointmentData> list = <AppointmentData>[].obs;
  String? userId;

  RxBool isAppointmentExist = false.obs;
  RxBool isErrorInLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoaded = false.obs;

  String nextUrl = "";

  UserAppointmentsClass? userAppointmentsClass;
  ScrollController scrollController = ScrollController();

  fetchUpcomingAppointments() async {
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/userspastappointment?user_id=$userId"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInLoading.value = true;
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        isAppointmentExist.value = true;
        userAppointmentsClass = UserAppointmentsClass.fromJson(jsonResponse);
        list.addAll(userAppointmentsClass!.data!.appointmentData!);
        nextUrl = userAppointmentsClass!.data!.nextPageUrl!;
        update();
      } else {
        isAppointmentExist.value = false;
        update();
      }
    }
    isLoaded.value = true;
    update();
  }

  loadMore() async {
    if (nextUrl != "null") {
      final response = await get(Uri.parse("$nextUrl&user_id=$userId"))
          .timeout(const Duration(seconds: Apis.timeOut));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "1") {
          userAppointmentsClass = UserAppointmentsClass.fromJson(jsonResponse);
          list.addAll(userAppointmentsClass!.data!.appointmentData!);
          nextUrl = userAppointmentsClass!.data!.nextPageUrl!;
        }
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userId = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    fetchUpcomingAppointments();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }
}


