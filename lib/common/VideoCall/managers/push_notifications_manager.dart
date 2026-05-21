import 'dart:convert';

import 'package:videocalling/services/localstorage_service.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:universal_io/io.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../utils/consts.dart';
import '../utils/pref_util.dart';
import 'package:videocalling/common/VideoCall/utils/configs.dart' as config;

final Set<String> _terminatedRejectSentSessions = <String>{};

class PushNotificationsManager {
  static const TAG = "PushNotificationsManager";
  static const String androidBundleIdentifier = "com.skytelehealth.app";
  static const String iosBundleIdentifier = "com.skytelehealth.app";

  static PushNotificationsManager? _instance;

  PushNotificationsManager._internal();

  static PushNotificationsManager _getInstance() {
    return _instance ??= PushNotificationsManager._internal();
  }

  factory PushNotificationsManager() => _getInstance();

  BuildContext? applicationContext;

  static PushNotificationsManager get instance => _getInstance();

  init() async {
    ConnectycubeFlutterCallKit.onTokenRefreshed = (token) {
      log('[onTokenRefresh] VoIP token: $token', TAG);
      subscribe(token);
    };

    ConnectycubeFlutterCallKit.getToken().then((token) {
      log('[getToken] VoIP token: $token', TAG);
      if (token != null) {
        subscribe(token);
      }
    });
  }

  subscribe(String token) async {
    log('[subscribe] token: $token', PushNotificationsManager.TAG);

    CreateSubscriptionParameters parameters = CreateSubscriptionParameters();

    parameters.pushToken = token;

    parameters.environment = CubeEnvironment.DEVELOPMENT;

    if (Platform.isAndroid) {
      parameters.channel = NotificationsChannels.GCM;
      parameters.platform = CubePlatform.ANDROID;

      // IMPORTANT:
      // This must match Android applicationId/package:
      // android/app/build.gradle applicationId
      // AndroidManifest activity package path
      parameters.bundleIdentifier = androidBundleIdentifier;
    } else if (Platform.isIOS) {
      parameters.channel = NotificationsChannels.APNS_VOIP;
      parameters.platform = CubePlatform.IOS;

      // Keep this aligned with iOS bundle id if iOS is used.
      parameters.bundleIdentifier = iosBundleIdentifier;
    }

    var deviceInfoPlugin = DeviceInfoPlugin();

    dynamic deviceId;

    if (kIsWeb) {
      var webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      deviceId = base64Encode(utf8.encode(webBrowserInfo.userAgent ?? ''));
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isMacOS) {
      var macOsInfo = await deviceInfoPlugin.macOsInfo;
      deviceId = macOsInfo.computerName;
    }

    parameters.udid = deviceId;

    log(
      '[subscribe] platform=${parameters.platform}, '
      'channel=${parameters.channel}, '
      'environment=${parameters.environment}, '
      'bundleIdentifier=${parameters.bundleIdentifier}, '
      'udid=${parameters.udid}',
      PushNotificationsManager.TAG,
    );

    createSubscription(parameters.getRequestParameters())
        .then((cubeSubscriptions) {
          log('[subscribe] subscription SUCCESS', PushNotificationsManager.TAG);

          SharedPrefs.saveSubscriptionToken(token);

          for (var subscription in cubeSubscriptions) {
            if (subscription.device?.clientIdentificationSequence == token) {
              SharedPrefs.saveSubscriptionId(subscription.id!);
              log(
                '[subscribe] saved subscription id: ${subscription.id}',
                PushNotificationsManager.TAG,
              );
            }
          }
        })
        .catchError((error) {
          log(
            '[subscribe] subscription ERROR: $error',
            PushNotificationsManager.TAG,
          );
        });
  }

  Future<void> unsubscribe() {
    return SharedPrefs.getSubscriptionId()
        .then((subscriptionId) async {
          if (subscriptionId != 0) {
            return deleteSubscription(subscriptionId).then((voidResult) {
              SharedPrefs.saveSubscriptionId(0);
            });
          } else {
            return Future.value();
          }
        })
        .catchError((onError) {
          log('[unsubscribe] ERROR: $onError', PushNotificationsManager.TAG);
        });
  }
}

