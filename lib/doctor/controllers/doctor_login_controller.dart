import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class DoctorLoginController extends GetxController {
  RxString emailAddress = "".obs;
  RxString pass = "".obs;
  RxBool isPhoneNumberError = false.obs;
  RxBool isPasswordError = false.obs;
  RxString passErrorText = "".obs;
  RxString token = "".obs;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> getToken() async {
    final savedToken = StorageService.readData(key: LocalStorageKeys.token);

    if (savedToken != null && savedToken.toString().isNotEmpty) {
      token.value = savedToken.toString();
      return;
    }

    final fcmToken = await firebaseMessaging.getToken();

    if (fcmToken != null && fcmToken.isNotEmpty) {
      token.value = fcmToken;
      StorageService.writeStringData(
        key: LocalStorageKeys.token,
        value: fcmToken,
      );
    }
  }

  storeToken() async {
    customDialog1(
      s1: 'login_dialog_title'.tr,
      s2: 'login_dialog_description'.tr,
    );
    if (token.value.isEmpty) {
      await getToken();
    }
    final response =
        await post(
          Uri.parse("${Apis.ServerAddress}/api/savetoken"),
          body: {"token": token.value.trim(), "type": "1"},
        ).timeout(const Duration(seconds: Apis.timeOut)).catchError((e) {
          Get.back();
          customDialog(s1: 'error'.tr, s2: 'unable_to_save_token'.tr);
        });
    if (response.statusCode == 200) {
      Get.back();
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        StorageService.writeBoolData(
          key: LocalStorageKeys.isTokenExist,
          value: true,
        );
        StorageService.writeStringData(
          key: LocalStorageKeys.token,
          value: token.value,
        );
        loginInto();
      }
    } else {
      Get.back();
      customDialog(s1: 'error'.tr, s2: response.body.toString());
    }
  }

  Future<void> loginInto() async {
    final String cleanEmail = emailAddress.value.trim();
    final String cleanPassword = pass.value.trim();

    if (GetUtils.isEmail(cleanEmail) == false) {
      isPhoneNumberError.value = true;
      return;
    }

    if (cleanPassword.isEmpty || cleanPassword.length < PASS_LENGTH) {
      isPasswordError.value = true;
      passErrorText.value = 'enter_6_characters'.tr;
      return;
    }

    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
      await storeToken();
      return;
    }

    customDialog1(
      s1: 'login_dialog_title'.tr,
      s2: 'login_dialog_description'.tr,
    );

    try {
      if (token.value.isEmpty) {
        await getToken();
      }

      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/doctorlogin"),
        body: {
          'email': cleanEmail,
          'password': cleanPassword,
          'token': token.value.trim(),
        },
      ).timeout(const Duration(seconds: Apis.timeOut));

      debugPrint("DOCTOR_LOGIN_STATUS :: ${response.statusCode}");
      debugPrint("DOCTOR_LOGIN_BODY :: ${response.body}");

      if (response.statusCode != 200) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        customDialog(
          s1: 'error'.tr,
          s2: 'Server error: ${response.statusCode}',
        );
        return;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() == "0") {
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        final String registerError = jsonResponse['register']?.toString() ?? '';
        final String serverMessage = jsonResponse['message']?.toString() ?? '';

        if (registerError == "not_approved") {
          customDialog(
            s1: 'Account Under Review',
            s2: serverMessage.isNotEmpty
                ? serverMessage
                : 'Your account is under review. Please wait for admin approval.',
          );
          return;
        }

        if (registerError.toLowerCase().contains("invalid password")) {
          isPasswordError.value = true;
          passErrorText.value = 'Invalid password';
          return;
        }

        if (registerError.toLowerCase().contains("invalid email")) {
          isPhoneNumberError.value = true;
          customDialog(s1: 'error'.tr, s2: 'Invalid email address');
          return;
        }

        isPasswordError.value = true;
        passErrorText.value = registerError.isNotEmpty
            ? registerError
            : 'either_mobile_number_is_incorrect'.tr;
        return;
      }

      final register = jsonResponse['register'];

      if (register == null || register is! Map) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        customDialog(s1: 'error'.tr, s2: 'Invalid login response from server.');
        return;
      }

      final bool hasSubscription =
          register['has_subscription'].toString() == "1" ||
          register['has_subscription'] == true;

      await FirebaseDatabase.instance
          .ref()
          .child('100${register['doctor_id']}')
          .update({"name": register['name'], "image": register['profile_pic']});

      await FirebaseDatabase.instance
          .ref()
          .child("100${register['doctor_id']}")
          .child("TokenList")
          .set({"device": token.value});

      StorageService.writeBoolData(
        key: LocalStorageKeys.isLoggedInAsDoctor,
        value: true,
      );
      StorageService.writeBoolData(
        key: LocalStorageKeys.isLoggedIn,
        value: false,
      );

      StorageService.removeData(key: LocalStorageKeys.callSessionCS);

      StorageService.writeStringData(
        key: LocalStorageKeys.userIdWithAscii,
        value: "100${register['doctor_id']}",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.userId,
        value: register['doctor_id'].toString(),
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.name,
        value: register['name']?.toString() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.phone,
        value: register['phone']?.toString() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.email,
        value: register['email']?.toString() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.callerImage,
        value: register['profile_pic']?.toString() ?? "",
      );

      if (register['connectycube_user_id'].runtimeType == String) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        customDialog(s1: 'error'.tr, s2: 'error3'.tr);
        return;
      }

      CubeUser user = CubeUser(
        id: register['connectycube_user_id'],
        login: register['login_id'],
        fullName: register['name'].toString().replaceAll(" ", ""),
        password: register['connectycube_password'].toString(),
      );

      await SharedPrefs.saveNewUser(user);

      ConnectyCubeSessionService.loginToCC(
        user,
        onTap: () {
          if (Get.isDialogOpen == true) {
            Get.back();
          }

          if (hasSubscription) {
            Get.offAllNamed(Routes.doctorTabScreen);
          } else {
            Get.offAllNamed(
              Routes.chooseYourPlanScreen,
              arguments: {'doctorUrl': ""},
            );
          }

          changeNotifier.updateString("Done");
        },
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      debugPrint("DOCTOR_LOGIN_EXCEPTION :: $e");

      customDialog(s1: 'error'.tr, s2: e.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}

