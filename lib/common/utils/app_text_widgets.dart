import 'package:videocalling/common/utils/app_imports.dart';

class AppTextWidgets {
  static Widget boldTextNormal({
    required String text,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.bold,
        fontSize: size,
      ),
    );
  }

  static Widget boldTextWithColor({
    required String text,
    required Color color,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.bold,
        color: color,
        fontSize: size,
      ),
    );
  }

  static Widget regularText({
    required String text,
    required Color color,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.regular,
        color: color,
        fontSize: size,
      ),
    );
  }

  static Widget regularTextWithColor({
    required String text,
    required Color color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.regular,
        color: color,
      ),
    );
  }

  static Widget regularTextWithSize({
    required String text,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.regular,
        fontSize: size,
      ),
    );
  }

  static Widget mediumText({
    required String text,
    required Color color,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        color: color,
        fontSize: size,
      ),
    );
  }

  static Widget mediumTextWithColor({
    required String text,
    required Color color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        color: color,
      ),
    );
  }

  static Widget mediumTextWithSize({
    required String text,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        fontSize: size,
      ),
    );
  }

  static Widget semiBoldText({
    required String text,
    required Color color,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.semiBold,
        color: color,
        fontSize: size,
      ),
    );
  }

  static Widget semiBoldTextWithSize({
    required String text,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.semiBold,
        fontSize: size,
      ),
    );
  }

  static Widget semiBoldTextWithColor({
    required String text,
    required Color color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.semiBold,
        color: color,
      ),
    );
  }

  static Widget blackText({
    required String text,
    required Color color,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.black,
        color: color,
        fontSize: size,
      ),
    );
  }

  static Widget blackTextWithSize({
    required String text,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.black,
        fontSize: size,
      ),
    );
  }

  static Widget blackTextWithColor({
    required String text,
    required Color color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFontStyleTextStrings.black,
        color: color,
      ),
    );
  }
}

class AppFontStyleTextStrings {
  /// bold and w700
  static const String bold = "Bold";

  /// w900
  static const String black = "Black";

  /// w500
  static const String medium = "Medium";

  /// w600
  static const String semiBold = "SemiBold";

  /// w400 and normal
  static const String regular = "Regular";

  /// w300
  static const String light = "Light";
}


