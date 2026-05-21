// import 'package:videocalling/common/utils/app_imports.dart';
// import 'package:videocalling/doctor/utils/doctor_imports.dart';

// class RegisterAsDoctor extends GetView<DoctorRegisterController> {
//   final DoctorRegisterController registerController = Get.put(
//     DoctorRegisterController(),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: CustomAppBar(
//           title: 'doctor_register'.tr,
//           isBackArrow: true,
//           onPressed: () => Get.back(),
//         ),
//         elevation: 0,
//         leading: Container(),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AppTextWidgets.regularText(
//                     text: 'already_have_an_account'.tr,
//                     size: 12,
//                     color: AppColors.BLACK,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: AppTextWidgets.mediumText(
//                       text: " ${'login_now'.tr}",
//                       color: AppColors.AMBER,
//                       size: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//           Obx(
//             () => SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height - 150,
//                     decoration: const BoxDecoration(
//                       color: AppColors.WHITE,
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                       child: Form(
//                         key: registerController.formKey,
//                         child: Column(
//                           children: [
//                             DEditTextFormField(
//                               labelText: 'enter_name'.tr,
//                               errorText: registerController.isNameError.value
//                                   ? 'enter_name'.tr
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.name.value = val.trim();
//                                 registerController.isNameError.value = false;
//                               },
//                               validator: (value) {
//                                 registerController.name.value = (value ?? "").trim();
//                                 if (registerController.name.value.isEmpty) {
//                                   return 'Please Enter Name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 3),
//                             DEditTextFormField(
//                               validator: (value) {
//                                 registerController.phoneNumber.value = (value ?? "").trim();
//                                 if (registerController
//                                     .phoneNumber
//                                     .value
//                                     .isEmpty) {
//                                   return 'mobile_error_1'.tr;
//                                 } else if (registerController
//                                         .phoneNumber
//                                         .value
//                                         .length <
//                                     PHONE_LENGTH) {
//                                   return 'mobile_error_2'.trParams({
//                                     'length': PHONE_LENGTH.toString(),
//                                   });
//                                 }
//                                 return null;
//                               },
//                               labelText: 'enter_number'.tr,
//                               errorText:
//                                   registerController.isPhoneNumberError.value
//                                   ? registerController.phnNumberError.value
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.phoneNumber.value = val.trim();
//                                 registerController.isPhoneNumberError.value =
//                                     false;
//                               },
//                               keyboardType: TextInputType.phone,
//                             ),
//                             const SizedBox(height: 3),
//                             DEditTextFormField(
//                               labelText: 'enter_email_hint'.tr,
//                               errorText: registerController.isEmailError.value
//                                   ? 'enter_email_error'.tr
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.email.value = val.trim();
//                                 registerController.isEmailError.value = false;
//                               },
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 registerController.email.value = (value ?? "").trim();
//                                 if (registerController.email.value.isEmpty) {
//                                   return 'enter_email_hint'.tr;
//                                 } else if (!GetUtils.isEmail(
//                                   registerController.email.value,
//                                 )) {
//                                   return 'enter_email_error'.tr;
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 3),
//                             DEditTextFormField(
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   registerController.passwordVisible.value
//                                       ? Icons.visibility
//                                       : Icons.visibility_off,
//                                   color: Theme.of(context).primaryColorDark,
//                                 ),
//                                 onPressed: () {
//                                   registerController.passwordVisible.value =
//                                       !registerController.passwordVisible.value;
//                                 },
//                               ),
//                               labelText: 'password'.tr,
//                               errorText: registerController.isPassError.value
//                                   ? 'password_error'.tr
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.password.value = val.trim();
//                                 registerController.isPassError.value = false;
//                               },
//                               validator: (value) {
//                                 registerController.password.value = (value ?? "").trim();
//                                 if (registerController.password.value.isEmpty) {
//                                   return 'password_error1'.tr;
//                                 } else if (registerController
//                                         .password
//                                         .value
//                                         .length <
//                                     PASS_LENGTH) {
//                                   return 'password_error2'.trParams({
//                                     'length': '$PASS_LENGTH',
//                                   });
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.visiblePassword,
//                               obscureText:
//                                   registerController.passwordVisible.value,
//                             ),
//                             const SizedBox(height: 3),
//                             DEditTextFormField(
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   registerController.passwordVisible1.value
//                                       ? Icons.visibility
//                                       : Icons.visibility_off,
//                                   color: Theme.of(context).primaryColorDark,
//                                 ),
//                                 onPressed: () {
//                                   registerController.passwordVisible1.value =
//                                       !registerController
//                                           .passwordVisible1
//                                           .value;
//                                 },
//                               ),
//                               labelText: 'confirm_password'.tr,
//                               errorText: registerController.isPassError.value
//                                   ? 'password_error'.tr
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.confirmPassword.value = val.trim();
//                                 registerController.isPassError.value = false;
//                               },
//                               validator: (value) {
//                                 registerController.confirmPassword.value =
//                                     value!;
//                                 if (registerController
//                                     .confirmPassword
//                                     .value
//                                     .isEmpty) {
//                                   return 'password_error1'.tr;
//                                 } else if (registerController
//                                         .confirmPassword
//                                         .value
//                                         .length <
//                                     PASS_LENGTH) {
//                                   return 'password_error2'.trParams({
//                                     'length': '$PASS_LENGTH',
//                                   });
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.visiblePassword,
//                               obscureText:
//                                   registerController.passwordVisible1.value,
//                             ),
//                             const SizedBox(height: 3),

