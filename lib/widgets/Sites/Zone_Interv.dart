import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/Intervenants_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/Missions_Dialog.dart';

class Zone_Interv extends StatefulWidget {
  const Zone_Interv({Key? key}) : super(key: key);

  @override
  State<Zone_Interv> createState() => _Zone_IntervState();
}

class _Zone_IntervState extends State<Zone_Interv> {
  TextEditingController textController_Intervention_Date = TextEditingController();
  TextEditingController textController_Intervention_Type = TextEditingController();
  TextEditingController textController_Intervention_Remarque = TextEditingController();

  String selectedTypeInter = "";
  String selectedTypeInterID = "";
  String selectedParcTypeInter = "";
  String selectedParcTypeInterID = "";
  String selectedStatusInter = "";
  String selectedStatusInterID = "";
  String selectedFactInter = "";
  String selectedFactInterID = "";

  String selectedUserInter = "";
  String selectedUserInterID = "";

  DateTime wDateTime = DateTime.now();

  Future initLib() async {
    await DbTools.initListFam();

    selectedTypeInter = DbTools.List_TypeInter[0];
    selectedTypeInterID = DbTools.List_TypeInterID[0];

    selectedParcTypeInter = DbTools.List_ParcTypeInter[0];
    selectedParcTypeInterID = DbTools.List_ParcTypeInterID[0];

    selectedStatusInter = DbTools.List_StatusInter[0];
    selectedStatusInterID = DbTools.List_StatusInterID[0];

    selectedFactInter = DbTools.List_FactInter[0];
    selectedFactInterID = DbTools.List_FactInterID[0];

    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
    Filtre();

    AlimSaisie();
  }

  Future Filtre() async {
    DbTools.ListInterventionsearchresult.clear();
    DbTools.ListInterventionsearchresult.addAll(DbTools.ListIntervention);
    DbTools.ListInterventionsearchresult.sort(DbTools.affSortComparisonData);

    if (DbTools.ListInterventionsearchresult.length > 0) {
      DbTools.gIntervention = DbTools.ListInterventionsearchresult[0];
    }
    await DbTools.getInterMissionsIntervention(DbTools.gIntervention.InterventionId!);
    print("Filtre ListInterMission LENGHT ${DbTools.ListInterMission.length}");

    setState(() {});
  }

