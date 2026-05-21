import 'package:videocalling/common/utils/app_imports.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AppointmentDetailsScreenPdfController extends GetxController {
  int appointmentId = Get.arguments['appointmentId'];

  pw.Document pdf = pw.Document();
  RxBool isDataLoaded = false.obs;
  Uint8List? pdfBytes;
  DoctorAppointmentDetailsClass1 doctorAppointmentDetailsClass =
      DoctorAppointmentDetailsClass1();

  callApi() async {
    isDataLoaded.value = false;
    update();

    var response = await post(
      Uri.parse(
        '${Apis.ServerAddress}/api/appointmentdetail?id=$appointmentId&type=1',
      ),
      body: {"id": "$appointmentId", "type": "1"},
    ).timeout(const Duration(seconds: Apis.timeOut));

    if (response.statusCode == 200) {
      doctorAppointmentDetailsClass = DoctorAppointmentDetailsClass1.fromJson(
        jsonDecode(response.body),
      );

      makePdf1();
    }
  }

  makePdf1() async {
    pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(15),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.0),
            ),
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: pw.ListView(
              children: [
                pw.Column(
                  children: [
                    pw.SizedBox(height: 10),

                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: pw.BoxDecoration(
                        // boxShadow: const [
                        //   pw.BoxShadow(
                        //     color: PdfColors.red,
                        //     spreadRadius: 0,
                        //     blurRadius: 25,
                        //   ),
                        // ],
                        borderRadius: pw.BorderRadius.circular(23),
                        color: PdfColors.white,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      doctorAppointmentDetailsClass
                                              .data
                                              ?.doctorName
                                              ?.toString() ??
                                          "",
                                      style: const pw.TextStyle(
                                        fontSize: 18,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      doctorAppointmentDetailsClass
                                              .doctor
                                              ?.departmentls
                                              ?.name ??
                                          "",
                                      style: const pw.TextStyle(
                                        fontSize: 18,
                                        color: PdfColor.fromInt(0xFF01d8c9),
                                      ),
                                    ),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                      double.parse(
                                        doctorAppointmentDetailsClass
                                                .doctor
                                                ?.avgratting
                                                ?.toString() ??
                                            "0.0",
                                      ).toStringAsFixed(1),
                                      style: const pw.TextStyle(
                                        fontSize: 18,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          pw.SizedBox(height: 5),
                          pw.Divider(
                            color: const PdfColor.fromInt(0xffCECECE),
                            thickness: 1,
                          ),
                          pw.SizedBox(height: 5),

                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      doctorAppointmentDetailsClass
                                              .data
                                              ?.userName ??
                                          "",
                                      style: const pw.TextStyle(
                                        fontSize: 20,
                                        color: PdfColor.fromInt(0xFF01d8c9),
                                      ),
                                    ),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                      StorageService.readData(
                                            key: LocalStorageKeys.phone,
                                          ) ??
                                          "",
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xff767676),
                                      ),
                                    ),
                                    pw.Text(
                                      StorageService.readData(
                                            key: LocalStorageKeys.email,
                                          ) ??
                                          "",
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xff767676),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              pw.SizedBox(width: 15),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    doctorAppointmentDetailsClass.data?.date ==
                                            null
                                        ? ""
                                        : DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                              doctorAppointmentDetailsClass
                                                  .data!
                                                  .date!,
                                            ),
                                          ),
                                    style: const pw.TextStyle(
                                      fontSize: 16,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                    doctorAppointmentDetailsClass.data?.slot
                                            ?.toString() ??
                                        "",
                                    style: const pw.TextStyle(
                                      fontSize: 16,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          pw.SizedBox(height: 5),
                          pw.Divider(
                            color: const PdfColor.fromInt(0xffCECECE),
                            thickness: 1,
                          ),
                          pw.SizedBox(height: 5),

                          pw.Text(
                            'description'.tr,
                            style: const pw.TextStyle(
                              fontSize: 14,
                              color: PdfColor.fromInt(0xFF01d8c9),
                            ),
                          ),

                          pw.SizedBox(height: 10),

                          pw.Text(
                            doctorAppointmentDetailsClass.data?.description ??
                                "",
                            style: const pw.TextStyle(
                              fontSize: 13,
                              color: PdfColor.fromInt(0xff494949),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 15),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: pw.BoxDecoration(
                        boxShadow: const [
                          pw.BoxShadow(
                            color: PdfColor.fromInt(0xffFFFFFF),
                            spreadRadius: 0,
                            blurRadius: 25, // Blur radius
                          ),
                        ],
                        borderRadius: pw.BorderRadius.circular(23),
                        color: PdfColors.white,
                      ),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(width: 10),
                          pw.SizedBox(height: 10),
                          pw.Divider(
                            color: const PdfColor.fromInt(0xffCECECE),
                            thickness: 1,
                          ),
                          pw.Text(
                            'prescription'.tr,
                            style: const pw.TextStyle(
                              fontSize: 18,
                              color: PdfColor.fromInt(0xff01d8c9),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(23),
                              color: PdfColors.white,
                            ),
                            child: pw.Column(
                              children: [
                                ...List.generate(
                                  (doctorAppointmentDetailsClass
                                                  .prescription
                                                  ?.medicine
                                                  ?.length ??
                                              0) >
                                          2
                                      ? 2
                                      : doctorAppointmentDetailsClass
                                                .prescription
                                                ?.medicine
                                                ?.length ??
                                            0,
                                  (i) => pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Expanded(
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Expanded(
                                                  child: pw.Text(
                                                    "${doctorAppointmentDetailsClass.prescription!.medicine![i].medicine_name}",
                                                    maxLines: 2,
                                                    style: const pw.TextStyle(
                                                      fontSize: 14,
                                                      color: PdfColors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Row(
                                              children: [
                                                pw.Text(
                                                  'medicine_param1'.tr,
                                                  style: const pw.TextStyle(
                                                    fontSize: 14,
                                                    color: PdfColor.fromInt(
                                                      0xFF01d8c9,
                                                    ),
                                                  ),
                                                ),
                                                pw.SizedBox(width: 5),
                                                pw.Text(
                                                  "${doctorAppointmentDetailsClass.prescription!.medicine![i].type}",
                                                  style: const pw.TextStyle(
                                                    fontSize: 14,
                                                    color: PdfColor.fromInt(
                                                      0xff767676,
                                                    ),
                                                  ),
                                                ),
                                                pw.Spacer(),
                                                pw.Text(
                                                  'medicine_param2'.tr,
                                                  style: const pw.TextStyle(
                                                    fontSize: 14,
                                                    color: PdfColor.fromInt(
                                                      0xff767676,
                                                    ),
                                                  ),
                                                ),
                                                pw.SizedBox(width: 5),
                                                pw.Text(
                                                  "${doctorAppointmentDetailsClass.prescription!.medicine![i].dosage}",
                                                  style: const pw.TextStyle(
                                                    fontSize: 14,
                                                    color: PdfColor.fromInt(
                                                      0xff767676,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Row(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.symmetric(
                                                        vertical: 5,
                                                      ),
                                                  child: pw.Text(
                                                    'medicine_param3'.tr,
                                                    style: const pw.TextStyle(
                                                      fontSize: 14,
                                                      color: PdfColor.fromInt(
                                                        0xFF01d8c9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pw.SizedBox(width: 5),
                                                pw.Expanded(
                                                  child: pw.Column(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      pw.Wrap(
                                                        crossAxisAlignment: pw
                                                            .WrapCrossAlignment
                                                            .start,
                                                        runSpacing: 15,
                                                        spacing: 8,
                                                        children: [
                                                          for (
                                                            int j = 0;
                                                            j <
                                                                doctorAppointmentDetailsClass
                                                                    .prescription!
                                                                    .medicine![i]
                                                                    .time!
                                                                    .length;
                                                            j++
                                                          )
                                                            pw.Container(
                                                              alignment: pw
                                                                  .Alignment
                                                                  .center,
                                                              width: 65,
                                                              decoration: pw.BoxDecoration(
                                                                borderRadius:
                                                                    pw.BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                                border: pw.Border.all(
                                                                  color: const PdfColor.fromInt(
                                                                    0xffCCCCCC,
                                                                  ),
                                                                ),
                                                              ),
                                                              padding:
                                                                  const pw.EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 6,
                                                                  ),
                                                              child: pw.Text(
                                                                "${doctorAppointmentDetailsClass.prescription!.medicine![i].time![j].tTime}",
                                                                style: const pw.TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      PdfColors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(height: 15),
                                            pw.Text(
                                              "Consume it for ${doctorAppointmentDetailsClass.prescription!.medicine![i].repeatDays} Days",
                                              style: const pw.TextStyle(
                                                fontSize: 14,
                                                color: PdfColor.fromInt(
                                                  0xff767676,
                                                ),
                                              ),
                                            ),
                                            pw.SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    var length =
        (doctorAppointmentDetailsClass.prescription?.medicine?.length ?? 0);
    if (length > 2) {
      var l1 = length;
      l1 -= 2;
      for (var j = 0; j < ((length - 2) / 7).ceil(); j++) {
        var length = l1;
        if (l1 > 7) {
          length = 7;
          l1 -= 7;
        }
        pdf.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(15),
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Container(
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1.0),
                ),
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  children: [
                    ...List.generate(length, (i) {
                      i = i + 2 + (7 * j);
                      return pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Expanded(
                                      child: pw.Text(
                                        "${doctorAppointmentDetailsClass.prescription!.medicine![i].medicine_name}",
                                        maxLines: 2,
                                        style: const pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      'medicine_param1'.tr,
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xFF01d8c9),
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Text(
                                      "${doctorAppointmentDetailsClass.prescription!.medicine![i].type}",
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xff767676),
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.Text(
                                      'medicine_param2'.tr,
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xff767676),
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Text(
                                      "${doctorAppointmentDetailsClass.prescription!.medicine![i].dosage}",
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColor.fromInt(0xff767676),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: pw.Text(
                                        'medicine_param3'.tr,
                                        style: const pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColor.fromInt(0xFF01d8c9),
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Expanded(
                                      child: pw.Column(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Wrap(
                                            crossAxisAlignment:
                                                pw.WrapCrossAlignment.start,
                                            runSpacing: 15,
                                            spacing: 8,
                                            children: [
                                              for (
                                                int j = 0;
                                                j <
                                                    doctorAppointmentDetailsClass
                                                        .prescription!
                                                        .medicine![i]
                                                        .time!
                                                        .length;
                                                j++
                                              )
                                                pw.Container(
                                                  alignment:
                                                      pw.Alignment.center,
                                                  width: 65,
                                                  decoration: pw.BoxDecoration(
                                                    borderRadius:
                                                        pw.BorderRadius.circular(
                                                          5,
                                                        ),
                                                    border: pw.Border.all(
                                                      color:
                                                          const PdfColor.fromInt(
                                                            0xffCCCCCC,
                                                          ),
                                                    ),
                                                  ),
                                                  padding:
                                                      const pw.EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6,
                                                      ),
                                                  child: pw.Text(
                                                    "${doctorAppointmentDetailsClass.prescription!.medicine![i].time![j].tTime}",
                                                    style: const pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColors.black,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 15),
                                pw.Text(
                                  "Consume it for ${doctorAppointmentDetailsClass.prescription!.medicine![i].repeatDays} Days",
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff767676),
                                  ),
                                ),
                                pw.SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        );
      }
    }

    pdfBytes = await pdf.save();
    isDataLoaded.value = true;

    update();
  }

  savePdf12(BuildContext context) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      // hideValue:controller.test ? true : false,
      backgroundColor: AppColors.WHITE,
      barrierDismissible: true,
      max: 100,
      msg: 'pdf_downloading'.tr,
      msgColor: AppColors.LIGHT_GREY_TEXT,
      progressType: ProgressType.valuable,
      completed: Completed(
        completedMsg: "downloading_done".tr,
        completedImage: const AssetImage(AppImages.doneIcon),
      ),
    );
    if (int.parse(androidInfo.version.release.toString()) < 12) {
      bool isPermission = await Permission.storage.request().isGranted;

      var fileName = "prescription_${doctorAppointmentDetailsClass.data!.id}";
      String path = "";
      final path1 = await getDownloadsDirectory();
      path = "$path1/$fileName.pdf";
      File file = await File(path).writeAsBytes(await pdf.save());
      // if (await file.exists()) {
      //   await file.delete();
      // }
      // var raf = file.openSync(mode: FileMode.write);
      // raf.writeFromSync(List.from(await pdf.save()));
      // await raf.close();
      pd.update(value: 100);
    } else {
      var fileName = "prescription_${doctorAppointmentDetailsClass.data!.id}";
      String path;
      path = await ExternalPath.getExternalStoragePublicDirectory(
        "${ExternalPath.DIRECTORY_DOWNLOAD}/$fileName.pdf",
      );
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(List.from(await pdf.save()));
      await raf.close();
      pd.update(value: 100);
    }
  }

  savePdf1(BuildContext context) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      backgroundColor: AppColors.WHITE,
      barrierDismissible: true,
      max: 100,
      msg: 'pdf_downloading'.tr,
      msgColor: AppColors.LIGHT_GREY_TEXT,
      progressType: ProgressType.valuable,
      completed: Completed(
        completedMsg: "downloading_done".tr,
        completedImage: const AssetImage(AppImages.doneIcon),
      ),
    );

    if (Platform.isAndroid) {
      try {
        var fileName =
            "prescription_${doctorAppointmentDetailsClass.data!.id}.pdf";

        File file = File('/storage/emulated/0/Download/$fileName');
        if (await file.exists()) {
          await file.delete();
        }
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(List.from(await pdf.save()));
        await raf.close();
        pd.update(value: 100);
      } on Exception catch (e) {
        pd.update(value: 100);
        errorDialog(message: e.toString());
      }
    } else {
      try {
        var fileName =
            "prescription_${doctorAppointmentDetailsClass.data!.id}.pdf";

        Directory directory = await getApplicationDocumentsDirectory();

        File file = File('${directory.path}/$fileName');
        if (await file.exists()) {
          await file.delete();
        }
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(List.from(await pdf.save()));
        await raf.close();
        pd.update(value: 100);
      } on Exception catch (e) {
        pd.update(value: 100);
        errorDialog(message: e.toString());
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    callApi();
  }
}
