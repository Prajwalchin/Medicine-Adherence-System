// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:resize/resize.dart';

import '../api/api_provider.dart';
import '../reusable/constant.dart';
import '../utilities/notify.dart';
import 'otp_screen.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing the dialog
    builder: (ctx) => PopScope(
      canPop: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

class LogoScreen extends ConsumerStatefulWidget {
  const LogoScreen({super.key});

  @override
  ConsumerState<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends ConsumerState<LogoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  bool isNumberValid = false;
  final FocusNode focusNode = FocusNode();

  login() async {
    var api = ref.read(apiProvider);
    print(controller.text);
    showLoadingIndicator(context);
    String? response =
        await api.doLogin(phoneNumber: controller.text.replaceAll(' ', ''));
    Navigator.pop(context);
    if (response == null) {
      notify(
        text: 'Something went wrong, Please try agian later',
        context: context,
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OtpScreen(phoneNumber: controller.text.replaceAll(' ', ''))));
    }
  }

  showLoginModal() {
    showModalBottomSheet(
        elevation: 10,
        useSafeArea: true,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          PhoneNumber number = PhoneNumber(isoCode: 'IN');
          return StatefulBuilder(
            builder: (context, setState) {
              void onPhoneNumberChanged(PhoneNumber number) {
                // Add validation logic
                bool isValid = number.phoneNumber != null &&
                    number.phoneNumber!.length >= 10;
                setState(() {
                  isNumberValid = isValid; // Update validation status
                });
              }

              return PopScope(
                canPop: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20)), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(64),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
                    ),
                    child: Form(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          SizedBox(height: 25.h),
                          Text(
                            "Welcome to HealthMobi",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              color: fontColor, 
                              fontWeight: FontWeight.w500,
                              fontSize: 24.sp,
                            ),
                          ),
                          Text(
                            "We use your phone number to send a secure OTP (One-Time Password) for verifying your identity.",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              color: fontgrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          InternationalPhoneNumberInput(
                            onInputChanged: onPhoneNumberChanged,
                            onInputValidated: (bool value) {
                              setState(() {
                                isNumberValid = value;
                              });
                            },
                            ignoreBlank: true,
                            autoValidateMode: AutovalidateMode.onUnfocus,
                            selectorTextStyle:
                                GoogleFonts.roboto(color: Colors.black),
                            initialValue: number,
                            textFieldController: controller,
                            formatInput: true,
                            focusNode: focusNode,
                            keyboardType: TextInputType.phone,
                            inputBorder: UnderlineInputBorder(),
                          ),
                          Container(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isNumberValid ? login : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    disabledBackgroundColor: grey,
                                    fixedSize: Size(double.infinity, 50.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    "Continue",
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
            },
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoginModal();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: Text(
                  "HealthMobi",
                  style: GoogleFonts.roboto(
                    color: fontColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 36.sp,
                  ),
                ),
              ),
              Spacer(),
              // Center Section
              Image.asset(
                'assets/images/chatbot_logo.png',
                width: 500.w,
                height: 500.h,
              ),
              Spacer(),
              SizedBox(height: 200.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
