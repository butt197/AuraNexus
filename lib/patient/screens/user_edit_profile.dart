import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserEditProfile extends GetView<UserEditController> {
  final UserEditController editController = Get.put(UserEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          title: 'register'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
        leading: Container(),
      ),
      body: Obx(() => editController.isLoaded.value
          ? const LinearProgressIndicator()
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextWidgets.regularText(
                            text: 'already_have_an_account'.tr,
                            size: 12,
                            color: AppColors.BLACK),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: AppTextWidgets.mediumText(
                            text: " ${'login_now'.tr}",
                            color: AppColors.AMBER,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Obx(() => Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(65),
                                        child: editController.image != null ||
                                                editController
                                                    .isImageSelected.value
                                            ? Image.file(
                                                editController.image!,
                                                height: 130,
                                                width: 130,
                                                fit: BoxFit.fill,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    editController.profileImage,
                                                height: 130,
                                                width: 130,
                                                placeholder: (context, url) =>
                                                    Icon(
                                                  Icons.image,
                                                  color: Theme.of(context)
                                                      .primaryColorDark
                                                      .withOpacity(0.5),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.image,
                                                  color: Theme.of(context)
                                                      .primaryColorDark
                                                      .withOpacity(0.5),
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 135,
                                width: 135,
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        controller.getImage();
                                      },
                                      child: Image.asset(
                                        AppImages.editHomeScreen,
                                        height: 35,
                                        width: 35,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        decoration: const BoxDecoration(
                            color: AppColors.WHITE,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              EditTextField(
                                editingController:
                                    editController.nameController,
                                labelText: 'enter_name'.tr,
                                errorText: editController.isNameError.value
                                    ? 'enter_name'.tr
                                    : null,
                                onChanged: (val) {
                                  editController.name.value = val.trim();
                                  editController.isNameError.value = false;
                                  editController.update();
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              EditTextField(
                                keyboardType: TextInputType.phone,
                                editingController:
                                    editController.phoneController,
                                labelText: 'enter_number'.tr,
                                errorText:
                                    editController.isPhoneNumberError.value
                                        ? editController.phnNumberError.value
                                        : null,
                                onChanged: (val) {
                                  editController.phoneNumber.value = val.trim();
                                  editController.isPhoneNumberError.value =
                                      false;
                                  editController.update();
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              EditTextField(
                                keyboardType: TextInputType.emailAddress,
                                editingController:
                                    editController.emailController,
                                labelText: 'enter_email_hint'.tr,
                                errorText: editController.isEmailError.value
                                    ? 'enter_email_error'.tr
                                    : null,
                                onChanged: (val) {
                                  editController.email.value = val.trim();
                                  editController.isEmailError.value = false;
                                  editController.update();
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              EditTextField(
                                obscureText: true,
                                editingController:
                                    editController.passController,
                                labelText: 'password'.tr,
                                errorText: editController.isPassError.value
                                    ? 'password_not_match'.tr
                                    : null,
                                onChanged: (val) {
                                  editController.password.value = val.trim();
                                  editController.isPassError.value = false;
                                  editController.update();
                                },
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              EditTextField(
                                obscureText: true,
                                editingController:
                                    editController.confirmController,
                                labelText: 'confirm_password'.tr,
                                errorText: editController.isPassError.value
                                    ? 'password_not_match'.tr
                                    : null,
                                onChanged: (val) {
                                  editController.confirmPassword.value = val.trim();
                                  editController.isPassError.value = false;
                                  editController.update();
                                },
                              ),
                              const SizedBox(
                                height: 23,
                              ),
                              SizedBox(
                                height: 50,
                                child: InkWell(
                                  onTap: () {
                                    Get.focusScope?.unfocus();
                                    editController.registerUser();
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      Center(
                                        child: AppTextWidgets.regularText(
                                          text: 'update'.tr,
                                          color: AppColors.WHITE,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}



