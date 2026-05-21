class UploadImageModel {
  int? status;
  String? message;
  UploadImageData? data;

  UploadImageModel({this.status, this.message, this.data});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UploadImageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UploadImageData {
  String? name;
  String? appointmentId;
  String? image;
  String? updatedAt;
  String? createdAt;
  int? id;

  UploadImageData(
      {this.name,
        this.appointmentId,
        this.image,
        this.updatedAt,
        this.createdAt,
        this.id});

  UploadImageData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    appointmentId = json['appointment_id'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['appointment_id'] = this.appointmentId;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class ReportDeleteRes {
  int? status;
  String? message;

  ReportDeleteRes({this.status, this.message});

  ReportDeleteRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}


