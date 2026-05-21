import 'package:videocalling/common/utils/app_imports.dart';

class ForgetPasswordController extends GetxController {
  String id = Get.arguments['id'];

  TextEditingController emailTextField = TextEditingController();
  RxBool isEmailError = false.obs;
  RxString emailError = "".obs;

  sendEmail() async {
    customDialog1(s1: 'loading'.tr, s2: 'please_wait_while_processing'.tr);

    try {
      final String email = Uri.encodeComponent(emailTextField.text.trim());

      final response = await get(
        Uri.parse(
          "${Apis.ServerAddress}/api/forgotpassword?type=$id&email=$email",
        ),
      ).timeout(const Duration(seconds: Apis.timeOut));

      Get.back();

      if (response.statusCode != 200) {
        messageDialog('error'.tr, 'Server error: ${response.statusCode}', 0);
        return;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'].toString() == '1') {
        messageDialog(
          'success'.tr,
          jsonResponse['msg']?.toString() ?? 'Success',
          1,
        );
      } else {
        messageDialog(
          'error'.tr,
          jsonResponse['msg']?.toString() ?? 'Unable to process request.',
          0,
        );
      }
    } on TimeoutException catch (_) {
      Get.back();
      messageDialog(
        'error'.tr,
        'Request timeout. Server email service is still slow or blocked.',
        0,
      );
    } catch (e) {
      Get.back();
      messageDialog('error'.tr, e.toString(), 0);
    } finally {
      Client().close();
    }
  }

  messageDialog(String s1, String s2, int i) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () async {
        if (i == 1 && id == "1") {
          Get.back();
          Get.back();
        } else if (i == 1 && id == "2") {
          Get.back();
          Get.back();
        } else {
          Get.back();
        }
      },
      s3style: const TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        color: AppColors.BLACK,
      ),
    );
  }
}
