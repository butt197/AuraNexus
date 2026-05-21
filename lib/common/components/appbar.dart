import 'package:videocalling/common/utils/app_imports.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  VoidCallback? onPressed;
  bool? isBackArrow;
  TextStyle? textStyle;

  CustomAppBar(
      {super.key, required this.title, this.isBackArrow, this.onPressed, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.color1,
                AppColors.color2,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          height: 60 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 60,
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              (isBackArrow ?? false)
                  ? InkWell(
                      onTap: onPressed,
                      child: Image.asset(
                        AppImages.backIcon,
                        height: 25,
                        width: 22,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: (isBackArrow ?? false) ? 10 : 0,
              ),
              Text(
                title,
                style: textStyle ??
                    const TextStyle(
                      color: AppColors.WHITE,
                      fontSize: 22,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSearchScreenAppBar extends StatelessWidget {
  String title;
  String title1;
  TextEditingController textController;
  Animation<Color> valueColor;
  Function(String) onSubmitted;
  VoidCallback onPressed;
  VoidCallback? onPressed1;
  bool? isBackArrow;

  CustomSearchScreenAppBar({super.key, 
    required this.title,
    required this.title1,
    required this.textController,
    required this.valueColor,
    required this.onSubmitted,
    required this.onPressed,
    this.isBackArrow,
    this.onPressed1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.color1,
                AppColors.color2,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          height: 125 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    (isBackArrow ?? false)
                        ? InkWell(
                            onTap: onPressed1,
                            child: Image.asset(
                              AppImages.backIcon,
                              height: 25,
                              width: 22,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      width: (isBackArrow ?? false) ? 10 : 0,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppFontStyleTextStrings.regular,
                        color: AppColors.WHITE,
                      ),
                    ),
                    AppTextWidgets.mediumText(
                      text: title1,
                      color: AppColors.WHITE,
                      size: 25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.WHITE,
                        ),
                        child: TextField(
                          controller: textController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'search_doctor_name'.tr,
                              hintStyle: TextStyle(
                                fontFamily: AppFontStyleTextStrings.regular,
                                color: AppColors.LIGHT_GREY_TEXT,
                                fontSize: 13,
                              ),
                              suffixIcon: Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      valueColor: valueColor,
                                    ),
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onSubmitted: onSubmitted,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: onPressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Image.asset(
                            AppImages.searchIcon,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomHomeScreenAppBar extends StatelessWidget {
  String title;
  String title1;
  TextEditingController textController;
  Animation<Color> valueColor;
  Function(String) onSubmitted;
  Function(String) onChanged;
  VoidCallback onPressed;

  CustomHomeScreenAppBar({super.key, 
    required this.title,
    required this.title1,
    required this.textController,
    required this.valueColor,
    required this.onSubmitted,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.color1,
                AppColors.color2,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          height: 125 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.WHITE,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                    AppTextWidgets.mediumText(
                      text: title1,
                      color: AppColors.WHITE,
                      size: 25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.WHITE,
                        ),
                        child: TextField(
                          controller: textController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'search_doctor_name'.tr,
                              hintStyle: TextStyle(
                                color: AppColors.LIGHT_GREY_TEXT,
                                fontSize: 13,
                                fontFamily: AppFontStyleTextStrings.regular,
                              ),
                              suffixIcon: Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      valueColor: valueColor,
                                    ),
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.WHITE),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          onSubmitted: onSubmitted,
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: onPressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Image.asset(
                            AppImages.searchIcon,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}


