class DoctorAppointmentDetailsClass {
  int? success;
  Prescription? prescription;
  String? register;
  String? prescription1;
  Data? data;
  List<PrescriptionImage>? image;

  DoctorAppointmentDetailsClass({this.success, this.prescription, this.register, this.data, this.image});

  DoctorAppointmentDetailsClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    register = json['register'];
    if(json['prescription'].runtimeType == String){
      prescription1 = json['prescription'];
    }else{
      prescription = new Prescription.fromJson(json['prescription']);
    }
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['image'] != null) {
      image = <PrescriptionImage>[];
      json['image'].forEach((v) {
        image!.add(new PrescriptionImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.prescription != null) {
      data['prescription'] = this.prescription!.toJson();
    }
    if (this.prescription1.toString() != "null") {
      data['prescription'] = this.prescription1;
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorAppointmentDetailsClass1 {
  int? success;
  Prescription? prescription;
  String? register;
  String? prescription1;
  Data? data;
  List<PrescriptionImage>? image;
  Doctor? doctor;

  DoctorAppointmentDetailsClass1({this.success, this.prescription, this.register, this.data, this.image});

  DoctorAppointmentDetailsClass1.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    register = json['register'];
    if(json['prescription'].runtimeType == String){
      prescription1 = json['prescription'];
    }else{
      prescription = new Prescription.fromJson(json['prescription']);
    }
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['image'] != null) {
      image = <PrescriptionImage>[];
      json['image'].forEach((v) {
        image!.add(new PrescriptionImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.prescription != null) {
      data['prescription'] = this.prescription!.toJson();
    }
    if (this.prescription1.toString() != "null") {
      data['prescription'] = this.prescription1;
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prescription {
  List<Medicine>? medicine;

  Prescription({this.medicine});

  Prescription.fromJson(Map<String, dynamic> json) {
    if (json['medicine'] != null) {
      medicine = <Medicine>[];
      json['medicine'].forEach((v) {
        medicine!.add(new Medicine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicine != null) {
      data['medicine'] = this.medicine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicine {
  int? medicineId;
  int? repeatDays;
  List<Time>? time;
  dynamic dosage;
  dynamic type;
  String? medicine_name;

  Medicine(
      {this.medicineId, this.repeatDays, this.time, this.dosage, this.type,this.medicine_name});

  Medicine.fromJson(Map<String, dynamic> json) {
    medicineId = json['medicine_id'];
    repeatDays = json['repeat_days'];
    medicine_name = json['medicine_name'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(new Time.fromJson(v));
      });
    }
    dosage = json['dosage'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine_id'] = this.medicineId;
    data['repeat_days'] = this.repeatDays;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    data['dosage'] = this.dosage;
    data['type'] = this.type;
    data['medicine_name'] = this.medicine_name;
    return data;
  }
}

class Time {
  String? tTime;

  Time({this.tTime});

  Time.fromJson(Map<String, dynamic> json) {
    tTime = json['t_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['t_time'] = this.tTime;
    return data;
  }
}

class Data {
  String? doctorImage;
  String? doctorName;
  String? userImage;
  String? userName;
  int? status;
  int? doctorId;
  int? userId;
  String? date;
  String? slot;
  dynamic phone;
  String? email;
  String? description;
  dynamic connectycubeUserId;
  dynamic id;
  String? prescription;
  List<DeviceToken>? deviceToken;
  String? remainTime;
  int? isAppointmentTime;

  Data(
      {this.doctorImage,
        this.doctorName,
        this.userImage,
        this.userName,
        this.status,
        this.doctorId,
        this.userId,
        this.date,
        this.slot,
        this.phone,
        this.email,
        this.description,
        this.connectycubeUserId,
        this.id,
        this.prescription,
        this.deviceToken,
        this.remainTime,
        this.isAppointmentTime});

  Data.fromJson(Map<String, dynamic> json) {
    doctorImage = json['doctor_image'];
    doctorName = json['doctor_name'];
    userImage = json['user_image'];
    userName = json['user_name'];
    status = json['status'];
    doctorId = json['doctor_id'];
    userId = json['user_id'];
    date = json['date'];
    slot = json['slot'];
    phone = json['phone'];
    email = json['email'];
    description = json['description'];
    connectycubeUserId = json['connectycube_user_id'];
    id = json['id'];
    prescription = json['prescription'];
    if (json['device_token'] != null) {
      deviceToken = <DeviceToken>[];
      json['device_token'].forEach((v) {
        deviceToken!.add(new DeviceToken.fromJson(v));
      });
    }
    remainTime = json['remain_time'];
    isAppointmentTime = json['is_appointment_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_image'] = this.doctorImage;
    data['doctor_name'] = this.doctorName;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['status'] = this.status;
    data['doctor_id'] = this.doctorId;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['slot'] = this.slot;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['description'] = this.description;
    data['connectycube_user_id'] = this.connectycubeUserId;
    data['id'] = this.id;
    data['prescription'] = this.prescription;
    if (this.deviceToken != null) {
      data['device_token'] = this.deviceToken!.map((v) => v.toJson()).toList();
    }
    data['remain_time'] = this.remainTime;
    data['is_appointment_time'] = this.isAppointmentTime;
    return data;
  }
}

class DeviceToken {
  String? token;
  int? type;

  DeviceToken({this.token, this.type});

  DeviceToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['type'] = this.type;
    return data;
  }
}

class PrescriptionImage {
  int? id;
  int? appointmentId;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;

  PrescriptionImage(
      {this.id,
        this.appointmentId,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt});

  PrescriptionImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    name = json['name'].toString();
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Doctor {
  int? id;
  String? name;
  String? email;
  String? aboutus;
  String? workingTime;
  String? address;
  double? lat;
  double? lon;
  int? phoneno;
  String? services;
  String? healthcare;
  String? image;
  int? departmentId;
  dynamic password;
  String? facebookUrl;
  String? twitterUrl;
  String? createdAt;
  String? updatedAt;
  int? isApprove;
  int? consultationFees;
  String? loginId;
  int? connectycubeUserId;
  dynamic connectycubePassword;
  int? avgratting;
  Departmentls? departmentls;

  Doctor(
      {this.id,
        this.name,
        this.email,
        this.aboutus,
        this.workingTime,
        this.address,
        this.lat,
        this.lon,
        this.phoneno,
        this.services,
        this.healthcare,
        this.image,
        this.departmentId,
        this.password,
        this.facebookUrl,
        this.twitterUrl,
        this.createdAt,
        this.updatedAt,
        this.isApprove,
        this.consultationFees,
        this.loginId,
        this.connectycubeUserId,
        this.connectycubePassword,
        this.avgratting,
        this.departmentls});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    aboutus = json['aboutus'];
    workingTime = json['working_time'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    phoneno = json['phoneno'];
    services = json['services'];
    healthcare = json['healthcare'];
    image = json['image'];
    departmentId = json['department_id'];
    password = json['password'];
    facebookUrl = json['facebook_url'];
    twitterUrl = json['twitter_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApprove = json['is_approve'];
    consultationFees = json['consultation_fees'];
    loginId = json['login_id'];
    connectycubeUserId = json['connectycube_user_id'];
    connectycubePassword = json['connectycube_password'];
    avgratting = json['avgratting'];
    departmentls = json['departmentls'] != null
        ? new Departmentls.fromJson(json['departmentls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['aboutus'] = this.aboutus;
    data['working_time'] = this.workingTime;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['phoneno'] = this.phoneno;
    data['services'] = this.services;
    data['healthcare'] = this.healthcare;
    data['image'] = this.image;
    data['department_id'] = this.departmentId;
    data['password'] = this.password;
    data['facebook_url'] = this.facebookUrl;
    data['twitter_url'] = this.twitterUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_approve'] = this.isApprove;
    data['consultation_fees'] = this.consultationFees;
    data['login_id'] = this.loginId;
    data['connectycube_user_id'] = this.connectycubeUserId;
    data['connectycube_password'] = this.connectycubePassword;
    data['avgratting'] = this.avgratting;
    if (this.departmentls != null) {
      data['departmentls'] = this.departmentls!.toJson();
    }
    return data;
  }
}

class Departmentls {
  int? id;
  String? icon;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? isActive;

  Departmentls(
      {this.id,
        this.icon,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.isActive});

  Departmentls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    return data;
  }
}

