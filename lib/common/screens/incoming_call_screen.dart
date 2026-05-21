import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

// class IncomingCallScreen extends StatefulWidget {
//   const IncomingCallScreen({Key? key}) : super(key: key);

//   @override
//   State<IncomingCallScreen> createState() => _IncomingCallScreenState();
// }

class IncomingCallScreen extends GetView<IncomingCallController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onBackPressed(context),
      child: Scaffold(
        body: GetBuilder<IncomingManageController>(
          builder: (value) {
            return Container(
              decoration: BoxDecoration(
                image: (value.image == 'Default')
                    ? null
                    : value.image.contains('default-user.png')
                    ? DecorationImage(
                        image: AssetImage(value.image),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: NetworkImage(value.image),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Container(
                color: value.image == 'Default'
                    ? null
                    : AppColors.BLACK.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(36),
                        child: Text(
                          controller.getCallTitle(),
                          style: TextStyle(
                            fontSize: 20,
                            color: value.image == 'Default'
                                ? AppColors.BLACK
                                : AppColors.WHITE,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36, bottom: 8),
                        child: Text(
                          value.name,
                          style: TextStyle(
                            fontSize: 28,
                            color: value.image == 'Default'
                                ? AppColors.BLACK
                                : AppColors.WHITE,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 36, bottom: 8),
                      //   child: Text(
                      //     "Members:",
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       color: value.image == 'Default'
                      //           ? AppColors.BLACK
                      //           : AppColors.WHITE,
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 86),
                      //   child: Text(
                      //     controller.callSession.callerId.toString(),
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       color: value.image == 'Default'
                      //           ? AppColors.BLACK
                      //           : AppColors.WHITE,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 86),
                        child: Text(
                          'Incoming call',
                          style: TextStyle(
                            fontSize: 18,
                            color: value.image == 'Default'
                                ? AppColors.BLACK
                                : AppColors.WHITE,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 36),
                            child: FloatingActionButton(
                              heroTag: "RejectCall",
                              backgroundColor: AppColors.RED,
                              onPressed: () {
                                controller.rejectCall(
                                  context,
                                  controller.callSession,
                                );
                              },
                              child: const Icon(
                                Icons.call_end,
                                color: AppColors.WHITE,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 36),
                            child: FloatingActionButton(
                              heroTag: "AcceptCall",
                              backgroundColor: AppColors.GREEN,
                              onPressed: () {
                                controller.acceptCall(
                                  context,
                                  controller.callSession,
                                );
                              },
                              child: const Icon(
                                Icons.call,
                                color: AppColors.WHITE,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
