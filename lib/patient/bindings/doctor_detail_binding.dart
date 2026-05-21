import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class DoctorDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDetailController>(
      () => DoctorDetailController(),
    );
  }
}


