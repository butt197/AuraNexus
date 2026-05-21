import 'package:videocalling/common/controllers/call_push_router.dart';
import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorTabController extends GetxController {
  final IncomingManageController incomingCallManager = Get.put(
    IncomingManageController(),
    permanent: true,
  );
  bool _callServicesStarted = false;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationHelper.initialize();
      _startCallServicesIfLoggedIn();
    });

    changeNotifier.stringStream.listen((String data) {
      if (data == "Done") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startCallServicesIfLoggedIn();
        });
      }
    });
  }

  Future<void> _startCallServicesIfLoggedIn() async {
    if (_callServicesStarted) return;

    final bool isDoctorLoggedIn =
        StorageService.readData(key: LocalStorageKeys.isLoggedInAsDoctor) ??
        false;

    final bool isPatientLoggedIn =
        StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;

    if (!isDoctorLoggedIn || isPatientLoggedIn) {
      debugPrint(
        "DOCTOR_CALL_INIT_SKIPPED_ROLE :: doctor=$isDoctorLoggedIn patient=$isPatientLoggedIn",
      );
      return;
    }

    final value = await SharedPrefs.getUser();

    if (value == null) {
      debugPrint("DOCTOR_CALL_INIT_SKIPPED :: Cube user not found");
      return;
    }

    _callServicesStarted = true;

    debugPrint("DOCTOR_CALL_INIT_STARTED");

    checkSystemAlertWindowPermission();

    if (Get.context != null) {
      CallManager.instance.init(Get.context!);
    } else {
      debugPrint("DOCTOR_CALL_INIT_WARNING :: Get.context is null");
    }

    await PushNotificationsManager.instance.init();

    await CallPushRouter.start(owner: 'doctor');

    ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
        onCallAcceptedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
        onCallRejectedWhenTerminated;

    debugPrint("DOCTOR_CALL_INIT_DONE");
  }

  // callNotification() async {
  //   FirebaseMessaging.onMessage.listen((message) {
  //     debugPrint('DOCTOR_FOREGROUND_FCM_DATA :: ${message.data}');

  //     final String? signalType = message.data['signal_type']?.toString();

  //     final bool isStartCall =
  //         signalType == SIGNAL_TYPE_START_CALL ||
  //         signalType == 'startCall' ||
  //         message.data['callId'] != null ||
  //         message.data['session_id'] != null ||
  //         message.data['sessionId'] != null;

  //     if (isStartCall) {
  //       debugPrint('DOCTOR_FOREGROUND_CALL_PUSH_RECEIVED :: ${message.data}');
  //       showRealIncomingCallNotificationFromData(message.data);
  //       return;
  //     }
  //     var payloadData =
  //         '${message.data['notificationType']}:${message.data['ccId']}';

  //     if (message.data[PARAM_CALLER_NAME] != null) {
  //       incomingCallManager.setValue(
  //         message.data[PARAM_CALLER_NAME],
  //         message.data[PARAM_CALLER_IMAGE] ?? "",
  //       );
  //     }

  //     if (message.data['signal_type'] == "rejectCall") {
  //       try {
  //         CallManager.instance.reject(message.data['session_id'], true);
  //       } catch (e) {
  //         debugPrint("DOCTOR_REJECT_CALL_ERROR :: $e");
  //       }
  //     } else if (message.data['signal_type'] == "startCall" ||
  //         message.data[PARAM_SESSION_ID] != null ||
  //         message.data['session_id'] != null ||
  //         message.data['sessionId'] != null) {
  //       debugPrint("DOCTOR_FOREGROUND_CALL_PUSH_RECEIVED :: ${message.data}");
  //       // Do not show fallback notification here.
  //       // ConnectyCube/P2P session listener should show real incoming call UI.
  //     } else if (message.data['order_id'] != null) {
  //       notificationHelper.showNotification(
  //         title: message.notification?.title ?? "",
  //         body: message.notification?.body ?? "",
  //         payload: "${message.data['type']}:${message.data['order_id']}",
  //         id: "124",
  //       );
  //     } else if (payloadData.split(":")[0].toString() == '3') {
  //       notificationHelper.showNotification(
  //         title: 'Call Rejected',
  //         body: message.notification?.body ?? "",
  //         payload: payloadData,
  //         id: "124",
  //       );

  //       try {
  //         CallManager.instance.reject(message.data['sessionId'], true);
  //       } catch (e) {
  //         debugPrint("DOCTOR_CALL_REJECT_PAYLOAD_ERROR :: $e");
  //       }
  //     } else if (payloadData.split(":")[0].toString() == '1') {
  //       incomingCallManager.setValue(
  //         message.data[PARAM_CALLER_NAME] ?? "",
  //         message.data['image'] ?? "",
  //       );
  //     } else {
  //       if (message.notification?.title != null) {
  //         notificationHelper.showNotification(
  //           title: message.notification?.title ?? "",
  //           body: message.notification?.body ?? "",
  //           payload: "${message.data['myid']}:${message.data['myUserName']}",
  //           id: "124",
  //         );
  //       }
  //     }
  //   });

  //   RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

  //   if (initialMessage != null) {
  //     debugPrint("DOCTOR_INITIAL_FCM_DATA :: ${initialMessage.data}");

  //     if (initialMessage.data['myUserName'] != null &&
  //         initialMessage.data['myid'] != null) {
  //       await Get.toNamed(
  //         Routes.chatScreen,
  //         arguments: {
  //           'userName': initialMessage.data['myUserName'].toString(),
  //           'uid': initialMessage.data['myid'].toString(),
  //           'isUser': initialMessage.data['myid'].toString().contains("100")
  //               ? false
  //               : true,
  //         },
  //       );
  //       Get.delete<ChatController>();
  //     }
  //   }

  //   FirebaseMessaging.onMessageOpenedApp.listen((message) async {
  //     debugPrint("DOCTOR_OPENED_FCM_DATA :: ${message.data}");

  //     if (message.data['type'] == "user_id") {
  //       Get.toNamed(
  //         Routes.uAppointmentDetailScreen,
  //         arguments: {'id': message.data['order_id'].toString()},
  //       );
  //     } else if (message.data['type'] == "doctor_id") {
  //       await Get.toNamed(
  //         Routes.dAppointmentDetailScreen,
  //         arguments: {'id': message.data['order_id'].toString()},
  //       );
  //       Get.delete<DAppointmentDetailsController>();
  //     }
  //   });
  // }

  getPage(int page) {
    switch (page) {
      case 0:
        return DoctorDashboard();
      case 1:
        return DoctorPastAppointments();
      case 2:
        return DoctorProfile();
      case 3:
        return ChatListScreen();
      case 4:
        return MoreInfoScreen();
    }
  }

  RxInt index = 0.obs;

  Future<bool> willPopScope() async {
    exit(0);
  }
}
