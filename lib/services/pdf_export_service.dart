import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/document_models.dart';
import '../models/user_profile.dart';

class PdfExportService {
  Future<void> exportCv({
    required UserProfile profile,
    required CvTemplate template,
  }) async {
    final document = pw.Document();
    final accent = switch (template) {
      CvTemplate.classic => PdfColors.blueGrey800,
      CvTemplate.modern => PdfColors.blue700,
      CvTemplate.creative => PdfColors.teal700,
    };

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(32)),
        build: (context) => [
          _cvHeader(profile, accent, template),
          pw.SizedBox(height: 18),
          _section('Résumé professionnel', [profile.summary], accent),
          _section('Expériences professionnelles', profile.experiences, accent),
          _section('Formations', profile.education, accent),
          _section('Compétences', profile.skills, accent),
          _section('Langues', profile.languages, accent),
          _section('Centres d’intérêt', profile.interests, accent),
        ],
      ),
    );

    await Printing.layoutPdf(
      name: 'cv_${profile.fullName.replaceAll(' ', '_').toLowerCase()}',
      onLayout: (_) => document.save(),
    );
  }

  Future<void> exportLetter({
    required String letter,
    required UserProfile profile,
  }) async {
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(42)),
        build: (context) => [
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              _pdfText(profile.fullName),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 32),
          pw.Text(
            _pdfText(letter),
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 5),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      name: 'lettre_motivation',
      onLayout: (_) => document.save(),
    );
  }

  pw.Widget _cvHeader(
    UserProfile profile,
    PdfColor accent,
    CvTemplate template,
  ) {
    final nameStyle = pw.TextStyle(
      color: template == CvTemplate.classic ? PdfColors.black : accent,
      fontSize: template == CvTemplate.creative ? 29 : 25,
      fontWeight: pw.FontWeight.bold,
    );

    return pw.Container(
      padding: template == CvTemplate.classic
          ? pw.EdgeInsets.zero
          : const pw.EdgeInsets.all(16),
      decoration: template == CvTemplate.classic
          ? null
          : pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border(left: pw.BorderSide(color: accent, width: 5)),
            ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _pdfText(profile.fullName.isEmpty ? 'Votre nom' : profile.fullName),
            style: nameStyle,
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            _pdfText(profile.targetJob),
            style: pw.TextStyle(color: accent, fontSize: 14),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            [
              profile.email,
              profile.phone,
              profile.address,
            ].where((item) => item.isNotEmpty).map(_pdfText).join(' - '),
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _section(String title, List<String> items, PdfColor accent) {
    final cleanItems = items.where((item) => item.trim().isNotEmpty).toList();
    if (cleanItems.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _pdfText(title),
            style: pw.TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Divider(color: accent, thickness: 0.8),
          ...cleanItems.map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(
                '- ${_pdfText(item)}',
                style: const pw.TextStyle(fontSize: 10, lineSpacing: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _pdfText(String value) {
    return value
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('•', '-')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('…', '...')
        .replaceAll('œ', 'oe')
        .replaceAll('Œ', 'OE')
        .replaceAll('\u00A0', ' ');
  }
}
