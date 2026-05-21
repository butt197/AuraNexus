import 'dart:developer' as dev;
import 'package:videocalling/common/utils/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' hide Category;
import 'package:file_picker/file_picker.dart';
import 'package:characters/characters.dart';

class ChatController extends GetxController {
  String userName = Get.arguments['userName'];
  String uid = Get.arguments['uid'];
  bool isUser = Get.arguments['isUser'];

  ScrollController lvScrollCtrl = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  RxString myUid = "".obs;
  RxString senderName = "".obs;
  RxBool isKeyboard = false.obs;
  RxBool isEmojiKeyboard = false.obs;
  RxBool isSeenStatusExist = false.obs;
  RxInt messageCount = 0.obs;
  RxBool isFirstMessage = false.obs;
  RxString channelId = "".obs;
  RxBool showButton = false.obs;
  RxString globalMessage = "".obs;
  RxBool showDate = false.obs;
  RxInt perPage = 20.obs;
  RxInt requestStatus = 0.obs;
  RxString message = "".obs;
  RxBool isLoading = false.obs;
  RxBool showLoadingIndicator = false.obs;
  RxString lastMessageUid = "".obs;

  TextField? textField;
  RxBool isFileUploading = false.obs;
  RxDouble uploadingProgress = 0.0.obs;

  Uint8List? image;
  final Map<String, dynamic> _tasks = {};

  Uint8List? fileThumbnail;
  List<String> monthsList = [
    'month_full_1'.tr,
    'month_full_2'.tr,
    'month_full_3'.tr,
    'month_full_4'.tr,
    'month_full_5'.tr,
    'month_full_6'.tr,
    'month_full_7'.tr,
    'month_full_8'.tr,
    'month_full_9'.tr,
    'month_full_10'.tr,
    'month_full_11'.tr,
    'month_full_12'.tr,
  ];

  Map<String, StreamSubscription> _progressSubscription = {};
  Map<String, StreamSubscription> _resultSubscription = {};

  List<String> tokensList = [];
  DatabaseReference? seenRef;
  var seenRefListner;
  var checkSeenRefListner;
  late StreamSubscription<bool> keyboardSubscription;
  late FocusNode myFocusNode;
  File? _image;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((
      bool isKeybord,
    ) {
      this.isKeyboard.value = isKeybord;

      if (isKeybord && isEmojiKeyboard.value) {
        isEmojiKeyboard.value = false;
      }
    });

    myFocusNode = FocusNode();

    myUid.value =
        StorageService.readData(key: LocalStorageKeys.userIdWithAscii) ?? "";
    senderName.value =
        StorageService.readData(key: LocalStorageKeys.name) ?? "";

    loadUserProfile();
    getMyUid();
    checkSeenStatus();
    markAsSeen();
    lvScrollCtrl.addListener(() {
      if (lvScrollCtrl.position.maxScrollExtent ==
          lvScrollCtrl.position.pixels) {
        showLoadingIndicator.value = true;
        perPage.value += 20;
      }
    });

