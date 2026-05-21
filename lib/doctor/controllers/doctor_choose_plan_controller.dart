import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';

class DoctorChooseYourPlanController extends GetxController {
  String doctorUrl = Get.arguments['doctorUrl'];

  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString doctorImageUrl = ''.obs;
  RxString userId = ''.obs;
  RxBool isErrorInLoading = false.obs;
  RxBool isImageSelected = false.obs;
  GetSubscriptionPlanClass? getSubscriptionPlanClass;
  Future? future;
  File? _image;
  RxInt selectedSubId = 1.obs;
  RxInt selectedAmount = 0.obs;
  RxInt selectedAmount1 = 0.obs;
  RxInt selectedIndex = 0.obs;

  RxInt id = 0.obs;
  RxInt price = 0.obs;
  RxInt price2 = 0.obs;

  RxInt selectedPaymentMethod = 8.obs;

  TextEditingController _tcDes = TextEditingController();

  fetchPlanDetail() async {
    final response = await http
        .get(Uri.parse("${Apis.ServerAddress}/api/get_subscription_list"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
          isErrorInLoading.value = true;
        });
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        getSubscriptionPlanClass = GetSubscriptionPlanClass.fromJson(
          jsonResponse,
        );
        selectedAmount1.value = getSubscriptionPlanClass!.data!.data![0].price!;
      }
    } catch (e) {
      isErrorInLoading.value = true;
    }
    Client().close();
  }

  bottomSheet(currency, amount, int? selectedSubId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: AppColors.transparentColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.WHITE,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextWidgets.boldTextWithColor(
                                text: "${userName.value}'s ",
                                color: AppColors.BLACK,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 20),
                            AppTextWidgets.boldTextWithColor(
                              text: CURRENCY + (amount.toString()),
                              color: AppColors.AMBER,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Divider(color: AppColors.GREY, thickness: 0.7),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppTextWidgets.boldTextWithColor(
                          text: 'select_a_payment_method'.tr.toUpperCase(),
                          color: AppColors.LIGHT_GREY_TEXT,
                          size: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      paymentMethodCardTile(
                        title: 'method6_title'.tr, // Stripe
                        explanation: 'method6_description'.tr,
                        index: 8,
                        setState: setState,
                      ),
                      Divider(color: AppColors.grey, thickness: 0.7),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                CustomButton(
                  onTap: () async {
                    Get.back();

                    selectedPaymentMethod.value = 8;

                    paymentIntent =
                        await (String amount, String currency) async {
                          Map<String, dynamic> body = {
                            'amount': ((int.parse(amount)) * 100).toString(),
                            'currency': currency,
                            'payment_method_types[]': 'card',
                          };

                          var response = await http.post(
                            Uri.parse(
                              'https://api.stripe.com/v1/payment_intents',
                            ),
                            headers: {
                              'Authorization': 'Bearer $stripeSecretKey',
                              'Content-Type':
                                  'application/x-www-form-urlencoded',
                            },
                            body: body,
                          );

                          return jsonDecode(response.body.toString());
                        }(selectedAmount1.value.toString(), CURRENCY_CODE);

                    http.Client().close();

                    await Stripe.instance.initPaymentSheet(
                      paymentSheetParameters: SetupPaymentSheetParameters(
                        paymentIntentClientSecret:
                            paymentIntent!['client_secret'],
                        merchantDisplayName: 'Doctor Finder',
                      ),
                    );

                    displayPaymentSheet();
                  },
                  btnText: 'process_payment'.tr,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Map<String, dynamic>? paymentIntent;

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      uploadRecipe(stripeToken: paymentIntent!['id']);
    } on StripeException catch (e) {
      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    } catch (e) {
      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    }
  }

  paymentMethodCardTile({
    String? title,
    String? explanation,
    required int index,
    required StateSetter setState,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod.value = index;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.LIGHT_GREY_TEXT),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selectedPaymentMethod.value == index
                    ? AppColors.AMBER
                    : AppColors.transparentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidgets.blackTextWithSize(text: title ?? "", size: 18),
                AppTextWidgets.blackText(
                  text: explanation ?? "",
                  color: AppColors.LIGHT_GREY_TEXT,
                  size: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  uploadRecipe({String stripeToken = ""}) async {
    RxInt paymentType = 5.obs;
    selectedPaymentMethod.value = 8;

    ProgressDialog pd = ProgressDialog(context: Get.context!);
    FormData data;
    if (paymentType.value == 2) {
      pd.show(
        progressValueColor: AppColors.color1,
        progressBgColor: AppColors.LIGHT_GREY_TEXT,
        progressType: ProgressType.valuable,
        max: 100,
        msg: 'receipt_uploading'.tr,
      );
      String fileName = _image!.path.split('/').last;
      data = FormData.fromMap({
        "file": await MultipartFile.fromFile(_image!.path, filename: fileName),
        'doctor_id': userId.value,
        'subscription_id': selectedSubId.value.toString(),
        'amount': selectedAmount1.value.toString(),
        'description': _tcDes.text,
        'payment_type': paymentType.value.toString(),
      });
    } else if (paymentType.value == 5) {
      customDialog1(
        s1: 'reporting_dialog1'.tr,
        s2: 'please_wait_while_processing'.tr,
      );
      data = FormData.fromMap({
        'doctor_id': userId.value,
        'subscription_id': selectedSubId.value.toString(),
        'amount': selectedAmount1.value.toString(),
        'stripe_token': stripeToken,
        'payment_type': paymentType.value.toString(),
      });
    } else {
      customDialog1(
        s1: 'reporting_dialog1'.tr,
        s2: 'please_wait_while_processing'.tr,
      );
      data = FormData.fromMap({
        'doctor_id': userId.value,
        'subscription_id': selectedSubId.value.toString(),
        'amount': selectedAmount1.value.toString(),
        'description': _tcDes.text,
        'payment_type': paymentType.value.toString(),
      });
    }

    Dio dio = Dio();
    dio
        .post(
          "${Apis.ServerAddress}/api/subscription_upload",
          data: data,
          onSendProgress: (int sent, int total) {
            int progress = (((sent / total) * 100).toInt());
            pd.update(value: progress - 5);
          },
        )
        .timeout(const Duration(seconds: Apis.timeOut))
        .then((response) async {
          pd.update(value: 100);
          pd.close();

          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(await response.data);
            if (jsonResponse['success'].toString() == "1") {
              if (paymentType.value == 2 || paymentType.value == 5) {
                customDialog(
                  s1: 'success_str'.tr,
                  s2: jsonResponse['msg'],
                  onPressed: () {
                    Get.offAllNamed(Routes.doctorTabScreen);
                  },
                  dismiss: false,
                );
              } else {
                Get.back();

                String finalid = jsonResponse['id'].toString();
                String? paymentLink;

                if (selectedPaymentMethod.value == 3) {
                  paymentLink =
                      '${Apis.ServerAddress}/paystack-payment?id=$finalid&type=2';
                } else if (selectedPaymentMethod.value == 4) {
                  paymentLink =
                      '${Apis.ServerAddress}/rave-payment?id=$finalid&type=2';
                } else if (selectedPaymentMethod.value == 5) {
                  paymentLink =
                      '${Apis.ServerAddress}/paytm-payment?id=$finalid&type=2';
                } else if (selectedPaymentMethod.value == 6) {
                  paymentLink =
                      '${Apis.ServerAddress}/braintree_payment?id=$finalid&type=2';
                } else if (selectedPaymentMethod.value == 7) {
                  paymentLink =
                      '${Apis.ServerAddress}/pay_razorpay?id=$finalid&type=2';
                } else {
                  customDialog(s1: 'fail'.tr, s2: 'fail_description'.tr);
                }

                RxString result = "".obs;
                await Get.toNamed(
                  Routes.inAppWebViewScreen,
                  arguments: {
                    'url': paymentLink,
                    'isDoctor': 0,
                    'appointmentId': '0',
                  },
                )?.then((value) {
                  if (value == null) return;
                  result.value = value;
                  update();
                  if ((result.value) == 'success') {
                    customDialog(
                      s1: 'success_str'.tr,
                      s2: 'payment_success'.tr,
                      onPressed: () {
                        Get.offAllNamed(Routes.doctorTabScreen);
                      },
                      dismiss: false,
                    );
                  } else if (result.value == 'fail') {
                    customDialog(s1: 'fail'.tr, s2: 'fail_description'.tr);
                  }
                });
              }
            }
          } else {
            customDialog(s1: 'error'.tr, s2: response.statusMessage!);
          }
          Dio().close();
        })
        .catchError((error) {
          customDialog(s1: 'error'.tr, s2: 'error3'.tr);
          Dio().close();
        });
  }

  showUploadRecipeSheet({required BuildContext context}) {
    _image = null;
    _tcDes.clear();
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: AppColors.transparentColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.WHITE,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: AppTextWidgets.boldTextWithColor(
                          text: 'upload_receip'.tr,
                          color: AppColors.BLACK,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 5),
                        child: Text(
                          'upload_receipt_des1'.tr,
                          style: TextStyle(
                            color: AppColors.LIGHT_GREY_TEXT,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextField(
                          controller: _tcDes,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Stack(
                          children: [
                            _image == null
                                ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    padding: const EdgeInsets.all(6),
                                    dashPattern: const [5, 3, 5, 3],
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final pickedFile = await picker
                                              .pickImage(
                                                source: ImageSource.gallery,
                                                imageQuality: 25,
                                              );

                                          if (pickedFile != null) {
                                            setState(() {
                                              _image = File(pickedFile.path);
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 150,
                                          width: double.maxFinite,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 50,
                                                  color: AppColors.AMBER_NORMAL,
                                                ),
                                                Text(
                                                  'choose_gallery'.tr,
                                                  style: const TextStyle(
                                                    fontSize: 12,
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
                                      _image!,
                                      height: 180,
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
                                                final pickedFile = await picker
                                                    .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 25,
                                                    );

                                                if (pickedFile != null) {
                                                  setState(() {
                                                    _image = File(
                                                      pickedFile.path,
                                                    );
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt,
                                                color: AppColors.WHITE,
                                              ),
                                              iconSize: 20,
                                              constraints: const BoxConstraints(
                                                maxHeight: 40,
                                                maxWidth: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _image == null
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
                                                            imageQuality: 25,
                                                          );

                                                      if (pickedFile != null) {
                                                        setState(() {
                                                          _image = File(
                                                            pickedFile.path,
                                                          );
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.photo,
                                                      color: AppColors.WHITE,
                                                    ),
                                                    iconSize: 20,
                                                    constraints:
                                                        const BoxConstraints(
                                                          maxHeight: 40,
                                                          maxWidth: 40,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      _image == null
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
                                                              _image!.path,
                                                          'isFromFile': true,
                                                        },
                                                      );
                                                      Get.delete<
                                                        DMyPhotoViewController
                                                      >();
                                                    },
                                                    icon: const Icon(
                                                      Icons.open_in_full,
                                                      color: AppColors.WHITE,
                                                    ),
                                                    iconSize: 20,
                                                    constraints:
                                                        const BoxConstraints(
                                                          maxHeight: 40,
                                                          maxWidth: 40,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _image == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                height: 50,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          color: AppColors.LIGHT_GREY_TEXT
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'remove_prescription'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .apply(
                                                color: AppColors.BLACK,
                                                fontSizeDelta: 2,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: SizedBox(
                          height: 50,
                          child: InkWell(
                            onTap: () {
                              if (_image != null && _tcDes.text.isNotEmpty) {
                                Get.back();
                                uploadRecipe();
                              } else {
                                Get.back();
                              }
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.color1,
                                          AppColors.color2,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    _image != null
                                        ? 'upload_prescription'.tr
                                        : 'cancel'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(
                                          color: Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                          fontSizeDelta: 2,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userName.value =
        StorageService.readData(key: LocalStorageKeys.name) ?? 'user_str'.tr;
    phone.value = StorageService.readData(key: LocalStorageKeys.phone) ?? "";
    email.value = StorageService.readData(key: LocalStorageKeys.email) ?? "";
    doctorImageUrl.value = doctorUrl;
    userId.value = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    future = fetchPlanDetail();
  }
}
