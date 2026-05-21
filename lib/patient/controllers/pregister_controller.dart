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

    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
      await storeToken();
      return;
    }

    customDialog1(s1: 'creating_account'.tr, s2: 'creating_account1'.tr);

    try {
      if (token.value.isEmpty) {
        await getToken();
      }

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
      firebaseMessaging.getToken().then((value) {
        if (value == null) return;
        token.value = value;
      });
    } else {
      token.value = StorageService.readData(key: LocalStorageKeys.token);
    }
  }

  storeToken() async {
    customDialog1(s1: 'creating_account'.tr, s2: 'creating_account1'.tr);
    if (token.value.isEmpty) {
      await getToken();
    }
    final response = await post(
      Uri.parse("${Apis.ServerAddress}/api/savetoken"),
      body: {"token": token.value, "type": "1"},
    );
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
        registerUser();
      }
    } else {
      Get.back();
      customDialog(s1: 'error'.tr, s2: response.body.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}

