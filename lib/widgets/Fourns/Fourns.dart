import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Fourns.dart';

import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Fourns/Fourn_Dialog.dart';



class fournDataSource extends DataGridSource {
  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  fournDataSource() {
    DbTools.getParam_ParamFam("Famfourn");

    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);
    buildDataGridRow();
  }

  void buildDataGridRow() {
    dataGridRow = DbTools.ListFournsearchresult.map<DataGridRow>((fourn) {

print("& buildDataGridRow ${fourn.fournCP} ${fourn.fournVille} ${fourn.fournPays}");

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: fourn.fournId),
        DataGridCell<String>(columnName: 'code', value: fourn.fournCodeGC),
        DataGridCell<bool>(columnName: 'sst', value: fourn.Fourn_F_SST == 1),
        DataGridCell<String>(columnName: 'statut', value: fourn.Fourn_Statut),
        DataGridCell<String>(columnName: 'nom', value: fourn.fournNom),
        DataGridCell<String>(columnName: 'cp', value: fourn.fournCP),
        DataGridCell<String>(columnName: 'ville', value: fourn.fournVille),
        DataGridCell<String>(columnName: 'pays', value: fourn.fournPays),

      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    double t = 5;
    double b = 3;

    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;

    Color backgroundColor = Colors.transparent;
    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRow(row, 0, Alignment.center, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRowBool(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
    ]);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(alignment: Alignment.center, child: Text(summaryValue));
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRow();
    notifyListeners();
  }
}

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************
class fourns_screen extends StatefulWidget {
  const fourns_screen({Key? key}) : super(key: key);

  @override
  fourns_screenState createState() => fourns_screenState();
}

class fourns_screenState extends State<fourns_screen> {
  fournDataSource fournInfoDataGridSource = fournDataSource();

  List<double> dColumnWidth = [
    80,
    100,
    100,
    90,
    500,
    90,
    400,
    400,
  ];

//  fournInfoDataGridSource fournInfoDataGridSource = fournInfoDataGridSource();

  final Search_TextController = TextEditingController();
  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;
  bool isLoad = false;

  DataGridRow memDataGridRow = DataGridRow(cells: []);

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID',                  dColumnWidth[0], 15, Alignment.centerLeft),
      FiltreTools.SfGridColumn('code', 'Cd',                dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('sst', 'S/t',                dColumnWidth[2], dColumnWidth[2], Alignment.centerLeft),
      FiltreTools.SfGridColumn('statut', 'St',              dColumnWidth[3], dColumnWidth[3], Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Raison Social',      dColumnWidth[4], dColumnWidth[4], Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp',                  dColumnWidth[5], dColumnWidth[5], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville',            dColumnWidth[6], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('pays', 'Pays',              dColumnWidth[7], 160, Alignment.centerLeft),
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
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')               dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'code')        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'sst')         dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'statut')      dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'nom')         dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'cp')          dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'ville')       dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'pays')        dColumnWidth[7] = args.width;
    });
  }


  Future Reload() async {
    await DbTools.getParam_ParamFam("Famfourn");

    print("gUserLoginTypeUser ${DbTools.gUserLoginTypeUser}");

      await DbTools.getFournAll();

    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListFournsearchresult.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      print("_buildFieldTextSearch Filtre ${DbTools.ListFourn.length}");
      DbTools.ListFournsearchresult.addAll(DbTools.ListFourn);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListFourn.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          DbTools.ListFournsearchresult.add(element);
        }
      });
    }

    fournInfoDataGridSource.handleRefresh();
    isLoad = true;

    print("🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢 memDataGridRow ${memDataGridRow.getCells()}");
    dataGridController.selectedRows.clear();
    dataGridController.selectedRows.add(memDataGridRow);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Reload();
  }

  @override
  Widget build(BuildContext context) {
    print("•••••••••••••• build");

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.white,
      child: Column(children: [
        ToolsBar(context),
        Container(
          height: 10,
        ),
        !isLoad
            ? Container()
            : SizedBox(
                height: MediaQuery.of(context).size.height - 190,
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: gColors.secondary,
                    selectionColor: gColors.backgroundColor,
                  ),
                  child: SfDataGrid(
                    source: fournInfoDataGridSource,
                    columns: getColumns(),
                    columnWidthMode: ColumnWidthMode.fill,
//                    tableSummaryRows: getGridTableSummaryRow(),

                    controller: dataGridController,


                    onFilterChanged: (DataGridFilterChangeDetails details) {
                      countfilterConditions = fournInfoDataGridSource.filterConditions.length;
                      setState(() {});
                    },
                    onCellTap: (DataGridCellTapDetails details) async {
                      int wRowSel = details.rowColumnIndex.rowIndex;
                      if (wRowSel == 0) return;

                      wColSel = details.rowColumnIndex.columnIndex;
                      DataGridRow wDataGridRow = fournInfoDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                      Selindex = fournInfoDataGridSource.dataGridRow.indexOf(wDataGridRow);
                      if (wColSel == 0) {

                        Fourn wfourn = DbTools.ListFournsearchresult[Selindex];
                        print(" ADD onSelectionChanging Add ${Selindex} wfourn ${wfourn.fournId} ${wfourn.fournNom}");
                        await showDialog(context: context, builder: (BuildContext context) => new Fourn_Dialog(fourn: wfourn));

                        Reload();
                      }
                    },

                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.row,
                    allowSorting: true,
                    allowFiltering: true,
                    headerRowHeight: 35,
                    rowHeight: 28,
                    allowColumnsResizing: true,
                    columnResizeMode: ColumnResizeMode.onResize,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                      Resize(args);
                      return true;
                    },
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    isScrollbarAlwaysShown: true,
                  ),
                ),
              ),
        Container(
          height: 10,
        ),
      ]),
    );
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", ToolsBarAdd, tooltip: "Ajouter un fourn"),
                Container(
                  width: 10,
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
                Container(
                  width: 10,
                ),
                ToolsBarSearch(context),
              ],
            ),
          ],
        ));
  }




  Widget ToolsBarSearch(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: 5,
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
              decoration:
              gColors.wRechInputDecoration,
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

  void ToolsBarSupprFilter() async {
    fournInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    Search_TextController.clear();
    await Filtre();
    setState(() {});
  }

  void ToolsBarAdd() async {

    print("ToolsBarAdd");
    Fourn wfourn = await Fourn.FournInit();
    await DbTools.addFourn(wfourn);
    wfourn.fournId = DbTools.gLastID;
    wfourn.fournNom = "???";
    await showDialog(context: context, builder: (BuildContext context) => new Fourn_Dialog(fourn: wfourn));
    await Reload();

  }
}
