import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:url_launcher/url_launcher.dart';

class BankDetailController extends GetxController {
  RxString doctorId = "".obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool isOpeningStripe = false.obs;

  UpdateBankDetails updateResponse = UpdateBankDetails();
  GetBankDetails getResponse = GetBankDetails();

  BankData? get payoutData => getResponse.data;

  getBankDetails() async {
    isLoaded.value = false;
    isError.value = false;

    try {
      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/get_bankdetails"),
        body: {'doctor_id': doctorId.value},
      ).timeout(const Duration(seconds: Apis.timeOut));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['msg'] == "Doctors Bank Details") {
          getResponse = GetBankDetails.fromJson(decoded);
        } else {
          isError.value = true;
          messageDialog('error'.tr, "${decoded['msg']}");
        }
      } else {
        isError.value = true;
        messageDialog('error'.tr, "${response.reasonPhrase}");
      }
    } catch (e) {
      isError.value = true;
      messageDialog('error'.tr, e.toString());
    } finally {
      isLoaded.value = true;
      Client().close();
    }
  }

  Future<void> startOrContinueStripeOnboarding() async {
    if (isOpeningStripe.value) return;

    isOpeningStripe.value = true;

    customDialog1(
      s1: 'reporting_dialog1'.tr,
      s2: 'Preparing Stripe payout setup...',
    );

    try {
      final response = await post(
        Uri.parse("${Apis.ServerAddress}/api/add_bankdetails"),
        body: {
          'doctor_id': doctorId.value,
          'return_url':
              "${Apis.ServerAddress}/api/get_bankdetails?doctor_id=${doctorId.value}",
          'refresh_url':
              "${Apis.ServerAddress}/api/get_bankdetails?doctor_id=${doctorId.value}",
        },
      ).timeout(const Duration(seconds: Apis.timeOut));

      Get.back();

      if (response.statusCode != 200) {
        messageDialog('error'.tr, response.reasonPhrase ?? 'Request failed.');
        return;
      }

      final decodedResponse = jsonDecode(response.body);

      final bool isSuccess =
          decodedResponse['success'].toString() == "1" ||
          decodedResponse['status'].toString() == "1";

      if (!isSuccess) {
        messageDialog(
          'error'.tr,
          decodedResponse['msg']?.toString() ??
              decodedResponse['register']?.toString() ??
              'Stripe setup failed.',
        );
        return;
      }

      updateResponse = UpdateBankDetails.fromJson(decodedResponse);

      final dynamic responseData = decodedResponse['data'];
      final String onboardingUrl =
          responseData is Map && responseData['onboarding_url'] != null
          ? responseData['onboarding_url'].toString().trim()
          : "";

      if (onboardingUrl.isNotEmpty) {
        final bool launched = await launchUrl(
          Uri.parse(onboardingUrl),
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          messageDialog(
            'error'.tr,
            'Unable to open Stripe onboarding link. Please try again.',
          );
          return;
        }

        return;
      }

      await getBankDetails();
      messageDialog('success'.tr, 'Stripe payout setup is already active.');
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      messageDialog('error'.tr, e.toString());
    } finally {
      isOpeningStripe.value = false;
      Client().close();
    }
  }

  Future<void> refreshStripeStatus() async {
    await getBankDetails();
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

  @override
  void onInit() {
    super.onInit();
    doctorId.value =
        StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    getBankDetails();
  }
}
