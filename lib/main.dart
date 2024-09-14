import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for URL launching
import 'qr_code_scanner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _result;

  // Method to set the scanned result
  void setResult(String result) {
    setState(() => _result = result);
  }

  // Method to check if the string is a URL
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  // Method to launch the URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri);
      } catch (e) {
        print('Could not launch $url: $e');
      }
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Check if the result is a URL and render it as a hyperlink
            if (_result != null)
              _isValidUrl(_result!)
                  ? GestureDetector(
                      onTap: () => _launchUrl(_result!),
                      child: Text(
                        _result!,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(_result!),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QrCodeScanner(setResult: setResult),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