@pragma('vm:entry-point')
Future<void> onCallRejectedWhenTerminated(CallEvent callEvent) async {
  await GetStorage.init();

  final String sessionId = callEvent.sessionId;
  final GetStorage box = GetStorage();
  final String rejectGuardKey = 'call_reject_push_sent_$sessionId';

  if (box.read(rejectGuardKey) == true) {
    log(
      '[onCallRejectedWhenTerminated] duplicate persistent ignored: $sessionId',
      PushNotificationsManager.TAG,
    );
    return;
  }

  await box.write(rejectGuardKey, true);

  _terminatedRejectSentSessions.add(sessionId);

  try {
    StorageService.removeData(key: LocalStorageKeys.callSessionCS);
  } catch (_) {}

  try {
    ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  } catch (_) {}

  initConnectycubeContextLess();

  final Map<String, dynamic> rejectPayload = {
    PARAM_CALL_TYPE: callEvent.callType.toString(),
    PARAM_SESSION_ID: sessionId,
    'session_id': sessionId,
    'sessionId': sessionId,
    'callId': sessionId,
    PARAM_CALLER_ID: callEvent.callerId.toString(),
    PARAM_CALLER_NAME: callEvent.callerName,
    PARAM_CALL_OPPONENTS: callEvent.opponentsIds.join(','),
    PARAM_SIGNAL_TYPE: SIGNAL_TYPE_REJECT_CALL,
    'signal_type': SIGNAL_TYPE_REJECT_CALL,
    'signalType': SIGNAL_TYPE_REJECT_CALL,
  };

  try {
    await sendPushAboutRejectFromKilledState(rejectPayload, callEvent.callerId);

    log(
      '[onCallRejectedWhenTerminated] reject push sent: $sessionId',
      PushNotificationsManager.TAG,
    );
  } catch (e) {
    log(
      '[onCallRejectedWhenTerminated] error: $e',
      PushNotificationsManager.TAG,
    );
  }
}

@pragma('vm:entry-point')
Future<void> onCallAcceptedWhenTerminated(CallEvent callEvent) async {
  await GetStorage.init();

  final String sessionId = callEvent.sessionId;

  if (sessionId.isEmpty) {
    log(
      '[onCallAcceptedWhenTerminated] empty sessionId',
      PushNotificationsManager.TAG,
    );
    return;
  }

  /*
    Critical:
    Do NOT remove callSessionCS here.

    When the app is background/terminated, CallKit accept can arrive before
    P2PClient.onReceiveNewSession is ready. We store the accepted session id
    so CallManager can accept it when the real P2P session arrives.
  */
  StorageService.writeStringData(
    key: LocalStorageKeys.callSessionCS,
    value: sessionId,
  );

  try {
    ConnectycubeFlutterCallKit.reportCallAccepted(sessionId: sessionId);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  } catch (e) {
    log(
      '[onCallAcceptedWhenTerminated] report accepted error: $e',
      PushNotificationsManager.TAG,
    );
  }

  log(
    '[onCallAcceptedWhenTerminated] stored accepted session: $sessionId',
    PushNotificationsManager.TAG,
  );
}

Future<void> sendPushAboutRejectFromKilledState(
  Map<String, dynamic> parameters,
  int callerId,
) {
  CreateEventParams params = CreateEventParams();
  params.parameters = parameters;
  params.parameters['message'] = "Reject call";
  params.parameters[PARAM_SIGNAL_TYPE] = SIGNAL_TYPE_REJECT_CALL;
  // params.parameters[PARAM_IOS_VOIP] = 1;

  params.notificationType = NotificationType.PUSH;
  params.environment = CubeEnvironment.DEVELOPMENT;
  // bool isProduction = bool.fromEnvironment('dart.vm.product');
  // params.environment =
  //     isProduction ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;
  params.usersIds = [callerId];

  return createEvent(params.getEventForRequest());
}

initConnectycubeContextLess() {
  CubeSettings.instance.applicationId = config.APP_ID;
  CubeSettings.instance.authorizationKey = config.AUTH_KEY;
  CubeSettings.instance.authorizationSecret = config.AUTH_SECRET;
  CubeSettings.instance.onSessionRestore = () {
    return SharedPrefs.getUser().then((savedUser) {
      return createSession(savedUser);
    });
  };
}

