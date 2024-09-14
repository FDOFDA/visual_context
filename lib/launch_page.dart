import 'package:flutter/material.dart';
import 'qr_code_scanner.dart';
import 'document_alignment_page.dart'; // New file to be created

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Action'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QrCodeScanner(
                    setResult: (result) {}, // Placeholder for setResult function
                  ),
                ),
              ),
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DocumentAlignmentPage(),
                ),
              ),
              child: const Text('Align Document'),
            ),
          ],
        ),
      ),
    );
  }
}
