import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/services/notification_service.dart';
import 'package:videocalling/patient/model/uhome_model.dart';

int PHONE_LENGTH = 10;
int PASS_LENGTH = 6;

String CURRENCY = "\$";
String CURRENCY_CODE = "USD";

// const String ServerToken =
//     'AAAAPwd2Odk:APA91bHOAgCVVag8SlmMQLA_xX1mONxeNKcEK0TYOAxHfAp3CvbJ_tewOoIh7MSPK0bMy9H8A9cCJqQYZH71W_SC0nZlfR57i2lDuIGKPtS3HcUB17GpbS1QDrz-08XAXkzjqyClSgtM';

StringChangeNotifier changeNotifier = StringChangeNotifier();

String latitude = "";
String longitude = "";

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
SharedPreferences? prefs;

final picker = ImagePicker();
final box = GetStorage();
final connect = GetConnect();

NotificationHelper notificationHelper = NotificationHelper();

List<SpecialityData> varSpecialityList = <SpecialityData>[];
List<BannerList> varBannerList = <BannerList>[];

String stripePublisherKey = 'pk_test_yFUNiYsEESF7QBY0jcZoYK9j00yHumvXho';
String stripeSecretKey = 'sk_test_H4cvZ6S2eX8vFFDdZCk4oNvt00RMnplVS4';
