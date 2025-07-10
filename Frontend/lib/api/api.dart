// ignore_for_file: equal_keys_in_map

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmobi/api/api_provider.dart';
import 'package:healthmobi/models/dashboard_analytics_model.dart';
import 'package:healthmobi/models/medication_course_model.dart';
import 'package:healthmobi/models/todays_schedule_model.dart';
import 'package:healthmobi/models/user_model.dart';
import 'package:healthmobi/provider/dashboard_analytics_state_provider.dart';
import 'package:healthmobi/provider/medication_course_provider.dart';
import 'package:healthmobi/provider/medication_course_state_provider.dart';
import 'package:healthmobi/provider/profile_provider.dart';
import 'package:healthmobi/provider/profile_state_provider.dart';
import 'package:healthmobi/provider/quote_provider.dart';
import 'package:healthmobi/provider/quote_state_provider.dart';
import 'package:healthmobi/provider/todays_schedule_state_provider.dart';
import 'package:healthmobi/provider/user_status_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/dashboard_analytics_provider.dart.dart';
import '../provider/todays_schedule_provider.dart';

class ApiService {
  final Ref ref;
  String? authToken;

  ApiService(this.ref);
  static const String aibaseUrl = "http://192.168.249.176:8000";
  // static const String baseUrl = "http://192.168.133.24:3000";
  static const String baseUrl = "https://firstpriority.tech";
  // static const String baseUrl = "http://192.168.183.10:3000";
  var headers = {'Content-Type': 'application/json'};
  var headers1 = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json'
  };
  SharedPreferences? pref;

  Future<String?> doLogin({required String phoneNumber}) async {
    http.Response response;
    String url = '$baseUrl/auth/initializelogin';
    var body = json.encode({"phone": phoneNumber});

    try {
      response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      ref
          .read(userLoginStatusProvider.notifier)
          .setUserLoginStatus(responseData['message']);
      return "success";
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> verifyOtp(
      {required String phoneNumber, required String otp}) async {
    http.Response response;
    String url = '$baseUrl/auth/login';
    var body = json.encode({"phone": phoneNumber, "otp": otp});

    try {
      response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      pref = await SharedPreferences.getInstance();
      pref!.setString('authToken', responseData["authToken"]);
      authToken = responseData["authToken"];
      return 'success';
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> register(
      {required String name,
      required String address,
      required String? email,
      required String motherTongue}) async {
    http.Response response;
    String url = '$baseUrl/auth/complete-registration';
    var body = json.encode({
      "name": name,
      "address": address,
      "email": email,
      "language": motherTongue
    });
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    try {
      response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      pref = await SharedPreferences.getInstance();
      pref!.setBool('loginData', true);
      return 'success';
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> aiBot({required String message}) async {
    http.Response response;
    String aiurl = aibaseUrl;
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    pref ??= await SharedPreferences.getInstance();
    aiurl = pref!.getString('aiurl') ?? aibaseUrl;
    String url = '$aiurl/chat';
    var body = json.encode({"message": message});

    try {
      response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData["response"];
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> uploadPrescription({required String imagePath}) async {
    var headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    };
    pref ??= await SharedPreferences.getInstance();
    authToken = pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/media/uploadPrescription'));

    request.files
        .add(await http.MultipartFile.fromPath('prescription', imagePath));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String body = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(body);
      print('Response Data: $responseData');
      if (responseData["message"]?.toString().toLowerCase() ==
          "Prescription uploaded and processed successfully".toLowerCase()) {
        return "success";
      }
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: $body");
      return "Not prescription";
    }
    return null;
  }

  Future<String?> todaysSchedule() async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/course/todays-schedule';
    // var body = json.encode({"message": message});

    try {
      response = await http.get(Uri.parse(url), headers: headers);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final responseData = json.decode(response.body);
      ref
          .read(todaysScheduleStateProvider.notifier)
          .setTodaysScheduleState(ApiState.done);
      ref
          .read(todaysScheduleProvider.notifier)
          .setTodaysSchedule(todaysScheduleFromJson(response.body));
      return "success";
    } else {
      ref
          .read(todaysScheduleStateProvider.notifier)
          .setTodaysScheduleState(ApiState.error);
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> getDashboardAnalytics() async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/course/last-7-day-matrix';
    // var body = json.encode({"message": message});

    try {
      response = await http.get(Uri.parse(url), headers: headers);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final responseData = json.decode(response.body);
      ref
          .read(dashboardAnalyticsStateProvider.notifier)
          .setDashboardAnalyticsState(ApiState.done);
      ref
          .read(dashboardAnalyticsProvider.notifier)
          .setDashboardAnalytics(dashboardAnalyticsFromJson(response.body));
      return "success";
    } else {
      ref
          .read(dashboardAnalyticsStateProvider.notifier)
          .setDashboardAnalyticsState(ApiState.error);
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> getQuote() async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/general/quote';
    // var body = json.encode({"message": message});

    try {
      response = await http.get(Uri.parse(url), headers: headers);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      ref.read(quoteStateProvider.notifier).setQuoteState(ApiState.done);
      ref.read(quoteProvider.notifier).setQuote(responseData["quote"]);
      return "success";
    } else {
      ref.read(quoteStateProvider.notifier).setQuoteState(ApiState.error);
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> getProfile() async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/user-feature/profile';
    // var body = json.encode({"message": message});

    try {
      response = await http.get(Uri.parse(url), headers: headers);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final responseData = json.decode(response.body);
      ref.read(profileStateProvider.notifier).setProfileState(ApiState.done);
      ref
          .read(profileProvider.notifier)
          .setProfile(profileModelFromJson(response.body));
      return "success";
    } else {
      ref.read(quoteStateProvider.notifier).setQuoteState(ApiState.error);
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> getMedicationCourse() async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/course/medication-courses';
    // var body = json.encode({"message": message});

    try {
      response = await http.get(Uri.parse(url), headers: headers);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final responseData = json.decode(response.body);
      ref
          .read(medicationCourseStateProvider.notifier)
          .setMedicationCourseState(ApiState.done);
      ref
          .read(medicationCourseProvider.notifier)
          .setMedicationCourse(medicationCourseModelFromJson(response.body));
      return "success";
    } else {
      ref
          .read(medicationCourseStateProvider.notifier)
          .setMedicationCourseState(ApiState.error);
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }

  Future<String?> takeMedicine(int intakeId) async {
    http.Response response;
    pref ??= await SharedPreferences.getInstance();
    authToken ??= pref!.getString('authToken');
    headers.addEntries([MapEntry('Authorization', 'Bearer $authToken')]);
    String url = '$baseUrl/course/take-medicine';
    var body = json.encode({"intake_id": intakeId});

    try {
      response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } on Exception catch (e) {
      print("Exception $e");
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("respose $response.body");
      return "success";
    } else {
      print("Error Status Code: ${response.statusCode}");
      print("Error Body: ${response.body}");
      return null;
    }
  }
}
