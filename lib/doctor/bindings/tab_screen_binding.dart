import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class TabScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorTabController>(
      () => DoctorTabController(),
    );
  }
}


