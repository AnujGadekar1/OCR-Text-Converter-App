import 'package:flutter/material.dart';
import 'dart:io';
import 'services/image_picker_service.dart';
import 'services/permissions_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final PermissionsService _permissionsService = PermissionsService();
  File? _selectedImage;

  // Handle image selection
  Future<void> _pickImage(bool fromGallery) async {
    await _permissionsService
        .requestPermissions(); // Request permissions dynamically
    File? image = fromGallery
        ? await _imagePickerService.pickImageFromGallery()
        : await _imagePickerService.captureImageWithCamera();

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Scan to Text"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show selected image
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Text(
                    "No Image Selected",
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            // Buttons for gallery and camera
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(true),
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(false),
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
