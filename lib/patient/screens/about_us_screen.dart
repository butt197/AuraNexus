import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class AboutUSScreen extends GetView<AboutUsController> {
  final AboutUsController termController = Get.put(AboutUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'about'.tr,
          onPressed: () => Get.back(),
          isBackArrow: true,
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(
            () => termController.isError.value
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 100,
                          color: AppColors.LIGHT_GREY_TEXT,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'unable_to_load_data'.tr,
                          style: const TextStyle(
                            fontFamily: AppFontStyleTextStrings.regular,
                          ),
                        )
                      ],
                    ),
                  )
                : termController.isLoaded.value
                    ? SingleChildScrollView(
                        child: Html(
                          data: "${termController.termsData.data?.about}",
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          )),
    );
  }
}


