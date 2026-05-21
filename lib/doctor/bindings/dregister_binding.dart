import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorRegisterController>(
      () => DoctorRegisterController(),
    );
  }
}


