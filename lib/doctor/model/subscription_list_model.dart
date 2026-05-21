class SubscriptionListModel {
  SubscriptionListModel({this.status, this.register, this.success, this.data});

  String? status;
  String? register;
  String? success;
  SubscriptionListData? data;

  factory SubscriptionListModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionListModel(
        status: json["status"],
        register: json["register"],
        success: json["success"],
        data: SubscriptionListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "register": register,
    "success": success,
    "data": data!.toJson(),
  };
}

class SubscriptionListData {
  SubscriptionListData({this.doctorsSubscription});

  List<DoctorsSubscription>? doctorsSubscription;

  factory SubscriptionListData.fromJson(Map<String, dynamic> json) =>
      SubscriptionListData(
        doctorsSubscription: List<DoctorsSubscription>.from(
          json["doctors_subscription"].map(
            (x) => DoctorsSubscription.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "doctors_subscription": List<dynamic>.from(
      doctorsSubscription!.map((x) => x.toJson()),
    ),
  };
}

class DoctorsSubscription {
  DoctorsSubscription({
    this.status,
    this.planName,
    this.planDetails,
    this.month,
    this.price,
    this.date,
  });

  int? status;
  String? planName;
  String? planDetails;
  String? month;
  int? price;
  DateTime? date;

  factory DoctorsSubscription.fromJson(Map<String, dynamic> json) =>
      DoctorsSubscription(
        status: json["status"],
        planName: json["plan_name"],
        planDetails: json["plan_details"],
        month: json["month"]?.toString(),
        price: json["price"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "plan_name": planName,
    "plan_details": planDetails,
    "month": month,
    "price": price,
    "date": date == null ? DateTime.now() : date!.toIso8601String(),
  };
}
