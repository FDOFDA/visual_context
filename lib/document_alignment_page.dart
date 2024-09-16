import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DocumentAlignmentPage extends StatefulWidget {
  const DocumentAlignmentPage({super.key});

  @override
  _DocumentAlignmentPageState createState() => _DocumentAlignmentPageState();
}

class _DocumentAlignmentPageState extends State<DocumentAlignmentPage> {
  String? _imagePath;

  Future<void> _alignDocument() async {
    bool isCameraGranted = await Permission.camera.isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request().isGranted;
    }

    if (!isCameraGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is needed to align documents.')),
      );
      return;
    }

    String imagePath = p.join(
      (await getApplicationSupportDirectory()).path,
      "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg",
    );

    try {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to align the document.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during edge detection: $e')),
      );
    }
  }

  Future<void> _saveImageToGallery(BuildContext context) async {
    if (_imagePath == null) return;

    bool isPermissionGranted = await _requestStoragePermission();

    if (isPermissionGranted) {
      try {
        // Read the image file as bytes
        File imageFile = File(_imagePath!);
        Uint8List imageBytes = await imageFile.readAsBytes();

        // Save the file using ImageGallerySaver with the MIME type and name
        final result = await ImageGallerySaver.saveImage(
          imageBytes,
          quality: 100,
          name: p.basenameWithoutExtension(_imagePath!), // Use the file's name
        );

        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to gallery')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image to gallery')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving image to gallery: $e')),
        );
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    // For MANAGE_EXTERNAL_STORAGE, which is only for Android 11+
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }
    // Handle permissions permanently denied
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is permanently denied. Please enable it from settings.'),
        ),
      );
      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Storage permission not granted. Unable to save the image.'),
      ),
    );
    return false;
  }

  void _discardImage(BuildContext context) {
    if (_imagePath == null) return;

    try {
      File(_imagePath!).deleteSync();
      setState(() {
        _imagePath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image discarded')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error discarding image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Alignment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imagePath != null)
                _ImageDisplay(imagePath: _imagePath!)
              else
                const Text(
                  'No document aligned yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              const SizedBox(height: 20),
              _ActionButton(
                text: 'Align Document',
                onPressed: _alignDocument,
                color: Colors.deepPurple,
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 20),
                _ActionButton(
                  text: 'Save to Gallery',
                  onPressed: () => _saveImageToGallery(context),
                  color: Colors.green,
                ),
                _ActionButton(
                  text: 'Discard Image',
                  onPressed: () => _discardImage(context),
                  color: Colors.red,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Widget to display the aligned document image
class _ImageDisplay extends StatelessWidget {
  final String imagePath;

  const _ImageDisplay({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imagePath),
          width: 300,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Reusable button widget for actions
class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
