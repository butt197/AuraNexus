class SearchDoctorClass {
  int? status;
  String? msg;
  SDData? data;

  SearchDoctorClass({this.status, this.msg, this.data});

  SearchDoctorClass.fromJson(Map<String, dynamic> json) {
    status = int.parse(json['status'].toString());
    msg = json['msg'];
    data = json['data'] != null ? new SDData.fromJson(json['data']) : null;
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

class SDData {
  int? currentPage;
  List<SDoctorData>? doctorData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<SDLinks>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  SDData(
      {this.currentPage,
      this.doctorData,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  SDData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      doctorData = <SDoctorData>[];
      json['data'].forEach((v) {
        doctorData!.add(new SDoctorData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <SDLinks>[];
      json['links'].forEach((v) {
        links!.add(new SDLinks.fromJson(v));
      });
    }
    nextPageUrl =
        json['next_page_url'] == null ? "null" : json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.doctorData != null) {
      data['data'] = this.doctorData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class SDoctorData {
  int? id;
  String? name;
  String? address;
  String? image;
  int? departmentId;
  String? departmentName;

  SDoctorData(
      {this.id,
      this.name,
      this.address,
      this.image,
      this.departmentId,
      this.departmentName});

  SDoctorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    departmentId = json['department_id'] is String ? 0 : json['department_id'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    return data;
  }
}

class SDLinks {
  String? url;
  String? label;
  bool? active;

  SDLinks({this.url, this.label, this.active});

  SDLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'] == null ? "" : json['url'];
    label = json['label'].toString();
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}


