import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/reusable/constant.dart';
import 'package:healthmobi/screens/pillbox_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class AddPrescriptionScreen extends ConsumerStatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  ConsumerState<AddPrescriptionScreen> createState() =>
      _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends ConsumerState<AddPrescriptionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _selectedImage;
  bool _isCameraInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController =
            CameraController(_cameras![0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    setState(() => _isLoading = true);
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        print('Capturing image...');
        final XFile image = await _cameraController!.takePicture();
        setState(() => _selectedImage = image);
        print('Image captured: ${image.path}');

        // Call the API to upload the prescription
        String? response = await ref
            .read(apiProvider)
            .uploadPrescription(imagePath: image.path);
        if (response == "Not prescription") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Warning'),
                content: Text(
                    'No medical prescription detected in the image.\n Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the state
                      setState(() {
                        _selectedImage = null;
                        _isLoading = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (response != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(
                    'Your medication has been added to your profile successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the state
                      setState(() {
                        _selectedImage = null;
                        _isLoading = false;
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const PillBoxScreen(),
                      ));
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Error'),
                content:
                    Text('Failed to upload prescription. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the state
                      setState(() {
                        _selectedImage = null;
                        _isLoading = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Camera is not initialized');
      }
    } catch (e) {
      print('Error capturing image: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    // setState(() => _isLoading = true);
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isLoading = true;
        });
        String? response = await ref
            .read(apiProvider)
            .uploadPrescription(imagePath: image.path);
        if (response != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(
                    'Your medication has been added to your profile successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the state
                      setState(() {
                        _selectedImage = null;
                        _isLoading = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Error'),
                content:
                    Text('Failed to upload prescription. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the state
                      setState(() {
                        _selectedImage = null;
                        _isLoading = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        print('Image selected from gallery: ${image.path}');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Show live camera preview or selected image
            Positioned.fill(
              child: _selectedImage == null
                  ? (_isCameraInitialized
                      ? CameraPreview(_cameraController!)
                      : const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white)))
                  : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
            ),

            // Loading indicator and message
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 20),
                        Text(
                          'Scanning... This may take some time.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom buttons (Capture & Upload)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  // Upload Button
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Upload",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Capture Button
                  GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            //title at top
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Add Prescription",
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
