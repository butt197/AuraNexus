import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

// bool _bgCallKitInitialized = false;
bool _bgCallKitPrepared = false;

Future<void> _prepareBackgroundCallKit(String sessionId) async {
  if (_bgCallKitPrepared) {
    debugPrint('CALLKIT_BG_INIT_SKIPPED_ALREADY_READY :: $sessionId');
    return;
  }

  _bgCallKitPrepared = true;

  try {
    ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
        onCallAcceptedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
        onCallRejectedWhenTerminated;

    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: onCallAcceptedWhenTerminated,
      onCallRejected: onCallRejectedWhenTerminated,
      icon: Platform.isAndroid ? 'launcher_icon' : 'AppIcon',
      color: '#07711e',
      ringtone: Platform.isAndroid ? 'custom_ringtone' : 'custom_ringtone.caf',
    );

    debugPrint('CALLKIT_BG_INIT_DONE :: $sessionId');
  } catch (e, st) {
    _bgCallKitPrepared = false;
    debugPrint('CALLKIT_BG_INIT_ERROR :: $e');
    debugPrint('CALLKIT_BG_INIT_STACK :: $st');
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('BG_FIREBASE_INIT_SKIP :: $e');
  }

  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint('BG_GET_STORAGE_INIT_SKIP :: $e');
  }

  debugPrint('BG_FCM_DATA :: ${event.data}');

  final String signalType =
      event.data[PARAM_SIGNAL_TYPE]?.toString() ??
      event.data['signal_type']?.toString() ??
      event.data['signalType']?.toString() ??
      '';

  final String sessionId =
      event.data[PARAM_SESSION_ID]?.toString() ??
      event.data['session_id']?.toString() ??
      event.data['sessionId']?.toString() ??
      event.data['callId']?.toString() ??
      event.data['call_id']?.toString() ??
      '';

  if (signalType == SIGNAL_TYPE_END_CALL || signalType == 'endCall') {
    if (sessionId.isNotEmpty) {
      try {
        ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
        ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
        StorageService.removeData(key: LocalStorageKeys.callSessionCS);
        debugPrint('BG_END_CALL_HANDLED :: $sessionId');
      } catch (e) {
        debugPrint('BG_END_CALL_ERROR :: $e');
      }
    }
    return;
  }

  if (signalType == SIGNAL_TYPE_REJECT_CALL || signalType == 'rejectCall') {
    if (sessionId.isNotEmpty) {
      try {
        ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
        ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
        StorageService.removeData(key: LocalStorageKeys.callSessionCS);
        debugPrint('BG_REJECT_CALL_HANDLED :: $sessionId');
      } catch (e) {
        debugPrint('BG_REJECT_CALL_ERROR :: $e');
      }
    }
    return;
  }

  final bool isStartCall =
      signalType == SIGNAL_TYPE_START_CALL ||
      signalType == 'startCall' ||
      event.data[PARAM_SESSION_ID] != null ||
      event.data['session_id'] != null ||
      event.data['sessionId'] != null ||
      event.data['callId'] != null ||
      event.data['call_id'] != null;

  if (!isStartCall) {
    debugPrint('BG_NON_CALL_PUSH_IGNORED :: ${event.data}');
    return;
  }

  if (sessionId.isEmpty) {
    debugPrint('BG_CALL_ERROR :: sessionId missing. Data: ${event.data}');
    return;
  }

  try {
    StorageService.writeStringData(
      key: LocalStorageKeys.callSessionCS,
      value: sessionId,
    );
    debugPrint('BG_CALL_SESSION_STORED :: $sessionId');
  } catch (e) {
    debugPrint('BG_CALL_SESSION_STORE_ERROR :: $e');
  }

  await showRealIncomingCallNotificationFromData(event.data);
  debugPrint('BG_CALL_NOTIFICATION_SHOWN :: $sessionId');
}

@pragma('vm:entry-point')
Future<void> showRealIncomingCallNotificationFromData(
  Map<String, dynamic> data,
) async {
  final String sessionId =
      data[PARAM_SESSION_ID]?.toString() ??
      data['session_id']?.toString() ??
      data['sessionId']?.toString() ??
      data['callId']?.toString() ??
      data['call_id']?.toString() ??
      '';

  if (sessionId.isEmpty) {
    debugPrint('CALL_NOTIFICATION_ERROR :: sessionId missing. Data: $data');
    return;
  }

  // final int callType =
  //     int.tryParse(
  //       data[PARAM_CALL_TYPE]?.toString() ??
  //           data['call_type']?.toString() ??
  //           data['callType']?.toString() ??
  //           CallType.VIDEO_CALL.toString(),
  //     ) ??
  //     CallType.VIDEO_CALL;

  // final int callerId =
  //     int.tryParse(
  //       data[PARAM_CALLER_ID]?.toString() ??
  //           data['caller_id']?.toString() ??
  //           data['callerId']?.toString() ??
  //           '0',
  //     ) ??
  //     0;

  // final String callerName =
  //     data[PARAM_CALLER_NAME]?.toString() ??
  //     data['caller_name']?.toString() ??
  //     data['callerName']?.toString() ??
  //     'Incoming Call';

  // final String callerImage =
  //     data[PARAM_CALLER_IMAGE]?.toString() ??
  //     data['caller_image']?.toString() ??
  //     data['photo_url']?.toString() ??
  //     '';

  // final String opponentsRaw =
  //     data[PARAM_CALL_OPPONENTS]?.toString() ??
  //     data['call_opponents']?.toString() ??
  //     data['opponentsIds']?.toString() ??
  //     data['opponents']?.toString() ??
  //     '';

  // final Set<int> opponents = opponentsRaw
  //     .split(',')
  //     .map((e) => int.tryParse(e.trim()))
  //     .whereType<int>()
  //     .toSet();

  // if (opponents.isEmpty && callerId != 0) {
  //   opponents.add(callerId);
  // }

  // final CallEvent callEvent = CallEvent(
  //   sessionId: sessionId,
  //   callType: callType,
  //   callerId: callerId,
  //   callerName: callerName,
  //   callPhoto: callerImage,
  //   opponentsIds: opponents,
  //   userInfo: {
  //     'signal_type': SIGNAL_TYPE_START_CALL,
  //     'signalType': SIGNAL_TYPE_START_CALL,
  //     'session_id': sessionId,
  //     'sessionId': sessionId,
  //     'callId': sessionId,
  //     'call_id': sessionId,
  //     'call_type': callType.toString(),
  //     'callType': callType.toString(),
  //     'caller_id': callerId.toString(),
  //     'callerId': callerId.toString(),
  //     'caller_name': callerName,
  //     'callerName': callerName,
  //     'caller_image': callerImage,
  //     'photo_url': callerImage,
  //     'call_opponents': opponents.join(','),
  //     'opponentsIds': opponents.join(','),
  //   },
  // );

  await _prepareBackgroundCallKit(sessionId);

  /*
    IMPORTANT:
    Do not call showCallNotification() here.

    ConnectyCube native FCM receiver already handles incoming call notification
    for this payload via processInviteCallEvent/showCallNotification.

    This background handler only prepares callbacks and stores session data.
    Showing another CallKit notification here creates duplicate native call state
    and can suppress later call notifications.
  */

  try {
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
    debugPrint('BG_CALLKIT_PREPARED_NOTIFICATION_LEFT_TO_NATIVE :: $sessionId');
  } catch (e, st) {
    debugPrint('BG_CALLKIT_PREPARE_ERROR :: $e');
    debugPrint('BG_CALLKIT_PREPARE_STACK :: $st');
  }
}