//                             DEditTextFormField(
//                               labelText: 'License Number',
//                               errorText: registerController.isLicenseError.value
//                                   ? 'License number is required'
//                                   : null,
//                               onChanged: (val) {
//                                 registerController.licenseNumber.value = val;
//                                 registerController.isLicenseError.value = false;
//                               },
//                               validator: (value) {
//                                 registerController.licenseNumber.value =
//                                     value ?? "";
//                                 if (registerController.licenseNumber.value
//                                     .trim()
//                                     .isEmpty) {
//                                   return 'License number is required';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),

//                             InkWell(
//                               onTap: () {
//                                 registerController.pickCertificateImages();
//                               },
//                               child: Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 14,
//                                   vertical: 14,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color:
//                                         registerController
//                                             .isCertificateError
//                                             .value
//                                         ? AppColors.RED
//                                         : AppColors.greyShade3,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       registerController
//                                               .certificateImages
//                                               .isEmpty
//                                           ? 'Upload Certificate Images'
//                                           : '${registerController.certificateImages.length} certificate image(s) selected',
//                                       style: const TextStyle(
//                                         fontFamily:
//                                             AppFontStyleTextStrings.regular,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     if (registerController
//                                         .isCertificateError
//                                         .value)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 6),
//                                         child: Text(
//                                           registerController
//                                               .certificateError
//                                               .value,
//                                           style: TextStyle(
//                                             color: AppColors.RED,
//                                             fontSize: 12,
//                                             fontFamily:
//                                                 AppFontStyleTextStrings.regular,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 3),
//                             const SizedBox(height: 20),
//                             SizedBox(
//                               height: 50,
//                               child: InkWell(
//                                 onTap: () {
//                                   Get.focusScope?.unfocus();
//                                   if (registerController.formKey.currentState!
//                                       .validate()) {
//                                     registerController.registerUser();
//                                   }
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(25),
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               AppColors.color1,
//                                               AppColors.color2,
//                                             ],
//                                             begin: Alignment.bottomLeft,
//                                             end: Alignment.topRight,
//                                           ),
//                                         ),
//                                         height: 50,
//                                         width: MediaQuery.of(
//                                           context,
//                                         ).size.width,
//                                       ),
//                                     ),
//                                     Center(
//                                       child: AppTextWidgets.mediumText(
//                                         text: 'register'.tr,
//                                         color: AppColors.WHITE,
//                                         size: 18,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class RegisterAsDoctor extends GetView<DoctorRegisterController> {
  final DoctorRegisterController registerController = Get.put(
    DoctorRegisterController(),
  );

  RegisterAsDoctor({super.key});

  Widget _smallGap() => const SizedBox(height: 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'doctor_register'.tr,
          isBackArrow: true,
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        leading: Container(),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.WHITE,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Form(
                      key: registerController.formKey,
                      child: Column(
                        children: [
                          DEditTextFormField(
                            labelText: 'enter_name'.tr,
                            errorText: registerController.isNameError.value
                                ? 'enter_name'.tr
                                : null,
                            onChanged: (val) {
                              registerController.name.value = val.trim();
                              registerController.isNameError.value = false;
                            },
                            validator: (value) {
                              registerController.name.value = (value ?? "").trim();
                              if (registerController.name.value
                                  .trim()
                                  .isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 6),

                          DEditTextFormField(
                            labelText: 'enter_number'.tr,
                            errorText:
                                registerController.isPhoneNumberError.value
                                ? registerController.phnNumberError.value
                                : null,
                            onChanged: (val) {
                              registerController.phoneNumber.value = val.trim();
                              registerController.isPhoneNumberError.value =
                                  false;
                            },
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              registerController.phoneNumber.value = (value ?? "").trim();

                              if (registerController.phoneNumber.value
                                  .trim()
                                  .isEmpty) {
                                return 'mobile_error_1'.tr;
                              }

                              if (registerController.phoneNumber.value
                                      .trim()
                                      .length <
                                  PHONE_LENGTH) {
                                return 'mobile_error_2'.trParams({
                                  'length': PHONE_LENGTH.toString(),
                                });
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 6),

                          DEditTextFormField(
                            labelText: 'enter_email_hint'.tr,
                            errorText: registerController.isEmailError.value
                                ? 'enter_email_error'.tr
                                : null,
                            onChanged: (val) {
                              registerController.email.value = val.trim();
                              registerController.isEmailError.value = false;
                            },
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              registerController.email.value = (value ?? "").trim();

                              if (registerController.email.value
                                  .trim()
                                  .isEmpty) {
                                return 'enter_email_hint'.tr;
                              }

                              if (!GetUtils.isEmail(
                                registerController.email.value.trim(),
                              )) {
                                return 'enter_email_error'.tr;
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 6),

                          DEditTextFormField(
                            suffixIcon: IconButton(
                              icon: Icon(
                                registerController.passwordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                registerController.passwordVisible.value =
                                    !registerController.passwordVisible.value;
                              },
                            ),
                            labelText: 'password'.tr,
                            errorText: registerController.isPassError.value
                                ? 'password_error'.tr
                                : null,
                            onChanged: (val) {
                              registerController.password.value = val.trim();
                              registerController.isPassError.value = false;
                            },
                            validator: (value) {
                              registerController.password.value = (value ?? "").trim();

                              if (registerController.password.value.isEmpty) {
                                return 'password_error1'.tr;
                              }

                              if (registerController.password.value.length <
                                  PASS_LENGTH) {
                                return 'password_error2'.trParams({
                                  'length': '$PASS_LENGTH',
                                });
                              }

                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                registerController.passwordVisible.value,
                          ),
                          const SizedBox(width: 8),
                          DEditTextFormField(
                            suffixIcon: IconButton(
                              icon: Icon(
                                registerController.passwordVisible1.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                registerController.passwordVisible1.value =
                                    !registerController.passwordVisible1.value;
                              },
                            ),
                            labelText: 'confirm_password'.tr,
                            errorText: registerController.isPassError.value
                                ? 'password_error'.tr
                                : null,
                            onChanged: (val) {
                              registerController.confirmPassword.value = val.trim();
                              registerController.isPassError.value = false;
                            },
                            validator: (value) {
                              registerController.confirmPassword.value = (value ?? "").trim();

                              if (registerController
                                  .confirmPassword
                                  .value
                                  .isEmpty) {
                                return 'password_error1'.tr;
                              }

                              if (registerController
                                      .confirmPassword
                                      .value
                                      .length <
                                  PASS_LENGTH) {
                                return 'password_error2'.trParams({
                                  'length': '$PASS_LENGTH',
                                });
                              }

                              if (registerController.confirmPassword.value !=
                                  registerController.password.value) {
                                return 'Password does not match';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                registerController.passwordVisible1.value,
                          ),

                          const SizedBox(height: 6),

                          DEditTextFormField(
                            labelText: 'License Number',
                            errorText: registerController.isLicenseError.value
                                ? 'License number is required'
                                : null,
                            onChanged: (val) {
                              registerController.licenseNumber.value = val;
                              registerController.isLicenseError.value = false;
                            },
                            validator: (value) {
                              registerController.licenseNumber.value =
                                  value ?? "";

                              if (registerController.licenseNumber.value
                                  .trim()
                                  .isEmpty) {
                                return 'License number is required';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          _certificatePickerBox(context),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.BLACK.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48,
                      child: InkWell(
                        onTap: () {
                          Get.focusScope?.unfocus();

                          if (registerController.formKey.currentState!
                              .validate()) {
                            registerController.registerUser();
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
                                height: 48,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Center(
                              child: AppTextWidgets.mediumText(
                                text: 'register'.tr,
                                color: AppColors.WHITE,
                                size: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextWidgets.regularText(
                          text: 'already_have_an_account'.tr,
                          size: 12,
                          color: AppColors.BLACK,
                        ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCertificateImagePreview(File imageFile, int index) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.BLACK,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              SizedBox(
                height: Get.height * 0.78,
                width: Get.width,
                child: PhotoView(
                  imageProvider: FileImage(imageFile),
                  backgroundDecoration: const BoxDecoration(
                    color: AppColors.BLACK,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                ),
              ),

              Positioned(
                top: 10,
                left: 12,
                right: 55,
                child: Text(
                  'Certificate ${index + 1}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.WHITE,
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.BLACK.withOpacity(0.65),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.WHITE, width: 1),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.WHITE,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _certificatePickerBox(BuildContext context) {
    final bool hasImages = registerController.certificateImages.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.greyShade3.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1.2,
          color: registerController.isCertificateError.value
              ? AppColors.RED
              : AppColors.themeColor3.withOpacity(0.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: registerController.isCertificateError.value
                    ? AppColors.RED
                    : AppColors.themeColor3,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasImages
                      ? '${registerController.certificateImages.length} certificate image(s) added'
                      : 'Certificate Images',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFontStyleTextStrings.medium,
                    fontSize: 13,
                    color: registerController.isCertificateError.value
                        ? AppColors.RED
                        : AppColors.BLACK,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  registerController.pickCertificateImages();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.color1, AppColors.color2],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 15, color: AppColors.WHITE),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: AppColors.WHITE,
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (registerController.isCertificateError.value)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  registerController.certificateError.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.RED,
                    fontSize: 11,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: hasImages
                ? GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: registerController.certificateImages.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.45,
                        ),
                    itemBuilder: (context, index) {
                      final File imageFile =
                          registerController.certificateImages[index];

                      return InkWell(
                        onTap: () {
                          _openCertificateImagePreview(imageFile, index);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.color1.withOpacity(0.95),
                                AppColors.color2.withOpacity(0.95),
                                AppColors.AMBER.withOpacity(0.95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.BLACK.withOpacity(0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.greyShade3,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),

                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    color: AppColors.BLACK.withOpacity(0.45),
                                    child: Text(
                                      'Tap to preview â€¢ Certificate ${index + 1}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.WHITE,
                                        fontSize: 10,
                                        fontFamily:
                                            AppFontStyleTextStrings.regular,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      registerController.removeCertificateImage(
                                        index,
                                      );
                                    },
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.BLACK.withOpacity(
                                          0.72,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.WHITE,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.WHITE,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : InkWell(
                    onTap: () {
                      registerController.pickCertificateImages();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.WHITE,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.themeColor3.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 34,
                            color: AppColors.themeColor3,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tap Add to upload certificate images',
                            style: TextStyle(
                              fontFamily: AppFontStyleTextStrings.regular,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

