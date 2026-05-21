import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class ChangePassword extends GetView<DChangePasswordController> {
  final DChangePasswordController changePasswordController =
      Get.put(DChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          onPressed: () => Get.back(),
          isBackArrow: true,
          title: 'change_password_str'.tr,
          textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
              color: Theme.of(context).scaffoldBackgroundColor, fontWeightDelta: 5),
        ),
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Stack(
          children: [
            Form(
              key: changePasswordController.formKey,
              child: Column(
                children: [
                  Obx(
                    () => DEditPasswordFormField(
                      controller: changePasswordController.oldpassword,
                      labelText: 'old_pwd'.tr,
                      errorText: changePasswordController.passwordError1.value
                          ? 'old_pwd_error'.tr
                          : null,
                      obscureCharacter: '*',
                      obscureText:
                          changePasswordController.passwordVisible.value,
                      onChanged: (String? val) {
                        if (val == null) return;
                        if (val.isNotEmpty) {
                          changePasswordController.oldPwdText.value = val;
                          changePasswordController.passwordError1.value = false;
                          changePasswordController.update();
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          changePasswordController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          changePasswordController.passwordVisible.value =
                              !changePasswordController.passwordVisible.value;
                          changePasswordController.update();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => DEditPasswordFormField(
                      controller: changePasswordController.newpassword,
                      labelText: 'new_pwd'.tr,
                      errorText: changePasswordController.passwordError2.value
                          ? changePasswordController.newPwd.value
                          : null,
                      obscureCharacter: '*',
                      obscureText:
                          changePasswordController.passwordVisible1.value,
                      onChanged: (String? val) {
                        if (val == null) return;
                        if (val.isNotEmpty) {
                          changePasswordController.newPwdText.value = val;
                          changePasswordController.passwordError2.value = false;
                          changePasswordController.update();
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          changePasswordController.passwordVisible1.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          changePasswordController.passwordVisible1.value =
                              !changePasswordController.passwordVisible1.value;
                          changePasswordController.update();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => DEditPasswordFormField(
                      controller: changePasswordController.confirmpassword,
                      labelText: 'confirm_password'.tr,
                      errorText: changePasswordController.passwordError3.value
                          ? changePasswordController.confPwd.value
                          : null,
                      obscureCharacter: '*',
                      obscureText:
                          changePasswordController.passwordVisible2.value,
                      onChanged: (String? val) {
                        if (val == null) return;
                        if (val.isNotEmpty) {
                          changePasswordController.confPwdText.value = val;
                          changePasswordController.passwordError3.value = false;
                          changePasswordController.update();
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          changePasswordController.passwordVisible2.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          changePasswordController.passwordVisible2.value =
                              !changePasswordController.passwordVisible2.value;
                          changePasswordController.update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          Get.focusScope?.unfocus();
                          changePasswordController.passwordError1.value = false;
                          changePasswordController.passwordError2.value = false;
                          changePasswordController.passwordError3.value = false;
                          changePasswordController.oldPwd.value = "";
                          changePasswordController.newPwd.value = "";
                          changePasswordController.confPwd.value = "";
                          if (changePasswordController.oldPwdText.value.isEmpty ||
                              changePasswordController
                                  .newPwdText.value.isEmpty ||
                              changePasswordController
                                  .confPwdText.value.isEmpty) {
                            if (changePasswordController
                                .oldPwdText.value.isEmpty) {
                              changePasswordController.oldPwd.value =
                                  'old_pwd_error'.tr;
                              changePasswordController.passwordError1.value =
                                  true;
                            }
                            if (changePasswordController
                                .newPwdText.value.isEmpty) {
                              changePasswordController.newPwd.value =
                                  'new_pwd_error'.tr;
                              changePasswordController.passwordError2.value =
                                  true;
                            }
                            if (changePasswordController
                                .confPwdText.value.isEmpty) {
                              changePasswordController.confPwd.value =
                                  'conf_pwd_error'.tr;
                              changePasswordController.passwordError3.value =
                                  true;
                            }
                          } else if (changePasswordController
                                  .newPwdText.value.length <
                              PASS_LENGTH) {
                            changePasswordController.newPwd.value =
                                'password_error2'
                                    .trParams({'length': '${PASS_LENGTH}'});
                            changePasswordController.passwordError2.value =
                                true;
                          } else if (changePasswordController
                                  .newPwdText.value !=
                              changePasswordController.confPwdText.value) {
                            changePasswordController.confPwd.value =
                                'password_error'.tr;
                            changePasswordController.passwordError3.value =
                                true;
                          } else {
                            changePasswordController.changePassword();
                          }
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.color1,
                                      AppColors.color2,
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Center(
                              child: changePasswordController
                                          .isErrorInLoading.value ==
                                      true
                                  ? const CircularProgressIndicator(
                                      color: AppColors.WHITE)
                                  : AppTextWidgets.mediumText(
                                      text: "change_password_str".tr,
                                      color: AppColors.WHITE,
                                      size: 18,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


