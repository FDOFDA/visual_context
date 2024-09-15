import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qr_code_scanner.dart';
import 'document_alignment_page.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  String? _scannedResult;

  // Method to update the result and handle URLs
  void _setResult(String result) {
    setState(() {
      _scannedResult = result;
    });
  }

  // Method to check if the string is a URL and launch it if valid
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Action'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_scannedResult != null)
                _ScannedResultDisplay(
                  scannedResult: _scannedResult!,
                  onLinkTap: _launchUrl, // Handle link opening
                ),
              const SizedBox(height: 20),
              _ActionButton(
                text: 'Scan QR Code',
                icon: Icons.qr_code_scanner,
                color: Colors.deepPurple,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrCodeScanner(
                      setResult: _setResult,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                text: 'Align Document',
                icon: Icons.document_scanner,
                color: Colors.teal,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DocumentAlignmentPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget to display the scanned result with hyperlink support
class _ScannedResultDisplay extends StatelessWidget {
  final String scannedResult;
  final Function(String) onLinkTap;

  const _ScannedResultDisplay({
    required this.scannedResult,
    required this.onLinkTap,
    Key? key,
  }) : super(key: key);

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _isValidUrl(scannedResult)
            ? () => onLinkTap(scannedResult)
            : null, // Only allow tapping if it's a valid URL
        child: Text(
          _isValidUrl(scannedResult)
              ? 'Tap to open link: $scannedResult'
              : 'Scanned Result: $scannedResult',
          style: TextStyle(
            fontSize: 16,
            color: _isValidUrl(scannedResult) ? Colors.blue : Colors.black87,
            decoration: _isValidUrl(scannedResult)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Reusable button widget for actions
class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
