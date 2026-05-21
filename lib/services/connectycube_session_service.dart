import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class ConnectyCubeSessionService {
  static void loginToCC(
    CubeUser user, {
    required VoidCallback onTap,
  }) {
    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession!.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        onTap();
      } else {
        loginToCubeChat(user, onTap: onTap);
      }
    } else {
      createSession(user).then((cubeSession) {
        loginToCubeChat(user, onTap: onTap);
      }).catchError((exception) {
        Get.back();
        customDialog(s1: 'error'.tr, s2: '$exception');
      });
    }
  }

  static void loginToCubeChat(
    CubeUser user, {
    VoidCallback? onTap,
  }) {
    CubeChatConnection.instance.login(user).then((cubeUser) {
      SharedPrefs.saveNewUser(user);
      if (onTap != null) {
        onTap();
      }
    }).catchError((exception) {
      Get.back();
      customDialog(s1: 'error'.tr, s2: '$exception');
    });
  }
}


