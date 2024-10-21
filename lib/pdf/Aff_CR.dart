import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus_backoff/pdf/Pdf_CR.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Aff_CR extends StatefulWidget {
  const Aff_CR({Key? key}) : super(key: key);

  @override
  Aff_CRState createState() {
    return Aff_CRState();
  }
}

class Aff_CRState extends State<Aff_CR> with SingleTickerProviderStateMixin {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Uint8List gwBdC = Uint8List.fromList([]);

  bool genBdC = false;

  @override
  void initLib() async {
    gwBdC = await generateCR();
    genBdC = true;
    setState(() {});
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Color wColor = Colors.transparent;

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }



  @override
  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,

      title: Container(
          color: gColors.primary,
          child: Row(
            children: [
              Container(
                width: 5,
              ),
              InkWell(
                child: SizedBox(
                    height: 100.0,
                    width: 100.0, // fixed width and height
                    child: new Image.asset(
                      'assets/images/AppIcow.png',
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                width: 25,
              ),
              Spacer(),
              Text(
                "COMPTE-RENDU",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_Wr,
              ),
              Spacer(),
              gColors.BtnAffUser(context),
              Container(
                width: 150,
                child: Text(
                  "Version : ${DbTools.gVersion}",
                  style: gColors.bodySaisie_N_W,
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: !genBdC
          ? Center(
              child: new Scaffold(
                  body: new Center(
                child: new SizedBox(width: 40.0, height: 40.0, child: const CircularProgressIndicator()),
              )),
            )
          :PdfPreview(
        maxPageWidth: 700,
        build: (format) => generateCR(),
        canDebug : false,
        canChangePageFormat : false,
        canChangeOrientation : false,

        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      )

    );
  }
}
