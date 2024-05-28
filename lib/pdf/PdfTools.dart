import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';

class PdfTools {
  static PdfColor baseColor = PdfColors.teal;
  static PdfColor accentColor = PdfColors.blueGrey900;
  static double FontSizeTitle = 12;
  static double FontSizeTxt = 11;

  static pw.Widget Titre(pw.Context context, String wLbl1, String wTxt1, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 8,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 40, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.center,
            height: 25,
            child: pw.Text(
              wTxt1,
              textAlign: wTextAlign,
              style: pw.TextStyle(
                color: wTxtPdfColor,
                fontWeight: pw.FontWeight.bold,
                fontSize: FontSizeTitle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget C1_L1(pw.Context context, String wLbl1, String wTxt1, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor, {int wMaxLines = 0}) {

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 8,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding:  pw.EdgeInsets.only(left: 10, top: 1, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: (25.0 + (wMaxLines) * 5.2),
            child: pw.Row(children: [
              pw.Text(
                wLbl1,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  wTxt1,
                  textAlign: wTextAlign,
                  maxLines: wMaxLines + 1,
                  style: pw.TextStyle(
                    color: wTxtPdfColor,
                    fontSize: FontSizeTxt,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  static pw.Widget C2_L1(pw.Context context, String wLbl1, String wTxt1, int wFlex1, String wLbl2, String wTxt2, int wFlex2, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: wFlex1,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 25,
            child: pw.Row(children: [
              pw.Text(
                wLbl1,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Text(
                wTxt1,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontSize: FontSizeTxt,
                ),
              ),
            ]),
          ),
        ),
        pw.Expanded(
          flex: wFlex2,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 25,
            child: pw.Row(children: [
              pw.Text(
                wLbl2,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Text(
                wTxt2,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontSize: FontSizeTxt,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  static pw.Widget C3_L1(pw.Context context, String wLbl1, String wTxt1, int wFlex1, String wLbl2, String wTxt2, int wFlex2, String wLbl3, String wTxt3, int wFlex3, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: wFlex1,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 20,
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text(
                wLbl1,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Text(
                wTxt1,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontSize: FontSizeTxt,
                ),
              ),
            ]),
          ),
        ),
        pw.Expanded(
          flex: wFlex2,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.center,
            height: 20,
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text(
                wLbl2,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Text(
                wTxt2,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: (wLbl1.compareTo("Action") == 0) ? PdfColors.green : wTxtPdfColor,
                  fontSize: FontSizeTxt,
                  fontWeight: (wLbl1.compareTo("Action") == 0) ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ]),
          ),
        ),
        pw.Expanded(
          flex: wFlex3,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.center,
            height: 20,
            child: pw.Row(children: [
              pw.Text(
                wLbl3,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: FontSizeTxt,
                ),
              ),
              pw.Text(
                wTxt3,
                textAlign: wTextAlign,
                style: pw.TextStyle(
                  color: wTxtPdfColor,
                  fontSize: FontSizeTxt,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  static pw.Widget C2_L3(pw.Context context, String wLbl1_1, String wTxt1_1, String wLbl1_2, String wTxt1_2, String wLbl1_3, String wTxt1_3, int wFlex1, String wLbl2_1, String wTxt2_1, String wLbl2_2, String wTxt2_2, String wLbl2_3, String wTxt2_3, int wFlex2, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor, {Uint8List? imageData_Cachet}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: wFlex1,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 70,
            child: pw.Row(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                pw.Row(children: [
                  pw.Text(
                    wLbl1_1,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                  pw.Text(
                    wTxt1_1,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text(
                    wLbl1_2,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                  pw.Text(
                    wTxt1_2,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text(
                    wLbl1_3,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                  pw.Text(
                    wTxt1_3,
                    textAlign: wTextAlign,
                    style: pw.TextStyle(
                      color: wTxtPdfColor,
                      fontSize: FontSizeTxt,
                    ),
                  ),
                ]),
              ]),
              DbTools.gIntervention.Intervention_Signature_Tech.length == 0 ? pw.Container():

              pw.Container(
                width : 160,
                padding: const pw.EdgeInsets.only(left: 10, top: 1, bottom: 1),
                child: pw.Image(pw.MemoryImage(DbTools.gIntervention.Intervention_Signature_Tech!)),
              ),

            ]),
          ),
        ),

        pw.Expanded(
          flex: wFlex2,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 70,
            child: pw.Row(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    pw.Row(children: [
                      pw.Text(
                        wLbl2_1,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                      pw.Text(
                        wTxt2_1,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Row(children: [
                      pw.Text(
                        wLbl2_2,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                      pw.Text(
                        wTxt2_2,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Row(children: [
                      pw.Text(
                        wLbl2_3,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                      pw.Text(
                        wTxt2_3,
                        textAlign: wTextAlign,
                        style: pw.TextStyle(
                          color: wTxtPdfColor,
                          fontSize: FontSizeTxt,
                        ),
                      ),
                    ]),
                  ]),
              DbTools.gIntervention.Intervention_Signature_Client.length == 0 ? pw.Container():
              pw.Container(
                width : 160,
                padding: const pw.EdgeInsets.only(left: 10, top: 1, bottom: 1),
                child: pw.Image(pw.MemoryImage(DbTools.gIntervention.Intervention_Signature_Client!)),
              ),

/*
              pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Container(
                  height: 85,
                  padding: const pw.EdgeInsets.only(left: 10),
                  child: pw.Image(pw.MemoryImage(imageData_Cachet!)),
                ),
              ]),
*/




            ]),
          ),
        ),


      ],
    );
  }

  static pw.Widget C1_L2(pw.Context context, String wLbl1, String wTxt1, String wTxt2, pw.TextAlign wTextAlign, PdfColor wBackGroundPdfColor, PdfColor wTxtPdfColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 8,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
                color: PdfColors.black,
              ),
              borderRadius: const pw.BorderRadius.all(
                pw.Radius.circular(1),
              ),
              color: wBackGroundPdfColor,
            ),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 0, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 38,
            child: pw.Column(children: [
              pw.Row(children: [
                pw.Text(
                  wLbl1,
                  textAlign: wTextAlign,
                  style: pw.TextStyle(
                    color: wTxtPdfColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: FontSizeTxt,
                  ),
                ),
                pw.Text(
                  wTxt1,
                  textAlign: wTextAlign,
                  style: pw.TextStyle(
                    color: wTxtPdfColor,
                    fontSize: FontSizeTxt,
                  ),
                ),
              ]),
              pw.Row(children: [
                pw.Text(
                  wTxt2,
                  textAlign: wTextAlign,
                  style: pw.TextStyle(
                    color: wTxtPdfColor,
                    fontSize: FontSizeTxt,
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ],
    );
  }
}
