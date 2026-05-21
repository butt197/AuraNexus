import 'package:videocalling/common/utils/app_imports.dart';

class InAppWebViewController1 extends GetxController {
  String url = Get.arguments['url'];
  int isDoctor = Get.arguments['isDoctor'];
  String appointmentId = Get.arguments['appointmentId'];

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  RxString newUrl = "".obs;
  RxDouble progress = 0.0.obs;
  final urlController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
        },
        onHideContextMenu: () {
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: AppColors.chatColor1,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }
}


