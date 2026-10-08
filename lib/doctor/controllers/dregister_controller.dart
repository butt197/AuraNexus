import 'package:videocalling/common/utils/app_imports.dart';
// import 'package:videocalling/common/utils/video_call_imports.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class DoctorRegisterController extends GetxController {
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
  RxString licenseNumber = "".obs;
  RxBool isLicenseError = false.obs;
  RxBool isCertificateError = false.obs;
  RxString certificateError = "".obs;

  final ImagePicker _picker = ImagePicker();
  RxList<File> certificateImages = <File>[].obs;
  final formKey = GlobalKey<FormState>();


  // Keep the complete certificate multipart payload safely below
  // the server/Nginx request-size threshold.
  static const int _certificateBatchBudgetBytes = 750 * 1024;

  Future<File> _compressCertificateToBudget(
    File source,
    int targetBytes,
    int index,
  ) async {
    final originalBytes = await source.readAsBytes();

    if (originalBytes.length <= targetBytes) {
      return source;
    }

    final decoded = img.decodeImage(originalBytes);

    if (decoded == null) {
      throw Exception(
        'Unable to process certificate image ${index + 1}. '
        'Please select a JPG or PNG image.',
      );
    }

    final resizeTargets = <int>[1400, 1200, 1000, 850, 720, 600];
    final qualityTargets = <int>[55, 45, 35, 28, 22, 18];

    List<int>? bestBytes;

    for (final maxSide in resizeTargets) {
      img.Image workingImage = decoded;

      if (decoded.width > maxSide || decoded.height > maxSide) {
        if (decoded.width >= decoded.height) {
          workingImage = img.copyResize(
            decoded,
            width: maxSide,
            interpolation: img.Interpolation.linear,
          );
        } else {
          workingImage = img.copyResize(
            decoded,
            height: maxSide,
            interpolation: img.Interpolation.linear,
          );
        }
      }

      for (final quality in qualityTargets) {
        final encoded = img.encodeJpg(
          workingImage,
          quality: quality,
        );

        bestBytes = encoded;

        if (encoded.length <= targetBytes) {
          await source.writeAsBytes(encoded, flush: true);

          debugPrint(
            "DOCTOR_CERT_COMPRESSED :: image=${index + 1} :: "
            "${(encoded.length / 1024).toStringAsFixed(0)} KB :: "
            "budget=${(targetBytes / 1024).toStringAsFixed(0)} KB",
          );

          return source;
        }
      }
    }

    if (bestBytes != null) {
      await source.writeAsBytes(bestBytes, flush: true);

      if (bestBytes.length <= targetBytes) {
        return source;
      }
    }

    throw Exception(
      'Certificate image ${index + 1} could not be compressed safely. '
      'Please use a clearer/smaller image.',
    );
  }

  Future<void> _enforceCertificateBatchBudget() async {
    if (certificateImages.isEmpty) return;

    final perImageBudget =
        _certificateBatchBudgetBytes ~/ certificateImages.length;

    if (perImageBudget < 35 * 1024) {
      throw Exception(
        'Too many certificate images selected at once. '
        'Please upload fewer images.',
      );
    }

    final List<File> compressedFiles = <File>[];

    for (int i = 0; i < certificateImages.length; i++) {
      final compressed = await _compressCertificateToBudget(
        certificateImages[i],
        perImageBudget,
        i,
      );

      compressedFiles.add(compressed);
    }

    certificateImages.assignAll(compressedFiles);

    int totalBytes = 0;

    for (final file in certificateImages) {
      totalBytes += await file.length();
    }

    debugPrint(
      "DOCTOR_CERT_BATCH_FINAL :: "
      "count=${certificateImages.length} :: "
      "${(totalBytes / 1024).toStringAsFixed(0)} KB",
    );

    if (totalBytes > _certificateBatchBudgetBytes) {
      throw Exception(
        'Certificate upload is still too large after compression.',
      );
    }
  }

  Future<void> pickCertificateImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 45,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (pickedFiles.isEmpty) return;

      final List<File> newFiles = pickedFiles
          .map((xFile) => File(xFile.path))
          .toList();

      for (final file in newFiles) {
        final bool alreadyExists = certificateImages.any(
          (existingFile) => existingFile.path == file.path,
        );

        if (!alreadyExists) {
          certificateImages.add(file);
        }
      }

      await _enforceCertificateBatchBudget();

      isCertificateError.value = false;
      certificateError.value = "";
      update();
    } catch (e) {
      customDialog(s1: 'error'.tr, s2: 'Unable to pick certificate images. $e');
    }
  }

  void removeCertificateImage(int index) {
    if (index < 0 || index >= certificateImages.length) return;

    certificateImages.removeAt(index);

    if (certificateImages.isEmpty) {
      isCertificateError.value = true;
      certificateError.value = 'Please upload at least one certificate image';
    } else {
      isCertificateError.value = false;
      certificateError.value = "";
    }

    update();
  }

  Future<bool> storeToken() async {
    if (token.value.trim().isEmpty) {
      await getToken();
    }

    final currentToken = token.value.trim();

    if (currentToken.isEmpty) {
      debugPrint("DOCTOR_REGISTER_TOKEN_SYNC_SKIPPED_NO_TOKEN");
      return false;
    }

    try {
      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/savetoken"),
        body: {"token": currentToken, "type": "1"},
      ).timeout(const Duration(seconds: Apis.timeOut));

      if (response.statusCode != 200) {
        debugPrint(
          "DOCTOR_REGISTER_TOKEN_SYNC_HTTP_${response.statusCode}",
        );
        return false;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() != "1") {
        debugPrint("DOCTOR_REGISTER_TOKEN_SYNC_REJECTED");
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

      debugPrint("DOCTOR_REGISTER_TOKEN_SYNC_OK");
      return true;
    } catch (e) {
      debugPrint("DOCTOR_REGISTER_TOKEN_SYNC_FAILED :: $e");
      return false;
    }
  }

  Future<void> registerUser() async {
    final String cleanName = name.value.trim();
    final String cleanPhone = phoneNumber.value.trim();
    final String cleanEmail = email.value.trim();
    final String cleanPassword = password.value.trim();
    final String cleanConfirmPassword = confirmPassword.value.trim();
    final String cleanLicenseNumber = licenseNumber.value.trim();

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

    if (cleanLicenseNumber.isEmpty) {
      isLicenseError.value = true;
      update();
      return;
    }

    if (certificateImages.isEmpty) {
      isCertificateError.value = true;
      certificateError.value = 'Please upload at least one certificate image';
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

    customDialog1(s1: 'creating_account'.tr, s2: 'creating_account1'.tr);

    try {
      if (token.value.trim().isEmpty) {
        await getToken();
      }

      if (token.value.trim().isNotEmpty &&
          StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
        await storeToken();
      }

      final uri = Uri.parse("${Apis.ServerAddress}/api/doctorregister");

      final request = http.MultipartRequest('POST', uri);

      request.fields['name'] = cleanName;
      request.fields['email'] = cleanEmail;
      request.fields['phone'] = cleanPhone;
      request.fields['password'] = cleanPassword;
      request.fields['token'] = token.value.trim();
      request.fields['license_number'] = cleanLicenseNumber;

      int totalUploadBytes = 0;

      for (final file in certificateImages) {
        final fileSize = await file.length();
        totalUploadBytes += fileSize;

        debugPrint(
          "DOCTOR_CERT_FILE :: ${file.path} :: "
          "${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB",
        );

        request.files.add(
          await http.MultipartFile.fromPath(
            'certificate_images[]',
            file.path,
          ),
        );
      }

      debugPrint(
        "DOCTOR_CERT_TOTAL_UPLOAD :: "
        "${(totalUploadBytes / 1024 / 1024).toStringAsFixed(2)} MB",
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: Apis.timeOut),
      );

      final responseBody = await streamedResponse.stream.bytesToString();

      debugPrint("DOCTOR_REGISTER_STATUS :: ${streamedResponse.statusCode}");
      debugPrint("DOCTOR_REGISTER_BODY :: $responseBody");

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (streamedResponse.statusCode != 200) {
        customDialog(
          s1: 'error'.tr,
          s2: 'Server error: ${streamedResponse.statusCode}',
        );
        return;
      }

      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['success'].toString() == "1") {
        customDialog(
          s1: 'success'.tr,
          s2:
              jsonResponse['register']['message'] ??
              'Registration successful. Your account is under review.',
          onPressed: () {
            Get.back();
            Get.back();
          },
        );
      } else {
        customDialog(s1: 'error'.tr, s2: jsonResponse['register'].toString());
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      debugPrint("DOCTOR_REGISTER_EXCEPTION :: $e");
      customDialog(s1: 'error'.tr, s2: e.toString());
    }
  }

  Future<void> getToken() async {
    final savedToken = StorageService.readData(key: LocalStorageKeys.token);

    if (savedToken != null && savedToken.toString().trim().isNotEmpty) {
      token.value = savedToken.toString().trim();
      return;
    }

    try {
      final fcmToken = await firebaseMessaging.getToken();

      if (fcmToken != null && fcmToken.trim().isNotEmpty) {
        token.value = fcmToken.trim();

        StorageService.writeStringData(
          key: LocalStorageKeys.token,
          value: token.value,
        );
        debugPrint("DOCTOR_REGISTER_FCM_TOKEN_OK");
        return;
      }
    } catch (e) {
      debugPrint("DOCTOR_REGISTER_FCM_TOKEN_FAILED :: $e");
    }

    if (Platform.isIOS && kDebugMode) {
      token.value = "ios_simulator_test_token";
      debugPrint("DOCTOR_REGISTER_USING_IOS_SIMULATOR_TEST_TOKEN");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}

