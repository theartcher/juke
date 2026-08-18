import 'package:flutter/services.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfUtils {
  static Future<pw.Font>? _cachedFontMono;
  static Future<pw.Font>? _cachedFontAnton;

  static Future<pw.Document> createDocument(List<TrackInfo> tracks) async {
    final font = await _getFont();
    int pageCount = getNumberOfPages(tracks.length);
    final pdf = pw.Document();

    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startIndex = pageIndex * 3;
      final endIndex = (startIndex + 3).clamp(0, tracks.length);
      final pageTracks = tracks.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.landscape,
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                for (var track in pageTracks) ...[
                  createCard(track, font),
                  if (track != pageTracks.last)
                    pw.SizedBox(height: 2 * PdfPageFormat.mm),
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

  static pw.Container createCard(TrackInfo track, pw.Font font) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      width: 65 * PdfPageFormat.mm,
      height: 65 * PdfPageFormat.mm * 2,
      child: pw.Column(
        children: [
          pw.SizedBox(
            width: 65 * PdfPageFormat.mm,
            height: 65 * PdfPageFormat.mm,
          ),
          pw.Divider(
            color: PdfColors.black,
            thickness: 1,
            borderStyle: pw.BorderStyle.dashed,
          ),
          pw.Center(
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
                pw.Text(
                  track.title.toString(),
                  textAlign: pw.TextAlign.center,
                  maxLines: 2,
                  overflow: pw.TextOverflow.clip,
                  style: pw.TextStyle(fontSize: 18, font: font),
                ),
                pw.SizedBox(height: 5 * PdfPageFormat.mm),
                pw.RichText(
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
