import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class MakeAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeAppointmentController>(
      () => MakeAppointmentController(),
    );
  }
}


