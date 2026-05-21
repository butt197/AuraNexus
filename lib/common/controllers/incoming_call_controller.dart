import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class IncomingCallController extends GetxController {
  late final P2PSession callSession;

  static const String TAG = "IncomingCallScreen";

  final IncomingManageController incomingScreenManager = Get.find();

  @override
  void onInit() {
    super.onInit();

    callSession = Get.arguments['callSession'];

    debugPrint("INCOMING_CONTROLLER_INIT :: ${callSession.sessionId}");

    FlutterRingtonePlayer().playRingtone(
      looping: true,
      volume: 0.1,
      asAlarm: false,
    );

    callSession.onSessionClosed = (closedSession) {
      debugPrint("INCOMING_CONTROLLER_SESSION_CLOSED");

      incomingScreenManager.removeValue();
      incomingScreenManager.removecallingImageValue();

      FlutterRingtonePlayer().stop();

      if (Get.currentRoute == Routes.incomingCallScreen ||
          Get.currentRoute == "/incoming-call-screen") {
        Get.back();
      }
    };
  }

  @override
  void onClose() {
    FlutterRingtonePlayer().stop();
    super.onClose();
  }

  String getCallTitle() {
    switch (callSession.callType) {
      case CallType.VIDEO_CALL:
        return "Incoming Video call";
      case CallType.AUDIO_CALL:
        return "Incoming Audio call";
      default:
        return "Incoming call";
    }
  }

  void acceptCall(BuildContext context, P2PSession callSession) {
    FlutterRingtonePlayer().stop();
    CallManager.instance.acceptCall(callSession.sessionId, false);
  }

  void rejectCall(BuildContext context, P2PSession callSession) {
    FlutterRingtonePlayer().stop();
    CallManager.instance.reject(callSession.sessionId, false);
  }

  Future<bool> onBackPressed(BuildContext context) {
    return Future.value(false);
  }
}
