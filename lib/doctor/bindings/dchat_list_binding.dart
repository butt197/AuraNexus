import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorChatListController>(
      () => DoctorChatListController(),
    );
  }
}


