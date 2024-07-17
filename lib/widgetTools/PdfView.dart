import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class PdfView extends StatefulWidget {
  final SfPdfViewer wSfPdfViewer;

  const PdfView({Key? key, required this.wSfPdfViewer}) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  late SfPdfViewer wSfPdfViewer;

  void initLib() async {}

  @override
  void initState() {
    wSfPdfViewer = widget.wSfPdfViewer;
    print(" ${wSfPdfViewer.controller!.zoomLevel}");

    super.initState();
  }

  double width = 0;
  int isZoom = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 56;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gColors.primary,
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
                  width: 200,
                ),
                Spacer(),
                Text(
                  "Documents",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
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
      ),
      backgroundColor: gColors.white,
      body: Container(
          width: width,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          color: gColors.LinearGradient2,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  isZoom == 2
                      ? Container(
                          width: width,
                          height: height,
                          child: wSfPdfViewer,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: isZoom == 0 ?  300 : 500,
                              height: height,
                              child: wSfPdfViewer,
                            ),
                          ],
                        )
                ],
              ),
              Positioned(
                right: 20,
                top: 10,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.zoom_out,
                            color: Colors.black,
                            size: 48.0,
                          ),
                          onTap: () async {
                            if (wSfPdfViewer.controller!.zoomLevel > 1)
                              wSfPdfViewer.controller!.zoomLevel = wSfPdfViewer.controller!.zoomLevel - 0.5;
                            else if (isZoom > 0) {
                              wSfPdfViewer.controller!.zoomLevel = 2;
                              isZoom--;
                              wSfPdfViewer.controller!.zoomLevel = 1;
                            }
                            setState(() {});
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.zoom_in,
                            color: Colors.black,
                            size: 48.0,
                          ),
                          onTap: () async {
                            if (isZoom == 2) wSfPdfViewer.controller!.zoomLevel = wSfPdfViewer.controller!.zoomLevel + 0.5;
                            else  {
                              wSfPdfViewer.controller!.zoomLevel = 2;
                              isZoom++;
                              wSfPdfViewer.controller!.zoomLevel = 1;
                            }

                            setState(() {});
                          },
                        ),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
