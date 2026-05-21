import 'package:videocalling/common/utils/app_imports.dart';

class SpecialityController extends GetxController {
  SpecialityClass? specialityClass;
  RxBool isLoading = true.obs;
  RxBool isErrorInLoading = false.obs;
  List<Speciality> list = [];

  getSpeciality() async {
    isLoading.value = true;
    final response =
        await get(Uri.parse("${Apis.ServerAddress}/api/getspeciality"))
            .timeout(const Duration(seconds: Apis.timeOut))
            .catchError((e) {
      isErrorInLoading.value = true;
    });

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        specialityClass = SpecialityClass.fromJson(jsonResponse);
        list.addAll(specialityClass!.data!);
        isLoading.value = false;
      }
    } catch (e) {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (list.isEmpty) {
      getSpeciality();
    }
  }
}


