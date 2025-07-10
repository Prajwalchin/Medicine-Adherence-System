// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/provider/user_status_provider.dart';
import 'package:healthmobi/screens/register_screen.dart';
import 'package:resize/resize.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_provider.dart';
import '../reusable/constant.dart';
import '../utilities/notify.dart';
import 'logo_screen.dart';
import 'tab_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  bool otpEntered = false;
  String otp = '';

  verifyOtp() async {
    showLoadingIndicator(context);

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => RegisterScreen(
    //               phoneNumber: widget.phoneNumber,
    //             )));
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const TabsScreen()),
    //     (Route<dynamic> route) => false);
    var api = ref.read(apiProvider);
    String? response =
        await api.verifyOtp(phoneNumber: widget.phoneNumber, otp: otp);
    if (response == null) {
      Navigator.pop(context);
      notify(
        text: 'Invalid OTP',
        context: context,
      );
    } else {
      Navigator.pop(context);
      if (ref.read(userLoginStatusProvider)?.toLowerCase() == 'otp sent') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loginData', true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TabsScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Form(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please wait..",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    color: fontColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                ),
                Text(
                  "We will auto verify the OTP\nsent to ${widget.phoneNumber}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    color: fontColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                OtpTextField(
                  numberOfFields: 4,
                  autoFocus: true,
                  fieldWidth: 60.w,
                  decoration: InputDecoration(
                      hintStyle: GoogleFonts.roboto(fontSize: 35.sp)),
                  enabledBorderColor: grey,
                  focusedBorderColor: primaryColor,
                  textStyle: GoogleFonts.roboto(fontSize: 24.sp),
                  onCodeChanged: (String verificationCode) {
                    if (verificationCode.length == 4) {
                      setState(() {
                        otpEntered = true;
                        otp = verificationCode;
                      });
                    } else {
                      setState(() {
                        otpEntered = false;
                        otp = '';
                      });
                    }
                  },
                  onSubmit: (String verificationCode) {
                    setState(() {
                      otpEntered = true;
                      otp = verificationCode;
                    });
                    verifyOtp();
                  },
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: otpEntered ? verifyOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: grey,
                          fixedSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          "Verify",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
