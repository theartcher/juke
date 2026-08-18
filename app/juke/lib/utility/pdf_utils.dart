import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

class PdfUtils {
  static Future<pw.Font>? _cachedFontMono;
  static Future<pw.Font>? _cachedFontAnton;

  static Future<pw.Document> createDocument(List<TrackInfo> tracks) async {
    final font = await _getFont();

    final qrImages = await Future.wait(
      tracks.map((track) => _generateQrImageBytes(track.directLink)),
    );

    final pageCount = getNumberOfPages(tracks.length);
    final pdf = pw.Document();

    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startIndex = pageIndex * 3;
      final endIndex = (startIndex + 3).clamp(0, tracks.length);
      final pageTracks = tracks.sublist(startIndex, endIndex);
      final pageQrImages = qrImages.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.landscape,
          build: (pw.Context context) {
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < pageTracks.length; i++) ...[
                  createCard(pageTracks[i], font, pageQrImages[i]),
                  if (i != pageTracks.length - 1)
                    pw.SizedBox(width: 2 * PdfPageFormat.mm),
                ],
              ],
            );
          },
        ),
      );
    }
    return pdf;
  }

  static Future<Uint8List> buildPdfBytes(List<TrackInfo> tracks) async {
    final document = await createDocument(tracks);
    return document.save();
  }

  static pw.Container createCard(
    TrackInfo track,
    pw.Font font,
    Uint8List qrImageBytes,
  ) {
    const cardSide = 65 * PdfPageFormat.mm;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      width: cardSide,
      height: cardSide * 2,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: cardSide,
            height: cardSide,
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(4 * PdfPageFormat.mm),
            child: pw.Image(
              pw.MemoryImage(qrImageBytes),
              width: cardSide - (8 * PdfPageFormat.mm),
              height: cardSide - (8 * PdfPageFormat.mm),
              fit: pw.BoxFit.contain,
            ),
          ),

          // Fold line
          pw.Divider(
            color: PdfColors.black,
            thickness: 1,
            borderStyle: pw.BorderStyle.dashed,
          ),

          // Text side
          pw.Container(
            width: cardSide,
            height: cardSide,
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(3 * PdfPageFormat.mm),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  track.releaseYear.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 28, font: font),
                ),
                pw.SizedBox(height: 5 * PdfPageFormat.mm),
                pw.RichText(
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: pw.TextOverflow.clip,
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: track.primaryArtist,
                        style: pw.TextStyle(fontSize: 14, font: font),
                      ),
                      if (track.secondaryArtists.isNotEmpty)
                        pw.TextSpan(
                          text: ' (feat. ${track.secondaryArtists.join(', ')})',
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<Uint8List> _generateQrImageBytes(String data) async {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);

    final byteData = await qrImage.toImageAsBytes(
      size: 300,
      format: ui.ImageByteFormat.png,
      decoration: const PrettyQrDecoration(),
    );

    if (byteData == null) {
      throw StateError('Failed to render QR code for "$data"');
    }
    return byteData.buffer.asUint8List();
  }

  static Future<pw.Font> _getFont({
    String fontFamily = jetBrainsMonoFamily,
  }) async {
    if (fontFamily == antonFamily) {
      _cachedFontAnton ??= () async {
        final fontData = await rootBundle.load('fonts/Anton-Regular.ttf');
        return pw.Font.ttf(fontData);
      }();

      return _cachedFontAnton!;
    }

    if (fontFamily == jetBrainsMonoFamily) {
      _cachedFontMono ??= () async {
        final fontData = await rootBundle.load(
          'fonts/JetBrainsMono-VariableFont_wght.ttf',
        );
        return pw.Font.ttf(fontData);
      }();

      return _cachedFontMono!;
    }

    _cachedFontMono ??= () async {
      final fontData = await rootBundle.load(
        'fonts/JetBrainsMono-VariableFont_wght.ttf',
      );
      return pw.Font.ttf(fontData);
    }();

    return _cachedFontMono!;
  }

  static int getNumberOfPages(int numberOfCards) {
    return (numberOfCards / 3).ceil();
  }
}
