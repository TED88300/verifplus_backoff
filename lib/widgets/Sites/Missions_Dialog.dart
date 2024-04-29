import 'dart:typed_data';

import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/PdfView.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Missions_Dialog {
  Missions_Dialog();

  static Future<void> Missions_dialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Missions(),
    );
  }
}

class Missions extends StatefulWidget {
  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  InterMission wInterMission = InterMission.InterMissionInit();

  String wTitle = "";

  String selectedMission = "";
  String selectedMissionID = "";
  List<String> List_Mission = [];
  List<String> List_MissionID = [];

  bool isSelect = false;



  Future Reload() async {
    await DbTools.getInterMissionsIntervention(DbTools.gIntervention.InterventionId!);
    builddoc();
    await Filtre();
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
      builddoc();
    }

    InterMission_TextController.text = wInterMission.InterMission_Nom;
    InterMission_NoteController.text = wInterMission.InterMission_Note;
    await Filtre();
  }

  void initState() {
    wImage = Image(
      image: AssetImage('assets/images/Avatar.png'),
      height: 0,
    );
    initLib();
    super.initState();
  }

  Widget wWidgetPdf = Container();
  Widget wPdf = Container();
  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;

  void builddoc() async {
    print("builddocbuilddocbuilddocbuilddocbuilddocbuilddocbuilddoc"); // ${pic}");

    String wUserImg = "Mission_${wInterMission.InterMissionId}.jpg";
    pic = await gColors.getImage(wUserImg);

    print("wUserImg $wUserImg length ${pic.length}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 100,
        height: 100,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar.png'),
        height: 0,
      );
    }

    wWidgetPdf = Container();
    wPdf = Container();

    String wDocPath = "Mission_${wInterMission.InterMissionId}_Doc.pdf";

    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
    Uint8List? _bytes = await gColors.getImage(wDocPath);

    print("wDocPath $wDocPath length ${_bytes.length}");


    print("_bytes length ${_bytes.length}");
    if (_bytes.length > 0) {
      wPdf = SfPdfViewer.memory(
        _bytes,
        key: _pdfViewerKey,
        enableDocumentLinkAnnotation: false,
        enableTextSelection: false,
        interactionMode: PdfInteractionMode.pan,
      );

      wWidgetPdf = Column(
        children: [
          Container(
            width: 200,
            height: 200,
            child: wPdf,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wPdf)));
                  setState(() {});
                },
                icon: Icon(Icons.open_with, color: Colors.green),
              ),
              IconButton(
                onPressed: () async {
                  print("delete $wDocPath");
                  await DbTools.removephoto_API_Post(wDocPath);
                  PaintingBinding.instance.imageCache.clear();
                  imageCache.clear();
                  imageCache.clearLiveImages();
                  await DefaultCacheManager().emptyCache(); //clears all data in cache.
                  await DefaultCacheManager().removeFile(wDocPath);
                  Reload();
                },
                icon: Icon(Icons.delete, color: Colors.red),
              )
            ],
          )
        ],
      );
    }
    setState(() {});

  }

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    builddoc();

  }

  Widget Photo() {
    String wImgPath = "${DbTools.SrvImg}Mission_${wInterMission.InterMissionId}.jpg";

    print("wImgPath $wImgPath");
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Image.asset("assets/images/Photo.png"),
              onPressed: () async {
                await _startFilePicker(onSetState);
              },
            ),
            Container(width: 10),
            wImage,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    double width = 600;
    double height = 580; //MediaQuery.of(context).size.height - 200;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: gColors.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Intervention / Missions",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_W,
              ),
            ],
          )),
      content: Container(
        margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 1,
                        ),
                        Container(
                          width: 480,
                          child: _buildFieldText(context, wInterMission),
                        ),
                        Container(
                          width: 1,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.check,
                            color: wInterMission.InterMissionId > 0 ? Colors.blue : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wInterMission.InterMissionId > 0) {
                              wInterMission.InterMission_Nom = InterMission_TextController.text;
                              wInterMission.InterMission_Note = InterMission_NoteController.text;
                              await DbTools.setInterMission(wInterMission);
                              await Reload();
                              wInterMission = InterMission.InterMissionInit();
                            }
                          },
                        ),
                        Container(
                          width: 1,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.delete,
                            color: wInterMission.InterMissionId > 0 ? Colors.red : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wInterMission.InterMissionId > 0) {
                              await DbTools.delInterMission(wInterMission);
                              await Reload();
                              wInterMission = InterMission.InterMissionInit();
                            }
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                            size: 24.0,
                          ),
                          onTap: () async {
                            InterMission interMission = await InterMission.InterMissionInit();
                            interMission.InterMission_InterventionId = DbTools.gIntervention.InterventionId!;
                            await DbTools.addInterMission(interMission);

                            await Reload();
                            setState(() {
                              print("wInterMission ${DbTools.gLastID}");
                              wInterMission = DbTools.ListInterMissionsearchresult.firstWhere((element) => element.InterMissionId == DbTools.gLastID);
                              print("wInterMission $wInterMission");
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 1,
                        ),
                        Container(
                          width: 280,
                          child: gColors.DropdownButtonMission(selectedMission, (sts) {
                            setState(() {
                              selectedMission = sts!;
                              selectedMissionID = List_MissionID[List_Mission.indexOf(selectedMission)];
                              InterMission_TextController.text = selectedMission;
                              print("onCHANGE InterMission_TextController.text ${InterMission_TextController.text}");
                            });
                          }, List_Mission, List_MissionID),
                        ),
                        Container(
                          width: 280,
                          child: _buildFieldNote(context, wInterMission),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Photo(),
                        Column(
                          children: [
                            Container(width: 8),
                            IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              icon: Image.asset("assets/images/Doc.png"),
                              onPressed: () async {
                                await _startFileDoc(onSetState);
                              },
                            ),
                          ],
                        ),
                        Container(width: 10),
                        wWidgetPdf,
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              Expanded(child: InterMissionGridWidget()),
            ],
          ),
        ),
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
          cellBuilder: (BuildContext context, DaviRow<InterMission> aInterMission) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
      new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.InterMission_Nom),
      new DaviColumn(name: 'Note', grow: 18, stringValue: (row) => row.InterMission_Note),
    ];

    print("InterMissionGridWidget");
    DaviModel<InterMission>? _model;
    _model = DaviModel<InterMission>(rows: DbTools.ListInterMissionsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<InterMission>(
          _model,
          visibleRowsCount: 10,
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

  void _onRowTap(BuildContext context, InterMission interMission) {
      isSelect = true;

      wInterMission = interMission;
      InterMission_TextController.text = interMission.InterMission_Nom;
      InterMission_NoteController.text = interMission.InterMission_Note;
      builddoc();
      print("_onRowTap ${wInterMission.InterMission_Nom}");

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
