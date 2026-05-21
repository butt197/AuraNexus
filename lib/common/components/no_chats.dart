import '../utils/app_imports.dart';

Widget noChats({required String title}) {
  return Column(
    children: [
      Container(
        height: Get.height * 0.6,
        margin: const EdgeInsets.all(55),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.noChatVector),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text("no_chats_title".tr,
                  style: const TextStyle(
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 22,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 15,
                  )),
            )
          ],
        ),
      ),
    ],
  );
}


