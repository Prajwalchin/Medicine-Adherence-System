// To parse this JSON data, do
//
//     final dashboardAnalytics = dashboardAnalyticsFromJson(jsonString);

import 'dart:convert';

DashboardAnalyticsModel dashboardAnalyticsFromJson(String str) => DashboardAnalyticsModel.fromJson(json.decode(str));

String dashboardAnalyticsToJson(DashboardAnalyticsModel data) => json.encode(data.toJson());

class DashboardAnalyticsModel {
    Map<String, int>? adherenceMatrix;
    Map<String, DetailedMatrix>? detailedMatrix;

    DashboardAnalyticsModel({
        this.adherenceMatrix,
        this.detailedMatrix,
    });

    factory DashboardAnalyticsModel.fromJson(Map<String, dynamic> json) => DashboardAnalyticsModel(
        adherenceMatrix: Map.from(json["adherenceMatrix"]!).map((k, v) => MapEntry<String, int>(k, v)),
        detailedMatrix: Map.from(json["detailedMatrix"]!).map((k, v) => MapEntry<String, DetailedMatrix>(k, DetailedMatrix.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "adherenceMatrix": Map.from(adherenceMatrix!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "detailedMatrix": Map.from(detailedMatrix!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class DetailedMatrix {
    DateTime? date;
    int? total;
    int? taken;
    int? percentage;

    DetailedMatrix({
        this.date,
        this.total,
        this.taken,
        this.percentage,
    });

    factory DetailedMatrix.fromJson(Map<String, dynamic> json) => DetailedMatrix(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        total: json["total"],
        taken: json["taken"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "total": total,
        "taken": taken,
        "percentage": percentage,
    };
}
