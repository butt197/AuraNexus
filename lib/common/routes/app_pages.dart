import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: _Paths.splashScreen,
      page: () => Builder(builder: (context) => SplashScreen()),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.doctorTabScreen,
      page: () => const DoctorTabsScreen(),
      binding: TabScreenBinding(),
    ),
    GetPage(
      name: _Paths.videoPlayerScreen,
      page: () => MyVideoPlayer(),
      binding: MyVideoPlayerBinding(),
    ),
    GetPage(
      name: _Paths.photoViewerScreen,
      page: () => MyPhotoViewer(),
      binding: MyPhotoViewerBinding(),
    ),
    GetPage(
      name: _Paths.chatScreen,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.uAppointmentPdfScreen,
      page: () => AppointmentDetailsScreenPdf(),
      binding: AppointmentDetailsScreenPdfBinding(),
    ),
    GetPage(
      name: _Paths.incomingCallScreen,
      page: () => IncomingCallScreen(),
      binding: IncomingCallBinding(),
    ),
    // GetPage(
    //   name: _Paths.uAppointmentPdfScreen,
    //   page: () => AppointmentDetailsScreenPdf(),
    //   binding: AppointmentDetailsScreenPdfBinding(),
    // ),

    /// doctor side screen
    GetPage(
      name: _Paths.doctorRegisterScreen,
      page: () => RegisterAsDoctor(),
      binding: DoctorRegisterBinding(),
    ),
    GetPage(
      name: _Paths.chooseYourPlanScreen,
      page: () => DoctorChooseYourPlanScreen(),
      binding: DoctorChooseYourPlanBinding(),
    ),
    GetPage(
      name: _Paths.dMyPhotoViewerScreen,
      page: () => DMyPhotoView(),
      binding: DMyPhotoViewBinding(),
    ),
    GetPage(
      name: _Paths.dChangePasswordScreen,
      page: () => ChangePassword(),
      binding: DChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.dSubscriptionListScreen,
      page: () => SubscriptionListScreen(),
      binding: SubscriptionListBinding(),
    ),
    GetPage(
      name: _Paths.dIncomeReportScreen,
      page: () => IncomeReportScreen(),
      binding: IncomeReportBinding(),
    ),
    GetPage(
      name: _Paths.dBankDetailsScreen,
      page: () => BankDetailScreen(),
      binding: BankDetailBinding(),
    ),
    GetPage(
      name: _Paths.dAllAppointmentsScreen,
      page: () => DoctorAllAppointments(),
      binding: DAllAppointmentsBinding(),
    ),
    GetPage(
      name: _Paths.dAppointmentDetailScreen,
      page: () => DoctorAppointmentDetails(),
      binding: DAppointmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.dSearchMedicineScreen,
      page: () => SearchMedicineScreen(),
      binding: SearchMedicineBinding(),
    ),
    GetPage(
      name: _Paths.dStepThreeDetailScreen,
      page: () => StepThreeDetailsScreen(),
      binding: StepThreeDetailsBinding(),
    ),
    GetPage(
      name: _Paths.dHolidayManageScreen,
      page: () => ManageHolidayScreen(),
      binding: HolidayManageBinding(),
    ),
    // GetPage(
    //   name: _Paths.dSearchMedicineScreen,
    //   page: () => MedicinseScreen(),
    //   binding: AddMedicineToAppointmentBinding(),
    // ),

    /// patient side screen
    GetPage(
      name: _Paths.userTabScreen,
      page: () => const PatientTabsScreen(),
      binding: PatientTabScreenBinding(),
    ),
    GetPage(
      name: _Paths.termsAndConditionScreen,
      page: () => TermAndConditions(),
      binding: TermAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.aboutUSScreen,
      page: () => AboutUSScreen(),
      binding: AboutUSBinding(),
    ),
    GetPage(
      name: _Paths.reportIssuesScreen,
      page: () => ReportIssuesScreen(),
      binding: ReportIssueBinding(),
    ),
    GetPage(
      name: _Paths.editProfileScreen,
      page: () => UserEditProfile(),
      binding: UserEditBinding(),
    ),
    GetPage(
      name: _Paths.specialityScreen,
      page: () => SpecialityScreen(),
      binding: SpecialityBinding(),
    ),
    GetPage(
      name: _Paths.specialityDoctorScreen,
      page: () => SpecialityDoctorScreen(),
      binding: SpecialityDoctorBinding(),
    ),
    GetPage(
      name: _Paths.doctorDetailScreen,
      page: () => DoctorDetailScreen(),
      binding: DoctorDetailBinding(),
    ),
    GetPage(
      name: _Paths.doctorReviewScreen,
      page: () => ReviewsScreen(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.forgetPasswordScreen,
      page: () => ForgetPassword(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.loginUserScreen,
      page: () => LoginAsUser(),
      binding: UserLoginBinding(),
    ),
    GetPage(
      name: _Paths.makeAppointmentScreen,
      page: () => MakeAppointment(),
      binding: MakeAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.inAppWebViewScreen,
      page: () => InAppWebViewScreen(),
      binding: InAppWebViewBinding(),
    ),
    GetPage(
      name: _Paths.patientRegisterScreen,
      page: () => RegisterAsPatient(),
      binding: RegisterPatientBinding(),
    ),
    GetPage(
      name: _Paths.uAppointmentDetailScreen,
      page: () => UserAppointmentDetailsScreen(),
      binding: UserAppointmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.uAllAppointmentsScreen,
      page: () => UAllAppointments(),
      binding: UAllAppointmentsBinding(),
    ),
    GetPage(
      name: _Paths.dAllNearbyScreen,
      page: () => DAllNearbyScreen(),
      binding: DAllNearbyBinding(),
    ),
    GetPage(
      name: _Paths.dSearchScreen,
      page: () => DoctorSearchScreen(),
      binding: DoctorSearchBinding(),
    ),
  ];
}


