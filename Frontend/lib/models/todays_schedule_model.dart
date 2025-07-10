import 'dart:convert';

TodaysScheduleModel todaysScheduleFromJson(String str) => TodaysScheduleModel.fromJson(json.decode(str));

String todaysScheduleToJson(TodaysScheduleModel data) => json.encode(data.toJson());

class TodaysScheduleModel {
  DateTime? date;
  int? totalIntakes;
  int? takenIntakes;
  int? missedIntakes;
  int? upcomingIntakes;
  List<Schedule>? schedule;

  TodaysScheduleModel({
    this.date,
    this.totalIntakes,
    this.takenIntakes,
    this.missedIntakes,
    this.upcomingIntakes,
    this.schedule,
  });

  factory TodaysScheduleModel.fromJson(Map<String, dynamic> json) => TodaysScheduleModel(
        date: json["date"] != null 
            ? DateTime.parse(json["date"]).toLocal() // ✅ Converts to IST
            : null,
        totalIntakes: json["total_intakes"],
        takenIntakes: json["taken_intakes"],
        missedIntakes: json["missed_intakes"],
        upcomingIntakes: json["upcoming_intakes"],
        schedule: json["schedule"] == null
            ? []
            : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "total_intakes": totalIntakes,
        "taken_intakes": takenIntakes,
        "missed_intakes": missedIntakes,
        "upcoming_intakes": upcomingIntakes,
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
      };
}

class Schedule {
  int? intakeId;
  String? medicineName;
  DateTime? scheduledAt;
  dynamic takenAt;
  String? status;
  String? timing;
  String? medtype;
  int? pillcount;

  Schedule({
    this.intakeId,
    this.medicineName,
    this.scheduledAt,
    this.takenAt,
    this.status,
    this.timing,
    this.medtype,
    this.pillcount,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        intakeId: json["intake_id"],
        medicineName: json["medicine_name"],
        scheduledAt: json["scheduled_at"] != null 
            ? DateTime.parse(json["scheduled_at"]).toLocal() // ✅ Converts to IST
            : null,
        takenAt: json["taken_at"],
        status: json["status"],
        timing: json["timing"],
        medtype: json["medtype"],
        pillcount: json["pillcount"],
      );

  Map<String, dynamic> toJson() => {
        "intake_id": intakeId,
        "medicine_name": medicineName,
        "scheduled_at": scheduledAt?.toIso8601String(),
        "taken_at": takenAt,
        "status": status,
        "timing": timing,
        "medtype": medtype,
        "pillcount": pillcount,
      };
}
