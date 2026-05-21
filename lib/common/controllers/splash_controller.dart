import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    CubeSettings.instance.isDebugEnabled = false;
    Get.isLogEnable = false;
    getToken();
  }

  getToken() async {
    getCC();

    Timer(const Duration(seconds: 2), () {
      final bool isDoctor =
          StorageService.readData(key: LocalStorageKeys.isLoggedInAsDoctor) ??
          false;

      final bool isPatient =
          StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;

      if (isDoctor && !isPatient) {
        Get.offAllNamed(Routes.doctorTabScreen);
        return;
      }

      if (isPatient && !isDoctor) {
        Get.offAllNamed(Routes.userTabScreen);
        return;
      }

      Get.offAllNamed(Routes.userTabScreen);
    });
  }

  getCC() {
    SharedPrefs.getUser().then((value) {
      if (value == null) return;
      ConnectyCubeSessionService.loginToCC(
        value,
        onTap: () => changeNotifier.updateString("Done"),
      );
    });
  }
}
