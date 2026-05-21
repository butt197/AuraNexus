import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DMyPhotoView extends GetView<DMyPhotoViewController> {
  final DMyPhotoViewController photoViewController =
      Get.put(DMyPhotoViewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: photoViewController.isFromFile
          ? PhotoView(
              imageProvider: FileImage(File(photoViewController.imagePath)),
            )
          : PhotoView(
              imageProvider: NetworkImage(photoViewController.imagePath),
            ),
    );
  }
}


