import 'package:flutter/material.dart';
import 'qr_code_scanner.dart';
import 'document_alignment_page.dart'; // New file to be created

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  String? _scannedResult;

  // Method to update the result
  void _setResult(String result) {
    setState(() {
      _scannedResult = result;
    });
  }

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
            // Display the scanned result if available
            if (_scannedResult != null)
              Text(
                'Scanned Result: $_scannedResult',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QrCodeScanner(
                    setResult: _setResult, // Pass the state updating function
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
