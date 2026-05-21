import 'dart:developer';

import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:developer' as dev;

class DoctorProfileController extends GetxController {
  RxInt index = 0.obs;

  ValueNotifier<String?> selectedValue = ValueNotifier(null);

  uploadData() async {
    int departmentId = 0;

    for (int i = 0; i < departmentList.length; i++) {
      if (specialityClass!.data![i].name == selectedValue.value) {
        departmentId = specialityClass!.data![i].id!;
        break;
      }
    }
    await Future.delayed(Duration.zero);
    customDialog1(s1: 'reporting_dialog1'.tr, s2: 'while_saving_changes'.tr);

    if (sImage == null) {
      final response = await post(
          Uri.parse("${Apis.ServerAddress}/api/doctoreditprofile"),
          body: {
            "doctor_id": doctorId.value,
            "name": nameController.text,
            "password": password.value,
            "email": doctorProfileDetails!.data!.email ?? "",
            "consultation_fees": feeController.text,
            "aboutus": aboutUsController.text,
            "working_time": worktimeController.text,
            "address": textEditingController.text,
            "lat": center!.latitude.toString(),
            "lon": center!.longitude.toString(),
            "phoneno": phoneController.text,
            "services": serviceController.text,
            "healthcare": healthcareController.text,
            "department_id": departmentId.toString(),
          }).timeout(const Duration(seconds: Apis.timeOut)).catchError(
        (e) {
          Get.back();
          messageDialog('error'.tr, 'unable_to_load_data'.tr);
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "1") {
          Get.back();
          isSuccessful.value = true;
          messageDialog('success'.tr, 'profile_update_successfully'.tr);
        } else {
          Get.back();
          messageDialog('error'.tr, jsonResponse['register']);
        }
      }
    } else {
      Dio d = Dio();

      var formData = dio.FormData.fromMap({
        "doctor_id": doctorId.value,
        "name": nameController.text,
        "password": password,
        "email": doctorProfileDetails!.data!.email ?? "",
        "aboutus": aboutUsController.text,
        "consultation_fees": feeController.text,
        "working_time": worktimeController.text,
        "address": textEditingController.text,
        "lat": center!.latitude.toString(),
        "lon": center!.longitude.toString(),
        "phoneno": phoneController.text,
        "services": serviceController.text,
        "healthcare": healthcareController.text,
        "department_id": departmentId.toString(),
        'image': await dio.MultipartFile.fromFile(sImage!.path,
            filename: sImage!.path.split("/").last),
      });
      var response = await d
          .post("${Apis.ServerAddress}/api/doctoreditprofile", data: formData)
          .timeout(const Duration(seconds: Apis.timeOut))
          .catchError((e) {
        Get.back();
        messageDialog('error'.tr, 'unable_to_load_data'.tr);
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        if (jsonResponse['success'].toString() == "1") {
          Get.back();
          isSuccessful.value = true;
          messageDialog('success'.tr, 'profile_update_successfully'.tr);
        } else {
          Get.back();
          messageDialog('error'.tr, response.data['register']);
        }
      }
    }

    if (sImage != null) {
      Dio().close();
    }
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () {
        if (isSuccessful.value) {
          future = fetchDoctorProfileDetails();
          future2 = fetchDoctorSchedule();
          index.value = 0;
          Get.offAllNamed(Routes.doctorTabScreen);
        } else {
          Get.back();
        }
      },
    );
  }

  DoctorProfileDetails? doctorProfileDetails;
  DoctorScheduleDetails? doctorScheduleDetails;
  Future? future;
  Future? future2;
  RxString doctorId = "".obs;

  RxBool isErrorInLoading = false.obs;
  RxBool isProfileLoaded = false.obs;
  RxBool isScheduleLoaded = false.obs;

  List<String> daysList = [
    'day_full_1'.tr,
    'day_full_2'.tr,
    'day_full_3'.tr,
    'day_full_4'.tr,
    'day_full_5'.tr,
    'day_full_6'.tr,
    'day_full_7'.tr
  ];

  RxList<MyData> myData = <MyData>[].obs;

