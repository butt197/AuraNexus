import 'package:videocalling/common/utils/app_imports.dart';

class PatientChatListController extends GetxController {
  var ds;
  RxString myUid = "".obs;

  RxList<ChatListDetails> chatListDetails = <ChatListDetails>[].obs;
  List<ChatListDetails> chatListDetailsPA = [];

  getChatListData() {
    ds = FirebaseDatabase.instance.ref().child(myUid.value).onValue.listen((
      event,
    ) {
      chatListDetailsPA.clear();
      final snapshotValue = event.snapshot.value as Map;

      if (snapshotValue['chatlist'] != null) {
        final Map<dynamic, dynamic> chatListMap = Map<dynamic, dynamic>.from(
          snapshotValue['chatlist'],
        );

        chatListMap.forEach((key, values) {
          if (values['last_msg'] != null) {
            chatListDetailsPA.add(
              ChatListDetails(
                channelId: values['channelId'],
                message: values['last_msg'],
                messageCount: values['messageCount'],
                time:
                    values['time']?.toString() ??
                    DateTime.now().toIso8601String(),
                type: int.parse(values['type'].toString()),
                userUid: key,
              ),
            );
          }
        });
      }

      if (chatListDetailsPA.length > 1) {
        chatListDetailsPA.sort((a, b) => b.time.compareTo(a.time));
      }
      chatListDetails.clear();
      chatListDetails.addAll(chatListDetailsPA);
      st.value = true;
    });
  }

  RxBool st = false.obs;
  RxBool loginCheckUser = false.obs;

  String messageTiming(DateTime dateTime) {
    if (DateTime.now().difference(dateTime).inDays == 0) {
      return "${dateTime.toLocal().hour.toString().padLeft(2, "0")} : ${dateTime.toLocal().minute.toString().padLeft(2, "0")}";
    } else if (DateTime.now().difference(dateTime).inDays == 1) {
      return 'chat_time_yesterday'.tr;
    } else {
      return 'chat_time_day_ago'.trParams({
        'day': DateTime.now().difference(dateTime).inDays.toString(),
      });
    }
  }

  typeToWidget(int type, String msg, int count) {
    final cleanMsg = msg.trim().toLowerCase();

    bool isImage =
        cleanMsg.endsWith('.jpg') ||
        cleanMsg.endsWith('.jpeg') ||
        cleanMsg.endsWith('.png') ||
        cleanMsg.endsWith('.webp') ||
        cleanMsg.endsWith('.gif');

    bool isVideo =
        cleanMsg.endsWith('.mp4') ||
        cleanMsg.endsWith('.mov') ||
        cleanMsg.endsWith('.avi') ||
        cleanMsg.endsWith('.mkv') ||
        cleanMsg.endsWith('.webm');

    bool isPdf = cleanMsg.endsWith('.pdf');

    bool isFile = type == 2 && !isImage && !isVideo;

    if (type == 1 || isImage) {
      return Row(
        children: [
          Icon(Icons.photo, size: 15, color: AppColors.themeColor3),
          const SizedBox(width: 5),
          Text(
            'photo_str'.tr,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (isVideo) {
      return Row(
        children: [
          Icon(Icons.videocam, size: 15, color: AppColors.themeColor3),
          const SizedBox(width: 5),
          Text(
            'video_str'.tr,
            style: const TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (isPdf) {
      return Row(
        children: [
          Icon(Icons.picture_as_pdf, size: 15, color: AppColors.themeColor3),
          const SizedBox(width: 5),
          Text(
            'PDF file',
            style: const TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (isFile) {
      return Row(
        children: [
          Icon(Icons.insert_drive_file, size: 15, color: AppColors.themeColor3),
          const SizedBox(width: 5),
          Text(
            'File',
            style: const TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      return Text(
        msg,
        style: TextStyle(
          fontFamily: count > 0
              ? AppFontStyleTextStrings.bold
              : AppFontStyleTextStrings.regular,
          color: count > 0 ? AppColors.GREEN : AppColors.greyShade6,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  DateTime safeParseChatTime(String rawTime) {
    try {
      String value = rawTime.trim();

      if (value.endsWith('ZZ')) {
        value = value.substring(0, value.length - 1);
      }

      return DateTime.tryParse(value)?.toLocal() ?? DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    myUid.value =
        StorageService.readData(key: LocalStorageKeys.userIdWithAscii) ?? "";
    loginCheckUser.value =
        StorageService.readData(key: LocalStorageKeys.isLoggedIn) ?? false;
    if (myUid.value.isNotEmpty) {
      getChatListData();
    }
  }
}
