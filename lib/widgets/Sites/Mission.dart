import 'dart:typed_data';

import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/Documents.dart';
import 'package:verifplus_backoff/widgets/Sites/Photos.dart';

class Mission extends StatefulWidget {
  @override
  State<Mission> createState() => _MissionState();
}

class _MissionState extends State<Mission> {
  InterMission wInterMission = InterMission.InterMissionInit();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String wTitle = "";

  String selectedMission = "";
  String selectedMissionID = "";
  List<String> List_Mission = [];
  List<String> List_MissionID = [];

  bool isSelect = false;

  int selVue = 1;
  int pastillePhoto = 0;
  int pastilleDoc = 0;

  Future Reload() async {
    await DbTools.getInterMissionsIntervention(DbTools.gIntervention.InterventionId!);
    await Filtre();
  }


  Future getPastille() async {


    pastillePhoto = 0;

    for (int i = 0; i < 5; i++) {
      String wUserImg = "./Img/Intervention_${DbTools.gIntervention.InterventionId}_${DbTools.gInterMission.InterMissionId}_$i.jpg";
      try {
        bool wTest = await gColors.fileExist(wUserImg);
        if (wTest) pastillePhoto++;
      } catch (e) {
        print("ERROR ${wUserImg}");
      }
    }

    await DbTools.getInterMissions_Document_MissonID(DbTools.gInterMission.InterMissionId);
    pastilleDoc = DbTools.ListInterMissions_Document.length;
 }


  Future Filtre() async {
    DbTools.ListInterMissionsearchresult.clear();
    DbTools.ListInterMissionsearchresult.addAll(DbTools.ListInterMission);
    DbTools.ListInterMissionsearchresult.forEach((element) {
      print("DbTools ${element.InterMission_InterventionId} ${element.InterMissionId}");
    });
    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamFam("Missions");
    List_Mission.clear();
    List_Mission.addAll(DbTools.ListParam_ParamFam);
    List_MissionID.clear();
    List_MissionID.addAll(DbTools.ListParam_ParamFamID);

    selectedMission = List_Mission[0];
    selectedMissionID = List_MissionID[0];

    await DbTools.getInterMissionsIntervention(DbTools.gIntervention.InterventionId!);

    if (DbTools.ListInterMission.length > 0) {
      isSelect = true;

      wInterMission = DbTools.ListInterMission[0];
      InterMission_TextController.text = wInterMission.InterMission_Nom;
      InterMission_NoteController.text = wInterMission.InterMission_Note;
//      builddoc();
    }

    DbTools.gInterMission = wInterMission;
    InterMission_TextController.text = wInterMission.InterMission_Nom;
    InterMission_NoteController.text = wInterMission.InterMission_Note;

    await getPastille();


    await Filtre();
  }

  void initState() {
    wSfPdfViewer = SfPdfViewer.network(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      key: _pdfViewerKey,
    );

    wImage = Image(
      image: AssetImage('assets/images/Avatar.png'),
      height: 0,
    );
    initLib();
    super.initState();
  }

  Widget wWidgetPdf = Container();
  Widget wPdf = Container();

  late SfPdfViewer wSfPdfViewer;
  PdfViewerController wPdfViewerController = PdfViewerController();

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;

  void onSetState() async {
    print("Parent onMaj() Relaod()");
//    builddoc();
  }

  void selTaches() async {
    selVue = 1;
    setState(() {});
  }

  void selPhotos() async {
    selVue = 2;
    setState(() {});
  }

