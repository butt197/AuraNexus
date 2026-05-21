import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

customDialog({
  required String s1,
  required String s2,
  TextStyle? s1style,
  TextStyle? s2style,
  TextStyle? s3style,
  VoidCallback? onPressed,
  bool dismiss = true,
}) {
  Get.dialog(AlertDialog(
    title: Text(
      s1,
      style: s1style ?? const TextStyle(fontFamily: AppFontStyleTextStrings.black),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s2,
          maxLines: 3,
          style: s2style ??
              const TextStyle(
                fontFamily: AppFontStyleTextStrings.regular,
                fontSize: 14,
              ),
        )
      ],
    ),
    actions: [
      TextButton(
        onPressed: onPressed ??
            () {
              Get.back();
            },
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(Get.context!).primaryColor,
        ),
        child: Text(
          'ok_btn'.tr,
          style: s3style ??
              const TextStyle(
                fontFamily: AppFontStyleTextStrings.medium,
                color: AppColors.BLACK,
              ),
        ),
      ),
    ],
  ),barrierDismissible: dismiss);
}

customDialog1({
  required String s1,
  required String s2,
  TextStyle? s1style,
  TextStyle? s2style,
}) {
  Get.dialog(AlertDialog(
    title: Text(
      s1,
      style: s1style ??
          const TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
    ),
    content: Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              s2,
              style: s2style ??
                  const TextStyle(
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 12,
                  ),
            ),
          )
        ],
      ),
    ),
  ));
}

customDialog2({
  required String s1,
  required String s2,
  TextStyle? s1style,
  TextStyle? s2style,
  TextStyle? s3style,
  required VoidCallback onPressedYes,
  required VoidCallback onPressedNo,
}) {
  Get.dialog(AlertDialog(
    title: Text(
      s1,
      style: s1style ?? const TextStyle(fontFamily: AppFontStyleTextStrings.black),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s2,
          maxLines: 3,
          style: s2style ??
              const TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
        )
      ],
    ),
    actions: [
      TextButton(
        onPressed: onPressedYes,
        child: Text('yes_btn'.tr),
      ),
      TextButton(
        onPressed: onPressedNo,
        child: Text('no_btn'.tr),
      ),
    ],
  ));
}

logoutDialog(
    {required String s1, required String s2, required VoidCallback onPressed}) {
  Get.dialog(AlertDialog(
    title: Text(
      s1,
      style: const TextStyle(fontFamily: AppFontStyleTextStrings.black),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s2,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        )
      ],
    ),
    actions: [
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(Get.context!).hintColor,
        ),
        child: AppTextWidgets.mediumTextWithColor(
          text: 'yes_btn'.tr,
          color: AppColors.BLACK,
        ),
      ),
    ],
  ));
}

errorDialog({required String message}) {
  Get.dialog(AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Icon(
          Icons.error,
          size: 80,
          color: AppColors.RED,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          message.toString(),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ),
  ));
}

callOptionDialog({required int callId}) {
  Get.dialog(AlertDialog(
    title: Text('call_dialog_title'.tr),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: Get.width / 4,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                    CallManager.instance.startNewCall(
                        Get.context!, CallType.AUDIO_CALL, {callId});
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
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
                          height: 50,
                          width: Get.width / 4,
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.call,
                          color: AppColors.WHITE,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                width: Get.width / 4,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                    CallManager.instance.startNewCall(
                        Get.context!, CallType.VIDEO_CALL, {callId});
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
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
                          width: Get.width / 4,
                          height: 50,
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.video_call,
                          color: AppColors.WHITE,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  ));
}

uploadMediaOptionDialog({
  required VoidCallback onTap,
  required VoidCallback onTap1,
}) {
  Get.dialog(AlertDialog(
    title: Text('media_upload_title'.tr),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: Get.width / 4,
                child: InkWell(
                  onTap: onTap,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
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
                            height: 50,
                            width: Get.width / 4),
                      ),
                      const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.WHITE,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                width: Get.width / 4,
                child: InkWell(
                  onTap: onTap1,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
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
                          width: Get.width / 4,
                          height: 50,
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.file_present,
                          color: AppColors.WHITE,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  ));
}

unSendMessageDialog({
  required VoidCallback onTap,
}) {
  Get.dialog(
    barrierColor: AppColors.chatUnSendBarrierColor,
    AlertDialog(
      backgroundColor: AppColors.WHITE,
      elevation: 0,
      title: Text(
        'remove_msg_title'.tr,
        style: const TextStyle(
          fontFamily: AppFontStyleTextStrings.regular,
          color: AppColors.BLACK,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'remove_msg_subtitle'.tr,
            style: TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 13,
              color: AppColors.RED800,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.grey.withOpacity(0.3),
                    ),
                    child: Center(
                      child: AppTextWidgets.blackText(
                        text: 'cancel'.tr,
                        color: AppColors.BLACK,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.grey,
                    ),
                    child: Center(
                      child: AppTextWidgets.blackText(
                        text: 'remove'.tr,
                        color: AppColors.WHITE,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


