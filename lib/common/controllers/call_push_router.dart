import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class CallPushRouter {
  static bool _isStarted = false;
  static String? _owner;

  static StreamSubscription<RemoteMessage>? _onMessageSub;
  static StreamSubscription<RemoteMessage>? _onOpenedSub;

  static Future<void> start({required String owner}) async {
    if (_isStarted && _owner == owner) {
      debugPrint('CALL_PUSH_ROUTER_ALREADY_STARTED_BY :: $owner');
      return;
    }

    if (_isStarted && _owner != owner) {
      debugPrint('CALL_PUSH_ROUTER_SWITCH :: from=$_owner to=$owner');

      await _onMessageSub?.cancel();
      await _onOpenedSub?.cancel();

      _onMessageSub = null;
      _onOpenedSub = null;
      _isStarted = false;
      _owner = null;
    }

    _isStarted = true;
    _owner = owner;

    debugPrint('CALL_PUSH_ROUTER_STARTED_BY :: $owner');

    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    _onMessageSub = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) async {
      debugPrint('GLOBAL_FOREGROUND_FCM_DATA :: ${message.data}');

      final String signalType =
          message.data[PARAM_SIGNAL_TYPE]?.toString() ??
          message.data['signal_type']?.toString() ??
          message.data['signalType']?.toString() ??
          '';

      final String sessionId =
          message.data[PARAM_SESSION_ID]?.toString() ??
          message.data['session_id']?.toString() ??
          message.data['sessionId']?.toString() ??
          message.data['callId']?.toString() ??
          message.data['call_id']?.toString() ??
          '';

      if (signalType == SIGNAL_TYPE_END_CALL || signalType == 'endCall') {
        debugPrint('GLOBAL_FOREGROUND_END_CALL_RECEIVED :: $sessionId');

        if (sessionId.isNotEmpty) {
          ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
          ConnectycubeFlutterCallKit.setOnLockScreenVisibility(
            isVisible: false,
          );
        }

        return;
      }

      if (signalType == SIGNAL_TYPE_REJECT_CALL || signalType == 'rejectCall') {
        debugPrint('GLOBAL_FOREGROUND_REJECT_CALL_RECEIVED :: $sessionId');

        if (sessionId.isNotEmpty) {
          ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
          ConnectycubeFlutterCallKit.setOnLockScreenVisibility(
            isVisible: false,
          );

          try {
            CallManager.instance.reject(sessionId, true);
          } catch (e) {
            debugPrint('GLOBAL_REJECT_CALL_ERROR :: $e');
          }
        }

        return;
      }

      if (signalType == SIGNAL_TYPE_START_CALL || signalType == 'startCall') {
        debugPrint(
          'GLOBAL_FOREGROUND_START_CALL_PUSH_RECEIVED :: ${message.data}',
        );

        final int callerId =
            int.tryParse(
              message.data[PARAM_CALLER_ID]?.toString() ??
                  message.data['caller_id']?.toString() ??
                  message.data['callerId']?.toString() ??
                  '0',
            ) ??
            0;

        final int? currentCubeUserId =
            CubeChatConnection.instance.currentUser?.id;

        if (currentCubeUserId != null && callerId == currentCubeUserId) {
          debugPrint(
            'GLOBAL_FOREGROUND_SELF_CALL_PUSH_IGNORED :: session=$sessionId user=$currentCubeUserId',
          );
          return;
        }

        /*
      Important:
      In foreground, P2P onReceiveNewSession already handles real call notification
      through CallManager._showIncomingCallScreen().

      Do NOT call _showIncomingCallNotification(message) here.
      Calling it here creates duplicate call notifications and breaks CallKit state.
    */
        return;
      }

      if (message.data['order_id'] != null) {
        notificationHelper.showNotification(
          title: message.notification?.title ?? 'Notification',
          body: message.notification?.body ?? '',
          payload: "${message.data['type']}:${message.data['order_id']}",
          id: "124",
        );
        return;
      }

      if (message.notification?.title != null) {
        notificationHelper.showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          payload: "${message.data['myid']}:${message.data['myUserName']}",
          id: "124",
        );
      }
    });

    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint('GLOBAL_INITIAL_FCM_DATA :: ${initialMessage.data}');
      await _handleOpenedMessage(initialMessage);
    }

    _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) async {
      debugPrint('GLOBAL_OPENED_FCM_DATA :: ${message.data}');
      await _handleOpenedMessage(message);
    });
  }

  static Future<void> _showIncomingCallNotification(
    RemoteMessage message,
  ) async {
    final Map<String, dynamic> data = message.data;

    final String sessionId =
        data[PARAM_SESSION_ID]?.toString() ??
        data['session_id']?.toString() ??
        data['sessionId']?.toString() ??
        data['callId']?.toString() ??
        data['call_id']?.toString() ??
        '';

    if (sessionId.isEmpty) {
      debugPrint('GLOBAL_CALL_ERROR :: sessionId missing. Data: $data');
      return;
    }

    final int callType =
        int.tryParse(
          data[PARAM_CALL_TYPE]?.toString() ??
              data['call_type']?.toString() ??
              data['callType']?.toString() ??
              CallType.VIDEO_CALL.toString(),
        ) ??
        CallType.VIDEO_CALL;

    final int callerId =
        int.tryParse(
          data[PARAM_CALLER_ID]?.toString() ??
              data['caller_id']?.toString() ??
              data['callerId']?.toString() ??
              '0',
        ) ??
        0;

    final String callerName =
        data[PARAM_CALLER_NAME]?.toString() ??
        data['caller_name']?.toString() ??
        data['callerName']?.toString() ??
        'Incoming Call';

    final String callerImage =
        data[PARAM_CALLER_IMAGE]?.toString() ??
        data['caller_image']?.toString() ??
        data['photo_url']?.toString() ??
        '';

    final String opponentsRaw =
        data[PARAM_CALL_OPPONENTS]?.toString() ??
        data['call_opponents']?.toString() ??
        data['opponentsIds']?.toString() ??
        '';

    final Set<int> opponents = opponentsRaw
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toSet();

    if (opponents.isEmpty && callerId != 0) {
      opponents.add(callerId);
    }

    final CallEvent callEvent = CallEvent(
      sessionId: sessionId,
      callType: callType,
      callerId: callerId,
      callerName: callerName,
      callPhoto: callerImage,
      opponentsIds: opponents,
      userInfo: {
        'signal_type': SIGNAL_TYPE_START_CALL,
        'session_id': sessionId,
      },
    );

    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);

    await ConnectycubeFlutterCallKit.showCallNotification(callEvent);

    debugPrint('GLOBAL_REAL_CALL_NOTIFICATION_SHOWN :: $sessionId');
  }

  static Future<void> _handleOpenedMessage(RemoteMessage message) async {
    if (message.data['type'] == "user_id") {
      Get.toNamed(
        Routes.uAppointmentDetailScreen,
        arguments: {'id': message.data['order_id'].toString()},
      );
    } else if (message.data['type'] == "doctor_id") {
      await Get.toNamed(
        Routes.dAppointmentDetailScreen,
        arguments: {'id': message.data['order_id'].toString()},
      );
      Get.delete<DAppointmentDetailsController>();
    } else if (message.data['myUserName'] != null &&
        message.data['myid'] != null) {
      await Get.toNamed(
        Routes.chatScreen,
        arguments: {
          'userName': message.data['myUserName'].toString(),
          'uid': message.data['myid'].toString(),
          'isUser': message.data['myid'].toString().contains("100")
              ? false
              : true,
        },
      );
      Get.delete<ChatController>();
    }
  }
}
