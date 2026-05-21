class MakeAppointmentClass {
  String? success;
  String? register;
  List<MAData>? data;

  MakeAppointmentClass({this.success, this.register, this.data});

  MakeAppointmentClass.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    register = json['register'];
    if (json['data'] != null) {
      data = <MAData>[];
      json['data'].forEach((v) {
        data!.add(new MAData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MAData {
  String? title;
  List<Slottime>? slottime;

  MAData({this.title, this.slottime});

  MAData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['slottime'] != null) {
      slottime = <Slottime>[];
      json['slottime'].forEach((v) {
        slottime!.add(new Slottime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.slottime != null) {
      data['slottime'] = this.slottime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slottime {
  int? id;
  String? name;
  String? isBook;

  Slottime({this.id, this.name, this.isBook});

  Slottime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    isBook = json['is_book'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_book'] = this.isBook;
    return data;
  }
}

class MakeAppointmentClass1 {
  String? success;
  String? register;
  List<MAData>? data;

  MakeAppointmentClass1({this.success, this.register, this.data});

  MakeAppointmentClass1.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    register = json['msg'];
    if (json['data'] != null) {
      data = <MAData>[];
      json['data'].forEach((v) {
        data!.add(new MAData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.register;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


