import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/gObj.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_Dialog.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning.dart';
import 'package:verifplus_backoff/widgets/Sites/Photos.dart';
import 'package:verifplus_backoff/widgets/Sites/Mission.dart';

import 'package:verifplus_backoff/widgets/Sites/Zone_Interv_Add.dart';

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************

class IntervInfoDataGridSource extends DataGridSource {
  IntervInfoDataGridSource() {
    buildDataGridRows();
  }
  var inputFormat2 = DateFormat('dd/MM/yyyy');

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListInterventionsearchresult.map<DataGridRow>((Intervention Interv) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: Interv.InterventionId),
        DataGridCell<String>(columnName: 'date', value: "${inputFormat2.parse(Interv.Intervention_Date!)}"),
        DataGridCell<String>(columnName: 'org', value: DbTools.getParam_Param_Text("Type_Organe", Interv.Intervention_Parcs_Type!)),
        DataGridCell<String>(columnName: 'type', value: Interv.Intervention_Type),
        DataGridCell<int>(columnName: 'organes', value: Interv.Cnt),
        DataGridCell<String>(columnName: 'status', value: Interv.Intervention_Status),
        DataGridCell<String>(columnName: 'factu', value: Interv.Intervention_Facturation),
        DataGridCell<String>(columnName: 'ComInter', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable!)),
        DataGridCell<String>(columnName: 'ManCom', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable2!)),
        DataGridCell<String>(columnName: 'ManTech', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable3!)),
        DataGridCell<String>(columnName: 'RefTech', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable4!)),
        DataGridCell<String>(columnName: 'Rem', value: Interv.Intervention_Remarque!.replaceAll("\n", " - ")),
      ]);
    }).toList();
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    double t = 5;
    double b = 3;

    Color selectedRowTextColor = Colors.white;
    bool selected = (DbTools.gIntervention.InterventionId.toString() == row.getCells()[0].value.toString());
    Color textColor = selected ? selectedRowTextColor : Colors.black;
    Color backgroundColor = selected ? gColors.backgroundColor : Colors.transparent;

    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRowDate(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.center, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft, textColor),
    ]);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(alignment: Alignment.center, child: Text(summaryValue));
  }
}

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Zone_Interv extends StatefulWidget {
  const Zone_Interv({Key? key}) : super(key: key);

  @override
  State<Zone_Interv> createState() => _Zone_IntervState();
}

class _Zone_IntervState extends State<Zone_Interv> {
  List<double> dColumnWidth = [
    80,
    110,
    130,
    190,
    110,
    120,
    110,
    190,
    190,
    190,
    190,
    193,
  ];

  final MultiSelectController _controllerPartage = MultiSelectController();
  final MultiSelectController _controllerContrib = MultiSelectController();

  IntervInfoDataGridSource intervInfoDataGridSource = IntervInfoDataGridSource();

  final Search_TextController = TextEditingController();
  TextEditingController textController_Ct_Debut = TextEditingController();
  TextEditingController textController_Ct_Fin = TextEditingController();
  DateTime selectedDate = DateTime.now();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputFormat2 = DateFormat('dd/MM/yyyy');
  DateTime Ct_Debut = DateTime.now();
  DateTime Ct_Fin = DateTime.now();
  DataGridRow memDataGridRow = DataGridRow(cells: []);

