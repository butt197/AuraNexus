class Apis {
  static const int timeOut = 20;

  static const String ServerAddress = 'http://159.89.136.249:8080';

  /// image paths
  static const String IMAGE = "$ServerAddress/upload/banner/";
  static const String specialityImagePath = "$ServerAddress/upload/services/";
  static const String reportImagePath = "$ServerAddress/upload/ap_img_up/";
  static const String chatMediaPath = "$ServerAddress/upload/chat/";
  static const String doctorImagePath = "$ServerAddress/upload/doctors/";
  static const String userImagePath = "$ServerAddress/upload/profile/";

  static const String SUCCESS_PAYMENT_URL = "$ServerAddress/payment_success";
  static const String FAIL_PAYMENT_URL = "$ServerAddress/payment_failed";
}