  void AlimSaisie() async {
    if (DbTools.gIntervention.Intervention_Type!.isNotEmpty) {
      selectedTypeInter = DbTools.gIntervention.Intervention_Type!;
      selectedTypeInterID = DbTools.List_TypeInterID[DbTools.List_TypeInter.indexOf(selectedTypeInter)];
    }

    if (DbTools.gIntervention.Intervention_Status!.isNotEmpty) {
      selectedStatusInter = DbTools.gIntervention.Intervention_Status!;
      selectedStatusInterID = DbTools.List_StatusInterID[DbTools.List_StatusInter.indexOf(selectedStatusInter)];
    }

    if (DbTools.gIntervention.Intervention_Facturation!.isNotEmpty) {
      selectedFactInter = DbTools.gIntervention.Intervention_Facturation!;
      selectedFactInterID = DbTools.List_FactInterID[DbTools.List_FactInter.indexOf(selectedFactInter)];
    }



    if (DbTools.gIntervention.Intervention_Responsable!.isNotEmpty) {
      DbTools.getUserid(DbTools.gIntervention.Intervention_Responsable!);
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter $selectedUserInter");
      selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    textController_Intervention_Date.text = DbTools.gIntervention.Intervention_Date!;

    textController_Intervention_Type.text = DbTools.gIntervention.Intervention_Type!;

    textController_Intervention_Remarque.text = "${DbTools.gIntervention.Intervention_Remarque!}";

    await DbTools.getPlanning_InterventionIdRes(DbTools.gIntervention.InterventionId!);
    print("DbTools.ListUserH ${DbTools.ListUserH.length}");

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//          ToolsBar(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: InterventionGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter Interventions"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                ],
              ),
              ContentInterventionCadre(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                ),
                Icon(
                  Icons.search,
                  color: Colors.blue,
                  size: 30.0,
                ),
                Container(
                  width: 10,
                ),
                Container(
                  width: 10,
                ),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
            ),
            Container(
              height: 1,
              color: gColors.primary,
            )
          ],
        ));
  }

  void ToolsBarSave() async {
    DbTools.gIntervention.Intervention_Date = textController_Intervention_Date.text;
    DbTools.gIntervention.Intervention_Type = selectedTypeInter;
    DbTools.gIntervention.Intervention_Status = selectedStatusInter;
    DbTools.gIntervention.Intervention_Facturation = selectedFactInter;
    DbTools.gIntervention.Intervention_Responsable = "$selectedUserInterID";
    DbTools.gIntervention.Intervention_Remarque = textController_Intervention_Remarque.text;
    await DbTools.setIntervention(DbTools.gIntervention);
    await Filtre();
  }

  void ToolsBarAdd() async {
    await DbTools.addIntervention(DbTools.gSite.SiteId, "2023/06/22", "Verif");
    DbTools.getInterventionID(DbTools.gLastID);
    await initLib();
  }

  Widget ContentInterventionCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 460,
          margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentIntervention(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Intervention ${DbTools.gIntervention.InterventionId}',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void Intervenants() async {
//    await Intervenants_Dialog.Intervenants_dialog(context);
//    setState(() {});
  }

  void Missions() async {
    await Missions_Dialog.Missions_dialog(context);
    setState(() {});
  }

  Widget ContentIntervention(BuildContext context) {
    /*  String wIntervenants = "";
    for (int i = 0; i < DbTools.ListUser.length; i++) {
      var element = DbTools.ListUser[i];
      if ( DbTools.gIntervention.Intervention_Intervenants!.contains("${element.UserID}"))
        wIntervenants = "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom}";
    }*/

    String wIntervenants = "";
    for (int i = 0; i < DbTools.ListUserH.length; i++) {
      var element = DbTools.ListUserH[i];
      wIntervenants = "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    String wMissions = "";
    print("ContentIntervention ListInterMission LENGHT ${DbTools.ListInterMission.length}");
    for (int i = 0; i < DbTools.ListInterMission.length; i++) {
      var element = DbTools.ListInterMission[i];
      print("ListInterMission InterMission_Nom ${element.InterMission_Nom}");
      wMissions = "$wMissions${wMissions.isNotEmpty ? ", " : ""}${element.InterMission_Nom}";
    }

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Center(
                          child: TextField(
                        controller: textController_Intervention_Date,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                        ),

                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(context: context, initialDate: wDateTime, firstDate: DateTime(DateTime.now().year - 10), lastDate: DateTime(DateTime.now().year + 10));
                          if (pickedDate != null) {
                            wDateTime = pickedDate;
                            print(pickedDate);
                            String formattedDate = DateFormat('dd/mm/yyyy').format(pickedDate);
                            print(formattedDate);
                            setState(() {
                              textController_Intervention_Date.text = formattedDate;
                            });
                          } else {}
                        },
                      ))),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Row(
                      children: [
                        gColors.Txt(100, "Organes", "${DbTools.getParam_Param_Text("Type_Organe", DbTools.gIntervention.Intervention_Parcs_Type!)}"),
                      ],
                    ),
                  ),
                  selectedTypeInter.isEmpty
                      ? Container()
                      : gColors.DropdownButtonTypeInter(100, 8, "Type", selectedTypeInter, (sts) {
                          setState(() {
                            selectedTypeInter = sts!;
                            selectedTypeInterID = DbTools.List_TypeInterID[DbTools.List_TypeInter.indexOf(selectedTypeInter)];
                            print("onCHANGE selectedTypeInter $selectedTypeInter");
                            print("onCHANGE selectedTypeInterID $selectedTypeInterID");
                          });
                        }, DbTools.List_TypeInter, DbTools.List_TypeInterID),
                  selectedStatusInter.isEmpty
                      ? Container()
                      : gColors.DropdownButtonTypeInter(100, 8, "Status", selectedStatusInter, (sts) {
                          setState(() {
                            selectedStatusInter = sts!;
                            selectedStatusInterID = DbTools.List_StatusInterID[DbTools.List_StatusInter.indexOf(selectedStatusInter)];
                            print("onCHANGE selectedStatusInter $selectedStatusInter");
                            print("onCHANGE selectedStatusInterID $selectedStatusInterID");
                          });
                        }, DbTools.List_StatusInter, DbTools.List_StatusInterID),
                  selectedFactInter.isEmpty
                      ? Container()
                      : gColors.DropdownButtonTypeInter(100, 8, "Facturation", selectedFactInter, (sts) {
                          setState(() {
                            selectedFactInter = sts!;
                            selectedFactInterID = DbTools.List_FactInterID[DbTools.List_FactInter.indexOf(selectedFactInter)];
                            print("onCHANGE selectedFactInter $selectedFactInter");
                            print("onCHANGE selectedFactInterID $selectedFactInterID");
                          });
                        }, DbTools.List_FactInter, DbTools.List_FactInterID),
                  selectedUserInter.isEmpty
                      ? Container()
                      : gColors.DropdownButtonTypeInter(100, 8, "Responsable", selectedUserInter, (sts) {
                          setState(() {
                            selectedUserInter = sts!;
                            selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
                            print("onCHANGE selectedUserInter $selectedUserInter");
                            print("onCHANGE selectedUserInterID $selectedUserInterID");
                          });
                        }, DbTools.List_UserInter, DbTools.List_UserInterID),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                        child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.red, Icons.people, Intervenants, tooltip: "Intervenants"),
                      ),
                      Container(
                        width: 290,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          wIntervenants,
                          maxLines: 3,
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                        child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.engineering, Missions, tooltip: "Missions"),
                      ),
                      Container(
                        width: 290,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          wMissions,
                          maxLines: 3,
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(100, 40, "Remarque", textController_Intervention_Remarque, Ligne: 5),
                    ],
                  ),
                ]))));
  }

  Widget InterventionGridWidget() {
    List<EasyTableColumn<Intervention>> wColumns = [
      EasyTableColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellBuilder: (BuildContext context, RowData<Intervention> aIntervention) {
            return InkWell(
                child: const Icon(Icons.edit, size: 16),
                onTap: () async {
                  DbTools.gIntervention = aIntervention.row;
                  print("DbTools.gIntervention.InterventionId ${DbTools.gIntervention.InterventionId}");
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => new Intervention_Dialog(
                            site: DbTools.gSite,
                          ));
                });
          }),
      new EasyTableColumn(name: 'Date', width: 100, stringValue: (row) => "${row.Intervention_Date}"),
      new EasyTableColumn(name: 'Organes', width: 100, stringValue: (row) => "${DbTools.getParam_Param_Text("Type_Organe", row.Intervention_Parcs_Type!)}"),
      new EasyTableColumn(name: 'Type', width: 100, stringValue: (row) => "${row.Intervention_Type}"),
      new EasyTableColumn(name: 'Status', width: 100, stringValue: (row) => "${row.Intervention_Status}"),
      new EasyTableColumn(name: 'Facturation', width: 100, stringValue: (row) => "${row.Intervention_Facturation}"),
      new EasyTableColumn(name: 'Responsable', width: 190, stringValue: (row) => "${DbTools.getUserid_Nom(row.Intervention_Responsable!)}"),
      new EasyTableColumn(name: 'Remarque', width: 480, stringValue: (row) => "${row.Intervention_Remarque!.replaceAll("\n", " - ")}"),
      new EasyTableColumn(name: 'Organes', width: 80, stringValue: (row) => "${row.Cnt}", cellAlignment: Alignment.center),
    ];
    print("InterventionGridWidget ${DbTools.ListInterventionsearchresult.length}");
    EasyTableModel<Intervention>? _model;
    _model = EasyTableModel<Intervention>(rows: DbTools.ListInterventionsearchresult, columns: wColumns);
    return new EasyTableTheme(
        child: new EasyTable<Intervention>(visibleRowsCount: 16, _model, onRowTap: (Intervention) async {
          DbTools.gIntervention = Intervention;

          AlimSaisie();
        }),
        data: EasyTableThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColor: Colors.black, expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }
}
