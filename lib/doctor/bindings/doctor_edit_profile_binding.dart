import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorProfileController>(
      () => DoctorProfileController(),
    );
  }
}


