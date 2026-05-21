import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class AppointmentDetailsScreenPdf
    extends GetView<AppointmentDetailsScreenPdfController> {
  final AppointmentDetailsScreenPdfController pdfController =
      Get.put(AppointmentDetailsScreenPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.color1,
        child: const Icon(
          Icons.download,
          color: AppColors.WHITE,
        ),
        onPressed: () async {
          controller.savePdf1(context);
        },
      ),
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          title: 'pdf_downloader'.tr,
          textStyle: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 22,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          onPressed: () => Get.back(),
          isBackArrow: true,
        ),
        leading: Container(),
      ),
      body: Obx(() => controller.isDataLoaded.value
          ? PDFView(
              filePath: null,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              onRender: (_pages) {},
              pdfData: controller.pdfBytes,
              onError: (error) {},
              onPageError: (page, error) {},
              onViewCreated: (PDFViewController pdfViewController) {},
              onPageChanged: (int? page, int? total) {},
            )
          : Center(child: CircularProgressIndicator())),
    );
  }
}


