import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  await GetStorage.init();

  try {
    notificationHelper.initialize();
  } catch (e) {
    debugPrint('Notification init skipped: $e');
  }

  Stripe.publishableKey = stripePublisherKey;
  await Stripe.instance.applySettings();
  debugPrint('Stripe initialized successfully');

  try {
    ConnectycubeFlutterCallKit.initEventsHandler();
    ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
        onCallAcceptedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
        onCallRejectedWhenTerminated;
  } catch (e) {
    debugPrint('ConnectyCube call kit init skipped: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
