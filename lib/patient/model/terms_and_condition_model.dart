class TermsData {
  int? status;
  String? msg;
  TData? data;

  TermsData({this.status, this.msg, this.data});

  TermsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new TData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TData {
  int? id;
  String? about;
  String? trems;
  String? privacy;
  String? dataDeletion;
  String? createdAt;
  String? updatedAt;

  TData(
      {this.id,
      this.about,
      this.trems,
      this.privacy,
      this.dataDeletion,
      this.createdAt,
      this.updatedAt});

  TData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    about = json['about'];
    trems = json['trems'];
    privacy = json['privacy'];
    dataDeletion = json['data_deletion'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['about'] = this.about;
    data['trems'] = this.trems;
    data['privacy'] = this.privacy;
    data['data_deletion'] = this.dataDeletion;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


