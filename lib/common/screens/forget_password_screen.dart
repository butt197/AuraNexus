import 'package:videocalling/common/utils/app_imports.dart';

class ForgetPassword extends GetView<ForgetPasswordController> {
  ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());

  ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: CustomAppBar(
            title: 'forget_password'.tr,
            isBackArrow: true,
            onPressed: () => Get.back(),
          ),
          leading: Container(),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                40.hs,
                Image.asset(
                  AppImages.forgetIcon,
                  height: 170,
                  width: 170,
                ),
                20.hs,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'forget_password_enter_email'.tr,
                        style: const TextStyle(
                          fontFamily: AppFontStyleTextStrings.regular,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                40.hs,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "we_will_email_a_password_reset_link".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.greyShade6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                20.hs,
                Obx(
                  () => EditTextField(
                    editingController: forgetPasswordController.emailTextField,
                    labelText: 'enter_email_hint'.tr,
                    errorText: forgetPasswordController.isEmailError.value
                        ? forgetPasswordController.emailError.value
                        : null,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        forgetPasswordController.isEmailError.value = false;
                      }
                    },
                  ),
                ),
                40.hs,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onTap: () {
                      Get.focusScope?.unfocus();
                      if (forgetPasswordController
                          .emailTextField.text.isEmpty) {
                        forgetPasswordController.isEmailError.value = true;
                        forgetPasswordController.emailError.value =
                            'enter_email_hint'.tr;
                      } else if (GetUtils.isEmail(
                              forgetPasswordController.emailTextField.text) ==
                          false) {
                        forgetPasswordController.isEmailError.value = true;
                        forgetPasswordController.emailError.value =
                            'enter_email_error'.tr;
                      } else {
                        forgetPasswordController.sendEmail();
                      }
                    },
                    btnText: 'btn_submit'.tr,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}


