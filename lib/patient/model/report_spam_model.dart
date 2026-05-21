class ReportSpamData {
  int? success;
  String? register;
  RData? data;

  ReportSpamData({this.success, this.register, this.data});

  ReportSpamData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    register = json['register'];
    data = json['data'] != null ? new RData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RData {
  int? userId;
  String? title;
  dynamic description;
  String? updatedAt;
  String? createdAt;
  int? id;

  RData(
      {this.userId,
      this.title,
      this.description,
      this.updatedAt,
      this.createdAt,
      this.id});

  RData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}


