import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class ReportIssuesScreen extends GetView<ReportIssueController> {
  final ReportIssueController issueController =
      Get.put(ReportIssueController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          flexibleSpace: CustomAppBar(
            title: 'title4'.tr,
            onPressed: () => Get.back(),
            isBackArrow: true,
          ),
          elevation: 0,
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: issueController.issuesList.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Obx(() => ListTile(
                            leading: Checkbox(
                              onChanged: (val) {
                                if (issueController.title.contains(
                                    issueController.issuesList[index])) {
                                  issueController.title.remove(
                                      issueController.issuesList[index]);
                                } else {
                                  issueController.title
                                      .add(issueController.issuesList[index]);
                                }
                                issueController.update();
                              },
                              value: issueController.title
                                  .contains(issueController.issuesList[index]),
                            ),
                            title: Text(issueController.issuesList[index]),
                            onTap: () {
                              if (issueController.title.contains(
                                  issueController.issuesList[index])) {
                                issueController.title
                                    .remove(issueController.issuesList[index]);
                              } else {
                                issueController.title
                                    .add(issueController.issuesList[index]);
                              }
                              issueController.update();
                            },
                          )));
                },
              ),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Obx(
                    () => TextField(
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        filled: true,
                        hintText: "description_hint".tr,
                        errorText: issueController.isDescriptionError.value
                            ? "description_error".tr
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (val) {
                        issueController.description = val;
                        issueController.isDescriptionError.value = false;
                      },
                    ),
                  )),
              CustomButton(
                onTap: () {
                  Get.focusScope?.unfocus();
                  issueController.reportIssue();
                },
                btnText: 'report'.tr,
              )
            ],
          ),
        ),
      ),
    );
  }
}


