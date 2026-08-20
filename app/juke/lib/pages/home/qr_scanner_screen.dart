import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final MobileScannerController _controller;

  bool _hasScanned = false;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_hasScanned || _isClosing || capture.barcodes.isEmpty) {
      return;
    }

    final value = capture.barcodes.first.rawValue;

    if (value == null) {
      return;
    }

    _hasScanned = true;
    await _closeScanner(value);
  }

  Future<void> _closeScanner([String? result]) async {
    if (_isClosing) return;

    _isClosing = true;
    try {
      await _controller.stop();
    } finally {
      if (!mounted) return;

      context.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan card'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _closeScanner,
          tooltip: 'Close scanner',
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await _closeScanner();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(controller: _controller, onDetect: _onDetect),

            Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Point your camera at a Spotify card',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