    SharedPreferences.getInstance().then((value) {
      value.remove("payload");
      value.commit();
    });
  }

  Future<void> getImage({ImageSource source = ImageSource.camera}) async {
    try {
      final XFile? pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      final file = File(pickedImage.path);
      await uploadFileToServer(file, isImage: true);
    } catch (e) {
      isFileUploading.value = false;
      uploadingProgress.value = 0.0;
      customDialog(
        s1: 'error'.tr,
        s2: e.toString(),
        onPressed: () => Get.back(),
      );
    }
  }

  Future<void> pickCameraImage() async {
    await getImage(source: ImageSource.camera);
  }

  loadUserProfile() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref(uid)
        .child("TokenList");
    starCountRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        Map<dynamic, dynamic>.from(data as Map).forEach((key, values) {
          tokensList.add(data[key]);
        });
      }
    });

    DatabaseReference starCountRef2 = FirebaseDatabase.instance
        .ref(myUid.value)
        .child("chatlist")
        .child(uid);

    starCountRef2.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final snapshot = event.snapshot.value as Map;
        if (snapshot['status'] == 0) {
          requestStatus.value = 2;
        } else {
          requestStatus.value = snapshot['status'] ?? 1;
        }
        update();
      } else {
        requestStatus.value = 1;
        update();
      }
    });
  }

  uploadDataWithBackgroundService(String taskId, result) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat");

    await collectionReference.doc(taskId.toString()).update({
      "msg": jsonDecode(result.response)['data'],
      "time": DateTime.now().toString(),
      "uid": myUid.value,
      "type": jsonDecode(result.response)['data'].toString().contains(".jpg")
          ? 1
          : 2,
    });

    if (isFirstMessage.value) {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.set({
        "time": DateTime.now().toString(),
        "last_msg": jsonDecode(result.response)['data'],
        "type": jsonDecode(result.response)['data'].toString().contains(".jpg")
            ? 1
            : 2,
        "messageCount": 0,
        "status": 1,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      await dbRef2.once().then((DatabaseEvent event) {
        final snapshot = event.snapshot.value as Map;

        dbRef2.set({
          "time": DateTime.now().toString(),
          "last_msg": jsonDecode(result.response)['data'],
          "type":
              jsonDecode(result.response)['data'].toString().contains(".jpg")
              ? 1
              : 2,
          "messageCount": event.snapshot.value == null
              ? 1
              : snapshot['messageCount'] + 1,
          "status": 0,
          "channelId": channelId.value,
        });
      });
      isFirstMessage.value = false;
    } else {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);
      await dbRef.update({
        "time": DateTime.now().toString(),
        "last_msg": jsonDecode(result.response)['data'],
        "type": jsonDecode(result.response)['data'].toString().contains(".jpg")
            ? 1
            : 2,
        "messageCount": 0,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      await dbRef2.once().then((DatabaseEvent event) {
        final snapshot = event.snapshot.value as Map;

        dbRef2.update({
          "time": DateTime.now().toString(),
          "last_msg": jsonDecode(result.response)['data'],
          "type":
              jsonDecode(result.response)['data'].toString().contains(".jpg")
              ? 1
              : 2,
          "messageCount": snapshot.isEmpty ? 1 : snapshot['messageCount'] + 1,
          "channelId": channelId.value,
        });
      });
    }

    for (int i = 0; i < tokensList.length; i++) {
      sendNotification(senderName.value, "Shared a file", tokensList[i]);
    }

    _progressSubscription['$taskId']?.cancel();
    _resultSubscription['$taskId']?.cancel();
  }

  getMyUid() async {
    if (uid.compareTo(myUid.value) < 0) {
      channelId.value = (uid + myUid.value);
    } else {
      channelId.value = myUid.value + uid;
    }
  }

  Timer markTypingAsZerotimer = Timer(const Duration(seconds: 1), () {});

  void markAsTyping() {
    DatabaseReference db = FirebaseDatabase.instance.ref();
    db.child(uid).child("chatlist").child(myUid.value).update({
      "typingTime": 1,
    });

    db
        .child(uid)
        .child("chatlist")
        .child(myUid.value)
        .child("typingTime")
        .onValue
        .listen((event) {
          markTypingAsZerotimer.cancel();
          if (event.snapshot.value == 1) {
            markTypingAsZerotimer = Timer(const Duration(seconds: 1), () {
              db.child(uid).child("chatlist").child(myUid.value).update({
                "typingTime": 0,
              });
            });
          }
        });
  }

  Future<bool> onBackPress() {
    if (isEmojiKeyboard.value) {
      isEmojiKeyboard.value = false;
    } else {
      Get.back();
    }
    return Future.value(false);
  }

  void toggleEmojiKeyboard() async {
    if (isEmojiKeyboard.value) {
      isEmojiKeyboard.value = false;
      await Future.delayed(const Duration(milliseconds: 80));
      myFocusNode.requestFocus();
    } else {
      myFocusNode.unfocus();
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 120));
      isEmojiKeyboard.value = true;
    }
  }

  void onEmojiSelected(Category? category, Emoji emoji) {
    final text = textEditingController.text;
    final selection = textEditingController.selection;

    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;

    final newText = text.replaceRange(start, end, emoji.emoji);

    textEditingController.text = newText;
    textEditingController.selection = TextSelection.collapsed(
      offset: start + emoji.emoji.length,
    );

    message.value = newText;
    showButton.value = newText.trim().isNotEmpty;
    markAsTyping();
  }

  void onEmojiBackspacePressed() {
    final text = textEditingController.text;
    final selection = textEditingController.selection;

    if (text.isEmpty) return;

    final cursorPosition = selection.start < 0 ? text.length : selection.start;
    if (cursorPosition <= 0) return;

    final beforeCursor = text.substring(0, cursorPosition);
    final afterCursor = text.substring(cursorPosition);

    final chars = beforeCursor.characters;
    if (chars.isEmpty) return;

    final newBeforeCursor = chars.skipLast(1).toString();
    final newText = newBeforeCursor + afterCursor;

    textEditingController.text = newText;
    textEditingController.selection = TextSelection.collapsed(
      offset: newBeforeCursor.length,
    );

    message.value = newText;
    showButton.value = newText.trim().isNotEmpty;
  }

  void sendMessage(int type) async {
    Get.focusScope?.unfocus();
    String msg = message.value;
    message.value = "";
    showButton.value = false;
    isSeenStatusExist.value = false;

    textEditingController = TextEditingController(text: "");
    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat")
        .add({
          "msg": msg,
          "time": DateTime.now().toString(),
          "uid": myUid.value,
          "type": type,
        });

    if (isFirstMessage.value) {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.set({
        "time": DateTime.now().toString(),
        "last_msg": msg,
        "type": type,
        "messageCount": 0,
        "status": 1,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      await dbRef2.once().then((value) {
        final snapshot = value.snapshot.value as Map;
        dbRef2.set({
          "time": DateTime.now().toString(),
          "last_msg": msg,
          "type": type,
          "messageCount": snapshot.isEmpty
              ? 1
              : snapshot['messageCount'] == null
              ? 1
              : snapshot['messageCount'] + 1,
          "status": 0,
          "channelId": channelId.value,
        });
      });
      isFirstMessage.value = false;
    } else {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.update({
        "time": DateTime.now().toString(),
        "last_msg": msg,
        "type": type,
        "messageCount": 0,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      await dbRef2.once().then((data) {
        final call = data.snapshot.value as Map;

        dbRef2.update({
          "time": DateTime.now().toString(),
          "last_msg": msg,
          "type": type,
          "messageCount": call.isEmpty
              ? 1
              : call['messageCount'] == null
              ? 1
              : call['messageCount'] + 1,
          "channelId": channelId.value,
        });
      });
    }

    if (messageCount.value >= 0) {
      globalMessage.value = globalMessage.value.isEmpty
          ? msg
          : globalMessage.value + "`" + msg;
    }

    for (int i = 0; i < tokensList.length; i++) {
      sendNotification(senderName.value, msg, tokensList[i]);
    }
  }

  void sendTask(int type, String taskId) async {
    String msg = message.value;

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat");
    await collectionReference.doc(taskId).set({
      "msg": msg,
      "time": DateTime.now().toString(),
      "uid": myUid.value,
      "type": type,
    });
  }

  Future<void> deleteTask(String docId) async {
    if (docId.trim().isEmpty || channelId.value.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat")
        .doc(docId)
        .delete();
  }

  void updateTaskToFile(int type, String taskId) async {
    String msg = message.value;
    message.value = "";
    showButton.value = false;
    isSeenStatusExist.value = false;

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat");
    await collectionReference.doc(taskId).set({
      "msg": msg,
      "time": DateTime.now().toString(),
      "uid": myUid.value,
      "type": type,
    });

    if (isFirstMessage.value) {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.set({
        "time": DateTime.now().toString(),
        "last_msg": msg,
        "type": type,
        "messageCount": 0,
        "status": 1,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      dbRef2.onValue.listen((DatabaseEvent event) {
        final snapshot = event.snapshot.value as Map;

        dbRef2.set({
          "time": DateTime.now().toString(),
          "last_msg": msg,
          "type": type,
          "messageCount": snapshot.isEmpty ? 1 : snapshot['messageCount'] + 1,
          "status": 0,
          "channelId": channelId.value,
        });
      });
      isFirstMessage.value = false;
    } else {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.update({
        "time": DateTime.now().toString(),
        "last_msg": msg,
        "type": type,
        "messageCount": 0,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      dbRef2.onValue.listen((DatabaseEvent event) {
        final snapshot = event.snapshot.value as Map;

        dbRef2.update({
          "time": DateTime.now().toString(),
          "last_msg": msg,
          "type": type,
          "messageCount": snapshot.isEmpty ? 1 : snapshot['messageCount'] + 1,
          "channelId": channelId.value,
        });
      });
    }

    for (int i = 0; i < tokensList.length; i++) {
      sendNotification(senderName.value, msg, tokensList[i]);
    }
  }

  void markAsSeen() async {
    String x = "${uid}";
    seenRef = FirebaseDatabase.instance
        .ref(myUid.value)
        .child('chatlist')
        .child(x);
    seenRefListner = seenRef!.onValue.listen((event) {
      seenRef!.update({"messageCount": 0});
    });
  }

  checkSeenStatus() async {
    checkSeenRefListner = FirebaseDatabase.instance
        .ref(uid)
        .child('chatlist')
        .child(myUid.value)
        .child("messageCount")
        .onValue
        .listen((event) {
          if (event.snapshot.value != null) {
            final snapshot = event.snapshot.value as int;
            if (event.snapshot.value == 0) {
              messageCount.value = snapshot;
              isSeenStatusExist.value = true;
              globalMessage.value = "";
            } else {
              messageCount.value = snapshot;
              isSeenStatusExist.value = false;
            }
          } else {
            isSeenStatusExist.value = false;
          }
        });
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      final path = result.files.single.path;
      if (path == null || path.isEmpty) {
        customDialog(
          s1: 'error'.tr,
          s2: 'Unable to read selected file path.',
          onPressed: () => Get.back(),
        );
        return;
      }

      final file = File(path);
      await uploadFileToServer(file, isImage: false);
    } catch (e) {
      isFileUploading.value = false;
      uploadingProgress.value = 0.0;
      customDialog(
        s1: 'error'.tr,
        s2: e.toString(),
        onPressed: () => Get.back(),
      );
    }
  }

  Future<void> uploadFileToServer(File file, {required bool isImage}) async {
    final String tempTaskId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      isFileUploading.value = true;
      uploadingProgress.value = 0.0;

      await FirebaseFirestore.instance
          .collection("Chats")
          .doc(channelId.value)
          .collection("All Chat")
          .doc(tempTaskId)
          .set({
            'uid': myUid.value,
            'msg': '',
            'type': 'task',
            'time': DateTime.now().toUtc().toIso8601String(),
            'isRead': false,
            'senderName': senderName.value,
            'progress': 0,
          });

      final uri = Uri.parse("${Apis.ServerAddress}/api/mediaupload");

      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: Apis.timeOut),
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("CHAT_UPLOAD_STATUS :: ${response.statusCode}");
      debugPrint("CHAT_UPLOAD_BODY :: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
          'Upload failed: ${response.statusCode} ${response.body}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded['status'].toString() != '1') {
        throw Exception(decoded['msg']?.toString() ?? 'Media upload failed.');
      }

      final String uploadedFile = decoded['data']?.toString() ?? '';

      if (uploadedFile.trim().isEmpty) {
        throw Exception(
          'Upload completed but server did not return file name.',
        );
      }

      await updateUploadedFileMessage(
        taskId: tempTaskId,
        uploadedFile: uploadedFile,
        mediaType: getMediaTypeFromFile(uploadedFile, fallbackImage: isImage),
      );

      uploadingProgress.value = 1.0;
    } catch (e) {
      try {
        await deleteTask(tempTaskId);
      } catch (_) {}

      customDialog(
        s1: 'error'.tr,
        s2: e.toString(),
        onPressed: () => Get.back(),
      );
    } finally {
      isFileUploading.value = false;
      uploadingProgress.value = 0.0;
    }
  }

  Future<void> updateUploadedFileMessage({
    required String taskId,
    required String uploadedFile,
    required int mediaType,
  }) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Chats")
        .doc(channelId.value)
        .collection("All Chat");

    await collectionReference.doc(taskId).set({
      "msg": uploadedFile,
      "time": DateTime.now().toString(),
      "uid": myUid.value,
      "type": mediaType,
    });

    if (isFirstMessage.value) {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.set({
        "time": DateTime.now().toString(),
        "last_msg": uploadedFile,
        "type": mediaType,
        "messageCount": 0,
        "status": 1,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      final event = await dbRef2.once();
      final snapshot = event.snapshot.value;

      int count = 1;
      if (snapshot is Map && snapshot['messageCount'] != null) {
        count = int.tryParse(snapshot['messageCount'].toString()) ?? 0;
        count++;
      }

      await dbRef2.set({
        "time": DateTime.now().toString(),
        "last_msg": uploadedFile,
        "type": mediaType,
        "messageCount": count,
        "status": 0,
        "channelId": channelId.value,
      });

      isFirstMessage.value = false;
    } else {
      DatabaseReference dbRef = FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid);

      await dbRef.update({
        "time": DateTime.now().toString(),
        "last_msg": uploadedFile,
        "type": mediaType,
        "messageCount": 0,
        "channelId": channelId.value,
      });

      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value);

      final event = await dbRef2.once();
      final snapshot = event.snapshot.value;

      int count = 1;
      if (snapshot is Map && snapshot['messageCount'] != null) {
        count = int.tryParse(snapshot['messageCount'].toString()) ?? 0;
        count++;
      }

      await dbRef2.update({
        "time": DateTime.now().toString(),
        "last_msg": uploadedFile,
        "type": mediaType,
        "messageCount": count,
        "channelId": channelId.value,
      });
    }

    for (int i = 0; i < tokensList.length; i++) {
      sendNotification(senderName.value, "Shared a file", tokensList[i]);
    }
  }

  String buildChatMediaUrl(String? value) {
    if (value == null) return '';

    final clean = value.trim();

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }

    return Apis.chatMediaPath + clean;
  }

  String getFileExtension(String? value) {
    if (value == null || value.trim().isEmpty) return '';

    final clean = value.trim().split('?').first;
    if (!clean.contains('.')) return '';

    return clean.split('.').last.toLowerCase();
  }

  bool isImageFile(String? value) {
    final ext = getFileExtension(value);
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  bool isVideoFile(String? value) {
    final ext = getFileExtension(value);
    return ['mp4', 'mov', 'mkv', 'webm'].contains(ext);
  }

  bool isDocumentFile(String? value) {
    final ext = getFileExtension(value);
    return ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'].contains(ext);
  }

  int getMediaTypeFromFile(String fileName, {required bool fallbackImage}) {
    if (isImageFile(fileName)) return 1;
    if (isVideoFile(fileName)) return 2;
    if (isDocumentFile(fileName)) return 4;

    return fallbackImage ? 1 : 4;
  }

  Widget typeToWidget({String? message, dynamic type, String? uid}) {
    final int normalizedType = int.tryParse(type.toString()) ?? -1;
    final String normalizedMessage = (message ?? '').trim();

    if (type.toString() == 'task' || normalizedType == 3) {
      return uid == myUid.value
          ? InkWell(
              onLongPress: () {},
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.WHITE),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AppTextWidgets.regularTextWithColor(
                        text: 'uploading_file'.tr,
                        color: AppColors.WHITE,
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.upload_rounded, color: AppColors.WHITE),
                    ),
                  ],
                ),
              ),
            )
          : AppTextWidgets.regularTextWithSize(
              text: 'uploading_file1'.tr,
              size: 10,
            );
    }

    if (normalizedType == 1 || normalizedType == 2 || normalizedType == 4) {
      final String mediaUrl = buildChatMediaUrl(normalizedMessage);
      final String ext = getFileExtension(normalizedMessage);

      if (mediaUrl.isEmpty) {
        return const Icon(Icons.broken_image);
      }

      if (isVideoFile(normalizedMessage)) {
        return InkWell(
          onTap: () async {
            await Get.toNamed(
              Routes.videoPlayerScreen,
              arguments: {'type': 2, 'url': mediaUrl},
            );
            Get.delete<MyVideoPlayerController>();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MyVideoThumbNail(url: mediaUrl),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.BLACK.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.play_arrow, color: AppColors.WHITE),
              ),
            ],
          ),
        );
      }

      if (isDocumentFile(normalizedMessage)) {
        return InkWell(
          onTap: () async {
            final Uri uri = Uri.parse(mediaUrl);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              customDialog(s1: 'error'.tr, s2: 'Unable to open file.');
            }
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: uid == myUid.value
                  ? AppColors.WHITE.withOpacity(0.15)
                  : AppColors.greyShade3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ext == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
                  color: uid == myUid.value ? AppColors.WHITE : AppColors.BLACK,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    normalizedMessage.split('/').last,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: uid == myUid.value
                          ? AppColors.WHITE
                          : AppColors.BLACK,
                      fontFamily: AppFontStyleTextStrings.regular,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return InkWell(
        onTap: () async {
          await Get.toNamed(
            Routes.photoViewerScreen,
            arguments: {
              'url': mediaUrl,
              'id': '0',
              'isDeleteShown': false,
              'reportName': userName,
            },
          );
          Get.delete<MyPhotoViewerController>();
        },
        child: Hero(
          tag: mediaUrl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: mediaUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return const SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorWidget: (context, url, error) {
                debugPrint('CHAT_IMAGE_LOAD_ERROR :: $url :: $error');
                return Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  color: AppColors.greyShade3,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () async {
        if (GetUtils.isURL(normalizedMessage)) {
          final Uri uri = Uri.parse(normalizedMessage);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          normalizedMessage,
          style: TextStyle(
            fontSize: GetUtils.isURL(normalizedMessage) ? 18 : 15,
            color: uid == myUid.value ? AppColors.WHITE : AppColors.BLACK,
            fontFamily: GetUtils.isURL(normalizedMessage)
                ? AppFontStyleTextStrings.light
                : AppFontStyleTextStrings.regular,
            decoration: GetUtils.isURL(normalizedMessage)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  DateTime parseChatDate(dynamic rawTime) {
    final fallback = DateTime.now();

    if (rawTime == null) return fallback;

    String value = rawTime.toString().trim();

    if (value.isEmpty) return fallback;

    value = value
        .replaceAll('\u202f', ' ')
        .replaceAll('\u00a0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Fix bad values like 2026-05-08T19:07:25.139131ZZ
    value = value.replaceFirst(RegExp(r'Z+$'), 'Z');

    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {}

    try {
      return DateFormat(
        'yyyy-MM-dd HH:mm:ss.SSSSSS',
      ).parseLoose(value).toLocal();
    } catch (_) {}

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parseLoose(value).toLocal();
    } catch (_) {}

    try {
      return DateFormat(
        'yyyy-MM-dd h:mm a',
        'en_US',
      ).parseLoose(value).toLocal();
    } catch (_) {}

    dev.log('Invalid chat date: "$rawTime"', name: 'ChatController');
    return fallback;
  }

  Widget statusToWidget(data) {
    if (data == 2) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "accept_chat_dialog_text1".tr,
                    style: const TextStyle(
                      fontFamily: AppFontStyleTextStrings.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  acceptChatRequest();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).primaryColor.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "accept_chat_dialog_text2".tr,
                      style: const TextStyle(
                        color: AppColors.WHITE,
                        fontFamily: AppFontStyleTextStrings.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (data == 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: textField = TextField(
                minLines: 1,
                maxLines: 6,
                focusNode: myFocusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.transparentColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.transparentColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.transparentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.transparentColor),
                  ),
                  hintText: "send_text_field_hint".tr,
                  filled: true,
                  hintStyle: const TextStyle(
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 15,
                  ),
                  prefixIcon: IconButton(
                    icon: isEmojiKeyboard.value
                        ? const Icon(Icons.keyboard)
                        : const Icon(Icons.emoji_emotions_outlined),
                    onPressed: toggleEmojiKeyboard,
                  ),

                  suffixIcon: IconButton(
                    icon: const Icon(Icons.file_present),
                    onPressed: () {
                      uploadMediaOptionDialog(
                        onTap: () {
                          pickCameraImage();
                          Get.back();
                        },
                        onTap1: () {
                          pickFile();
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
                onChanged: (val) {
                  markAsTyping();
                  message.value = val;
                  if (val.length == 0) {
                    showButton.value = false;
                  } else {
                    showButton.value = true;
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            showButton.value
                ? FloatingActionButton(
                    shape: const CircleBorder(
                      side: BorderSide(width: 5, color: AppColors.WHITE),
                    ),
                    onPressed: () {
                      sendMessage(0);
                    },
                    elevation: 0.0,
                    child: Transform.rotate(
                      angle: 5.5,
                      child: const Icon(Icons.send),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  acceptChatRequest() async {
    await FirebaseDatabase.instance
        .ref(myUid.value)
        .child('chatlist')
        .child(uid)
        .update({"status": 1})
        .then((value) {
          requestStatus.value = 1;
        });
  }

  unSendMessage(
    String id,
    int index,
    int length,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) async {
    if (index > 0) {
      await FirebaseFirestore.instance
          .collection("Chats")
          .doc(channelId.value)
          .collection("All Chat")
          .doc(id)
          .delete();
      Get.back();
    } else if (length == 1) {
      await FirebaseFirestore.instance
          .collection("Chats")
          .doc(channelId.value)
          .collection("All Chat")
          .doc(id)
          .delete();
      await FirebaseDatabase.instance
          .ref(myUid.value)
          .child("chatlist")
          .child(uid)
          .remove();
      await FirebaseDatabase.instance
          .ref(uid)
          .child("chatlist")
          .child(myUid.value)
          .remove();
      Get.back();
    } else {
      DatabaseReference documentReference = FirebaseDatabase.instance
          .ref(myUid.value)
          .child('chatlist')
          .child(uid);
      await documentReference.update({
        "time": snapshot.data!.docs[1]['time'].toString(),
        "last_msg": snapshot.data!.docs[1]['msg'],
        "type": snapshot.data!.docs[1]['type'],
      });

      DatabaseReference documentReference2 = FirebaseDatabase.instance
          .ref(uid)
          .child('chatlist')
          .child(myUid.value);
      await documentReference2.update({
        "time": snapshot.data!.docs[1]['time'].toString(),
        "last_msg": snapshot.data!.docs[1]['msg'],
        "type": snapshot.data!.docs[1]['type'],
      });
      Get.back();
      await FirebaseFirestore.instance
          .collection("Chats")
          .doc(channelId.value)
          .collection("All Chat")
          .doc(id)
          .delete();
    }
  }

  Future<Map<String, dynamic>> sendNotification(
    String userName,
    String message,
    String token,
  ) async {
    try {
      if (token.trim().isEmpty) {
        debugPrint("CHAT_NOTIFICATION_SKIPPED :: empty receiver token");
        return {"success": false, "msg": "Receiver token is empty"};
      }

      final Map<String, String> dataPayload = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'body': message,
        'title': userName,
        'uid': myUid.value.toString(),
        'channelId': channelId.value.toString(),
        'myUserName': userName,
        'myid': myUid.value.toString(),
        'notificationType': '0',
      };

      final response = await post(
        Uri.parse('${Apis.ServerAddress}/api/send-chat-notification'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'token': token.trim(),
          'title': userName,
          'body': message,
          'data': dataPayload,
        }),
      ).timeout(const Duration(seconds: Apis.timeOut));

      debugPrint("CHAT_NOTIFICATION_STATUS :: ${response.statusCode}");
      debugPrint("CHAT_NOTIFICATION_BODY :: ${response.body}");

      if (response.statusCode != 200) {
        return {
          "success": false,
          "msg": "Server error: ${response.statusCode}",
          "body": response.body,
        };
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {"success": false, "msg": "Invalid notification response"};
    } catch (e) {
      debugPrint("CHAT_NOTIFICATION_EXCEPTION :: $e");

      return {"success": false, "msg": e.toString()};
    }
  }
}
