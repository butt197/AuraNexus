import 'package:videocalling/common/utils/app_imports.dart';

class InAppWebViewScreen extends GetView<InAppWebViewController1> {
  InAppWebViewController1 webViewController =
      Get.put(InAppWebViewController1());

  InAppWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          flexibleSpace: CustomAppBar(
              title: '',
              textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeightDelta: 5)),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Obx(() => Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewController.webViewKey,
                      initialUrlRequest:
                          URLRequest(url: WebUri(webViewController.url)),
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: webViewController.options,
                      pullToRefreshController:
                          webViewController.pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController.webViewController = controller;

                        webViewController.webViewController
                            ?.addJavaScriptHandler(
                                handlerName: 'handlerFoo',
                                callback: (args) {
                                  return {
                                    'bar': 'bar_value',
                                    'baz': 'baz_value'
                                  };
                                });

                        webViewController.webViewController
                            ?.addJavaScriptHandler(
                          handlerName: 'handlerFooWithArgs',
                          callback: (args) {},
                        );
                      },
                      onLoadStart: (controller, url) {
                        webViewController.newUrl.value = url.toString();
                        webViewController.urlController.text =
                            webViewController.newUrl.value;
                        webViewController.update();
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunch(webViewController.url)) {
                            await launch(
                              webViewController.url,
                            );
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        webViewController.pullToRefreshController
                            .endRefreshing();
                        webViewController.url = url.toString();
                        webViewController.urlController.text =
                            webViewController.url;
                        if (url.toString() == Apis.SUCCESS_PAYMENT_URL) {
                          if (webViewController.isDoctor == 1) {
                            Get.back(result: "success");
                          } else {
                            Get.back();
                            customDialog(
                              s1: 'success_str'.tr,
                              s2: 'payment_success'.tr,
                              onPressed: () {
                                Get.offAllNamed(Routes.doctorTabScreen);
                              },
                            );
                          }
                        } else if (url.toString() == Apis.FAIL_PAYMENT_URL) {
                          Get.back(result: 'fail');
                        }
                      },
                      onLoadError: (controller, url, code, message) {
                        webViewController.pullToRefreshController
                            .endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          webViewController.pullToRefreshController
                              .endRefreshing();
                        }
                        webViewController.progress.value = progress / 100;
                        webViewController.urlController.text =
                            webViewController.url;
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        webViewController.url = url.toString();
                        webViewController.urlController.text =
                            webViewController.url;
                      },
                      onConsoleMessage: (controller, consoleMessage) {},
                    ),
                    webViewController.progress < 1.0
                        ? LinearProgressIndicator(
                            value: webViewController.progress.value)
                        : Container(),
                  ],
                ),
              )),
        ])));
  }
}



