// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    String? name;
    int? phone;
    String? email;
    String? address;
    String? language;
    String? role;

    ProfileModel({
        this.name,
        this.phone,
        this.email,
        this.address,
        this.language,
        this.role,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        language: json["language"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "language": language,
        "role": role,
    };
}
