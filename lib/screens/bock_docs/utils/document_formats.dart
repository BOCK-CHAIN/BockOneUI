// document_formats.dart - Document format generation utilities
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:archive/archive.dart';

enum DocumentFormat {
  txt,
  pdf,
  docx,
}

/// Generates a PDF document from title and content
Future<Uint8List> generatePDF(String title, String content) async {
  final pdf = pw.Document();
  
  // Split content into paragraphs
  final paragraphs = content.split('\n');
  
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(72), // 1 inch margins
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            // Content paragraphs
            ...paragraphs.map((para) {
              if (para.trim().isEmpty) {
                return pw.SizedBox(height: 12);
              }
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Text(
                  para,
                  style: const pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.left,
                ),
              );
            }),
          ],
        );
      },
    ),
  );
  
  return pdf.save();
}

/// Generates a DOCX document from title and content
/// DOCX is a ZIP file containing XML files
Future<Uint8List> generateDOCX(String title, String content) async {
  // Create a basic DOCX structure
  // DOCX is essentially a ZIP file with specific XML structure
  
  final archive = Archive();
  
  // Create the main document XML
  final documentXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Title"/>
      </w:pPr>
      <w:r>
        <w:t>$title</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:t></w:t>
      </w:r>
    </w:p>
${content.split('\n').map((line) => '''
    <w:p>
      <w:r>
        <w:t xml:space="preserve">${_escapeXml(line)}</w:t>
      </w:r>
    </w:p>
''').join('')}
  </w:body>
</w:document>''';
  
  // Create styles XML
  final stylesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:styleId="Title">
    <w:name w:val="Title"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:pPr>
      <w:spacing w:after="240" w:line="276" w:lineRule="auto"/>
      <w:jc w:val="left"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:eastAsia="Arial"/>
      <w:b/>
      <w:sz w:val="32"/>
      <w:szCs w:val="32"/>
    </w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:eastAsia="Calibri" w:cs="Calibri"/>
      <w:sz w:val="22"/>
      <w:szCs w:val="22"/>
    </w:rPr>
  </w:style>
</w:styles>''';
  
  // Create content types XML
  final contentTypesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>''';
  
  // Create relationships XML
  final relsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';
  
  final wordRelsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>''';
  
  // Add files to archive
  archive.addFile(ArchiveFile('[Content_Types].xml', contentTypesXml.length, Uint8List.fromList(contentTypesXml.codeUnits)));
  archive.addFile(ArchiveFile('word/document.xml', documentXml.length, Uint8List.fromList(documentXml.codeUnits)));
  archive.addFile(ArchiveFile('word/styles.xml', stylesXml.length, Uint8List.fromList(stylesXml.codeUnits)));
  archive.addFile(ArchiveFile('_rels/.rels', relsXml.length, Uint8List.fromList(relsXml.codeUnits)));
  archive.addFile(ArchiveFile('word/_rels/document.xml.rels', wordRelsXml.length, Uint8List.fromList(wordRelsXml.codeUnits)));
  
  // Create ZIP file
  final zipEncoder = ZipEncoder();
  final zipData = zipEncoder.encode(archive);
  
  return Uint8List.fromList(zipData!);
}

String _escapeXml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

