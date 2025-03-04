import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_Dialog.dart';

// Responsable Intervention:
// Manager technique Tectn : (????) pour planif
// Coll Plannifier :

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************

class IntervInfoDataGridSource extends DataGridSource {
  IntervInfoDataGridSource() {
    buildDataGridRows();
  }

//  DATE 2024-04-12T17:26:40.987656
  var inputFormat2 = DateFormat('dd/MM/yyyy');

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListInterventionsearchresult.map<DataGridRow>((Intervention Interv) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: Interv.InterventionId),
        DataGridCell<String>(columnName: 'status', value: Interv.Intervention_Status),
        DataGridCell<String>(columnName: 'client', value: Interv.Client_Nom),
        DataGridCell<String>(columnName: 'groupe', value: Interv.Groupe_Nom),
        DataGridCell<String>(columnName: 'site', value: Interv.Site_Nom),
        DataGridCell<String>(columnName: 'zone', value: Interv.Zone_Nom),
        DataGridCell<String>(columnName: 'date', value: "${inputFormat2.parse(Interv.Intervention_Date!)}"),
        DataGridCell<String>(columnName: 'type', value: Interv.Intervention_Type),
        DataGridCell<String>(columnName: 'org', value: DbTools.getParam_Param_Text("Type_Organe", Interv.Intervention_Parcs_Type!)),
        DataGridCell<int>(columnName: 'organes', value: Interv.Cnt),
        DataGridCell<String>(columnName: 'factu', value: Interv.Intervention_Facturation),
        DataGridCell<String>(columnName: 'ComInter', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable!)),
        DataGridCell<String>(columnName: 'ManCom', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable2!)),
        DataGridCell<String>(columnName: 'ManTech', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable3!)),
        DataGridCell<String>(columnName: 'RefTech', value: DbTools.getUserMat_Nom(Interv.Intervention_Responsable4!)),
        DataGridCell<String>(columnName: 'Rem', value: Interv.Intervention_Remarque!.replaceAll("\n", " - ")),
      ]);
    }).toList();
    sortedColumns.add(SortColumnDetails(name: 'organes', sortDirection: DataGridSortDirection.descending));
    sort();
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
    bool selected = (DbTools.gIntervention.InterventionId.toString() == row.getCells()[1].value.toString());
    Color textColor = selected ? selectedRowTextColor : Colors.black;
    Color backgroundColor = selected ? gColors.backgroundColor : Colors.transparent;

    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor,), // bCircle : true),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor, bCircle: true),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRowDate(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 8, Alignment.center, textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 12, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 13, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 14, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 15, Alignment.centerLeft, textColor),
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

class Interventions extends StatefulWidget {
  @override
  _InterventionsState createState() => _InterventionsState();
}

class _InterventionsState extends State<Interventions> {
  List<double> dColumnWidth = [
    80,
    135,
    200,
    150,
    300,
    170,
    120,
    130,
    110,
    80,
    110,
    190,
    190,
    190,
    190,
    273,
  ];

  IntervInfoDataGridSource intervInfoDataGridSource = IntervInfoDataGridSource();

  final Search_TextController = TextEditingController();
  TextEditingController textController_Ct_Debut = TextEditingController();
  TextEditingController textController_Ct_Fin = TextEditingController();
  DateTime selectedDate = DateTime.now();

