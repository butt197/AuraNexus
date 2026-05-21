import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class PChatListScreen extends GetView<PatientChatListController> {
  final PatientChatListController chatListController = Get.put(
    PatientChatListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(title: 'recent_chats'.tr),
        leading: Container(),
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      body: Obx(
        () => chatListController.loginCheckUser.value
            ? Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: chatListController.st.value
                          ? chatListController.chatListDetails.isEmpty
                                ? noChats(title: "no_chats_description_user".tr)
                                : MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: ListView.builder(
                                      itemCount: chatListController
                                          .chatListDetails
                                          .length,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder(
                                          stream: FirebaseDatabase.instance
                                              .ref(
                                                chatListController
                                                    .chatListDetails[index]
                                                    .userUid,
                                              )
                                              .onValue,
                                          builder: (context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                    1,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    gradient:
                                                        chatListController
                                                                .chatListDetails[index]
                                                                .messageCount >
                                                            0
                                                        ? LinearGradient(
                                                            colors: [
                                                              AppColors
                                                                  .LIGHT_BLUE_ACCENT
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              AppColors
                                                                  .LIGHT_BLUE_ACCENT
                                                                  .withOpacity(
                                                                    0.05,
                                                                  ),
                                                            ],
                                                            stops: const [
                                                              0.1,
                                                              0.6,
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          )
                                                        : null,
                                                  ),
                                                  child: ListTile(
                                                    title: Text(
                                                      snapshot
                                                              .data!
                                                              .snapshot
                                                              .value['name'] ??
                                                          "",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            chatListController
                                                                    .chatListDetails[index]
                                                                    .messageCount >
                                                                0
                                                            ? AppFontStyleTextStrings
                                                                  .bold
                                                            : AppFontStyleTextStrings
                                                                  .regular,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      child: Container(
                                                        height: 55,
                                                        width: 55,
                                                        color: AppColors
                                                            .greyShade3,
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                              snapshot
                                                                  .data!
                                                                  .snapshot
                                                                  .value['image'] ??
                                                              " ",
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (
                                                                context,
                                                                string,
                                                              ) =>
                                                                  const SizedBox(
                                                                    height: 55,
                                                                    width: 55,
                                                                  ),
                                                          errorWidget:
                                                              (
                                                                context,
                                                                err,
                                                                f,
                                                              ) => Icon(
                                                                Icons
                                                                    .account_circle,
                                                                size: 50,
                                                                color: AppColors
                                                                    .greyShade4,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        chatListController
                                                                    .chatListDetails[index]
                                                                    .messageCount ==
                                                                0
                                                            ? const SizedBox()
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      AppColors
                                                                          .GREEN_ACCENT
                                                                          .withOpacity(
                                                                            0.6,
                                                                          ),
                                                                      AppColors
                                                                          .LIGHT_BLUE_ACCENT,
                                                                    ],
                                                                    stops:
                                                                        const [
                                                                          0.3,
                                                                          1,
                                                                        ],
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                height: 23,
                                                                width: 23,
                                                                child: Center(
                                                                  child: Text(
                                                                    chatListController
                                                                        .chatListDetails[index]
                                                                        .messageCount
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                      color: AppColors
                                                                          .BLACK,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                        AppTextWidgets.mediumTextWithSize(
                                                          text: chatListController
                                                              .messageTiming(
                                                                chatListController
                                                                    .safeParseChatTime(
                                                                      chatListController
                                                                          .chatListDetails[index]
                                                                          .time,
                                                                    ),
                                                              ),
                                                          size: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: chatListController
                                                        .typeToWidget(
                                                          chatListController
                                                              .chatListDetails[index]
                                                              .type,
                                                          chatListController
                                                              .chatListDetails[index]
                                                              .message,
                                                          chatListController
                                                              .chatListDetails[index]
                                                              .messageCount,
                                                        ),
                                                    tileColor: AppColors
                                                        .transparentColor,
                                                    onTap: () async {
                                                      await Get.toNamed(
                                                        Routes.chatScreen,
                                                        arguments: {
                                                          'userName': snapshot
                                                              .data!
                                                              .snapshot
                                                              .value['name'],
                                                          'uid': chatListController
                                                              .chatListDetails[index]
                                                              .userUid,
                                                          'isUser': false,
                                                        },
                                                      );
                                                      Get.delete<
                                                        ChatController
                                                      >();
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              )
            : noChats(title: "no_chats_description_user".tr),
      ),
    );
  }
}
