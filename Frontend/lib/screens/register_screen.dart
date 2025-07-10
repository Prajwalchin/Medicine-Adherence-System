// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/api/api_provider.dart';
import 'package:healthmobi/utilities/notify.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusable/constant.dart';
import 'tab_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedMotherTongue;

  final List<String> motherTongues = ['Hindi', 'Marathi', 'English'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Form(
                  key: formKey,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Join the HealthMobi Network",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              color: fontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 24.sp,
                            ),
                          ),
                          Text(
                            "Stay on track with your medications, effortlessly.",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              color: fontgrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Full Name
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Mother Tongue (Dropdown)
                          FormField<String>(
                            validator: (value) {
                              if (value == null) {
                                return "Select your mother tongue";
                              }
                              return null;
                            },
                            builder: (state) => Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      value: selectedMotherTongue,
                                      hint: Text(
                                        'Mother Tongue',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedMotherTongue = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: motherTongues.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                if (state.hasError)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? '',
                                      style: GoogleFonts.roboto(
                                        color: Colors.redAccent.shade700,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Care taker phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          // Address Field
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: "Address",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                String? response =
                                    await ref.read(apiProvider).register(
                                          name: nameController.text,
                                          email: emailController.text,
                                          address: addressController.text,
                                          motherTongue: selectedMotherTongue!,
                                        );
                                if (response != null) {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool('loginData', true);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabsScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  notify(
                                      text:
                                          "Something went wrong!, Please try again",
                                      context: context);
                                }
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => TabsScreen(),
                                //   ),
                                //   (route) => false,
                                // );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Register",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
