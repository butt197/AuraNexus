import 'dart:developer' as dev;

import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

import 'package:http/http.dart' as http;

import '../../common/utils/video_call_imports.dart';

class MakeAppointmentController extends GetxController {
  String id = Get.arguments['id'];
  String name = Get.arguments['name'];
  String consultationFee = Get.arguments['consultationFee'];

  DateTime dateTime = DateTime.now();

  RxBool isToday = true.obs;

  MakeAppointmentClass1? makeAppointmentClass;
  RxBool isLoading = true.obs;
  RxBool isLoading1 = true.obs;
  RxBool istimingSlotLoading = true.obs;
  RxBool isNoSlot = false.obs;
  RxBool isNoTimingSlot = false.obs;
  RxString description = "".obs;
  String userId = "";
  String doctorId = "";
  String date = "";
  RxString slotId = "".obs;
  RxString slotName = "".obs;
  RxBool isPhoneError = false.obs;
  ScrollController scrollController = ScrollController();
  RxBool isAppointmentMadeSuccessfully = false.obs;
  RxString AppointmentId = "".obs;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();

  Map<String, dynamic>? paymentIntent;
  bool isPaymentFlowRunning = false;
  String stripeConnectError = "";
  List<String> days = [
    'day1'.tr,
    'day2'.tr,
    'day3'.tr,
    'day4'.tr,
    'day5'.tr,
    'day6'.tr,
    'day7'.tr,
    'day1'.tr,
  ];

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

  List<RxBool> isSelected = <RxBool>[];
  RxList<RxBool> selectedSlot = <RxBool>[].obs;
  List<RxBool> selectedTimingSlot = <RxBool>[];
  RxInt previousSelectedIndex = 0.obs;
  RxInt previousSelectedSlot = 0.obs;
  RxInt previousSelectedTimingSlot = 0.obs;
  RxInt currentSlotsIndex = 0.obs;
  RxBool isDescriptionEmpty = false.obs;
  RxBool isChecked = true.obs;
  RxBool checkHolidayFuture = false.obs;

  initialize() async {
    for (int i = 0; i < 30; i++) {
      isSelected.add(false.obs);
    }
    isSelected[0].value = true;
    textEditingController.text =
        StorageService.readData(key: LocalStorageKeys.phone) ?? "";
    userId = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    doctorId = id;
    checkIfHoliday(
      dateTime.add(const Duration(days: 0)).toString().substring(0, 10),
      true,
      i: 0,
    );
  }

  initializeTimeSlots(int index) {
    selectedTimingSlot.clear();
    try {
      for (
        int i = 0;
        i < makeAppointmentClass!.data![index].slottime!.length;
        i++
      ) {
        selectedTimingSlot.add(false.obs);
      }
    } catch (e) {
      isNoSlot.value = true;
      isLoading.value = false;
    }
    currentSlotsIndex.value = index;
  }