  void selDocs() async {
    selVue = 3;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    double width = 800;
    double height = 595; //MediaQuery.of(context).size.height - 200;

    print("••••••••••••••••••••• build");

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  "Ordre de mission",
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "IM4b", selTaches, tooltip: "Tâches"),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: Stack(
                  children: <Widget>[
                    CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "IM5b", selPhotos, tooltip: "Photos"),

                    if (pastillePhoto > 0)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$pastillePhoto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: Stack(
                  children: <Widget>[
                    CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "IM5", selDocs, tooltip: "Documents"),
                    if (pastilleDoc > 0)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$pastilleDoc',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                  ],
                ),
              ),

            ],
          ),
          Container
            (
            height: 10,
          ),
          Container(
            height: 160,
            child: InterMissionGridWidget(),
          ),
          Container(
            height: 10,
          ),
          selVue != 1
              ? Container()
              : Column(
                  children: [
                    Container(
                      width: 800,
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: gColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        color: gColors.white,
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Image.asset("assets/images/IM4b.png"),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                "Libellé :",
                                style: gColors.bodySaisie_N_G,
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    color: Colors.transparent,
//                          width: 300,
                                    child: gColors.DropdownButtonMission(selectedMission, (sts) {
                                      setState(() {
                                        selectedMission = sts!;
                                        selectedMissionID = List_MissionID[List_Mission.indexOf(selectedMission)];
                                        InterMission_TextController.text = selectedMission;
                                        print("onCHANGE InterMission_TextController.text ${InterMission_TextController.text}");
                                      });
                                    }, List_Mission, List_MissionID),
                                  ),
                                ),
                                Container(
                                  width: 550,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                  child: Container(
                                    width: 500,
                                    color: Colors.white,
//                          padding: EdgeInsets.fromLTRB(0, 0, 50, 0),

                                    child: _buildFieldText(context, wInterMission),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                            ),
                            InkWell(
                              child:
                              Image.asset("assets/images/ico_Save.png",
                                width: 24.0,),

                              onTap: () async {
                                print("setInterMission A ${wInterMission.InterMissionId}");
                                if (wInterMission.InterMissionId > 0) {


                                  wInterMission.InterMission_Nom = InterMission_TextController.text;
                                  wInterMission.InterMission_Note = InterMission_NoteController.text;
                                  await DbTools.setInterMission(wInterMission);
                                  await Reload();
//                                  wInterMission = InterMission.InterMissionInit();
                                  DbTools.gInterMission = wInterMission;
                                }
                              },
                            ),
                            Container(
                              width: 5,
                            ),
                            InkWell(
                              child:                               Image.asset("assets/images/ico_Del.png",
                                width: 24.0,),

                              onTap: () async {
                                if (wInterMission.InterMissionId > 0) {
                                  await DbTools.delInterMission(wInterMission);
                                  await Reload();
                                  wInterMission = InterMission.InterMissionInit();
                                  DbTools.gInterMission = wInterMission;
                                }
                              },
                            ),
                            Container(
                              width: 5,
                            ),
                            InkWell(
                              child:

                              Image.asset("assets/images/ico_Add.png",
                                width: 24.0,),

                              onTap: () async {
                                InterMission interMission = await InterMission.InterMissionInit();
                                interMission.InterMission_InterventionId = DbTools.gIntervention.InterventionId!;
                                await DbTools.addInterMission(interMission);

                                await Reload();
                                print("ADD wInterMission ${DbTools.gLastID}");
                                wInterMission = DbTools.ListInterMissionsearchresult.firstWhere((element) => element.InterMissionId == DbTools.gLastID);
                                print("ADD wInterMission ${wInterMission.Desc()}");
                                InterMission_TextController.text = interMission.InterMission_Nom;
                                InterMission_NoteController.text = interMission.InterMission_Note;
                                DbTools.gInterMission = wInterMission;

//                      builddoc();

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 800,
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: gColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        color: gColors.white,
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Image.asset("assets/images/IM4c.png"),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                "Note :",
                                style: gColors.bodySaisie_N_G,
                              ),
                            ),
                            Container(
                              width: 680,
                              child: _buildFieldNote(context, wInterMission),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          selVue != 2 ? Container() : Photos(),
          selVue != 3 ? Container() : Documents(),
          selVue != 4 ? Container() : Documents(),


        ],
      ),
    );
  }

  final InterMission_TextController = TextEditingController();
  Widget _buildFieldText(BuildContext context, InterMission interMission) {
    print("_buildFieldText ${interMission.InterMission_Nom} ${wInterMission.InterMission_Nom}");
    print("_buildFieldText InterMission_TextController.text ${InterMission_TextController.text}");

    return TextFormField(
      controller: InterMission_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final InterMission_NoteController = TextEditingController();
  Widget _buildFieldNote(BuildContext context, InterMission interMission) {
    return TextFormField(
      maxLines: 17,
      minLines: 17,
      controller: InterMission_NoteController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  Widget InterMissionGridWidget() {
    List<DaviColumn<InterMission>> wColumns = [
      DaviColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellStyleBuilder: (row) => row.data.InterMissionId == wInterMission.InterMissionId ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null,
          cellBuilder: (BuildContext context, DaviRow<InterMission> aInterMission) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                return gColors.primary;
              }),
              value: aInterMission.data.InterMission_Exec,
              onChanged: (bool? value) async {
                aInterMission.data.InterMission_Exec = (value == true);
                await DbTools.setInterMission(aInterMission.data);
                setState(() {});
              },
            );
          }),
      new DaviColumn(name: 'ID', grow: 1, cellStyleBuilder: (row) => row.data.InterMissionId == wInterMission.InterMissionId ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null, stringValue: (row) => row.InterMissionId.toString()),
      new DaviColumn(name: 'Libellé', grow: 32, cellStyleBuilder: (row) => row.data.InterMissionId == wInterMission.InterMissionId ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null, stringValue: (row) => row.InterMission_Nom),
      new DaviColumn(name: 'Note', grow: 32, cellStyleBuilder: (row) => row.data.InterMissionId == wInterMission.InterMissionId ? CellStyle(background: gColors.backgroundColor, textStyle: const TextStyle(color: Colors.white)) : null, stringValue: (row) => row.InterMission_Note),
    ];

    print("InterMissionGridWidget");
    DaviModel<InterMission>? _model;
    _model = DaviModel<InterMission>(rows: DbTools.ListInterMissionsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<InterMission>(
          _model,
//          rowColor: _rowColor,
          visibleRowsCount: 5,
          onRowTap: (interMission) => _onRowTap(context, interMission),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

/*
  Color? _rowColor(DaviRow<InterMission> row) {
    if (row.data.InterMissionId == wInterMission.InterMissionId) {
      return gColors.backgroundColor;
    }

    return null;
  }
*/

  void _onRowTap(BuildContext context, InterMission interMission) async{
    isSelect = true;

    wInterMission = interMission;
    InterMission_TextController.text = interMission.InterMission_Nom;
    InterMission_NoteController.text = interMission.InterMission_Note;
    DbTools.gInterMission = wInterMission;
//    builddoc();
    print("_onRowTap ${wInterMission.InterMission_Nom}");

    await getPastille();

    setState(() {});
  }

//**********************************
//**********************************
//**********************************

  _startFileDoc(VoidCallback onSetState) async {
    String wDocPath = "Mission_${wInterMission.InterMissionId}_Doc.pdf";
    print("UploadFilePicker > ${wDocPath}");
    await Upload.UploadDocPicker(wDocPath, onSetState);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  _startFilePicker(VoidCallback onSetState) async {
    String wDocPath = "Mission_${wInterMission.InterMissionId}.jpg";
    await Upload.UploadFilePicker(wDocPath, onSetState);
  }


}
