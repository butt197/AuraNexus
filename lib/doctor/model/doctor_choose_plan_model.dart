class GetSubscriptionPlanClass {
  GetSubscriptionPlanClass({this.status, this.msg, this.data});

  int? status;
  String? msg;
  PlanData? data;

  factory GetSubscriptionPlanClass.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionPlanClass(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : PlanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class PlanData {
  PlanData({this.data, this.currency});

  List<Datum>? data;
  String? currency;

  factory PlanData.fromJson(Map<String, dynamic> json) => PlanData(
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    currency: json["currency"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "currency": currency,
  };
}

class Datum {
  Datum({
    this.id,
    this.planName,
    this.month,
    this.price,
    this.planDetails,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? planName;
  int? month;
  int? price;
  String? planDetails;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] is int
        ? json["id"]
        : int.tryParse(json["id"]?.toString() ?? ""),
    planName: json["plan_name"]?.toString(),
    month: json["month"] is int
        ? json["month"]
        : int.tryParse(json["month"]?.toString() ?? ""),
    price: json["price"] is int
        ? json["price"]
        : int.tryParse(json["price"]?.toString() ?? ""),
    planDetails: json["plan_details"]?.toString(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_name": planName,
    "month": month,
    "price": price,
    "plan_details": planDetails,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
