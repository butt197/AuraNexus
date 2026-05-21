import 'package:videocalling/common/utils/app_imports.dart';

import '../utils/doctor_imports.dart';

class SearchMedicineController extends GetxController {
  dynamic medicineMap = Get.arguments['medicineMap'];
  int id = Get.arguments['id'];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    callMostUsedMedicineApi();
  }

  TextEditingController searchMedicineController = TextEditingController();
  RxBool isSearchMedicineEmpty = false.obs;
  RxBool isMostUsedMedicineLoaded = false.obs;
  RxBool isLoadingSearchMedicine = false.obs;
  RxBool isSearch = false.obs;

  RxInt cnt = 0.obs;

  SearchAddMedicineModel searchAddMedicineModel = SearchAddMedicineModel();

  RxList<MedicineData> ll = <MedicineData>[].obs;
  RxList<MedicineData> mostUsedMedicineList = <MedicineData>[].obs;
  RxList<bool> mostUsedMedicineCheak = <bool>[].obs;
  RxList<bool> cheak = <bool>[].obs;

  callMostUsedMedicineApi() async {
    isMostUsedMedicineLoaded.value = false;
    mostUsedMedicineList.clear();

    var response =
        await get(Uri.parse("${Apis.ServerAddress}/api/most_used_medicine"))
            .timeout(const Duration(seconds: Apis.timeOut));

    if (response.statusCode == 200) {
      searchAddMedicineModel =
          SearchAddMedicineModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < searchAddMedicineModel.data!.length; i++) {
        mostUsedMedicineList.add(searchAddMedicineModel.data![i]);
      }
      mostUsedMedicineCheak.value =
          List.filled(mostUsedMedicineList.length, false);
      isMostUsedMedicineLoaded.value = true;
    } else {
      isMostUsedMedicineLoaded.value = true;
      ll.clear();
    }
    cnt.value = 0;
    Client().close();
  }

  searchMedicineApi({required String medicineName}) async {
    isSearch.value = true;
    isLoadingSearchMedicine.value = false;
    ll.clear();
    var response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/search_medicine?name=$medicineName"))
        .timeout(const Duration(seconds: Apis.timeOut));

    if (response.statusCode == 200) {
      searchAddMedicineModel =
          SearchAddMedicineModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < searchAddMedicineModel.data!.length; i++) {
        ll.add(searchAddMedicineModel.data![i]);
      }
      cheak.value = List.filled(ll.length, false);
      isLoadingSearchMedicine.value = true;
    } else {
      isLoadingSearchMedicine.value = true;
      ll.clear();
    }
    cnt.value = 0;
    Client().close();
  }
}


