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
  String? _statusMessage;
  DuplexFlip _selectedFlipSide = DuplexFlip.longEdge;

  Future<Uint8List?> _preparePdf(TrackStore store) async {
    if (store.verifiedTracks.isEmpty) {
      setState(() {
        _statusMessage = 'No verified tracks available to print yet.';
      });
      return null;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = 'Generating your deck PDF...';
    });

    try {
      final pdfBytes = await PdfUtils.buildPdfBytes(store.verifiedTracks);

      if (!mounted) {
        return null;
      }

      setState(() {
        _cachedPdfBytes = pdfBytes;
        _statusMessage = 'Deck PDF ready.';
      });

      return pdfBytes;
    } catch (error) {
      if (!mounted) {
        return null;
      }

      setState(() {
        _statusMessage = 'Could not generate PDF: $error';
      });

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
    final pdfBytes = await _preparePdf(
      store,
    ); // todo add cache -> _cachedPdfBytes ??
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

      setState(() {
        _statusMessage = 'Print dialog opened.';
      });
    } on MissingPluginException {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage =
            'Printing plugin not registered yet. Stop the app and run it again (full restart) after adding dependencies.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Printing failed: $error';
      });
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

      setState(() {
        _statusMessage = 'Share sheet opened.';
      });
    } on MissingPluginException {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage =
            'Printing plugin not registered yet. Stop the app and run it again (full restart) after adding dependencies.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Could not open share sheet: $error';
      });
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
        'Print your cards, cut and fold accordingly and enjoy your new personalized deck.',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: dividerPadding * 2,
                    children: [
                      ...headerText,
                      Text(
                        '${store.verifiedTracks.length} verified cards ready',
                        style: TextStyle(
                          fontFamily: jetBrainsMonoFamily,
                          fontSize: subHeaderTextSize,
                        ),
                      ),
                      DuplexSideSelector(
                        selectedFlipSide: _selectedFlipSide,
                        onChanged: (DuplexFlip newValue) {
                          setState(() {
                            _selectedFlipSide = newValue;
                          });
                        },
                      ),
                      if (_statusMessage != null)
                        Text(
                          _statusMessage!,
                          style: TextStyle(
                            fontFamily: jetBrainsMonoFamily,
                            fontSize: 14,
                            color: secondaryColor,
                          ),
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
