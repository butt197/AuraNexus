import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserLoginController extends GetxController {
  bool isBack = Get.arguments['isBack'];
  RxString phoneNumber = "".obs;
  RxString pass = "".obs;
  RxBool isPhoneNumberError = false.obs;
  RxBool isPasswordError = false.obs;
  RxString passErrorText = "".obs;
  RxString token = "".obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxString name = "".obs, email = "".obs, image = "".obs;
  String message = "";

  TextEditingController emailT = TextEditingController();
  TextEditingController passwordT = TextEditingController();

  Future<bool> storeToken(type) async {
    if (token.value.trim().isEmpty) {
      await getToken();
    }

    final currentToken = token.value.trim();

    if (currentToken.isEmpty) {
      debugPrint("PATIENT_LOGIN_TOKEN_SYNC_SKIPPED_NO_TOKEN");
      return false;
    }

    try {
      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/savetoken"),
        body: {"token": currentToken, "type": "1"},
      ).timeout(const Duration(seconds: Apis.timeOut));

      if (response.statusCode != 200) {
        debugPrint(
          "PATIENT_LOGIN_TOKEN_SYNC_HTTP_${response.statusCode}",
        );
        return false;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() != "1") {
        debugPrint("PATIENT_LOGIN_TOKEN_SYNC_REJECTED");
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

      debugPrint("PATIENT_LOGIN_TOKEN_SYNC_OK");
      return true;
    } catch (e) {
      debugPrint("PATIENT_LOGIN_TOKEN_SYNC_FAILED :: $e");
      return false;
    }
  }

  getToken() async {
    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
      if (Platform.isIOS && kDebugMode) {
        try {
          final value = await firebaseMessaging.getToken();

          if (value != null && value.isNotEmpty) {
            token.value = value;
            debugPrint("LOGIN_FCM_TOKEN_OK");
            return;
          }
        } catch (e) {
          debugPrint("LOGIN_FCM_TOKEN_FAILED :: $e");
        }

        token.value = "ios_simulator_test_token";
        debugPrint("LOGIN_USING_IOS_SIMULATOR_TEST_TOKEN");
        return;
      }

      try {
        final value = await firebaseMessaging.getToken();

        if (value != null && value.isNotEmpty) {
          token.value = value;
        }
      } catch (e) {
        debugPrint("PATIENT_LOGIN_FCM_TOKEN_FAILED :: $e");
      }
    } else {
      token.value =
          StorageService.readData(key: LocalStorageKeys.token) ?? "";
    }
  }

  Future<void> loginInto(int type) async {
    final String cleanEmail = phoneNumber.value.trim();
    final String cleanPassword = pass.value.trim();
    final String cleanGoogleEmail = email.value.trim();
    final String cleanGoogleName = name.value.trim();

    if (GetUtils.isEmail(cleanEmail) == false && type == 1) {
      isPhoneNumberError.value = true;
      return;
    }

    if (cleanPassword.length < PASS_LENGTH && type == 1) {
      isPasswordError.value = true;
      passErrorText.value = 'enter_6_characters'.tr;
      return;
    }

    if (token.value.isEmpty) {
      await getToken();
    }

    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null &&
        token.value.trim().isNotEmpty) {
      await storeToken(type);
    }

    customDialog1(
      s1: 'login_dialog_title'.tr,
      s2: 'login_dialog_description'.tr,
      s1style: Theme.of(Get.context!).textTheme.bodyLarge,
      s2style: Theme.of(Get.context!).textTheme.bodyMedium,
    );

    try {
      if (token.value.isEmpty) {
        await getToken();
      }

      final Uri uri = type == 1
          ? Uri.parse("${Apis.ServerAddress}/api/login").replace(
              queryParameters: {
                'email': cleanEmail,
                'password': cleanPassword,
                'login_type': type.toString(),
                'token': token.value.trim(),
              },
            )
          : Uri.parse("${Apis.ServerAddress}/api/login").replace(
              queryParameters: {
                'email': cleanGoogleEmail,
                'login_type': type.toString(),
                'token': token.value.trim(),
                'name': cleanGoogleName,
              },
            );

      final response = await post(
        uri,
      ).timeout(const Duration(seconds: Apis.timeOut));

      debugPrint("PATIENT_LOGIN_STATUS :: ${response.statusCode}");
      debugPrint("PATIENT_LOGIN_BODY :: ${response.body}");

      if (response.statusCode != 200) {
        if (Get.isDialogOpen == true) Get.back();
        messageDialog('error'.tr, 'Server error: ${response.statusCode}');
        return;
      }

      final decoded = jsonDecode(response.body);

      if (decoded['success'].toString() == "0") {
        if (Get.isDialogOpen == true) Get.back();

        if (type != 1) {
          errorDialog(message: decoded['register']);
        } else {
          isPasswordError.value = true;
          passErrorText.value = 'either_email_password_incorrect'.tr;
        }
        return;
      }

      UserLoginResponse _response = UserLoginResponse.fromJson(decoded);

      await FirebaseDatabase.instance
          .ref()
          .child("117${_response.register!.userId}")
          .update({
            "name": _response.register!.name,
            "image": _response.register!.profilePic,
          });

      await FirebaseDatabase.instance
          .ref()
          .child("117${_response.register!.userId}")
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
        key: LocalStorageKeys.phone,
        value: _response.register!.phone?.toString().trim() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.password,
        value: cleanPassword,
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.name,
        value: _response.register!.name?.toString().trim() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.email,
        value: _response.register!.email?.toString().trim() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.userIdWithAscii,
        value: '117${_response.register!.userId}',
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.callerImage,
        value: _response.register!.profilePic?.toString().trim() ?? "",
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.userId,
        value: _response.register!.userId.toString(),
      );

      StorageService.writeStringData(
        key: LocalStorageKeys.profileImage,
        value: _response.register!.profilePic?.toString().trim() ?? "",
      );

      final CubeUser user = CubeUser(
        id: _response.register?.connectycubeUserId,
        login: _response.register?.loginId,
        fullName: _response.register?.name.toString().trim().replaceAll(
          " ",
          "",
        ),
        password: _response.register?.connectycubePassword.toString(),
      );

      await SharedPrefs.saveNewUser(user);

      ConnectyCubeSessionService.loginToCC(
        user,
        onTap: () {
          if (Get.isDialogOpen == true) Get.back();

          if (isBack) {
            Get.back();
            Get.back(result: true);
          } else {
            Get.offAllNamed(Routes.userTabScreen);
          }

          changeNotifier.updateString("Done");
        },
      );
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("PATIENT_LOGIN_EXCEPTION :: $e");
      messageDialog('error'.tr, 'unable_to_load_data'.tr);
    }
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      s1style: Theme.of(Get.context!).textTheme.bodyLarge,
      s2style: Theme.of(Get.context!).textTheme.bodyLarge,
      s3style: Theme.of(Get.context!).textTheme.bodyLarge,
    );
  }

  googleLogin() async {
    await _googleSignIn
        .signIn()
        .then((value) {
          if (value != null) {
            name.value = value.displayName ?? "";
            email.value = value.email;
            image.value = value.photoUrl ?? "";
            loginInto(2);
          }
        })
        .catchError((e) {
          errorDialog(message: e.toString());
        });
  }

  TextEditingController MobileNumber = TextEditingController();
  bool isMobileNumberError = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}

