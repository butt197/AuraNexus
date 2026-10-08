import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class RegisterPatientController extends GetxController {
  RxString name = "".obs;
  RxString phoneNumber = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxString confirmPassword = "".obs;
  RxString phnNumberError = "".obs;
  RxBool isPhoneNumberError = false.obs;
  RxBool isNameError = false.obs;
  RxBool isEmailError = false.obs;
  RxBool isPassError = false.obs;
  RxString token = "".obs;
  RxString error = "".obs;

  RxBool passwordVisible = true.obs;
  RxBool passwordVisible1 = true.obs;

  final formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    final String cleanName = name.value.trim();
    final String cleanPhone = phoneNumber.value.trim();
    final String cleanEmail = email.value.trim();
    final String cleanPassword = password.value.trim();
    final String cleanConfirmPassword = confirmPassword.value.trim();

    if (cleanName.isEmpty) {
      isNameError.value = true;
      update();
      return;
    }

    if (cleanPhone.length < PHONE_LENGTH) {
      isPhoneNumberError.value = true;
      phnNumberError.value = 'valid_mobile_number'.tr;
      update();
      return;
    }

    if (GetUtils.isEmail(cleanEmail) == false) {
      isEmailError.value = true;
      update();
      return;
    }

    if (cleanPassword.isEmpty ||
        cleanPassword.length < PASS_LENGTH ||
        cleanPassword != cleanConfirmPassword) {
      isPassError.value = true;
      update();
      return;
    }

    if (token.value.isEmpty) {
      await getToken();
    }

    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null &&
        token.value.trim().isNotEmpty) {
      await storeToken();
    }

    customDialog1(s1: 'creating_account'.tr, s2: 'creating_account1'.tr);

    try {

      final String url = "${Apis.ServerAddress}/api/register";

      final response = await post(
        Uri.parse(url),
        body: {
          'name': cleanName,
          'email': cleanEmail,
          'phone': cleanPhone,
          'password': cleanPassword,
          'token': token.value.trim(),
        },
      ).timeout(const Duration(seconds: Apis.timeOut));

      debugPrint("PATIENT_REGISTER_STATUS :: ${response.statusCode}");
      debugPrint("PATIENT_REGISTER_BODY :: ${response.body}");

      if (response.statusCode != 200) {
        if (Get.isDialogOpen == true) Get.back();
        customDialog(
          s1: 'error'.tr,
          s2: 'Server error: ${response.statusCode}',
        );
        return;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() == "0") {
        if (Get.isDialogOpen == true) Get.back();
        error.value =
            jsonResponse['register']?.toString() ?? 'Registration failed';
        customDialog(s1: 'error'.tr, s2: error.value);
        return;
      }

      final register = jsonResponse['register'];

      await FirebaseDatabase.instance
          .ref()
          .child("117${register['user_id']}")
          .set({"name": register['name'], "image": register['profile_pic']});

      await FirebaseDatabase.instance
          .ref()
          .child("117${register['user_id']}")
          .child("TokenList")
          .set({"device": token.value.trim()});

      StorageService.writeBoolData(
        key: LocalStorageKeys.isLoggedIn,
        value: true,
      );

      StorageService.writeBoolData(
        key: LocalStorageKeys.isLoggedInAsDoctor,
        value: false,
      );

      StorageService.removeData(key: LocalStorageKeys.callSessionCS);

      StorageService.writeStringData(
        key: LocalStorageKeys.userId,
        value: register['user_id'].toString(),
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.name,
        value: register['name']?.toString().trim() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.email,
        value: register['email']?.toString().trim() ?? cleanEmail,
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.phone,
        value: register['phone']?.toString().trim() ?? cleanPhone,
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.password,
        value: cleanPassword,
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.userIdWithAscii,
        value: '117${register['user_id']}',
      );

      final CubeUser user = CubeUser(
        id: register['connectycube_user_id'],
        login: register['login_id'],
        fullName: register['name'].toString().trim().replaceAll(" ", ""),
        password: cleanPassword,
      );

      await SharedPrefs.saveNewUser(user);

      ConnectyCubeSessionService.loginToCC(
        user,
        onTap: () {
          if (Get.isDialogOpen == true) Get.back();
          Get.offAllNamed(Routes.userTabScreen);
          changeNotifier.updateString("Done");
        },
      );
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("PATIENT_REGISTER_EXCEPTION :: $e");
      customDialog(s1: 'error'.tr, s2: 'unable_to_load_data'.tr);
    }
  }

  getToken() async {
    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
      try {
        final value = await firebaseMessaging.getToken();

        if (value != null && value.isNotEmpty) {
          token.value = value;
          debugPrint("FCM_TOKEN_OK");
          return;
        }
      } catch (e) {
        debugPrint("FCM_TOKEN_FAILED :: $e");
      }

      if (Platform.isIOS && kDebugMode) {
        token.value = "ios_simulator_test_token";
        debugPrint("USING_IOS_SIMULATOR_TEST_TOKEN");
      } else {
        token.value = "";
        debugPrint("FCM_TOKEN_UNAVAILABLE_CONTINUING_WITHOUT_TOKEN");
      }
    } else {
      token.value =
          StorageService.readData(key: LocalStorageKeys.token) ?? "";
    }
  }

  Future<bool> storeToken() async {
    if (token.value.trim().isEmpty) {
      await getToken();
    }

    final currentToken = token.value.trim();

    if (currentToken.isEmpty) {
      debugPrint("PATIENT_REGISTER_TOKEN_SYNC_SKIPPED_NO_TOKEN");
      return false;
    }

    try {
      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/savetoken"),
        body: {"token": currentToken, "type": "1"},
      ).timeout(const Duration(seconds: Apis.timeOut));

      if (response.statusCode != 200) {
        debugPrint(
          "PATIENT_REGISTER_TOKEN_SYNC_HTTP_${response.statusCode}",
        );
        return false;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() != "1") {
        debugPrint("PATIENT_REGISTER_TOKEN_SYNC_REJECTED");
        return false;
      }

      StorageService.writeBoolData(
        key: LocalStorageKeys.isTokenExist,
        value: true,
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.token,
        value: currentToken,
      );

      debugPrint("PATIENT_REGISTER_TOKEN_SYNC_OK");
      return true;
    } catch (e) {
      debugPrint("PATIENT_REGISTER_TOKEN_SYNC_FAILED :: $e");
      return false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}