  fetchDoctorSchedule() async {
    isScheduleLoaded.value = false;
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/getdoctorschedule?doctor_id=${doctorId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        doctorScheduleDetails = DoctorScheduleDetails.fromJson(jsonResponse);
        fetchSlotsCount();
        isScheduleLoaded.value = true;
      }
    } else {
      isErrorInLoading.value = true;
    }
  }

  fetchDoctorProfileDetails() async {
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/doctordetail?doctor_id=${doctorId.value}"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      messageDialog('error'.tr, 'unable_to_load_data'.tr);
      isErrorInLoading.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      try {
        doctorProfileDetails = DoctorProfileDetails.fromJson(jsonResponse);
      } catch (E) {
        isErrorInLoading.value = true;
      }

      print(doctorProfileDetails!.data!.image!);

      nameController.text = doctorProfileDetails!.data!.name!;
      password.value = doctorProfileDetails!.data!.password ?? "";
      phoneController.text = doctorProfileDetails!.data!.phoneno.toString();

      selectedValue.value =
          (doctorProfileDetails!.data!.departmentName == null ||
                  doctorProfileDetails!.data!.departmentName!.isEmpty
              ? null
              : doctorProfileDetails!.data!.departmentName);

      worktimeController.text =
          (doctorProfileDetails!.data!.workingTime ?? "null") == "null"
              ? ""
              : doctorProfileDetails!.data!.workingTime!;
      feeController.text =
          doctorProfileDetails!.data!.consultationFees.toString();
      aboutUsController.text = doctorProfileDetails!.data!.aboutus ?? "";
      serviceController.text = doctorProfileDetails!.data!.services ?? "";
      healthcareController.text = doctorProfileDetails!.data!.healthcare ?? "";
      isProfileLoaded.value = true;
      try {
        if (doctorProfileDetails!.data!.lat != null) {
          textEditingController.text = doctorProfileDetails!.data!.address!;

          center = LatLng(double.parse(doctorProfileDetails!.data!.lat!),
              double.parse(doctorProfileDetails!.data!.lon!));
          locateMarker(center!, false);
        } else {
          _getLocationStart();
        }
      } catch (e) {
        _getLocationStart();
      }
    } else {
      messageDialog('error'.tr, 'unable_to_load_data'.tr);
      isErrorInLoading.value = true;
    }
  }

  Future<bool> onWillPopScope() async {
    bool x = false;
    if (index.value > 0) {
      index.value = index.value - 1;
      x = false;
    } else {
      x = true;
    }
    return x;
  }

  RxBool isNameError = false.obs;
  RxBool isPhoneError = false.obs;
  RxBool isWorkingTimeError = false.obs;
  RxBool isAboutUsError = false.obs;
  RxBool isServiceError = false.obs;
  RxBool isDepartmentError = false.obs;
  RxBool isHealthCareError = false.obs;
  RxBool isFeeError = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutUsController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController worktimeController = TextEditingController();
  TextEditingController healthcareController = TextEditingController();
  TextEditingController feeController = TextEditingController();

  RxString password = "".obs;

  GoogleMapController? mapController;
  final Map<String, Marker> markers = {};
  LatLng? center;
  RxBool sLocationUpdated = false.obs;
  Future? getLocation;
  RxBool isAddressError = false.obs;
  TextEditingController textEditingController = TextEditingController();

  RxList<String> departmentList = <String>[].obs;
  SpecialityClass? specialityClass;
  File? sImage;
  RxBool sImageSelected = false.obs;

  String? base64image;

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);

    if (pickedFile != null) {
      sImageSelected.value = false;
      sImage = File(pickedFile.path);
      base64image = base64Encode(sImage!.readAsBytesSync());
      sImageSelected.value = true;
    }
  }

  getSpecialities() async {
    final response =
        await get(Uri.parse("${Apis.ServerAddress}/api/getspeciality"))
            .timeout(const Duration(seconds: Apis.timeOut));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      specialityClass = SpecialityClass.fromJson(jsonResponse);
      for (int i = 0; i < specialityClass!.data!.length; i++) {
        departmentList.add(specialityClass!.data![i].name!);
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  locateMarker(LatLng latLng, bool x) async {
    final marker = Marker(
      markerId: const MarkerId("curr_loc"),
      position: latLng,
      infoWindow: const InfoWindow(title: 'Doctor location'),
    );
    markers["Current Location"] = marker;
    sLocationUpdated.value = true;

    if (x) {
      final coordinates =
          Coordinates(latitude: latLng.latitude, longitude: latLng.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          coordinates.latitude!, coordinates.longitude!);

      var first = placemarks.first;

      textEditingController.text =
          "${first.name!}, ${first.postalCode!}, ${first.locality!}, ${first.subAdministrativeArea!}, ${first.administrativeArea!}";
    }
  }

  _getLocationStart() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      center = LatLng(value.latitude, value.longitude);
      locateMarker(center!, true);
      return value;
    });
  }

  RxList<int> slotsCount = [0, 0, 0, 0, 0, 0, 0].obs;

  fetchSlotsCount() {
    slotsCount.value = [0, 0, 0, 0, 0, 0, 0];
    for (int i = 0; i < doctorScheduleDetails!.data!.length; i++) {
      if (doctorScheduleDetails!.data![i].dayId == 0) {
        slotsCount[0] = slotsCount[0] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 1) {
        slotsCount[1] = slotsCount[1] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 2) {
        slotsCount[2] = slotsCount[2] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 3) {
        slotsCount[3] = slotsCount[3] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 4) {
        slotsCount[4] = slotsCount[4] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 5) {
        slotsCount[5] = slotsCount[5] + 1;
      } else if (doctorScheduleDetails!.data![i].dayId == 6) {
        slotsCount[6] = slotsCount[6] + 1;
      }
    }
  }

  // step four --------------------

  RxBool isSuccessful = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSpecialities();
    doctorId.value =
        StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    future = fetchDoctorProfileDetails();
    future2 = fetchDoctorSchedule();
  }

  Widget step1({required BuildContext context}) {
    return Obx(() => Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.hs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 800),
                                  child: (sImageSelected.value &&
                                          sImage != null)
                                      ? Image.file(
                                          sImage!,
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: doctorProfileDetails!
                                                  .data!.image!
                                                  .toString()
                                                  .contains(
                                                      Apis.doctorImagePath)
                                              ? doctorProfileDetails!
                                                  .data!.image!
                                                  .toString()
                                              : ("${Apis.doctorImagePath}${doctorProfileDetails!.data!.image.toString()}"),
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Transform.scale(
                                                  scale: 3.1,
                                                  child: Icon(
                                                    Icons.account_circle,
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.3),
                                                    size: 50,
                                                  )),
                                          errorWidget: (context, url, error) =>
                                              Transform.scale(
                                                  scale: 3.1,
                                                  child: Icon(
                                                    Icons.account_circle,
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(0.3),
                                                    size: 50,
                                                  )),
                                        )),
                            ),
                          ),
                        ),
                        Container(
                          height: 135,
                          width: 135,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Image.asset(
                                  AppImages.editYellowBg,
                                  height: 35,
                                  width: 35,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Obx(() => EditDetailFormField1(
                            labelText: 'name_hint'.tr,
                            errorText:
                                isNameError.value ? 'enter_name'.tr : null,
                            controller: nameController,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isNameError.value = false;
                              }
                              update();
                            },
                          )),
                      3.hs,
                      Obx(() => EditDetailFormField1(
                            labelText: 'phone_number'.tr,
                            errorText:
                                isPhoneError.value ? 'enter_number'.tr : null,
                            controller: phoneController,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isPhoneError.value = false;
                              }
                              update();
                            },
                          )),
                      25.hs,
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: !isDepartmentError.value
                                  ? Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.4)
                                  : AppColors.RED700,
                              width: 1),
                        ),
                        child: departmentList.isEmpty
                            ? Container()
                            : ListenableBuilder(
                                listenable: selectedValue,
                                builder: (context, child) {
                                  return DropdownButton(
                                    hint: Text('select_department_hint'.tr),
                                    items: departmentList.map((x) {
                                      return DropdownMenuItem(
                                        value: x,
                                        child: Text(
                                          x,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedValue.value,
                                    onTap: () {
                                      isDepartmentError.value = false;
                                    },
                                    onChanged: (val) {
                                      if (val == null) return;
                                      selectedValue.value = val;
                                    },
                                    isExpanded: true,
                                    underline: Container(),
                                    icon: Image.asset(
                                      AppImages.dropdownIcon,
                                      height: 15,
                                      width: 15,
                                    ),
                                  );
                                },
                              ),
                      ),
                      3.hs,
                      Obx(() => EditDetailFormField1(
                            labelText: 'working_time'.tr,
                            errorText: isWorkingTimeError.value
                                ? 'working_error'.tr
                                : null,
                            controller: worktimeController,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isWorkingTimeError.value = false;
                              }
                              update();
                            },
                          )),
                      3.hs,
                      Obx(() => EditDetailFormField1(
                            prefixText: CURRENCY,
                            keyboardType: TextInputType.number,
                            labelText: 'consultation_fee'.tr,
                            errorText: isFeeError.value
                                ? 'common_textfield_error'.tr
                                : null,
                            controller: feeController,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isFeeError.value = false;
                              }
                              update();
                            },
                          )),
                      3.hs,
                      Obx(() => EditDetailFormField(
                            labelText: 'about'.tr,
                            errorText: isAboutUsError.value
                                ? 'about_us_error'.tr
                                : null,
                            controller: aboutUsController,
                            maxLines: 5,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isAboutUsError.value = false;
                              }
                              update();
                            },
                          )),
                      3.hs,
                      Obx(() => EditDetailFormField(
                            labelText: 'services'.tr,
                            errorText: isAboutUsError.value
                                ? 'services_error'.tr
                                : null,
                            controller: serviceController,
                            maxLines: 5,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isServiceError.value = false;
                              }
                              update();
                            },
                          )),
                      3.hs,
                      Obx(() => EditDetailFormField(
                            labelText: 'health_care_str'.tr,
                            errorText: isHealthCareError.value
                                ? 'common_textfield_error'.tr
                                : null,
                            controller: healthcareController,
                            maxLines: 3,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                isHealthCareError.value = false;
                              }
                              update();
                            },
                          )),
                      100.hs,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget step2({required BuildContext context}) {
    return Obx(() => Container(
          color: Theme.of(context).primaryColorLight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: EditTextField(
                  editingController: textEditingController,
                  labelText: 'address'.tr,
                  errorText:
                      isAddressError.value ? 'select_address_error'.tr : null,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      isAddressError.value = false;
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder(
                      future: getLocation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            future == null ||
                            future2 == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Obx(() => GoogleMap(
                                onMapCreated: onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: (sLocationUpdated.value
                                          ? center
                                          : center) ??
                                      const LatLng(
                                          40.7731125115069, -73.96187393112228),
                                  zoom: 15.0,
                                ),
                                onTap: (latLang) {
                                  sLocationUpdated.value = false;
                                  center = latLang;
                                  locateMarker(center!, true);
                                },
                                buildingsEnabled: true,
                                compassEnabled: true,
                                markers: markers.values.toSet(),
                              ));
                        }
                      }),
                ),
              ),
              30.hs,
            ],
          ),
        ));
  }

  Widget step3({required BuildContext context}) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            10.hs,
            FutureBuilder(
                future: future2,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      future == null ||
                      future2 == null) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 170,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      isScheduleLoaded.value) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        myData.add(MyData(
                          avgratting: doctorProfileDetails!.data!.avgratting,
                          departmentName: selectedValue.value,
                          id: 1,
                          name: nameController.text,
                          email: doctorProfileDetails!.data!.email,
                          aboutus: aboutUsController.text,
                          workingTime: worktimeController.text,
                          address: textEditingController.text,
                          lat: center!.latitude.toString(),
                          lon: center!.longitude.toString(),
                          phoneno: phoneController.text,
                          password: password.value,
                          services: serviceController.text,
                          healthcare: healthcareController.text,
                          consultationFees: feeController.text,
                        ));
                        return InkWell(
                          onTap: () async {
                            await Get.toNamed(Routes.dStepThreeDetailScreen,
                                arguments: {
                                  'id': index.toString(),
                                  'myData': myData[index],
                                  'doctorId': doctorId.value,
                                  'base64image':
                                      sImage == null ? 'null' : base64image!,
                                })?.then((value) {
                              Get.delete<StepThreeDetailsController>();
                              if (value ?? false) {
                                future2 = fetchDoctorSchedule();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppImages.calender,
                                            height: 15,
                                            width: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          AppTextWidgets.mediumTextWithColor(
                                            text: daysList[index],
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: slotsCount[index] == 0 ? 0 : 10,
                                      ),
                                      Container(
                                        child: ListView.builder(
                                          itemCount: slotsCount[index],
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemBuilder: (context, ind) {
                                            int length = 0;
                                            for (int k = 0; k < index; k++) {
                                              length = length + slotsCount[k];
                                            }

                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Image.asset(
                                                      AppImages.timeIcon,
                                                      height: 13,
                                                      width: 13,
                                                      color: AppColors.AMBER,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    AppTextWidgets
                                                        .mediumTextWithSize(
                                                      text:
                                                          "${doctorScheduleDetails!.data![ind + length].startTime} - ${doctorScheduleDetails!.data![ind + length].endTime}",
                                                      size: 11,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  AppImages.arrowIcon,
                                  height: 15,
                                  width: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height - 170,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget step4({required BuildContext context}) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: [
          isErrorInHoliday.value
              ? Container(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Center(
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
                        )
                      ],
                    ),
                  ),
                )
              : isHolidayLoaded.value
                  ? isHolidayFound.value
                      ? ListView.builder(
                          padding: const EdgeInsets.only(bottom: 200),
                          itemCount: holidayList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: AppColors.WHITE,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DateTime.parse(holidayList[index]
                                                        .startDate!) ==
                                                    DateTime.parse(
                                                        holidayList[index]
                                                            .endDate!)
                                                ? AppTextWidgets.boldTextNormal(
                                                    text:
                                                        "${DateTime.parse(holidayList[index].startDate!).day} ${months[DateTime.parse(holidayList[index].startDate!).month - 1]} ${DateTime.parse(holidayList[index].startDate!).year}",
                                                    size: 12,
                                                  )
                                                : AppTextWidgets.boldTextNormal(
                                                    text:
                                                        "${DateTime.parse(holidayList[index].startDate!).day} ${months[DateTime.parse(holidayList[index].startDate!).month - 1]} ${DateTime.parse(holidayList[index].startDate!).year} - ${DateTime.parse(holidayList[index].endDate!).day} ${months[DateTime.parse(holidayList[index].endDate!).month - 1]} ${DateTime.parse(holidayList[index].endDate!).year}",
                                                    size: 12,
                                                  ),
                                            AppTextWidgets.semiBoldText(
                                              text: (DateTime.parse(holidayList[
                                                                      index]
                                                                  .startDate!)
                                                              .difference(DateTime
                                                                  .parse(holidayList[
                                                                          index]
                                                                      .endDate!))
                                                              .inDays
                                                              .abs() +
                                                          1)
                                                      .toString() +
                                                  'days_holiday'.tr,
                                              color: AppColors.AMBER,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.AMBER,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppColors.WHITE,
                                          ),
                                          onPressed: () async {
                                            await Get.toNamed(
                                                Routes.dHolidayManageScreen,
                                                arguments: {
                                                  'holidayId':
                                                      holidayList[index].id ??
                                                          0,
                                                  'startDate': DateTime.parse(
                                                      holidayList[index]
                                                          .startDate!),
                                                  'endDate': DateTime.parse(
                                                      holidayList[index]
                                                          .endDate!),
                                                  'description':
                                                      "${holidayList[index].description ?? ""}",
                                                })?.then((value) {
                                              if (value != null) {
                                                loadHoliday();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: AppColors.LIGHT_GREY_TEXT,
                                  ),
                                  AppTextWidgets.mediumText(
                                    text: holidayList[index].description ?? "",
                                    color: AppColors.LIGHT_GREY_TEXT,
                                    size: 12,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.noAppointment,
                                width: 250,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AppTextWidgets.blackTextWithSize(
                                text: 'no_holiday_title'.tr,
                                size: 18,
                              ),
                              Text(
                                'no_holiday_subtitle'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.LIGHT_GREY_TEXT,
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                        )
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, right: 20),
              child: FloatingActionButton(
                backgroundColor: AppColors.AMBER,
                onPressed: () async {
                  await Get.toNamed(Routes.dHolidayManageScreen, arguments: {
                    'holidayId': 0,
                    'startDate': DateTime.now(),
                    'endDate': DateTime.now(),
                    'description': "",
                  })?.then((value) {
                    if (value != null) {
                      loadHoliday();
                    }
                  });
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<String> months = [
    'month1'.tr,
    'month2'.tr,
    'month3'.tr,
    'month4'.tr,
    'month5'.tr,
    'month6'.tr,
    'month7'.tr,
    'month8'.tr,
    'month9'.tr,
    'month10'.tr,
    'month11'.tr,
    'month12'.tr,
  ];

  RxBool isErrorInHoliday = false.obs;
  RxBool isHolidayLoaded = false.obs;
  RxBool isHolidayFound = false.obs;
  RxList<HData> holidayList = <HData>[].obs;

  loadHoliday() async {
    isHolidayLoaded.value = false;
    isHolidayFound.value = false;
    isErrorInHoliday.value = false;
    var response = await get(Uri.parse(
            '${Apis.ServerAddress}/api/getholiday?doctor_id=${doctorId.value}'))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      isErrorInHoliday.value = true;
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['success'].toString() == "1") {
        holidayList.clear();
        HolidayModel model = HolidayModel.fromJson(responseData);
        holidayList.addAll(model.data!);
        isHolidayLoaded.value = true;
        isHolidayFound.value = true;
      } else {
        isHolidayFound.value = false;
        isHolidayLoaded.value = true;
      }
    } else {
      isErrorInHoliday.value = true;
    }
  }
}


