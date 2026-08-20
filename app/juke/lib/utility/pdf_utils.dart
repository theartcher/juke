import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr/qr.dart';

/// How the physical printer flips the sheet when duplex printing.
///
/// This is a printer setting. The generated back page is mirrored to
/// compensate for the selected flip direction.
enum DuplexFlip { longEdge, shortEdge }

class PdfUtils {
  static const int _columns = 3;
  static const int _rows = 2;
  static const int _cardsPerSheet = _columns * _rows;

  static const double _cardSize = 65 * PdfPageFormat.mm;
  static const double _cardGap = 2 * PdfPageFormat.mm;

  static Future<pw.Font>? _monoFont;
  static Future<pw.Font>? _antonFont;

  static Future<pw.Document> createDocument(
    List<TrackInfo> tracks, {
    DuplexFlip duplexFlip = DuplexFlip.shortEdge,
  }) async {
    final monoFont = await _getFont();
    final yearFont = await _getFont(fontFamily: antonFamily);
    final fallbacks = await _getFontFallbacks();

    final document = pw.Document();

    final sheetCount = getNumberOfSheets(tracks.length);

    for (int sheet = 0; sheet < sheetCount; sheet++) {
      final tracksOnSheet = _tracksForSheet(tracks, sheet);

      final frontCards = <pw.Widget>[
        for (final track in tracksOnSheet)
          _buildFrontCard(track, monoFont, yearFont, fallbacks),
      ];

      _fillEmptySlots(frontCards);

      document.addPage(_buildSheetPage(frontCards));
      final backCards = List<pw.Widget?>.filled(_cardsPerSheet, null);

      for (int frontSlot = 0; frontSlot < tracksOnSheet.length; frontSlot++) {
        final backSlot = _mapBackSlot(frontSlot, duplexFlip);
        backCards[backSlot] = _buildBackCard(tracksOnSheet[frontSlot]);
      }

      final backPage = [for (final card in backCards) card ?? _emptyCard()];
      document.addPage(_buildSheetPage(backPage));
    }

    return document;
  }

  static Future<Uint8List> buildPdfBytes(
    List<TrackInfo> tracks, {
    DuplexFlip duplexFlip = DuplexFlip.shortEdge,
  }) async {
    final document = await createDocument(tracks, duplexFlip: duplexFlip);

    return document.save();
  }

  static int getNumberOfSheets(int numberOfCards) {
    if (numberOfCards <= 0) {
      return 0;
    }

    return (numberOfCards + _cardsPerSheet - 1) ~/ _cardsPerSheet;
  }

  static int _mapBackSlot(int frontSlot, DuplexFlip duplexFlip) {
    final row = frontSlot ~/ _columns;
    final column = frontSlot % _columns;

    switch (duplexFlip) {
      case DuplexFlip.longEdge:
        // Landscape page:
        // long-edge flip mirrors vertically.
        final backRow = _rows - 1 - row;

        return backRow * _columns + column;

      case DuplexFlip.shortEdge:
        // Landscape page:
        // short-edge flip mirrors horizontally.
        final backColumn = _columns - 1 - column;

        return row * _columns + backColumn;
    }
  }

  static List<TrackInfo> _tracksForSheet(
    List<TrackInfo> tracks,
    int sheetIndex,
  ) {
    final start = sheetIndex * _cardsPerSheet;
    final end = (start + _cardsPerSheet).clamp(0, tracks.length);

    return tracks.sublist(start, end);
  }

  static void _fillEmptySlots(List<pw.Widget> cards) {
    while (cards.length < _cardsPerSheet) {
      cards.add(_emptyCard());
    }
  }

  static pw.Widget _emptyCard() {
    return pw.SizedBox(width: _cardSize, height: _cardSize);
  }

  static pw.Page _buildSheetPage(List<pw.Widget> cards) {
    final rows = <pw.Widget>[];

    for (int row = 0; row < _rows; row++) {
      final rowCards = <pw.Widget>[];

      for (int column = 0; column < _columns; column++) {
        final slot = row * _columns + column;

        rowCards.add(cards[slot]);

        if (column < _columns - 1) {
          rowCards.add(pw.SizedBox(width: _cardGap));
        }
      }

      rows.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: rowCards,
        ),
      );

      if (row < _rows - 1) {
        rows.add(pw.SizedBox(height: _cardGap));
      }
    }

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (_) => pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: rows,
      ),
    );
  }

  static pw.Widget _buildFrontCard(
    TrackInfo track,
    pw.Font defaultFont,
    pw.Font releaseYearFont,
    List<pw.Font> fontFallbacks,
  ) {
    return pw.Container(
      width: _cardSize,
      height: _cardSize,
      padding: const pw.EdgeInsets.all(3 * PdfPageFormat.mm),
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            track.releaseYear.toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 28, font: releaseYearFont),
          ),

          pw.SizedBox(height: 5 * PdfPageFormat.mm),

          pw.Text(
            track.title.toString(),
            textAlign: pw.TextAlign.center,
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
            style: pw.TextStyle(
              fontSize: 18,
              font: defaultFont,
              fontFallback: fontFallbacks,
            ),
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
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: defaultFont,
                    fontFallback: fontFallbacks,
                  ),
                ),
                if (track.secondaryArtists.isNotEmpty)
                  pw.TextSpan(
                    text: ' (feat. ${track.secondaryArtists.join(', ')})',
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: defaultFont,
                      fontFallback: fontFallbacks,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBackCard(TrackInfo track) {
    const qrPadding = 4 * PdfPageFormat.mm;

    final qrSize = _cardSize - (2 * qrPadding);

    return pw.Container(
      width: _cardSize,
      height: _cardSize,
      padding: const pw.EdgeInsets.all(qrPadding),
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      child: _buildQrCode(track.directLink, qrSize),
    );
  }

  static pw.Widget _buildQrCode(String data, double size) {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );

    final qrImage = QrImage(qrCode);

    final moduleCount = qrImage.moduleCount;
    final moduleSize = size / moduleCount;

    return pw.CustomPaint(
      size: PdfPoint(size, size),
      painter: (PdfGraphics canvas, PdfPoint paintSize) {
        canvas.setColor(PdfColors.black);

        for (int row = 0; row < moduleCount; row++) {
          for (int column = 0; column < moduleCount; column++) {
            if (!qrImage.isDark(row, column)) {
              continue;
            }

            canvas.drawRect(
              column * moduleSize,
              paintSize.y - (row + 1) * moduleSize,
              moduleSize,
              moduleSize,
            );
          }
        }

        canvas.fillPath();
      },
    );
  }

  static Future<pw.Font> _getFont({
    String fontFamily = jetBrainsMonoFamily,
  }) async {
    if (fontFamily == antonFamily) {
      _antonFont ??= () async {
        final fontData = await rootBundle.load('fonts/Anton-Regular.ttf');

        return pw.Font.ttf(fontData);
      }();

      return _antonFont!;
    }

    _monoFont ??= () async {
      final fontData = await rootBundle.load(
        'fonts/JetBrainsMono-VariableFont_wght.ttf',
      );

      return pw.Font.ttf(fontData);
    }();

    return _monoFont!;
  }

  static Future<List<pw.Font>> _getFontFallbacks() async {
    final notoSans = await PdfGoogleFonts.notoSansRegular();
    final notoSansJp = await PdfGoogleFonts.notoSansJPRegular();
    final notoSansSymbols = await PdfGoogleFonts.notoSansSymbols2Regular();

    return [notoSans, notoSansJp, notoSansSymbols];
  }
}
