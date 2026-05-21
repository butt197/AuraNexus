import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class StepThreeDetailsController extends GetxController {
  String id = Get.arguments['id'];
  MyData myData = Get.arguments['myData'];
  String doctorId = Get.arguments['doctorId'];
  String base64image = Get.arguments['base64image'];

  RxBool areChangesMade = false.obs;
  RxBool isErrorInLoading = false.obs;
  RxBool isDataLoaded = false.obs;
  RxBool isSlotAvailable = false.obs;

  RxList<SlotsData> slotsData = <SlotsData>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDoctorSlots();
    getSpecialities();
  }

  Future<bool> onWillPopScope() async {
    Get.back(result: areChangesMade.value);
    return false;
  }

  RxInt departmentId = 1.obs;

  getSpecialities() async {
    departmentId.value = 0;
    final response =
        await get(Uri.parse("${Apis.ServerAddress}/api/getspeciality"))
            .timeout(const Duration(seconds: Apis.timeOut));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      SpecialityClass specialityClass = SpecialityClass.fromJson(jsonResponse);
      for (int i = 0; i < specialityClass.data!.length; i++) {
        if (specialityClass.data![i].name == myData.departmentName) {
          departmentId.value = i + 1;
          break;
        }
      }
    }
    Client().close();
  }

  var scheduleResponse;
  fetchDoctorSlots() async {
    scheduleResponse = await get(Uri.parse(
            "${Apis.ServerAddress}/api/getdoctorschedule?doctor_id=$doctorId"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      customDialog(s1: 'error'.tr, s2: "${scheduleResponse.reasonPhrase}");
      isErrorInLoading.value = true;
    });
    if (scheduleResponse.statusCode == 200) {
      final jsonResponse = jsonDecode(scheduleResponse.body);
      if (jsonResponse['success'].toString() == "1") {
        DoctorSlotsDetails doctorSlotsDetails =
            DoctorSlotsDetails.fromJson(jsonResponse);
        if (doctorSlotsDetails.data!.isEmpty) {
          isSlotAvailable.value = false;
        } else {
          for (int i = 0; i < doctorSlotsDetails.data!.length; i++) {
            slotsData.add(doctorSlotsDetails.data![i]);
            isError.add(false.obs);
            errorMessage.add("x");
            startTime.add(doctorSlotsDetails.data![i].startTime!);
            endTime.add(doctorSlotsDetails.data![i].endTime!);
            slotsList.add(doctorSlotsDetails.data![i].getslotls!.obs);
            selectedvValue
                .add("${doctorSlotsDetails.data![i].duration} ${'min_str'.tr}");
            textEditingControllerEndTime
                .add(TextEditingController(text: endTime[i]));
            textEditingControllerStartTime
                .add(TextEditingController(text: startTime[i]));
          }
        }
        isDataLoaded.value = true;
      } else {
        isDataLoaded.value = true;
        isSlotAvailable.value = false;
      }
    } else {
      customDialog(s1: 'error'.tr, s2: "${scheduleResponse.reasonPhrase}");
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  generateJson() {
    List<int> slotsCount = [0, 0, 0, 0, 0, 0, 0];
    if (slotsData.isEmpty) {
      customDialog(s1: 'empty_str'.tr, s2: 'no_changes_made'.tr);
    } else {
      for (int i = 0; i < slotsData.length; i++) {
        if (slotsData[i].dayId == 0) {
          slotsCount[0] = slotsCount[0] + 1;
        } else if (slotsData[i].dayId == 1) {
          slotsCount[1] = slotsCount[1] + 1;
        } else if (slotsData[i].dayId == 2) {
          slotsCount[2] = slotsCount[2] + 1;
        } else if (slotsData[i].dayId == 3) {
          slotsCount[3] = slotsCount[3] + 1;
        } else if (slotsData[i].dayId == 4) {
          slotsCount[4] = slotsCount[4] + 1;
        } else if (slotsData[i].dayId == 5) {
          slotsCount[5] = slotsCount[5] + 1;
        } else if (slotsData[i].dayId == 6) {
          slotsCount[6] = slotsCount[6] + 1;
        }
      }

      String x = "{\"timing\":{";
      for (int i = 0; i < 7; i++) {
        int z = 0;
        x = "$x\"$i\":[";
        for (int j = 0; j < slotsData.length; j++) {
          if (i == slotsData[j].dayId) {
            z = z + 1;
            x = "$x{\"start_time\":\"${startTime[j]}\",\"end_time\":\"${endTime[j]}\",\"duration\":\"${selectedvValue[j]!.substring(0, 2)}\"}${slotsCount[i] == z ? "" : ","}";
          }
        }
        x = "$x]${i < 6 ? "," : ""}";
      }
      x = "$x}}";
      bool isErrorExist = false;
      String msg = "";
      for (int i = 0; i < isError.length; i++) {
        if (isError[i].value) {
          isErrorExist = true;
          msg = errorMessage[i];
          break;
        }
      }

      isErrorExist ? customDialog(s1: 'error'.tr, s2: msg) : uploadData(x);
    }
  }

  uploadData(x) async {
    customDialog1(s1: 'reporting_dialog1'.tr, s2: 'while_saving_changes'.tr);

    if (base64image == "null") {
      final response = await post(
          Uri.parse("${Apis.ServerAddress}/api/doctoreditprofile"),
          body: {
            "doctor_id": doctorId,
            "name": myData.name,
            "password": myData.password,
            "email": myData.email,
            "consultation_fees": myData.consultationFees,
            "aboutus": myData.aboutus,
            "working_time": myData.workingTime,
            "address": myData.address,
            "lat": myData.lat,
            "lon": myData.lon,
            "phoneno": myData.phoneno,
            "services": myData.services,
            "healthcare": myData.healthcare,
            "department_id": departmentId.toString(),
            "time_json": x,
          }).timeout(const Duration(seconds: Apis.timeOut)).catchError((e) {
        Get.back();
        customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
        customDialog(s1: 'empty_str'.tr, s2: 'no_changes_made'.tr);
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "1") {
          Get.back();
          customDialog(
            s1: 'success'.tr,
            s2: 'time_slot_added_successfully'.tr,
            onPressed: () {
              isError.clear();
              errorMessage.clear();
              selectedvValue.clear();
              startTime.clear();
              endTime.clear();
              slotsList.clear();
              slotsData.clear();
              textEditingControllerEndTime.clear();
              textEditingControllerStartTime.clear();
              fetchDoctorSlots();
              areChangesMade.value = true;
              Get.back(result: areChangesMade.value);
              Get.back(result: areChangesMade.value);
            },
          );
          return false;
        } else {
          Get.back();
          customDialog(s1: 'error'.tr, s2: jsonResponse['register']);
        }
      }
    } else {
      final response = await post(
          Uri.parse("${Apis.ServerAddress}/api/doctoreditprofile"),
          body: {
            "doctor_id": doctorId,
            "name": myData.name,
            "password": myData.password,
            "email": myData.email,
            "consultation_fees": myData.consultationFees,
            "aboutus": myData.aboutus,
            "working_time": myData.workingTime,
            "address": myData.address,
            "lat": myData.lat,
            "lon": myData.lon,
            "phoneno": myData.phoneno,
            "services": myData.services,
            "healthcare": myData.healthcare,
            "image": base64image,
            "department_id": departmentId.toString(),
            "time_json": x,
          }).timeout(const Duration(seconds: Apis.timeOut)).catchError((e) {
        Get.back();
        customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "1") {
          Get.back();
          customDialog(
            s1: 'success'.tr,
            s2: 'time_slot_added_successfully'.tr,
            onPressed: () {
              isError.clear();
              errorMessage.clear();
              selectedvValue.clear();
              startTime.clear();
              endTime.clear();
              slotsList.clear();
              slotsData.clear();
              textEditingControllerEndTime.clear();
              textEditingControllerStartTime.clear();
              fetchDoctorSlots();
              areChangesMade.value = true;
              Get.back(result: areChangesMade.value);
              Get.back(result: areChangesMade.value);
            },
          );
        } else {
          Get.back();
          customDialog(s1: 'error'.tr, s2: jsonResponse['register']);
        }
      }
    }
    Client().close();
  }

  slotsDistribution(String startTime, String endTime, interval, i) {
    if (interval.toString().isEmpty) {
      slotsList[i].clear();
      return;
    }
    slotsList[i].clear();
    try {
      if (int.parse(startTime.split(":")[1]) >= 60 ||
          int.parse(endTime.split(":")[1]) >= 60) {
        errorMessage[i] = 'timing_wrong'.tr;
        isError[i].value = true;
      } else {
        DateTime d1 = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            int.parse(startTime.split(":")[0]),
            int.parse(startTime.split(":")[1]));
        DateTime d2 = DateTime(dateTime.year, dateTime.month, dateTime.day,
            int.parse(endTime.split(":")[0]), int.parse(endTime.split(":")[1]));
        if (d2.difference(d1).inMinutes.isNegative) {
          errorMessage[i] = 'end_time_small_then_start_time'.tr;
          isError[i].value = true;
        } else {
          for (int x = 0; x < d2.difference(d1).inMinutes / interval; x++) {
            dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              int.parse(startTime.split(":")[0]),
              int.parse(startTime.split(":")[1]),
            );
            int ii = interval;
            slotsList[i].add(Getslotls(
                slot:
                    "${dateTime.add(Duration(minutes: x * ii)).toString().substring(11, 16)}${dateTime.add(Duration(minutes: x * ii)).hour > 12 ? "pm_str".tr : "am_str".tr}"));
          }
        }
      }
    } catch (e) {
      errorMessage[i] = 'start_end_time_wrong'.tr;
      isError[i].value = true;
    }
  }

  List<String> slotsInterval = [
    "15 ${'min_str'.tr}",
    "30 ${'min_str'.tr}",
    "45 ${'min_str'.tr}",
    "60 ${'min_str'.tr}",
  ];

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? _picked;

  selectTime(i, bool isStartTime) async {
    Get.focusScope?.unfocus();
    if (isStartTime && textEditingControllerStartTime[i].text.isNotEmpty) {
      _time = TimeOfDay(
          hour: int.parse(textEditingControllerStartTime[i].text.split(":")[0]),
          minute:
              int.parse(textEditingControllerStartTime[i].text.split(":")[1]));
    } else if (textEditingControllerEndTime[i].text.isNotEmpty) {
      _time = TimeOfDay(
          hour: int.parse(textEditingControllerEndTime[i].text.split(":")[0]),
          minute:
              int.parse(textEditingControllerEndTime[i].text.split(":")[1]));
    } else {
      _time = TimeOfDay.now();
    }
    _picked = await showTimePicker(
      context: Get.context!,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (_picked != null) {
      if (isStartTime) {
        startTime[i] =
            ("${_picked!.hour.toString().padLeft(2, '0')}:${_picked!.minute.toString().padLeft(2, '0')}");
        textEditingControllerStartTime[i].text =
            ("${_picked!.hour.toString().padLeft(2, '0')}:${_picked!.minute.toString().padLeft(2, '0')}");
        isError[i].value = false;
        selectedvValue[i] = null;

        if (textEditingControllerEndTime[i].text.isNotEmpty &&
            !isError[i].value) {
          selectedvValue[i] = slotsInterval.first;
          slotsDistribution(startTime[i], endTime[i],
              int.parse(slotsInterval.first.toString().substring(0, 2)), i);

          update();
        }
      } else {
        endTime[i] =
            ("${_picked!.hour.toString().padLeft(2, '0')}:${_picked!.minute.toString().padLeft(2, '0')}");
        textEditingControllerEndTime[i].text =
            ("${_picked!.hour.toString().padLeft(2, '0')}:${_picked!.minute.toString().padLeft(2, '0')}");
        isError[i].value = false;
        selectedvValue[i] = null;

        if (textEditingControllerStartTime[i].text.isNotEmpty &&
            !isError[i].value) {
          selectedvValue[i] = slotsInterval.first;
          slotsDistribution(startTime[i], endTime[i],
              int.parse(slotsInterval.first.toString().substring(0, 2)), i);

          update();
        }
      }
    }
  }

  RxInt totalCards = 1.obs;

  RxList<RxBool> isError = <RxBool>[].obs;
  RxList<String> errorMessage = <String>[].obs;

  RxList<dynamic> selectedvValue = <dynamic>[].obs;
  RxList<String> startTime = <String>[].obs;
  RxList<String> endTime = <String>[].obs;
  DateTime dateTime = DateTime.now();

  RxList<RxList<Getslotls>> slotsList = <RxList<Getslotls>>[].obs;
  RxList<TextEditingController> textEditingControllerStartTime =
      <TextEditingController>[].obs;
  RxList<TextEditingController> textEditingControllerEndTime =
      <TextEditingController>[].obs;

  RxList<int> slotsCount = [0, 0, 0, 0, 0, 0, 0].obs;

  addValues() {
    isError.add(false.obs);
    errorMessage.add("x");
    selectedvValue.add("15 ${'min_str'.tr}");
    startTime.add("x");
    endTime.add("x");
    slotsList.add(<Getslotls>[].obs);
    slotsData.add(SlotsData(
        dayId: int.parse(id),
        duration: "15",
        doctorId: 1,
        getslotls: slotsList[slotsList.length - 1]));
    textEditingControllerEndTime.add(TextEditingController(text: ""));
    textEditingControllerStartTime.add(TextEditingController(text: ""));
    update();
  }
}


