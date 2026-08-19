import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/utility/pdf_utils.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/duplex_side_selector.dart';
import 'package:juke/widgets/header.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({super.key});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  Uint8List? _cachedPdfBytes;
  bool _isBusy = false;
  DuplexFlip _selectedFlipSide = DuplexFlip.longEdge;

  Future<Uint8List?> _preparePdf(TrackStore store) async {
    if (store.verifiedTracks.isEmpty) {
      return null;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      final pdfBytes = await PdfUtils.buildPdfBytes(
        store.verifiedTracks,
        duplexFlip: _selectedFlipSide,
      );

      if (!mounted) {
        return null;
      }

      setState(() {
        _cachedPdfBytes = pdfBytes;
      });

      return pdfBytes;
    } catch (error) {
      if (!mounted) {
        return null;
      }

      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _printCards(TrackStore store) async {
    final pdfBytes = await _preparePdf(store);
    if (pdfBytes == null) {
      return;
    }

    try {
      await Printing.layoutPdf(
        name: 'juke-cards.pdf',
        onLayout: (_) async => pdfBytes,
      );

      if (!mounted) {
        return;
      }
    } catch (error) {
      return;
    }
  }

  Future<void> _sharePdf(TrackStore store) async {
    final pdfBytes = _cachedPdfBytes ?? await _preparePdf(store);
    if (pdfBytes == null) {
      return;
    }

    try {
      await Printing.sharePdf(bytes: pdfBytes, filename: 'juke-cards.pdf');

      if (!mounted) {
        return;
      }
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();

    const dividerPadding = 12.0;

    final headerText = [
      RichText(
        text: TextSpan(
          text: 'Print ',
          style: TextStyle(
            fontFamily: antonFamily,
            color: primaryColor,
            fontSize: headerTextSize,
          ),
          children: [
            TextSpan(
              text: 'your newly personalized cards',
              style: TextStyle(
                fontFamily: antonFamily,
                color: secondaryColor,
                fontSize: headerTextSize,
              ),
            ),
          ],
        ),
      ),
      Text(
        'Print your cards and cut accordingly to enjoy your new personalized deck.',
        style: TextStyle(
          fontFamily: jetBrainsMonoFamily,
          fontSize: subHeaderTextSize,
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(showModeSwitcher: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: dividerPadding * 2,
                    children: [
                      ...headerText,
                      _isBusy
                          ? Center(
                              child: Column(
                                spacing: 16,
                                children: [
                                  Text(
                                    'Preparing your PDF...',
                                    style: TextStyle(
                                      fontFamily: jetBrainsMonoFamily,
                                      fontSize: subHeaderTextSize,
                                    ),
                                  ),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : DuplexSideSelector(
                              selectedFlipSide: _selectedFlipSide,
                              onChanged: (DuplexFlip newValue) {
                                setState(() {
                                  _selectedFlipSide = newValue;
                                });
                              },
                            ),
                      CustomButton(
                        text: 'print my cards',
                        onPress: _isBusy ? null : () => _printCards(store),
                        type: ButtonType.primary,
                      ),
                      CustomButton(
                        text: 'share pdf',
                        onPress: _isBusy ? null : () => _sharePdf(store),
                        type: ButtonType.secondary,
                      ),
                      CustomButton(
                        text: 'open faq',
                        onPress: null,
                        type: ButtonType.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
