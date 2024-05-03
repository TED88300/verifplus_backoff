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
        DataGridCell<String>(columnName: 'client', value: Interv.Client_Nom),
        DataGridCell<String>(columnName: 'groupe', value: Interv.Groupe_Nom),
        DataGridCell<String>(columnName: 'site', value: Interv.Site_Nom),
        DataGridCell<String>(columnName: 'zone', value: Interv.Zone_Nom),
        DataGridCell<DateTime>(columnName: 'date', value: inputFormat2.parse(Interv.Intervention_Date!)),
        DataGridCell<String>(columnName: 'org', value: DbTools.getParam_Param_Text("Type_Organe", Interv.Intervention_Parcs_Type!)),
        DataGridCell<String>(columnName: 'type', value: Interv.Intervention_Type),
        DataGridCell<int>(columnName: 'organes', value: Interv.Cnt),
        DataGridCell<String>(columnName: 'status', value: Interv.Intervention_Status),
        DataGridCell<String>(columnName: 'factu', value: Interv.Intervention_Facturation),
        DataGridCell<String>(columnName: 'RespCom', value: DbTools.getUserid_Nom(Interv.Intervention_Responsable!)),
        DataGridCell<String>(columnName: 'RespTech', value: DbTools.getUserid_Nom(Interv.Intervention_Responsable2!)),
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
    Color textColor = dataGridController.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;

    Color backgroundColor = Colors.transparent;
    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      4, Alignment.centerLeft, textColor),
      FiltreTools.SfRowDate(row,  5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      8, Alignment.center, textColor),
      FiltreTools.SfRow(row,      9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row,      10, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 12, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 13, Alignment.centerLeft, textColor),
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
    200,
    130,
    200,
    170,
    130,
    130,
    130,
    110,
    130,
    110,
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
  int Selindex = -1;
  int countfilterConditions = -1;


  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputFormat2 = DateFormat('dd/MM/yyyy');
  DateTime Ct_Debut = DateTime.now();
  DateTime Ct_Fin = DateTime.now();

  DataGridRow memDataGridRow = DataGridRow(cells: []);


  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID',          dColumnWidth[0], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('groupe', 'Client',  dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('groupe', 'Groupe',  dColumnWidth[2], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('site', 'Site',      dColumnWidth[3], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('zone', 'Zone',      dColumnWidth[4], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('date', 'Date',      dColumnWidth[5], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('org', 'Organes',    dColumnWidth[6], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('type', 'Type',      dColumnWidth[7], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('organes', 'Cpt',    dColumnWidth[8], dColumnWidth[1], Alignment.center),
      FiltreTools.SfGridColumn('status', 'Status',  dColumnWidth[9], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('factu', 'Fact',     dColumnWidth[10], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RespCom', 'RespCom',dColumnWidth[11], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RespTech', 'RespTech',dColumnWidth[12], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('Rem', 'Remarques', dColumnWidth[13], dColumnWidth[1], Alignment.centerLeft),
    ];
  }

  List<GridTableSummaryRow> getGridTableSummaryRow()
  {
    return
      [      GridTableSummaryRow(
          color: gColors.secondary,
          showSummaryInRow: false,
          title: 'Cpt: {Count}',
          titleColumnSpan: 1,
          columns: [
            GridSummaryColumn(
                name: 'Count',
                columnName: 'id',
                summaryType: GridSummaryType.count),
          GridSummaryColumn(
              name: 'Sum',
              columnName: 'organes',
              summaryType: GridSummaryType.sum),
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
      else if (args.column.columnName == 'factu')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'RespCom')
        dColumnWidth[10] = args.width;
      else if (args.column.columnName == 'RespTech')
        dColumnWidth[11] = args.width;
      else if (args.column.columnName == 'Rem') dColumnWidth[12] = args.width;
    });
  }

  Future Reload() async {
    await DbTools.initListFam();
    await DbTools.getInterventionAll();

    Ct_Debut = DateTime.now();
    Ct_Fin   = DateTime(1980);
    for (int i = 0; i < DbTools.ListIntervention.length; i++) {
      var element = DbTools.ListIntervention[i];
      DateTime wDT = inputFormat2.parse(element.Intervention_Date!);
      if(wDT.difference(Ct_Debut).inHours < 0)
        {
          Ct_Debut = wDT;
        }
      if(wDT.difference(Ct_Fin).inHours > 0)
        {
          Ct_Fin = wDT;
        }
    }

    textController_Ct_Debut.text = inputFormat2.format(Ct_Debut);
    textController_Ct_Fin.text = inputFormat2.format(Ct_Fin);
    Filtre();
  }

  Future Filtre() async {

    List<Intervention> ListInterventionsearchresultDate = [];
    DbTools.ListInterventionsearchresult.clear();

    if (textController_Ct_Debut.text.isNotEmpty) {
      Ct_Debut = inputFormat2.parse(textController_Ct_Debut.text);
    }

    if (textController_Ct_Fin.text.isNotEmpty) {
      Ct_Fin = inputFormat2.parse(textController_Ct_Fin.text);
    }


    for (int i = 0; i < DbTools.ListIntervention.length; i++) {
      var element = DbTools.ListIntervention[i];
      DateTime wDT = inputFormat2.parse(element.Intervention_Date!);

      if(wDT.difference(Ct_Debut).inHours >= 0 && wDT.difference(Ct_Fin).inHours <= 0)
      {
        ListInterventionsearchresultDate.add(element);
      }

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


    print("🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢 memDataGridRow ${memDataGridRow.getCells()}");
    intervInfoDataGridSource.handleRefresh();
    dataGridController.selectedRows.clear();
    dataGridController.selectedRows.add(memDataGridRow);

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


  Widget InterventionGridWidget()
  {
    return   SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: gColors.secondary,
              selectionColor: gColors.backgroundColor,
              //rowHoverColor: gColors.white,
              //rowHoverTextStyle : TextStyle(color: gColors.tks),

            ),
            child: SfDataGrid(
              //*********************************
              onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) async {
                if (addedRows.length > 0 ) {
                  Selindex = intervInfoDataGridSource.dataGridRows.indexOf(addedRows.last);
                  DbTools.gIntervention = DbTools.ListIntervention[Selindex];
                  await DbTools.getClient(DbTools.gIntervention.ClientId!);
                  print("•••••••••• DbTools.gClient.ClientId ${DbTools.gClient.ClientId} / ${DbTools.gIntervention.ClientId!} ");

                  await DbTools.getGroupe(DbTools.gIntervention.GroupeId!);
                  await DbTools.getSite(DbTools.gIntervention.SiteId!);
                  await DbTools.getZone(DbTools.gIntervention.ZoneId!);
                  if (wColSel == 0)
                  {
                     memDataGridRow = addedRows.last;

                    await showDialog(
                        context: context,
                        builder: (BuildContext context) => new Intervention_Dialog(
                          site: DbTools.gSite,
                        ));
                    Reload();


                  }
                }
                else if (removedRows.length > 0 )
                {
                  Selindex = intervInfoDataGridSource.dataGridRows.indexOf(removedRows.last);
                  DbTools.gIntervention = DbTools.ListIntervention[Selindex];
                  await DbTools.getGroupe(DbTools.gIntervention.GroupeId!);
                  await DbTools.getSite(DbTools.gIntervention.SiteId!);
                  await DbTools.getZone(DbTools.gIntervention.ZoneId!);
                  if (wColSel == 0)
                  {
                     memDataGridRow = removedRows.last;

                    await showDialog(
                        context: context,
                        builder: (BuildContext context) => new Intervention_Dialog(
                          site: DbTools.gSite,
                        ));
                    Reload();


                  }
                }
              },

              onFilterChanged: (DataGridFilterChangeDetails details) {
                countfilterConditions = intervInfoDataGridSource.filterConditions.length;
                setState(() {});
              },
              onCellTap: (DataGridCellTapDetails details) {
                wColSel = details.rowColumnIndex.columnIndex;
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
              selectionMode: SelectionMode.multiple,
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
                selectedDate =  inputFormat2.parse(textController_Ct_Debut.text);
              await _selectDate(context, DateTime(1980) , DateTime.now());


              if(selectedDate.difference(DateTime.now()).inHours >= 0) return;
              if(selectedDate.difference(Ct_Fin).inHours >= 0) return;
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
                selectedDate =  inputFormat2.parse(textController_Ct_Fin.text);
              await _selectDate(context, Ct_Debut , DateTime.now());

              if(selectedDate.difference(DateTime.now()).inHours >= 0) return;
              if(selectedDate.difference(Ct_Debut).inHours < 0) return;

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
            size: 20.0,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: Search_TextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
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

  Future<void> _selectDate(BuildContext context,DateTime firstDate, DateTime lastDate ) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: firstDate, lastDate: lastDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