  DateTime Du = DateTime.now();
  DateTime Au = DateTime.now();

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('date', 'Date', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('org', 'Organes', dColumnWidth[2], dColumnWidth[2], Alignment.centerLeft),
      FiltreTools.SfGridColumn('type', 'Type', dColumnWidth[3], dColumnWidth[3], Alignment.centerLeft),
      FiltreTools.SfGridColumn('organes', 'Cpt', dColumnWidth[4], dColumnWidth[4], Alignment.center),
      FiltreTools.SfGridColumn('status', 'Status', dColumnWidth[5], dColumnWidth[5], Alignment.centerLeft),
      FiltreTools.SfGridColumn('factu', 'Fact', dColumnWidth[6], dColumnWidth[6], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ComInter', 'Com. Inter', dColumnWidth[7], dColumnWidth[7], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ManCom', 'Man Com', dColumnWidth[8], dColumnWidth[8], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ManTech', 'Man Tecs', dColumnWidth[9], dColumnWidth[9], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RefTech', 'Ref Tech', dColumnWidth[10], dColumnWidth[10], Alignment.centerLeft),
      FiltreTools.SfGridColumn('Rem', 'Remarques', dColumnWidth[11], dColumnWidth[11], Alignment.centerLeft),
    ];
  }

  List<GridTableSummaryRow> getGridTableSummaryRow() {
    return [
      GridTableSummaryRow(
          color: gColors.secondary,
          showSummaryInRow: false,
          title: 'Cpt: {Count}',
          titleColumnSpan: 1,
          columns: [
            GridSummaryColumn(name: 'Count', columnName: 'id', summaryType: GridSummaryType.count),
            GridSummaryColumn(name: 'Sum', columnName: 'organes', summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'date')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'org')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'type')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'organes')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'status')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'factu')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'ComInter')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'ManCom')
        dColumnWidth[8] = args.width;
      else if (args.column.columnName == 'ComInter')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'ManCom')
        dColumnWidth[10] = args.width;
      else if (args.column.columnName == 'Rem') dColumnWidth[11] = args.width;
    });
  }

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

  String selectedUserInter2 = "";
  String selectedUserInterID2 = "";

  String selectedUserInter3 = "";
  String selectedUserInterID3 = "";

  String selectedUserInter4 = "";
  String selectedUserInterID4 = "";

  String selectedUserInter5 = "";
  String selectedUserInterID5 = "";

  String selectedUserInter6 = "";
  String selectedUserInterID6 = "";

  DateTime wDateTime = DateTime.now();

  Future Reload() async {
    await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
    Ct_Debut = DateTime.now();
    Ct_Fin = DateTime(1980);
    for (int i = 0; i < DbTools.ListIntervention.length; i++) {
      var element = DbTools.ListIntervention[i];

      try {
        DateTime wDT = inputFormat2.parse(element.Intervention_Date!);
        if (wDT.difference(Ct_Debut).inHours < 0) {
          Ct_Debut = wDT;
        }
        if (wDT.difference(Ct_Fin).inHours > 0) {
          Ct_Fin = wDT;
        }
      } catch (e) {}
    }

    textController_Ct_Debut.text = inputFormat2.format(Ct_Debut);
    textController_Ct_Fin.text = inputFormat2.format(Ct_Fin);

    await Filtre();
    AlimSaisie();
  }

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

    selectedUserInter2 = DbTools.List_UserInter[0];
    selectedUserInterID2 = DbTools.List_UserInterID[0];

    selectedUserInter3 = DbTools.List_UserInter[0];
    selectedUserInterID3 = DbTools.List_UserInterID[0];

    selectedUserInter4 = DbTools.List_UserInter[0];
    selectedUserInterID4 = DbTools.List_UserInterID[0];

    selectedUserInter5 = DbTools.List_UserInter[0];
    selectedUserInterID5 = DbTools.List_UserInterID[0];

    selectedUserInter6 = DbTools.List_UserInter[0];
    selectedUserInterID6 = DbTools.List_UserInterID[0];

    Reload();
  }

  Future Filtre() async {
    List<Intervention> ListInterventionsearchresultDate = [];
    DbTools.ListInterventionsearchresult.clear();

    try {
      if (textController_Ct_Debut.text.isNotEmpty) {
        Ct_Debut = inputFormat2.parse(textController_Ct_Debut.text);
      }

      if (textController_Ct_Fin.text.isNotEmpty) {
        Ct_Fin = inputFormat2.parse(textController_Ct_Fin.text);
      }
    } catch (e) {}

    for (int i = 0; i < DbTools.ListIntervention.length; i++) {
      var element = DbTools.ListIntervention[i];

      try {
        DateTime wDT = inputFormat2.parse(element.Intervention_Date!);
        if (wDT.difference(Ct_Debut).inHours >= 0 && wDT.difference(Ct_Fin).inHours <= 0) {
          ListInterventionsearchresultDate.add(element);
        }
      } catch (e) {}
    }
    if (Search_TextController.text.isEmpty) {
      DbTools.ListInterventionsearchresult.addAll(ListInterventionsearchresultDate);
    } else {
      ListInterventionsearchresultDate.forEach((element) {
        bool wAdd = false;
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          wAdd = true;
        }

        if (wAdd) {
          DbTools.ListInterventionsearchresult.add(element);
        }
      });
    }

    DbTools.ListInterventionsearchresult.sort(DbTools.affSortComparisonData);
    if (DbTools.ListInterventionsearchresult.length > 0) {
      if (DbTools.gIntervention.InterventionId == -1) DbTools.gIntervention = DbTools.ListInterventionsearchresult[0];
    }

    intervInfoDataGridSource.handleRefresh();
    intervInfoDataGridSource.sortedColumns.add(SortColumnDetails(name: 'date', sortDirection: DataGridSortDirection.descending));
    intervInfoDataGridSource.sort();

    setState(() {});
  }

  void AlimSaisie() async {
    if (DbTools.gIntervention.Intervention_Type!.isNotEmpty) {
      selectedTypeInterID = DbTools.gIntervention.Intervention_Type!;
      selectedTypeInter = DbTools.List_TypeInter[DbTools.List_TypeInterID.indexOf(selectedTypeInterID)];

      _controllerPartage.clearAllSelection();
      if (DbTools.gIntervention.Intervention_Partages!.isNotEmpty) {
        List<ValueItem> wValueItem = DbTools.ValueItem_parseStringToArray(DbTools.gIntervention.Intervention_Partages!);
        try {
          _controllerPartage.setSelectedOptions(wValueItem);
        } catch (e) {
          print(" ERROR ${e} ");
        }
      }

      _controllerContrib.clearAllSelection();
      if (DbTools.gIntervention.Intervention_Contributeurs!.isNotEmpty) {
        List<ValueItem> wValueItem = DbTools.ValueItem_parseStringToArray(DbTools.gIntervention.Intervention_Contributeurs!);
        try {
          _controllerContrib.setSelectedOptions(wValueItem);
        } catch (e) {
          print(" ERROR ${e} ");
        }
      }
    }

    print("AlimSaisie B");
    if (DbTools.gIntervention.Intervention_Status!.isNotEmpty) {
      selectedStatusInter = DbTools.gIntervention.Intervention_Status!;
      print("selectedStatusInter ${selectedStatusInter}");
      selectedStatusInterID = DbTools.List_StatusInterID[DbTools.List_StatusInter.indexOf(selectedStatusInter)];
    }

    if (DbTools.gIntervention.Intervention_Facturation!.isNotEmpty) {
      selectedFactInter = DbTools.gIntervention.Intervention_Facturation!;
      print("selectedFactInter ${selectedFactInter}");
      selectedFactInterID = DbTools.List_FactInterID[DbTools.List_FactInter.indexOf(selectedFactInter)];
    }

    await DbTools.getInterMissionsIntervention(DbTools.gIntervention.InterventionId!);

    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    selectedUserInter2 = DbTools.List_UserInter[0];
    selectedUserInterID2 = DbTools.List_UserInterID[0];

    selectedUserInter3 = DbTools.List_UserInter[0];
    selectedUserInterID3 = DbTools.List_UserInterID[0];

    selectedUserInter4 = DbTools.List_UserInter[0];
    selectedUserInterID4 = DbTools.List_UserInterID[0];

    selectedUserInter5 = DbTools.List_UserInter[0];
    selectedUserInterID5 = DbTools.List_UserInterID[0];

    selectedUserInter6 = DbTools.List_UserInter[0];
    selectedUserInterID6 = DbTools.List_UserInterID[0];

    if (DbTools.gIntervention.Intervention_Responsable!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable!);
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("Zone_Interv selectedUserInter $selectedUserInter");
      selectedUserInterID = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable2!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable2!);
      selectedUserInter2 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter2 $selectedUserInter2");
      selectedUserInterID2 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable3!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable3!);
      selectedUserInter3 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter3 $selectedUserInter3");
      selectedUserInterID3 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable4!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable4!);
      selectedUserInter4 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter4 $selectedUserInter4");
      selectedUserInterID4 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    textController_Intervention_Date.text = DbTools.gIntervention.Intervention_Date!;
    textController_Intervention_Type.text = DbTools.gIntervention.Intervention_Type!;
    textController_Intervention_Remarque.text = "${DbTools.gIntervention.Intervention_Remarque!}";

    await DbTools.getPlanning_InterventionIdRes(DbTools.gIntervention.InterventionId!);
    print("DbTools.ListUserH ${DbTools.gIntervention.InterventionId!} ${DbTools.ListUserH.length}");

    await DbTools.getPlanning_InterventionId(DbTools.gIntervention.InterventionId!);
    print("DbTools.ListPlanning ${DbTools.gIntervention.InterventionId!} ${DbTools.ListPlanning.length}");

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
//        color: Colors.red,

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
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: InterventionGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Save", ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", ToolsBarAdd, tooltip: "Ajouter Interventions"),
                  ),
                  (DbTools.gIntervention.Cnt! > 0)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
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

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_tks,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  void ToolsBarDelete() async {
    print("ToolsBarDelete");
    Alert(
      context: context,
      style: alertStyle,
      alertAnimation: fadeAlertAnimation,
      image: Container(
        height: 100,
        width: 100,
        child: Image.asset('assets/images/AppIco.png'),
      ),
      title: "Vérif+ Alerte",
      desc: "Êtes-vous sûre de vouloir supprimer cette Intervention ?",
      buttons: [
        DialogButton(
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black12),
        DialogButton(
            child: Text(
              "Suprimer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await DbTools.delIntervention(DbTools.gIntervention);
              await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
              await Filtre();
              Navigator.of(context).pop();
            },
            color: Colors.red)
      ],
    ).show();
  }

  void ToolsBarSave() async {
    DbTools.gIntervention.Intervention_Date = textController_Intervention_Date.text;
    DbTools.gIntervention.Intervention_Type = selectedTypeInterID;
    DbTools.gIntervention.Intervention_Status = selectedStatusInter;
    DbTools.gIntervention.Intervention_Facturation = selectedFactInter;
    DbTools.gIntervention.Intervention_Responsable = "$selectedUserInterID";
    DbTools.gIntervention.Intervention_Responsable2 = "$selectedUserInterID2";
    DbTools.gIntervention.Intervention_Responsable3 = "$selectedUserInterID3";
    DbTools.gIntervention.Intervention_Responsable4 = "$selectedUserInterID4";

    DbTools.gIntervention.Intervention_Partages = "${_controllerPartage.selectedOptions}";
    DbTools.gIntervention.Intervention_Contributeurs = "${_controllerContrib.selectedOptions}";

    DbTools.gIntervention.Intervention_Remarque = textController_Intervention_Remarque.text;
    await DbTools.setIntervention(DbTools.gIntervention);

    await Reload();
  }

  void ToolsBarAdd() async {
    print("Zone_Interv_Add >");
    await Zone_Interv_Add.Dialogs_Add(context, true);
    await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
    await Reload();
  }

  void ToolsPlanning() async {
    print("ToolsPlanning");
    await showDialog(context: context, builder: (BuildContext context) => new Planning(bAppBar: true));
    AlimSaisie();
  }

  Widget ContentInterventionCadre(BuildContext context) {
    return Container(
      width: 800,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: gColors.primary, width: 1),
        borderRadius: BorderRadius.circular(5),
        shape: BoxShape.rectangle,
        color: gColors.LinearGradient2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentIntervention(context),
        ],
      ),
    );
  }



