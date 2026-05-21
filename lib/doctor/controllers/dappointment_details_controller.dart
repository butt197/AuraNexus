import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:dio/dio.dart' as d;

class DAppointmentDetailsController extends GetxController {
  String id = Get.arguments['id'];

  RxBool isLoaded = false.obs;
  RxBool isErrorInLoading = false.obs;
  RxInt apStatus = 0.obs;
  DoctorAppointmentDetailsClass doctorAppointmentDetailsClass =
      DoctorAppointmentDetailsClass();
  RxBool areChangesMade = false.obs;
  RxBool isTextFieldEmpty = false.obs;
  File? fImage;
  RxString userId = "".obs;

  RxList<PrescriptionImage> imageList = <PrescriptionImage>[].obs;

  final formKey = GlobalKey<FormState>();
  var jr;
  UploadImageModel uploadImageModel = UploadImageModel();
  List<Medicine> localData = [];
  TextEditingController textEditingController = TextEditingController();

  fetchAppointmentDetails() async {
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/appointmentdetail?id=${id}&type=2"))
        .catchError((e) {
      isErrorInLoading.value = true;
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"].toString() == "1") {
        doctorAppointmentDetailsClass =
            DoctorAppointmentDetailsClass.fromJson(jsonResponse);

        apStatus.value = doctorAppointmentDetailsClass.data?.status ?? 0;
        imageList.clear();

        for (int i = 0; i < doctorAppointmentDetailsClass.image!.length; i++) {
          imageList.add(doctorAppointmentDetailsClass.image![i]);
        }

        userId.value = jsonResponse['data']['user_id'].toString();
        isLoaded.value = true;
      } else {
        isErrorInLoading.value = true;
        isLoaded.value = true;
      }
    } else {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  Future<bool> willPopScope() async {
    Get.back(result: areChangesMade.value);
    return false;
  }

  Widget button({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(() => (apStatus.value == 1 || apStatus.value == 2)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onTap: () => changeStatus("3"),
                  btnText: 'btn_accept'.tr,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSizeDelta: 2),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onTap: () => changeStatus("5"),
                  btnText: 'btn_cancel'.tr,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSizeDelta: 2),
                )
              ],
            )
          : apStatus.value == 3
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      onTap: () => customDialog2(
                        s1: 'confirmation'.tr,
                        s2: 'complete_appointment_subtitle'.tr,
                        onPressedYes: () async {
                          Get.back();
                          changeStatus("4");
                        },
                        onPressedNo: () => Get.back(),
                      ),
                      btnText: 'btn_complete'.tr,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSizeDelta: 2),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      onTap: () => changeStatus("0"),
                      btnText: 'btn_absent'.tr,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      textStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSizeDelta: 2),
                    ),
                  ],
                )
              : Container()),
    );
  }

  changeStatus(status) async {
    customDialog1(
        s1: 'reporting_dialog1'.tr, s2: 'please_wait_while_processing'.tr);
    final response = await post(Uri.parse(
        "${Apis.ServerAddress}/api/appointmentstatuschange?app_id=${id}&status=$status"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        Get.back();
        fetchAppointmentDetails();
        areChangesMade.value = true;
      } else if (jsonResponse['success'].toString() == "0") {
        Get.back();
        messageDialog('error'.tr, jsonResponse['msg']);
      }
    }
    Client().close();
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () {
        if (s1 == 'error'.tr) {
          Get.back();
        } else {
          fetchAppointmentDetails();
        }
      },
    );
  }

  showUploadPrescriptionSheetNew() {
    Get.bottomSheet(
        ignoreSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        backgroundColor: AppColors.WHITE,
        Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: Get.width,
                        alignment: Alignment.center,
                        child: AppTextWidgets.regularText(
                          text: 'upload_report'.tr,
                          color: AppColors.BLACK,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          fImage == null
                              ? DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  padding: const EdgeInsets.all(6),
                                  dashPattern: const [5, 3, 5, 3],
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(12)),
                                    child: InkWell(
                                      onTap: () async {
                                        final pickedFile =
                                            await picker.pickImage(
                                                source: ImageSource.gallery,
                                                imageQuality: 25);

                                        if (pickedFile != null) {
                                          setState(() {
                                            fImage = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 144,
                                        width: double.maxFinite,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 50,
                                                color: AppColors.AMBER,
                                              ),
                                              Text(
                                                'choose_gallery'.tr,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppFontStyleTextStrings
                                                          .regular,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    fImage!,
                                    height: 166,
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                  ),
                                ),
                          Positioned.fill(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.AMBER_NORMAL,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final pickedFile =
                                                await picker.pickImage(
                                                    source: ImageSource.camera,
                                                    imageQuality: 25);

                                            if (pickedFile != null) {
                                              setState(() {
                                                fImage = File(pickedFile.path);
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: AppColors.WHITE,
                                          ),
                                          iconSize: 20,
                                          constraints: const BoxConstraints(
                                              maxHeight: 40, maxWidth: 40),
                                        ),
                                      ],
                                    ),
                                  ),
                                  fImage == null
                                      ? const SizedBox()
                                      : Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.AMBER_NORMAL,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  final pickedFile =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 25);

                                                  if (pickedFile != null) {
                                                    setState(() {
                                                      fImage =
                                                          File(pickedFile.path);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.photo,
                                                  color: AppColors.WHITE,
                                                ),
                                                iconSize: 20,
                                                constraints: const BoxConstraints(
                                                    maxHeight: 40,
                                                    maxWidth: 40),
                                              ),
                                            ],
                                          ),
                                        ),
                                  fImage == null
                                      ? const SizedBox()
                                      : Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.AMBER_NORMAL,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await Get.toNamed(
                                                      Routes
                                                          .dMyPhotoViewerScreen,
                                                      arguments: {
                                                        'imagePath':
                                                            fImage!.path,
                                                        'isFromFile': true,
                                                      });
                                                  Get.delete<
                                                      DMyPhotoViewController>();
                                                },
                                                icon: const Icon(
                                                  Icons.open_in_full,
                                                  color: AppColors.WHITE,
                                                ),
                                                iconSize: 20,
                                                constraints: const BoxConstraints(
                                                    maxHeight: 40,
                                                    maxWidth: 40),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: textEditingController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          if (value.isEmpty) {
                            isTextFieldEmpty.value = true;
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            filled: true,
                            labelText: 'enter_report_hint'.tr,
                            errorText: isTextFieldEmpty.value
                                ? 'enter_report_error'.tr
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        onChanged: (val) {
                          setState(() {
                            if (val.isNotEmpty) {
                              isTextFieldEmpty.value = false;
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButtonExpanded(
                              onTap: () {
                                Get.focusScope!.unfocus();
                                Get.back();
                              },
                              btnText: 'btn_cancel'.tr,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomButtonExpanded(
                              onTap: () {
                                Get.focusScope!.unfocus();
                                if (fImage == null) {
                                  Fluttertoast.showToast(
                                    msg: 'please_select_image'.tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: AppColors.WHITE,
                                    textColor: AppColors.BLACK,
                                    fontSize: 16.0,
                                  );
                                } else if (textEditingController.text.isEmpty) {
                                  isTextFieldEmpty.value = true;
                                  Fluttertoast.showToast(
                                    msg: 'enter_report_error'.tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: AppColors.WHITE,
                                    textColor: AppColors.BLACK,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  uploadPrescriptionImage();
                                }
                              },
                              btnText: 'btn_upload'.tr,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  deleteMedicine({required List<Map<String, dynamic>> jsonData}) async {
    Map<String, dynamic> r = {"medicine": jsonData};
    customDialog1(
        s1: 'reporting_dialog1'.tr, s2: 'please_wait_while_processing'.tr);
    var response = await post(
      Uri.parse("${Apis.ServerAddress}/api/add_medicine_to_app"),
      body: {
        "appointment_id": id.toString(),
        "medicine_id": jsonEncode(r),
      },
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'].toString() == "0") {
        Get.back();
        messageDialog('error'.tr, jsonDecode(response.body)['msg']);
      } else {
        uploadImageModel = UploadImageModel.fromJson(jsonDecode(response.body));
        Get.back();
        fetchAppointmentDetails();
      }
    } else {
      Get.back();
      messageDialog('error'.tr, jr['msg']);
    }
    Client().close();
  }

  uploadPrescriptionImage() async {
    if (fImage == null) return;
    Get.back();
    customDialog1(
        s1: 'reporting_dialog1'.tr, s2: 'please_wait_while_processing'.tr);

    d.FormData data = d.FormData.fromMap({
      'image': await d.MultipartFile.fromFile(
        fImage!.path,
        filename: fImage?.path.split("/").last,
      ),
      "name": textEditingController.text,
      "appointment_id": id,
    });

    d.Dio dio = new d.Dio();
    dio
        .post(
      "${Apis.ServerAddress}/api/upload_image",
      data: data,
    )
        .then((response) async {
      if (response.statusCode == 200) {
        jr = await response.data;
        uploadImageModel = UploadImageModel.fromJson(jr!);
        Get.back();
        fetchAppointmentDetails();
      } else {
        Get.back();
        messageDialog('error'.tr, jr['msg']);
      }
      d.Dio().close();
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAppointmentDetails();
  }
}


