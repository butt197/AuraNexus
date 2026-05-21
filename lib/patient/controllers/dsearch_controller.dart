import 'package:videocalling/common/utils/app_imports.dart';

import 'package:videocalling/patient/utils/patient_imports.dart';

class DoctorSearchController extends GetxController {
  String keyword = Get.arguments['keyword'];

  RxBool isSearching = false.obs;
  RxBool isLoading = false.obs;
  RxBool isErrorInLoading = false.obs;
  SearchDoctorClass? searchDoctorClass;
  RxList<SDoctorData> newData = <SDoctorData>[].obs;
  RxString nextUrl = "".obs;
  RxBool isLoadingMore = false.obs;
  RxString searchKeyword = "".obs;
  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  SpecialityClass? specialityClass;
  RxList<String> departmentList = <String>[].obs;

  onChanged(String value) async {
    if (value.length == 0) {
      newData.clear();
      isErrorInLoading.value = false;
      isSearching.value = false;
    } else {
      isLoading.value = true;
      isSearching.value = true;
      final response = await get(
              Uri.parse("${Apis.ServerAddress}/api/searchdoctor?term=$value"))
          .catchError((e) {
        isLoading.value = false;
        isErrorInLoading.value = true;
      });
      try {
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
          newData.clear();
          newData.addAll(searchDoctorClass!.data!.doctorData!);
          nextUrl.value = searchDoctorClass!.data!.links!.last.url!;
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        isErrorInLoading.value = true;
      }
    }
  }

  _loadMoreFunc() async {
    if (nextUrl.value.isEmpty) {
      return;
    }
    isLoadingMore.value = true;
    final response = await get(Uri.parse("$nextUrl&term=$searchKeyword"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);

      newData.addAll(searchDoctorClass!.data!.doctorData ?? []);
      isLoadingMore.value = false;
      nextUrl.value = searchDoctorClass!.data!.links!.last.url!;
    }
  }

  onSubmit(String value) async {
    if (value.length == 0) {
      newData.clear();

      isSearching.value = false;
    } else {
      isLoading.value = true;
      isSearching.value = true;
      final response = await get(
          Uri.parse("${Apis.ServerAddress}/api/searchdoctor?term=$value"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
        newData.clear();
        newData.addAll(searchDoctorClass!.data!.doctorData!);
        nextUrl.value = searchDoctorClass!.data!.links!.last.url!;
        isLoading.value = false;
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onChanged(keyword);
    textController.text = keyword;
    searchKeyword.value = keyword;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _loadMoreFunc();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }
}


