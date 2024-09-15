import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function(String) setResult; // Specify type for clarity
  final MobileScannerController controller = MobileScannerController();

  // Check if the scanned string is a valid URL
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
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
            // Pass the result back to the LaunchPage
            setResult(result);

            // Stop the scanner and close the scanner page
            await controller.stop();
            controller.dispose();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
