import 'package:videocalling/common/utils/app_imports.dart';

class DoctorChatListController extends GetxController {
  var ds;
  RxString myUid = "".obs;

  RxList<ChatListDetails> chatListDetails = <ChatListDetails>[].obs;
  List<ChatListDetails> chatListDetailsPA = [];

  getChatListData() {
    if (myUid.value.isEmpty) return;
    ds = FirebaseDatabase.instance.ref(myUid.value).onValue.listen((event) {
      chatListDetailsPA.clear();

      final dynamic snapshotValue = event.snapshot.value;
      if (snapshotValue != null && snapshotValue['chatlist'] != null) {
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
                time: DateTime.parse(values['time'].toString()).toString(),
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
    if (type == 1) {
      return Row(
        children: [
          Icon(Icons.photo, size: 15, color: AppColors.themeColor3),
          SizedBox(width: 5),
          Text(
            'photo_str'.tr,
            style: TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (type == 2) {
      return Row(
        children: [
          Icon(Icons.videocam, size: 15, color: AppColors.themeColor3),
          SizedBox(width: 5),
          Text(
            'video_str'.tr,
            style: TextStyle(fontSize: 13),
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    myUid.value =
        StorageService.readData(key: LocalStorageKeys.userIdWithAscii) ?? "";
    if (myUid.value.isNotEmpty) {
      getChatListData();
    }
  }
}