  processPayment({required BuildContext context}) async {
    Get.focusScope?.unfocus();
    if (slotId.value.isEmpty || slotId.value.length == 0) {
      messageDialog('error'.tr, 'select_appointment_time'.tr);
    } else if (textEditingController.text.isEmpty ||
        textEditingController.text.length < PHONE_LENGTH) {
      isPhoneError.value = true;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else if (description.isEmpty) {
      isDescriptionEmpty.value = true;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      bottomSheet(context: context);
    }
  }

  Future<bool> createStripeConnectPaymentIntent() async {
    stripeConnectError = "";

    final String url = "${Apis.ServerAddress}/api/bookappointment";

    final Map<String, String> requestBody = {
      "user_id": userId,
      "doctor_id": doctorId,
      "date": date,
      "slot_id": slotId.value,
      "slot_name": slotName.value,
      "consultation_fees": consultationFee,
      "payment_type": "stripe",
      "payment_action": "create_intent",
      "phone": textEditingController.text,
      "user_description": description.value,
    };

    dev.log('CREATE_INTENT_START url=$url', name: 'StripeConnect');
    dev.log('CREATE_INTENT_BODY=$requestBody', name: 'StripeConnect');

    try {
      final response = await post(
        Uri.parse(url),
        body: requestBody,
      ).timeout(const Duration(seconds: Apis.timeOut));

      dev.log(
        'CREATE_INTENT_STATUS=${response.statusCode}',
        name: 'StripeConnect',
      );
      dev.log('CREATE_INTENT_RESPONSE=${response.body}', name: 'StripeConnect');

      if (response.statusCode != 200) {
        stripeConnectError = response.reasonPhrase ?? 'Payment failed.';
        return false;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"].toString() != "1") {
        final String serverMessage =
            jsonResponse["register"]?.toString() ??
            'Unable to initialize payment.';

        if (serverMessage.toLowerCase().contains('slot already booked')) {
          stripeConnectError =
              'This appointment slot is already booked. Please select another time slot.';
        } else {
          stripeConnectError = serverMessage;
        }

        return false;
      }

      final String paymentIntentId =
          jsonResponse["payment_intent_id"]?.toString() ?? "";
      final String clientSecret =
          jsonResponse["payment_intent_client_secret"]?.toString() ?? "";

      dev.log('CREATE_INTENT_PI_ID=$paymentIntentId', name: 'StripeConnect');
      dev.log(
        'CREATE_INTENT_CLIENT_SECRET_EXISTS=${clientSecret.isNotEmpty}',
        name: 'StripeConnect',
      );

      if (paymentIntentId.isEmpty || clientSecret.isEmpty) {
        stripeConnectError = 'Stripe Connect payment data is missing.';
        return false;
      }

      paymentIntent = {"id": paymentIntentId, "client_secret": clientSecret};

      return true;
    } catch (e, st) {
      dev.log(
        'CREATE_INTENT_EXCEPTION=$e',
        name: 'StripeConnect',
        error: e,
        stackTrace: st,
      );
      stripeConnectError = e.toString();
      return false;
    }
  }

  displayPaymentSheet() async {
    try {
      dev.log('BEFORE_PRESENT_PAYMENT_SHEET', name: 'StripeConnect');

      await Stripe.instance.presentPaymentSheet();

      dev.log('AFTER_PRESENT_PAYMENT_SHEET_SUCCESS', name: 'StripeConnect');

      customDialog(
        s1: 'success'.tr,
        s2: 'payment_success'.tr,
        dismiss: false,
        onPressed: () async {
          dev.log(
            'PAYMENT_SUCCESS_DIALOG_OK pi=${paymentIntent?['id']}',
            name: 'StripeConnect',
          );

          Get.back();

          await bookAppointment(type: "stripe", tId: paymentIntent!['id']);

          paymentIntent = null;
          isPaymentFlowRunning = false;
        },
      );
    } on StripeException catch (e, st) {
      dev.log(
        'PAYMENT_SHEET_STRIPE_EXCEPTION=$e',
        name: 'StripeConnect',
        error: e,
        stackTrace: st,
      );

      isPaymentFlowRunning = false;

      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    } catch (e, st) {
      dev.log(
        'PAYMENT_SHEET_EXCEPTION=$e',
        name: 'StripeConnect',
        error: e,
        stackTrace: st,
      );

      isPaymentFlowRunning = false;

      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    }
  }

  bookAppointment({String? tId, String? type}) async {
    customDialog1(s1: 'reporting_dialog1'.tr, s2: 'appoint_make_dialog'.tr);

    String url = "${Apis.ServerAddress}/api/bookappointment";

    Map mm = {};

    if (type == 'stripe') {
      mm = {
        "user_id": userId,
        "doctor_id": doctorId,
        "date": date,
        "slot_id": slotId.value,
        "slot_name": slotName.value,
        "consultation_fees": consultationFee,
        "payment_type": type,
        "phone": textEditingController.text,
        "user_description": description.value,
        "stripe_payment_id": tId,
        "payment_action": "confirm",
      };
    } else {
      mm = {
        "user_id": userId,
        "doctor_id": doctorId,
        "date": date,
        "slot_id": slotId.value,
        "slot_name": slotName.value,
        "consultation_fees": consultationFee,
        "payment_type": type,
        "phone": textEditingController.text,
        "user_description": description.value,
      };
    }

    dev.log('BOOK_APPOINTMENT_BODY=$mm', name: 'StripeConnect');

    final response = await post(Uri.parse(url), body: mm);

    dev.log(
      'BOOK_APPOINTMENT_STATUS=${response.statusCode}',
      name: 'StripeConnect',
    );
    dev.log(
      'BOOK_APPOINTMENT_RESPONSE=${response.body}',
      name: 'StripeConnect',
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"].toString() == "1") {
        Get.back();
        AppointmentId.value = jsonResponse['data'].toString();
        if (type == 'online') {
          String? paymentLink;

          if (selectedPaymentMethod.value == 3) {
            paymentLink =
                '${Apis.ServerAddress}/paystack-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 4) {
            paymentLink =
                '${Apis.ServerAddress}/rave-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 5) {
            paymentLink =
                '${Apis.ServerAddress}/paytm-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 6) {
            paymentLink =
                '${Apis.ServerAddress}/braintree_payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 7) {
            paymentLink =
                '${Apis.ServerAddress}/pay_razorpay?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 8) {
            paymentLink =
                '${Apis.ServerAddress}/stripe-payment?id=$AppointmentId&type=1';
          } else {
            messageDialog('fail'.tr, 'fail_description'.tr);
          }

          Get.toNamed(
            Routes.inAppWebViewScreen,
            arguments: {
              'url': paymentLink,
              'isDoctor': 1,
              'appointmentId': AppointmentId.value,
            },
          )?.then((result) {
            if (result == 'success') {
              isAppointmentMadeSuccessfully.value = true;
              customDialog(
                s1: 'success'.tr,
                s2: 'appointment_made_success'.tr,
                dismiss: false,
                onPressed: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  changeNotifier.updateString("REFRESH_USER_HOME");
                  Get.toNamed(
                    Routes.uAppointmentDetailScreen,
                    arguments: {'id': AppointmentId.value},
                  );
                },
              );
            } else if (result == 'fail') {
              messageDialog('fail'.tr, 'fail_description'.tr);
            }
          });
        } else if (type == 'stripe') {
          customDialog(
            s1: 'success'.tr,
            s2: 'appointment_made_success'.tr,
            onPressed: () {
              Get.back();
              Get.back();
              Get.back();
              changeNotifier.updateString("REFRESH_USER_HOME");
              Get.toNamed(
                Routes.uAppointmentDetailScreen,
                arguments: {'id': AppointmentId.value},
              );
            },
            dismiss: false,
          );
        } else {
          isAppointmentMadeSuccessfully.value = true;
          customDialog(
            dismiss: false,
            s1: 'success'.tr,
            s2: 'appointment_made_success'.tr,
            onPressed: () {
              Get.back();
              Get.back();
              Get.back();
              changeNotifier.updateString("REFRESH_USER_HOME");
              Get.toNamed(
                Routes.uAppointmentDetailScreen,
                arguments: {'id': AppointmentId.value},
              );
            },
          );
        }
      } else if (jsonResponse["success"].toString() == "3") {
        Get.back();
        customDialog(
          s1: 'error'.tr,
          s2: jsonResponse['register'],
          onPressed: () async {
            try {
              CallManager.instance.destroy();
              CubeChatConnection.instance.destroy();
              await PushNotificationsManager.instance.unsubscribe();
              await SharedPrefs.deleteUserData();
              await signOut();

              CubeChatConnection.instance.logout();
            } catch (e) {}
            await SharedPreferences.getInstance().then((pref) {
              pref.clear();
              pref.setString("isBack", "1");
            });
            StorageService.writeBoolData(
              key: LocalStorageKeys.isLoggedInAsDoctor,
              value: false,
            );
            StorageService.writeBoolData(
              key: LocalStorageKeys.isLoggedIn,
              value: false,
            );
            await Get.toNamed(
              Routes.loginUserScreen,
              arguments: {"isBack": false},
            );
          },
        );
      } else {
        Get.back();
        isPaymentFlowRunning = false;

        final String serverMessage =
            jsonResponse['register']?.toString() ?? 'Appointment failed.';

        if (serverMessage.toLowerCase().contains('slot already booked')) {
          messageDialog(
            'error'.tr,
            'This appointment slot is already booked. Please select another time slot.',
          );
        } else {
          messageDialog('error'.tr, serverMessage);
        }
      }
    }
  }

  checkIfHoliday(String date, bool isFirst, {required int i}) async {
    bool isHoliday = false;
    isLoading.value = true;
    isChecked.value = true;
    isNoSlot.value = false;

    var response = await http
        .get(
          Uri.parse(
            '${Apis.ServerAddress}/api/checkholiday?doctor_id=$doctorId&date=$date',
          ),
        )
        .catchError((e) {
          isNoSlot.value = true;
          isLoading.value = false;
        });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      isHoliday = jsonResponse['success'].toString() == '0' ? true : false;
      if (!isHoliday) {
        selectedSlot.clear();
        slotName.value = "";
        slotId.value = "";
        currentSlotsIndex.value = 0;
        previousSelectedTimingSlot.value = 0;
        makeAppointmentClass = MakeAppointmentClass1.fromJson(jsonResponse);
        if (makeAppointmentClass!.success.toString() == "1") {
          for (int i = 0; i < makeAppointmentClass!.data!.length; i++) {
            if (i == 0) {
              selectedSlot.add(true.obs);
            } else {
              selectedSlot.add(false.obs);
            }
          }
          initializeTimeSlots(0);
          isLoading.value = false;
          previousSelectedSlot.value = 0;
        } else {
          isNoSlot.value = true;
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    }
    checkHolidayFuture.value = isHoliday;
    isChecked.value = false;
    http.Client().close();
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () {
        Get.back();
      },
    );
  }

  RxInt selectedPaymentMethod = 8.obs;

  bottomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: AppColors.transparentColor,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.WHITE,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextWidgets.boldTextWithColor(
                          text: "$name's ${'consultation_fee'.tr}",
                          color: AppColors.BLACK,
                          size: 12,
                        ),
                      ),
                      AppTextWidgets.boldTextWithColor(
                        text: CURRENCY.trim() + consultationFee,
                        color: AppColors.AMBER,
                        size: 25,
                      ),
                    ],
                  ),
                  10.hs,
                  Divider(color: AppColors.grey, thickness: 0.7),
                  10.hs,
                  AppTextWidgets.semiBoldText(
                    text: 'PAYMENT METHOD',
                    color: AppColors.LIGHT_GREY_TEXT,
                    size: 12,
                  ),
                  12.hs,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.AMBER),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.AMBER,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextWidgets.mediumTextWithSize(
                              text: 'Stripe',
                              size: 18,
                            ),
                            AppTextWidgets.blackText(
                              text: 'Pay securely by card using Stripe.',
                              color: AppColors.LIGHT_GREY_TEXT,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  12.hs,
                ],
              ),
            ),
            CustomButton(
              onTap: () async {
                dev.log('PAY_BUTTON_TAPPED', name: 'StripeConnect');

                if (isPaymentFlowRunning) {
                  dev.log(
                    'PAYMENT_FLOW_ALREADY_RUNNING',
                    name: 'StripeConnect',
                  );
                  messageDialog(
                    'error'.tr,
                    'Payment is already in progress. Please wait and do not tap again.',
                  );
                  return;
                }

                isPaymentFlowRunning = true;

                Get.back();

                customDialog1(
                  s1: 'reporting_dialog1'.tr,
                  s2: 'Please wait while we prepare your payment.',
                );

                try {
                  dev.log('BEFORE_CREATE_INTENT', name: 'StripeConnect');

                  final bool intentCreated =
                      await createStripeConnectPaymentIntent();

                  dev.log(
                    'AFTER_CREATE_INTENT result=$intentCreated',
                    name: 'StripeConnect',
                  );

                  Get.back();

                  if (!intentCreated) {
                    dev.log(
                      'INTENT_NOT_CREATED_STOPPING error=$stripeConnectError',
                      name: 'StripeConnect',
                    );

                    isPaymentFlowRunning = false;

                    messageDialog(
                      'fail'.tr,
                      stripeConnectError.isNotEmpty
                          ? stripeConnectError
                          : 'Unable to initialize payment.',
                    );
                    return;
                  }

                  if (paymentIntent == null ||
                      paymentIntent!['client_secret'] == null) {
                    dev.log(
                      'PAYMENT_INTENT_NULL_OR_SECRET_MISSING',
                      name: 'StripeConnect',
                    );

                    isPaymentFlowRunning = false;

                    messageDialog(
                      'fail'.tr,
                      'Stripe payment could not be created.',
                    );
                    return;
                  }

                  dev.log('BEFORE_INIT_PAYMENT_SHEET', name: 'StripeConnect');

                  await Stripe.instance.initPaymentSheet(
                    paymentSheetParameters: SetupPaymentSheetParameters(
                      paymentIntentClientSecret:
                          paymentIntent!['client_secret'],
                      merchantDisplayName: 'Sky Telehealth',
                    ),
                  );

                  dev.log('AFTER_INIT_PAYMENT_SHEET', name: 'StripeConnect');

                  displayPaymentSheet();
                } catch (e, st) {
                  dev.log(
                    'PAY_BUTTON_EXCEPTION=$e',
                    name: 'StripeConnect',
                    error: e,
                    stackTrace: st,
                  );

                  isPaymentFlowRunning = false;

                  Get.back();
                  messageDialog('fail'.tr, e.toString());
                }
              },
              btnText: 'process_payment'.tr,
            ),
          ],
        );
      },
    );
  }

  paymentMethodCardTile({
    required String title,
    required String explanation,
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
                AppTextWidgets.mediumTextWithSize(text: title, size: 18),
                AppTextWidgets.blackText(
                  text: explanation,
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

  String _extractSlotStartTime(String? slotName) {
    if (slotName == null) return '';

    String value = slotName
        .replaceAll('\u202f', ' ')
        .replaceAll('\u00a0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toUpperCase();

    // Handles ranges like:
    // 8:00 PM - 8:30 PM
    // 8:00 PM TO 8:30 PM
    value = value.split('-').first.trim();
    value = value.split(' TO ').first.trim();

    // Extract first valid time from any text.
    final match = RegExp(
      r'(\d{1,2})(?::(\d{2}))?\s*(AM|PM)?',
      caseSensitive: false,
    ).firstMatch(value);

    if (match == null) return '';

    final hour = match.group(1) ?? '';
    final minute = match.group(2) ?? '00';
    final period = match.group(3);

    if (period == null || period.trim().isEmpty) {
      return '$hour:$minute';
    }

    return '$hour:$minute ${period.toUpperCase()}';
  }

  DateTime? parseSlotDateTime(String? slotName) {
    final cleanSlot = _extractSlotStartTime(slotName);
    if (cleanSlot.isEmpty) {
      dev.log('Slot time empty: "$slotName"', name: 'MakeAppointment');
      return null;
    }

    final selectedDate = date.trim().isNotEmpty
        ? DateTime.tryParse(date.trim())
        : DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (selectedDate == null) {
      dev.log('Invalid selected date: "$date"', name: 'MakeAppointment');
      return null;
    }

    final formats = <String>['h:mm a', 'hh:mm a', 'H:mm', 'HH:mm'];

    DateTime? parsedTime;

    for (final format in formats) {
      try {
        parsedTime = DateFormat(format, 'en_US').parseLoose(cleanSlot);
        break;
      } catch (_) {}
    }

    if (parsedTime == null) {
      dev.log(
        'Unable to parse slot time: raw="$slotName", clean="$cleanSlot"',
        name: 'MakeAppointment',
      );
      return null;
    }

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  bool isPastSlot(Slottime slot) {
    if (!isToday.value) return false;

    final slotDateTime = parseSlotDateTime(slot.name);

    // Important: unknown format should NOT disable the slot.
    if (slotDateTime == null) return false;

    return DateTime.now().isAfter(slotDateTime);
  }

  @override
  void onInit() {
    super.onInit();
    date = DateFormat('yyyy-MM-dd').format(dateTime);
    initialize();
  }
}