  int wColSel = -1;
  int wRowSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputFormat2 = DateFormat('dd/MM/yyyy');
  DateTime Ct_Debut = DateTime.now();
  DateTime Ct_Fin = DateTime.now();

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('status', 'Status', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('client', 'Client', dColumnWidth[2], dColumnWidth[2], Alignment.centerLeft),
      FiltreTools.SfGridColumn('groupe', 'Groupe', dColumnWidth[3], dColumnWidth[3], Alignment.centerLeft),
      FiltreTools.SfGridColumn('site', 'Site', dColumnWidth[4], dColumnWidth[4], Alignment.centerLeft),
      FiltreTools.SfGridColumn('zone', 'Zone', dColumnWidth[5], dColumnWidth[5], Alignment.centerLeft),
      FiltreTools.SfGridColumn('date', 'Date', dColumnWidth[6], dColumnWidth[6], Alignment.centerLeft),
      FiltreTools.SfGridColumn('type', 'Type', dColumnWidth[7], dColumnWidth[7], Alignment.centerLeft),
      FiltreTools.SfGridColumn('org', 'Organes', dColumnWidth[8], dColumnWidth[8], Alignment.centerLeft),
      FiltreTools.SfGridColumn('organes', 'Cpt', dColumnWidth[9], dColumnWidth[9], Alignment.center),
      FiltreTools.SfGridColumn('factu', 'Fact', dColumnWidth[10], dColumnWidth[10], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ComInter', 'Com. Inter', dColumnWidth[11], dColumnWidth[11], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ManCom', 'Man Com', dColumnWidth[12], dColumnWidth[12], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ManTech', 'Man Tecs', dColumnWidth[13], dColumnWidth[13], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RefTech', 'Ref Tech', dColumnWidth[14], dColumnWidth[14], Alignment.centerLeft),
      FiltreTools.SfGridColumn('Rem', 'Remarques', dColumnWidth[15], dColumnWidth[15], Alignment.centerLeft),
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
      else if (args.column.columnName == 'groupe')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'site')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'zone')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'date')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'org')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'type')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'organes')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'status')
        dColumnWidth[8] = args.width;
      else if (args.column.columnName == 'cpt')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'factu')
        dColumnWidth[10] = args.width;
      else if (args.column.columnName == 'ComInter')
        dColumnWidth[11] = args.width;
      else if (args.column.columnName == 'ManCom')
        dColumnWidth[12] = args.width;
      else if (args.column.columnName == 'ComInter')
        dColumnWidth[13] = args.width;
      else if (args.column.columnName == 'ManCom')
        dColumnWidth[14] = args.width;
      else if (args.column.columnName == 'Rem') dColumnWidth[15] = args.width;
    });
  }

  Future Reload() async {
    await DbTools.initListFam();
    await DbTools.getInterventionAll();

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
    Filtre();
  }

  Future Filtre() async {
    List<Intervention> ListInterventionsearchresultDate = [];
    DbTools.ListInterventionsearchresult.clear();

    try {
      if (textController_Ct_Debut.text.isNotEmpty) {
//        print("textController_Ct_Debut.text ${textController_Ct_Debut.text}");
//        print("Ct_Debut > ${Ct_Debut}");
        Ct_Debut = inputFormat2.parse(textController_Ct_Debut.text);
      }

      if (textController_Ct_Fin.text.isNotEmpty) {
//        print("textController_Ct_Fin.text ${textController_Ct_Fin.text}");
//        print("Ct_Fin > ${Ct_Fin}");
        Ct_Fin = inputFormat2.parse(textController_Ct_Fin.text);
//        print("Ct_Fin <>> ${Ct_Fin}");
      }
    } catch (e) {}

    print("Ct_Debut > ${Ct_Debut}");
    print("Ct_Fin   < ${Ct_Fin}");

    print("DbTools.ListIntervention.length ${DbTools.ListIntervention.length}");

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

    print("DbTools.ListInterventionsearchresult.length ${DbTools.ListInterventionsearchresult.length}");

    intervInfoDataGridSource.handleRefresh();
    setState(() {});
  }

  @override
  void initState() {
    textController_Ct_Debut.text = inputFormat2.format(Ct_Debut);
    textController_Ct_Fin.text = inputFormat2.format(Ct_Fin);

    super.initState();
    Reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(children: [
        ToolsBar(context),
        InterventionGridWidget(),
        Container(
          height: 10,
        ),
      ]),
    );
  }

  Future Open_Intervention() async {
    DbTools.gIntervention = DbTools.ListInterventionsearchresult[Selindex];


    await DbTools.getClient(DbTools.gIntervention.ClientId!);
    await DbTools.getGroupe(DbTools.gIntervention.GroupeId!);


    await DbTools.getSite(DbTools.gIntervention.SiteId!);


    await DbTools.getZone(DbTools.gIntervention.ZoneId!);
    await showDialog(
        context: context,
        builder: (BuildContext context) => new Intervention_Dialog(
              site: DbTools.gSite,
            ));
    Reload();
  }

  Widget InterventionGridWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: gColors.secondary,
              selectionColor: gColors.backgroundColor,
            ),
            child: SfDataGrid(
              //*********************************
              onFilterChanged: (DataGridFilterChangeDetails details) {
                countfilterConditions = intervInfoDataGridSource.filterConditions.length;
                setState(() {});
              },
              onCellTap: (DataGridCellTapDetails details) {
                wColSel = details.rowColumnIndex.columnIndex;
                wRowSel = details.rowColumnIndex.rowIndex;
                if (wRowSel == 0) return;
                print("wRowSel ${wRowSel}");
                DataGridRow wDataGridRow = intervInfoDataGridSource.effectiveRows[wRowSel - 1];
                print("wRowSel ${wDataGridRow.toString()}");
                Selindex = intervInfoDataGridSource.dataGridRows.indexOf(wDataGridRow);
                print("Selindex ${Selindex}");
                if (wColSel == 1) {
                  Open_Intervention();
                }
              },

              //*********************************
              showCheckboxColumn: true,
              selectionMode: SelectionMode.multiple,
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

              controller: dataGridController,
              onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                Resize(args);
                return true;
              },
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.fill,
              isScrollbarAlwaysShown: true,
            )));
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

  Widget popMenu() {
    return PopupMenuButton(
      child: Tooltip(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal), decoration: BoxDecoration(color: Colors.orange), message: "Filtre Date", child: Container(width: 30, height: 30, child: Image.asset("assets/images/ico_DateFilter.png"))),
      onSelected: (value) async {
        if (value == "S0") {
          FiltreTools.selDateTools(0);
        }
        if (value == "S1") {
          FiltreTools.selDateTools(1);
        }
        if (value == "S2") {
          FiltreTools.selDateTools(2);
        }
        if (value == "S3") {
          FiltreTools.selDateTools(3);
        }
        if (value == "S4") {
          FiltreTools.selDateTools(4);
        }
        if (value == "S5") {
          FiltreTools.selDateTools(5);
        }
        if (value == "S6") {
          FiltreTools.selDateTools(6);
        }
        if (value == "S7") {
          FiltreTools.selDateTools(7);
        }
        if (value == "S8") {
          FiltreTools.selDateTools(8);
        }
        if (value == "S9") {
          FiltreTools.selDateTools(9);
        }
        if (value == "S10") {
          FiltreTools.selDateTools(10);
        }

        textController_Ct_Debut.text = DateFormat('dd/MM/yyyy').format(FiltreTools.gDateDeb);
        textController_Ct_Fin.text = DateFormat('dd/MM/yyyy').format(FiltreTools.gDateFin);
        await Filtre();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: "S0",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Aujourd'hui",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S1",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Hier",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S2",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Avant hier",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S3",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine courante",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S4",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S5",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine précédent la précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S6",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois courant",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S7",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois précédent",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S8",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois précédent le précédent",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S9",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Année courante",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S10",
          height: 36,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Année précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
      ],
    );
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
          popMenu(),
          Container(
            width: 10,
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
