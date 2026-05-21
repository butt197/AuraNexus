import 'package:videocalling/common/utils/app_variales.dart';

class StorageService {
  static dynamic readData({
    required String key,
  }) {
    return box.read(key);
  }

  static bool checkData({
    required String key,
  }) {
    return box.hasData(key);
  }

  static writeStringData({
    required String key,
    required String value,
  }) {
    box.write(key, value);
  }

  static writeBoolData({
    required String key,
    required bool value,
  }) {
    box.write(key, value);
  }

  static removeData({
    required String key,
  }) {
    box.remove(key);
  }
}

class LocalStorageKeys {
  static const String callSessionCS = "callSessionCS";
  static const String isBack = "isBack";
  static const String isTokenExist = "isTokenExist";
  static const String token = "token";
  static const String userIdWithAscii = "userIdWithAscii";
  static const String userId = "userId";
  static const String isLoggedIn = "isLoggedIn";
  static const String isLoggedInAsDoctor = "isLoggedInAsDoctor";
  static const String profileImage = "profile_image";
  static const String name = "name";
  static const String phone = "phone";
  static const String email = "email";
  static const String password = "password";

  /// for video call
  static const String callReceiverName = "receiver_name";
  static const String callReceiverImage = "receiver_image";
  static const String callerImage = "cb_image";
}


