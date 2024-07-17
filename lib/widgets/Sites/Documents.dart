import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:davi/davi.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Documents.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions_Doc.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions_Document.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/PdfView.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Documents extends StatefulWidget {
  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  int MaxImg = 5;

  bool isForce = false;
  InterMission wInterMission = InterMission.InterMissionInit();

  String wError = "";

  InterMissions_Document wInterMissions_Document = InterMissions_Document();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late SfPdfViewer wSfPdfViewer;
  PdfViewerController wPdfViewerController = PdfViewerController();
  Widget wWidgetPdf = Container();
  Widget wPdf = Container();

  Future<void> AddDoc(Uint8List wUint8List, String name) async {
    print("files NAME ${name}");
    print("files LENGTH ${wUint8List.length}");
    await DbTools.getDocumentName(name);
    print("DbTools.ListDocument.length ${DbTools.ListDocument.length}");
    if (DbTools.ListDocument.length == 0) {
// AJOUT DU FICHIER
      Document document = Document();
      document.DocNom = name;
      document.DocLength = wUint8List.length;

      if (document.DocLength! < (3 * 1024 * 1024)) {
        await DbTools.addDocument(document);

        Uint8List wImage = wUint8List;
        String wUserImg = name;
        await Upload.SaveDoc(wUserImg, wImage);

        InterMissions_Doc interMissions_Doc = InterMissions_Doc();
        interMissions_Doc.InterMissionsDocInterMissionId = wInterMission.InterMissionId;
        interMissions_Doc.InterMissionsDocDocID = DbTools.gLastID;
        await DbTools.addInterMissions_Doc(interMissions_Doc);
        isForce = true;
      }
    } else {
      InterMissions_Doc interMissions_Doc = InterMissions_Doc();
      interMissions_Doc.InterMissionsDocInterMissionId = wInterMission.InterMissionId;
      interMissions_Doc.InterMissionsDocDocID = DbTools.ListDocument[0].DocID;
      await DbTools.addInterMissions_Doc(interMissions_Doc);
      isForce = true;
    }
  }

  Future<void> _pickDoc() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf,.txt';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((e) async {
        Uint8List wUint8List = reader.result as Uint8List;
        await AddDoc(wUint8List, files[0].name);
        setState(() {});
      });
    });
  }

  var spinkit = SpinKitRing(
    color: gColors.primary,
    size: 30.0,
    lineWidth: 4,
  );

  Future<void> Reload() async {
    print(" RELOAD ");

    print("Reload DbTools.gInterMission.InterMissionId ${wInterMission.InterMissionId} ${DbTools.gInterMission.InterMissionId}");

    if (!isForce && wInterMission == DbTools.gInterMission) return;
    wInterMission = DbTools.gInterMission;
    isForce = false;
    wWidgetPdf = Container();
    print("Reload getInterMissions_Document_MissonID ${wInterMission.InterMissionId} ${DbTools.gInterMission.InterMissionId}");

    await DbTools.getInterMissions_Document_MissonID(DbTools.gInterMission.InterMissionId!);
    if (DbTools.ListInterMissions_Document.length > 0) {
      print("Reload gInterMissions_Document ${DbTools.gInterMissions_Document.DocID}");
      wInterMissions_Document = DbTools.gInterMissions_Document;

      await getDdoc();
    } else {
      wInterMissions_Document.DocID = -1;
    }
  }

  @override
  void initState() {
    wSfPdfViewer = SfPdfViewer.network(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      key: _pdfViewerKey,
    );
    wInterMissions_Document.DocID = -1;
    super.initState();
//    Reload();
  }

  final List<XFile> _list = [];
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    double wSize = 120;

    return (isForce || wInterMission != DbTools.gInterMission)
        ? FutureBuilder<void>(
            future: Reload(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return buildDoc(context);
            },
          )
        : buildDoc(context);
  }

  Widget buildDoc(BuildContext context) {
    double wSize = 120;

    String wTailleStr = "";
    String wUseurStr = "";

    if (wInterMissions_Document.DocID != -1) {
      int wTaille = wInterMissions_Document.DocLength!;
      wTailleStr = "${wTaille} o";
      if (wTaille > 1024 * 1024) wTailleStr = "${(wTaille / (1024 * 1024)).round()} Mo";
      if (wTaille > 1024) wTailleStr = "${(wTaille / 1024).round()} Ko";

      DbTools.getUserMat(wInterMissions_Document.DocUserMat!);
      wUseurStr = DbTools.gUser.User_Nom;
    }

    print("buildDoc ${DbTools.ListInterMissions_Document.length}");
    print("wInterMissions_Document.DocID  ${wInterMissions_Document.DocID}");
    print("DbTools.gInterMission.InterMissionId  ${DbTools.gInterMission.InterMissionId}");
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 242,
                  width: 370,
                  child: InterMissions_DocumentGridWidget(),
                ),
                (wInterMissions_Document.DocID == -1)
                    ? Container(
                        height: 57,
                      )
                    : Container(
                        height: 76,
                        child: Row(
                          children: [
                            Container(
                              width: 370,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        child: Text(
                                          "Nom :",
                                          style: gColors.bodyTitle1_N_Gr,
                                        ),
                                      ),
                                      Text(
                                        "${wInterMissions_Document.DocNom}",
                                        style: gColors.bodyTitle1_B_Gr,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        child: Text(
                                          "Taille :",
                                          style: gColors.bodyTitle1_N_Gr,
                                        ),
                                      ),
                                      Text(
                                        "${wTailleStr}",
                                        style: gColors.bodyTitle1_B_Gr,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        child: Text(
                                          "Date :",
                                          style: gColors.bodyTitle1_N_Gr,
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat('dd/MM/yyyy').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(wInterMissions_Document.DocDate!))}",
                                        style: gColors.bodyTitle1_B_Gr,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 90,
                                        child: Text(
                                          "Utilisateur :",
                                          style: gColors.bodyTitle1_N_Gr,
                                        ),
                                      ),
                                      Text(
                                        "${wUseurStr}",
                                        style: gColors.bodyTitle1_B_Gr,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
              ],
            ),
            Container(
              width: 20,
            ),
            Container(
//              color: Colors.red,
              child: wWidgetPdf,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 30,
                  child: DropTarget(
                    onDragDone: (detail) async {
//                              _list.addAll(detail.files);
                      for (int i = 0; i < detail.files.length; i++) {
                        var file = detail.files[i];
                        print('onDragDone ${file.path} - ${file.name}  - ${file.mimeType}');
                        if (file.mimeType!.contains("pdf") || file.mimeType!.contains("text")) {
                          Uint8List wUint8List = await file.readAsBytes();
                          if (wUint8List.length > 0) {
                            print("wUint8List ${wUint8List.length}");
                            await AddDoc(wUint8List, file.name);
                          }
                        }
                      }
                      setState(() {});
                    },
                    onDragEntered: (detail) {
                      setState(() {
                        _dragging = true;
                      });
                    },
                    onDragExited: (detail) {
                      setState(() {
                        _dragging = false;
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      color: _dragging ? gColors.secondary : Colors.black26,
                      child: _list.isEmpty ? const Center(child: Text("Glisser fichiers ici")) : Text(""),
                    ),
                  ),
                ),
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", _pickDoc, tooltip: "Ajouter Photo"),
              ],
            ),
          ],
        ),
      ],
    ));
  }

  Widget InterMissions_DocumentGridWidget() {
    print("InterMissions_DocumentGridWidget DbTools.ListInterMissions_Document.length ${DbTools.ListInterMissions_Document.length}");

    print("InterMissions_DocumentGridWidget wInterMissions_Document.DocID ${wInterMissions_Document.DocID}");

    List<DaviColumn<InterMissions_Document>> wColumns = [
      new DaviColumn(name: 'ID', width: 60, cellStyleBuilder: (row) => row.data.DocID == wInterMissions_Document.DocID ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null, stringValue: (row) => row.DocID.toString()),
      new DaviColumn(name: 'Fichier', width: 300, cellStyleBuilder: (row) => row.data.DocID == wInterMissions_Document.DocID ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null, stringValue: (row) => row.DocNom),
    ];
    print("InterMissions_DocumentGridWidget");
    DaviModel<InterMissions_Document>? _model;
    _model = DaviModel<InterMissions_Document>(rows: DbTools.ListInterMissions_Document, columns: wColumns);
    return Column(
      children: [
        new DaviTheme(
            child: new Davi<InterMissions_Document>(
              _model,
//          rowColor: _rowColor,
              visibleRowsCount: 8,
              onRowTap: (InterMissions_Document) => _onRowTap(context, InterMissions_Document),
            ),
            data: DaviThemeData(
              header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
              headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
              cell: CellThemeData(
                contentHeight: 24,
                textStyle: gColors.bodySaisie_N_G,
              ),
            )),
      ],
    );
  }

  void _onRowTap(BuildContext context, InterMissions_Document interMissions_Document) async {
    wInterMissions_Document = interMissions_Document;
    await getDdoc();
    setState(() {});
  }

  void ToolsBarDelete() async {
    await DbTools.delInterMissions_Doc(wInterMission.InterMissionId, wInterMissions_Document.DocID!);
    isForce = true;
    setState(() {});
  }

  Future getDdoc() async {
    wWidgetPdf = Container();
    String wDocPath = "${wInterMissions_Document.DocNom}";
    if (wDocPath.toLowerCase().contains(".txt")) {
      Uint8List? _bytes = await gColors.getDoc(wDocPath);

      wWidgetPdf = Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: 300,
            height: 300,
            color: Colors.white,
            child: Text(
              "${utf8.decode(_bytes)}",
              style: gColors.bodyTitle1_N_Gr,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
              ),
            ],
          )
        ],
      );
    } else {
      Uint8List? _bytes = await gColors.getDoc(wDocPath);
      print("wDocPath $wDocPath length ${_bytes.length}");
      if (_bytes.length > 0) {
        wSfPdfViewer = await SfPdfViewer.memory(
          controller: wPdfViewerController,
          initialZoomLevel: 1,
          maxZoomLevel: 12,
          _bytes,
          key: _pdfViewerKey,
          enableDocumentLinkAnnotation: false,
          enableTextSelection: false,
          interactionMode: PdfInteractionMode.pan,
        );

        wWidgetPdf = Column(
          children: [
            Container(
              width: 300,
              height: 300,
              child: wSfPdfViewer,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(wSfPdfViewer: wSfPdfViewer)));

                    setState(() {});
                  },
                  icon: Icon(Icons.open_with, color: Colors.green),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
                ),
              ],
            )
          ],
        );
      }
    }
  }
}
