import 'package:videocalling/doctor/model/doctor_slot_details_model.dart';

class DoctorScheduleDetails {
  String? success;
  String? register;
  List<DSData>? data;

  DoctorScheduleDetails({this.success, this.register, this.data});

  DoctorScheduleDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    register = json['register'];
    if (json['data'] != null) {
      data = <DSData>[];
      json['data'].forEach((v) {
        data!.add(new DSData.fromJson(v));
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

class DSData {
  int? id;
  int? doctorId;
  int? dayId;
  String? startTime;
  String? endTime;
  String? duration;
  String? createdAt;
  String? updatedAt;
  List<Getslotls>? getslotls;

  DSData(
      {this.id,
      this.doctorId,
      this.dayId,
      this.startTime,
      this.endTime,
      this.duration,
      this.createdAt,
      this.updatedAt,
      this.getslotls});

  DSData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    dayId = json['day_id'];
    startTime = json['start_time'].toString();
    endTime = json['end_time'].toString();
    duration = json['duration'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['getslotls'] != null) {
      getslotls = <Getslotls>[];
      json['getslotls'].forEach((v) {
        getslotls!.add(new Getslotls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['day_id'] = this.dayId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.getslotls != null) {
      data['getslotls'] = this.getslotls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


