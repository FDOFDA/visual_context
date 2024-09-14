import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DocumentAlignmentPage extends StatefulWidget {
  const DocumentAlignmentPage({super.key});

  @override
  _DocumentAlignmentPageState createState() => _DocumentAlignmentPageState();
}

class _DocumentAlignmentPageState extends State<DocumentAlignmentPage> {
  String? _imagePath;

  Future<void> _alignDocument() async {
    // Check and request camera permissions
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      print('Camera permission not granted');
      return;
    }

    // Generate a file path for saving the captured image
    String imagePath = join(
      (await getApplicationSupportDirectory()).path,
      "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg",
    );

    try {
      // Use Edge Detection to detect edges and align the document
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      if (success) {
        setState(() {
          _imagePath = imagePath;
        });
      } else {
        print('Edge detection failed');
      }
    } catch (e) {
      print('Error during edge detection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Alignment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagePath != null)
              Image.file(
                File(_imagePath!),
                width: 300,
                height: 400,
                fit: BoxFit.cover,
              )
            else
              const Text('No document aligned yet'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _alignDocument,
              child: const Text('Align Document'),
            ),
          ],
        ),
      ),
    );
  }
}
