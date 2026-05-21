import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DChangePasswordController extends GetxController {
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  RxString docId = "".obs;
  final formKey = GlobalKey<FormState>();

  RxString oldPwd = "".obs;
  RxString newPwd = "".obs;
  RxString confPwd = "".obs;

  RxString oldPwdText = "".obs;
  RxString newPwdText = "".obs;
  RxString confPwdText = "".obs;

  RxBool isErrorInLoading = false.obs;

  RxBool passwordVisible = true.obs;
  RxBool passwordVisible1 = true.obs;
  RxBool passwordVisible2 = true.obs;

  RxBool passwordError1 = false.obs;
  RxBool passwordError2 = false.obs;
  RxBool passwordError3 = false.obs;

  changePassword() async {
    isErrorInLoading.value = true;

    final response = await post(
      Uri.parse("${Apis.ServerAddress}/api/change_password_doctor"),
      body: {
        'doctor_id': docId.value,
        'old_password': oldpassword.text,
        'new_password': newpassword.text,
        'conf_password': confirmpassword.text
      },
    );

    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      DChangePasswordRes mRes = DChangePasswordRes.fromJson(resp);
      if (mRes.status == 0) {
        customDialog(s1: 'error'.tr, s2: mRes.msg ?? "");
      } else {
        customDialog(
          s1: 'success_str'.tr,
          s2: mRes.msg ?? "",
          onPressed: () {
            Get.back();
            Get.back();
          },
        );
      }
      isErrorInLoading.value = false;
    } else {
      isErrorInLoading.value = false;
      customDialog(s1: 'error'.tr, s2: response.reasonPhrase ?? "");
    }
    Client().close();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    docId.value = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
  }
}


