import 'package:videocalling/common/utils/app_imports.dart';

class MyPhotoViewerController extends GetxController {
  late String url;
  late String id;
  late bool isDeleteShown;
  late String reportName;

  GlobalKey<FormState> sKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    url = _resolveImageUrl(args['url']?.toString() ?? '');
    id = args['id']?.toString() ?? '';
    isDeleteShown = args['isDeleteShown'] == true;
    reportName = args['reportName']?.toString() ?? '';
  }

  String _resolveImageUrl(String rawUrl) {
    String value = rawUrl.trim();

    if (value.isEmpty) {
      return '';
    }

    value = value.replaceAll('\\', '/');

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('/upload/chat/')) {
      return '${Apis.ServerAddress}$value';
    }

    if (value.startsWith('upload/chat/')) {
      return '${Apis.ServerAddress}/$value';
    }

    if (value.startsWith('/')) {
      return '${Apis.ServerAddress}$value';
    }

    return '${Apis.chatMediaPath}$value';
  }

  deletePhoto({String? imageId}) async {
    try {
      var res = await get(
        Uri.parse(
          "${Apis.ServerAddress}/api/delete_upload_image?image_id=$imageId",
        ),
      ).timeout(const Duration(seconds: Apis.timeOut));

      if (res.statusCode == 200) {
        ReportDeleteRes reportDeleteRes = ReportDeleteRes.fromJson(
          jsonDecode(res.body),
        );

        customDialog(
          onPressed: () {
            Get.back();
            Get.back(result: true);
          },
          s1: reportDeleteRes.status == 1 ? 'success'.tr : 'error'.tr,
          s2: reportDeleteRes.message ?? "",
        );
      }
    } catch (e) {
      customDialog(
        onPressed: () {
          Get.back();
        },
        s1: 'error'.tr,
        s2: e.toString(),
      );
    }
  }
}
