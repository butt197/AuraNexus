import 'package:videocalling/common/utils/app_imports.dart';

class MyApp extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAppController());
    return GetMaterialApp(
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
      translations: Words(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        timePickerTheme: TimePickerThemeData(
          dayPeriodTextColor: AppColors.themeColor1,
          helpTextStyle: const TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        hintColor: AppColors.themeColor1,
        primaryColor: AppColors.themeColor2,
        scaffoldBackgroundColor: AppColors.WHITE,
        primaryColorDark: AppColors.themeColor3,
        primaryColorLight: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: AppFontStyleTextStrings.regular),
          displayMedium: TextStyle(fontFamily: AppFontStyleTextStrings.regular),
          displaySmall: TextStyle(fontFamily: AppFontStyleTextStrings.regular),
          headlineMedium: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headlineSmall: TextStyle(fontFamily: AppFontStyleTextStrings.regular),
          titleLarge: TextStyle(fontFamily: AppFontStyleTextStrings.medium),
          titleMedium: TextStyle(fontFamily: AppFontStyleTextStrings.regular),
          titleSmall: TextStyle(fontFamily: AppFontStyleTextStrings.medium),
          bodySmall: TextStyle(
            fontSize: 10,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          bodyLarge: TextStyle(
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.light,
          ),
          labelLarge: TextStyle(fontFamily: AppFontStyleTextStrings.medium),
        ),
      ),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', ''),
      //   Locale('he', ''),
      //   Locale('ar', ''),
      //   Locale.fromSubtags(languageCode: 'zh'),
      // ],
    );
  }
}
