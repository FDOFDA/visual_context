import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for URL launching

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;
  final MobileScannerController controller = MobileScannerController();

  // Method to check if the scanned string is a valid URL
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  // Method to launch the URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final barcode = barcodes.first;

          if (barcode.rawValue != null) {
            final result = barcode.rawValue!;

            // Check if the scanned result is a valid URL
            if (_isValidUrl(result)) {
              // Launch the URL if it's valid
              await _launchUrl(result);
            } else {
              // Set the result if it's not a URL, allowing the parent widget to handle it
              setResult(result);
            }

            // Stop the scanner after detecting and processing the barcode
            await controller.stop().then((_) {
              controller.dispose();
              Navigator.of(context).pop();
            });
          }
        },
      ),
    );
  }
}
