// To parse this JSON data, do
//
//     final medicationCourseModel = medicationCourseModelFromJson(jsonString);

import 'dart:convert';

MedicationCourseModel medicationCourseModelFromJson(String str) =>
    MedicationCourseModel.fromJson(json.decode(str));

String medicationCourseModelToJson(MedicationCourseModel data) =>
    json.encode(data.toJson());

class MedicationCourseModel {
  List<Course>? courses;

  MedicationCourseModel({
    this.courses,
  });

  factory MedicationCourseModel.fromJson(Map<String, dynamic> json) =>
      MedicationCourseModel(
        courses: json["courses"] == null
            ? []
            : List<Course>.from(
                json["courses"]!.map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "courses": courses == null
            ? []
            : List<dynamic>.from(courses!.map((x) => x.toJson())),
      };
}

class Course {
  int? courseId;
  int? doctorId;
  String? doctorName;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<MedicineCourse>? medicineCourses;

  Course({
    this.courseId,
    this.doctorId,
    this.doctorName,
    this.status,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.medicineCourses,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseId: json["course_id"],
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        status: json["status"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        medicineCourses: json["medicine_courses"] == null
            ? []
            : List<MedicineCourse>.from(json["medicine_courses"]!
                .map((x) => MedicineCourse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "status": status,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "medicine_courses": medicineCourses == null
            ? []
            : List<dynamic>.from(medicineCourses!.map((x) => x.toJson())),
      };
}

class MedicineCourse {
  int? medicineCourseId;
  String? medicineName;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  String? frequency;
  String? medtype;
  int? pillcount;
  DateTime? createdAt;
  DateTime? updatedAt;
  Adherence? adherence;

  MedicineCourse({
    this.medicineCourseId,
    this.medicineName,
    this.status,
    this.startDate,
    this.endDate,
    this.frequency,
    this.medtype,
    this.pillcount,
    this.createdAt,
    this.updatedAt,
    this.adherence,
  });

  factory MedicineCourse.fromJson(Map<String, dynamic> json) => MedicineCourse(
        medicineCourseId: json["medicine_course_id"],
        medicineName: json["medicine_name"],
        status: json["status"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        frequency: json["frequency"],
        medtype: json["medtype"],
        pillcount: json["pillcount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        adherence: json["adherence"] == null
            ? null
            : Adherence.fromJson(json["adherence"]),
      );

  Map<String, dynamic> toJson() => {
        "medicine_course_id": medicineCourseId,
        "medicine_name": medicineName,
        "status": status,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "frequency": frequency,
        "medtype": medtype,
        "pillcount": pillcount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "adherence": adherence?.toJson(),
      };
}

class Adherence {
  int? totalIntakes;
  int? takenIntakes;
  int? percentage;

  Adherence({
    this.totalIntakes,
    this.takenIntakes,
    this.percentage,
  });

  factory Adherence.fromJson(Map<String, dynamic> json) => Adherence(
        totalIntakes: json["total_intakes"],
        takenIntakes: json["taken_intakes"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "total_intakes": totalIntakes,
        "taken_intakes": takenIntakes,
        "percentage": percentage,
      };
}
