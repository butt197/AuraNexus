class ChatListDetails {
  String message;
  String time;
  int type;
  String channelId;
  int messageCount;
  String userUid;

  ChatListDetails(
      {required this.message,
        required this.time,
        required this.type,
        required this.channelId,
        required this.messageCount,
        required this.userUid});
}