//  int selMnu = 1;
//  String selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Tous";


  int selMnu = 4;
  String selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Tâches & Ordes de missions";



  Widget selMnuIco = Container(
    width: 30,
    height: 30,
    child: Image.asset("assets/images/IM1.png"),
  );
  void ToolsBarMnu1() async {
    setState(() {
      selMnu = 1;
      selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Tous";
      selMnuIco = Container(
        width: 30,
        height: 30,
        child: Image.asset("assets/images/IM$selMnu.png"),
      );
    });
  }

  void ToolsBarMnu2() async {
    setState(() {
      selMnu = 2;
      selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Commercial";
      selMnuIco = Container(
        width: 30,
        height: 30,
        child: Image.asset("assets/images/IM$selMnu.png"),
      );
    });
  }

  void ToolsBarMnu3() async {
    setState(() {
      selMnu = 3;
      selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Technique";
      selMnuIco = Container(
        width: 30,
        height: 30,
        child: Image.asset("assets/images/IM$selMnu.png"),
      );
    });
  }

  void ToolsBarMnu4() async {
    setState(() {
      selMnu = 4;
      selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Tâches & Ordes de missions";
      selMnuIco = Container(
        width: 30,
        height: 30,
        child: Image.asset("assets/images/IM$selMnu.png"),
      );
    });
  }

  void ToolsBarMnu5() async {
    setState(() {
      selMnu = 5;
      selMnuTxt = "Intervention ${DbTools.gIntervention.InterventionId} /// Habilitations";
      selMnuIco = Container(
        width: 30,
        height: 30,
        child: Image.asset("assets/images/IM$selMnu.png"),
      );
    });
  }



  String wIntervenants = "";
  Widget ContentIntervention(BuildContext context) {
    print("selMnu $selMnu");
    wIntervenants = "";
    for (int i = 0; i < DbTools.ListUserH.length; i++) {
      var element = DbTools.ListUserH[i];
      wIntervenants = "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    Du = DateTime(3000, 1, 1);
    Au = DateTime(1900, 1, 1);

    for (int i = 0; i < DbTools.ListPlanning.length; i++) {
      var planning = DbTools.ListPlanning[i];
      print("•••••••••• Du ${planning.Planning_InterventionstartTime} Au  ${planning.Planning_InterventionendTime}");
      if (planning.Planning_InterventionstartTime.isBefore(Du)) Du = planning.Planning_InterventionstartTime;
      if (planning.Planning_InterventionendTime.isAfter(Au)) Au = planning.Planning_InterventionendTime;
    }

    String wMissions = "";
    print(" ContentIntervention ListInterMission LENGHT ${DbTools.ListInterMission.length}");
    for (int i = 0; i < DbTools.ListInterMission.length; i++) {
      var element = DbTools.ListInterMission[i];
      print(" ListInterMission InterMission_Nom ${element.InterMission_Nom}");
      wMissions = "$wMissions${wMissions.isNotEmpty ? ", " : ""}${element.InterMission_Nom}";
    }

    double wI = 380;
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        selMnuIco,
                        Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: wI,
                            child: Text(
                              selMnuTxt,
                              style: gColors.bodyTitle1_B_Gr,
                            ))
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, 'IM1', ToolsBarMnu1, tooltip: "tous"),
                    ),
                    Container(padding: EdgeInsets.fromLTRB(10, 0, 10, 0), child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, 'IM2', ToolsBarMnu2, tooltip: "Commercial")),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, 'IM3', ToolsBarMnu3, tooltip: "Technique"),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, 'IM4', ToolsBarMnu4, tooltip: "Tâches & Ordes de missions"),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, 'IM6', ToolsBarMnu5, tooltip: "Habilitations"),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                height: 1,
              ),
              selMnu == 1
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Block_Entete(context),
                        Container(
                          height: 10,
                        ),
                        Block_Commercial(context),
                        Block_Technique(context),
                        Block_Mission(context),
                      ]))
                  : Container(),
              selMnu == 2
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Block_Entete(context),
                        Container(
                          height: 10,
                        ),
                        Block_Commercial(context),
                        Block_Mission(context),
                      ]))
                  : Container(),
              selMnu == 3
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Block_Entete(context),
                        Block_Technique(context),
                        Block_Mission(context),
                      ]))
                  : Container(),
              selMnu == 4
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Block_Entete(context),
                        Mission(),
                      ]))
                  : Container(),
              selMnu == 5
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Block_Entete(context),
                        Container(
                          height: 10,
                        ),
                      ]))
                  : Container(),
            ],
          ),
        ));
  }

  double wLD = 384;
  double wLabelD = 90;

  Widget Block_Mission(BuildContext context) {
    return Container(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "Ordre de mission",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                    child: Image.asset("assets/images/IM4.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Mission :",
                      style: gColors.bodySaisie_N_G,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 290,
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris"
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: gColors.bodySaisie_B_G,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Block_Technique(BuildContext context) {
    return Container(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "Technique",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM3.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(wLabelD, 8, "Manager Tech", selectedUserInter3, (sts) {
                        setState(() {
                          selectedUserInter3 = sts!;
                          selectedUserInterID3 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter3)];
                          print("onCHANGE selectedUserInter3 $selectedUserInter3");
                          print("onCHANGE selectedUserInterID3 $selectedUserInterID3");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM3b.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(wLabelD, 8, "Pilot Projet", selectedUserInter4, (sts) {
                        setState(() {
                          selectedUserInter4 = sts!;
                          selectedUserInterID4 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter4)];
                          print("onCHANGE selectedUserInter4 $selectedUserInter4");
                          print("onCHANGE selectedUserInterID4 $selectedUserInterID4");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM3c.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(wLabelD, 8, "Cond. travaux", selectedUserInter5, (sts) {
                        setState(() {
                          selectedUserInter5 = sts!;
                          selectedUserInterID5 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter5)];
                          print("onCHANGE selectedUserInter5 $selectedUserInter5");
                          print("onCHANGE selectedUserInterID5 $selectedUserInterID5");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM3d.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(wLabelD, 8, "Chef d'équipe", selectedUserInter6, (sts) {
                        setState(() {
                          selectedUserInter6 = sts!;
                          selectedUserInterID6 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter6)];
                          print("onCHANGE selectedUserInter6 $selectedUserInter6");
                          print("onCHANGE selectedUserInterID6 $selectedUserInterID6");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: gColors.white,
            ),
            child: InkWell(
              onTap: () async {

              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Image.asset("assets/images/IM3e.png"),
                    ),
                    Container(
                      width: 110,
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(
                        "Techniciens :",
                        style: gColors.bodySaisie_N_G,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 290,
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Text(
                          wIntervenants,
                          maxLines: 3,
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                    child: Image.asset("assets/images/IM3f.png"),
                  ),
                  Container(
                    width: 110,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Sous-traitants :",
                      style: gColors.bodySaisie_N_G,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 290,
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text(
                        wIntervenants,
                        maxLines: 3,
                        style: gColors.bodySaisie_B_G,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Block_Commercial(BuildContext context) {
    return Container(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "Commercial",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM2.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(90, 8, "Commercial", selectedUserInter, (sts) {
                        setState(() {
                          selectedUserInter = sts!;
                          selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
                          print("onCHANGE selectedUserInter $selectedUserInter");
                          print("onCHANGE selectedUserInterID $selectedUserInterID");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: wLD,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.asset("assets/images/IM2b.png"),
                      ),
                      gColors.DropdownButtonTypeInterC2(90, 8, "Manager Com", selectedUserInter2, (sts) {
                        setState(() {
                          selectedUserInter2 = sts!;
                          selectedUserInterID2 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter2)];
                          print("onCHANGE selectedUserInter2 $selectedUserInter2");
                          print("onCHANGE selectedUserInterID2 $selectedUserInterID2");
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                    child: Image.asset("assets/images/IM2c.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Partage commercial",
                      style: gColors.bodySaisie_N_G,
                    ),
                  ),
                  Expanded(
                    child: MultiSelectDropDown(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hint: "",
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      controller: _controllerPartage,
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        print("selectedOptions ${selectedOptions.toString()}");
                        print("selectedOptions ${_controllerPartage.selectedOptions.toString()}");
                      },
                      options: DbTools.List_ValueItem_User,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      optionTextStyle: gColors.bodySaisie_B_B,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
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
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                    child: Image.asset("assets/images/IM2d.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Contributeurs commerciaux",
                      style: gColors.bodySaisie_N_G,
                    ),
                  ),
                  Expanded(
                    child: MultiSelectDropDown(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hint: "",
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      controller: _controllerContrib,
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        print("selectedOptions ${selectedOptions.toString()}");
                        print("selectedOptions ${_controllerContrib.selectedOptions.toString()}");
                      },
                      options: DbTools.List_ValueItem_User,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      optionTextStyle: gColors.bodySaisie_B_B,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
          selMnu == 2
              ? Container(
                  width: 800,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                          child: Image.asset("assets/images/IM3f.png"),
                        ),
                        Container(
                          width: 110,
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            "Sous-traitants :",
                            style: gColors.bodySaisie_N_G,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 290,
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              wIntervenants,
                              maxLines: 3,
                              style: gColors.bodySaisie_B_G,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget Block_Entete(BuildContext context) {
    return Container(
        width: 800,
        padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
        decoration: BoxDecoration(
          border: Border.all(color: gColors.primary, width: 1),
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
          color: gColors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: wLD,
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/images/ico_Date.png", fit: BoxFit.cover),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${textController_Intervention_Date.text} ( Du ${DateFormat('dd/MM/yyyy').format(Du)} au ${DateFormat('dd/MM/yyyy').format(Au)})",
                            style: gColors.bodySaisie_B_B,
                          ),
                        ],
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(context: context, initialDate: wDateTime, firstDate: DateTime(DateTime.now().year - 10), lastDate: DateTime(DateTime.now().year + 10));
                        if (pickedDate != null) {
                          wDateTime = pickedDate;
                          print("pickedDate ${pickedDate}");
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          print("formattedDate ${formattedDate}");

                          setState(() {
                            textController_Intervention_Date.text = formattedDate;
                          });
                        } else {}
                      },
                    )),
                Container(
                  width: wLD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            gColors.Txt(100, "Organes", "${DbTools.getParam_Param_Text("Type_Organe", DbTools.gIntervention.Intervention_Parcs_Type!)}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: wLD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      selectedTypeInter.isEmpty
                          ? Container()
                          : gColors.DropdownButtonTypeInter(30, 8, "Type", selectedTypeInter, (sts) {
                              setState(() {
                                selectedTypeInter = sts!;
                                selectedTypeInterID = DbTools.List_TypeInterID[DbTools.List_TypeInter.indexOf(selectedTypeInter)];
                              });
                            }, DbTools.List_TypeInter, DbTools.List_TypeInterID),
                    ],
                  ),
                ),
                Container(
                  width: wLD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      selectedStatusInter.isEmpty
                          ? Container()
                          : gColors.DropdownButtonTypeInter(100, 8, "Status", selectedStatusInter, (sts) {
                              setState(() {
                                selectedStatusInter = sts!;
                                selectedStatusInterID = DbTools.List_StatusInterID[DbTools.List_StatusInter.indexOf(selectedStatusInter)];
                              });
                            }, DbTools.List_StatusInter, DbTools.List_StatusInterID),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: wLD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      (!DbTools.gClient.Client_Contrat)
                          ? Container()
                          : Row(
                              children: [
                                Text(
                                  "Contrat ",
                                  style: gColors.bodySaisie_N_G,
                                ),
                                (DbTools.gClient.Client_Contrat_No.isEmpty)
                                    ? Container()
                                    : Text(
                                        "N° ${DbTools.gClient.Client_Contrat_No} - ",
                                        style: gColors.bodySaisie_B_G,
                                      ),
                                Text(
                                  "${DbTools.gClient.Client_TypeContrat}",
                                  style: gColors.bodySaisie_B_G,
                                )
                              ],
                            )
                    ],
                  ),
                ),
                Container(
                  width: wLD,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  DataGridController getDataGridController() {
    return dataGridController;
  }

  Widget InterventionGridWidget() {
    return Column(children: [
      ToolsBar(context),
      Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          height: MediaQuery.of(context).size.height - 250,
          child: SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: gColors.secondary,
                selectionColor: gColors.transparent,
              ),
              child: SfDataGrid(
                //*********************************
                onFilterChanged: (DataGridFilterChangeDetails details) {
                  countfilterConditions = intervInfoDataGridSource.filterConditions.length;
                  setState(() {});
                },
                onCellTap: (DataGridCellTapDetails details) async {
                  int wRowSel = details.rowColumnIndex.rowIndex;
                  if (wRowSel == 0) return;

                  wColSel = details.rowColumnIndex.columnIndex;
                  DataGridRow wDataGridRow = intervInfoDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                  Selindex = intervInfoDataGridSource.dataGridRows.indexOf(wDataGridRow);
                  DbTools.gIntervention = DbTools.ListInterventionsearchresult[Selindex];
                  await DbTools.getGroupe(DbTools.gIntervention.GroupeId!);
                  await DbTools.getSite(DbTools.gIntervention.SiteId!);
                  await DbTools.getZone(DbTools.gIntervention.ZoneId!);
                  AlimSaisie();
                  if (wColSel == 0) {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) => new Intervention_Dialog(
                              site: DbTools.gSite,
                            ));
                  }
                  Reload();
                },

                //*********************************

                allowSorting: true,
                allowFiltering: true,
                source: intervInfoDataGridSource,
                columns: getColumns(),
                tableSummaryRows: getGridTableSummaryRow(),

                headerRowHeight: 35,
                rowHeight: 28,
                allowColumnsResizing: true,
                columnResizeMode: ColumnResizeMode.onResize,
                selectionMode: SelectionMode.single,
                controller: getDataGridController(),
                onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                  Resize(args);
                  return true;
                },
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columnWidthMode: ColumnWidthMode.fill,
                isScrollbarAlwaysShown: true,
              )))
    ]);
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: Column(
          children: [
            Row(
              children: [
                CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
                ToolsBarSearch(context),
              ],
            ),
          ],
        ));
  }

  void ToolsBarSupprFilter() async {
    intervInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    Reload();
    setState(() {});
  }

  Widget ToolsBarSearch(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: 20,
          ),
          InkWell(
            child: Row(
              children: [
                Text(
                  "Début :  ",
                  style: gColors.bodySaisie_N_G,
                ),
                Text(
                  "${textController_Ct_Debut.text.isEmpty ? "--/--/--" : textController_Ct_Debut.text}",
                  style: gColors.bodyText_B_G,
                ),
              ],
            ),
            onTap: () async {
              if (textController_Ct_Debut.text.isEmpty)
                selectedDate = DateTime.now();
              else
                selectedDate = inputFormat2.parse(textController_Ct_Debut.text);
              await _selectDate(context, DateTime(1980), DateTime.now());

              if (selectedDate.difference(DateTime.now()).inHours >= 0) return;
              if (selectedDate.difference(Ct_Fin).inHours >= 0) return;
              countfilterConditions = 999;
              textController_Ct_Debut.text = DateFormat('dd/MM/yyyy').format(selectedDate);

              await Filtre();
            },
          ),
          Container(
            width: 20,
          ),
          InkWell(
            child: Row(
              children: [
                Text(
                  "Fin :  ",
                  style: gColors.bodySaisie_N_G,
                ),
                Text(
                  "${textController_Ct_Fin.text.isEmpty ? "--/--/--" : textController_Ct_Fin.text}",
                  style: gColors.bodyText_B_G,
                ),
              ],
            ),
            onTap: () async {
              if (textController_Ct_Fin.text.isEmpty)
                selectedDate = DateTime.now();
              else
                selectedDate = inputFormat2.parse(textController_Ct_Fin.text);
              await _selectDate(context, Ct_Debut, DateTime.now());

              if (selectedDate.difference(DateTime.now()).inHours >= 0) return;
              if (selectedDate.difference(Ct_Debut).inHours < 0) return;

              countfilterConditions = 999;
              textController_Ct_Fin.text = DateFormat('dd/MM/yyyy').format(selectedDate);

              await Filtre();
            },
          ),
          Container(
            width: 20,
          ),
          Icon(
            Icons.search,
            color: Colors.blue,
            size: 30.0,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: Search_TextController,
              decoration: gColors.wRechInputDecoration,
              onChanged: (String? value) async {
                print("_buildFieldTextSearch search ${Search_TextController.text}");
                await Filtre();
              },
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.cancel,
              size: 20.0,
            ),
            onPressed: () async {
              Search_TextController.clear();
              await Filtre();
            },
          ),
          Container(
            width: 20,
          ),
        ],
      ),
    ));
  }

  Future<void> _selectDate(BuildContext context, DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: firstDate, lastDate: lastDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
