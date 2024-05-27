import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Parc_EntInfoDataGridSource extends DataGridSource {
  Parc_EntInfoDataGridSource() {
    buildDataGridRows();
  }


  @override
  List<DataGridRow> get rows => FiltreTools.dataGridRows_CR_Filtre;

  void buildDataGridRows() {


  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {

    Color textColor = FiltreTools.dataGridController_CR.selectedRows.contains(row) ? Colors.white : Colors.black;
    Color backgroundColor = Colors.transparent;

    List<Widget> DataGridCells = [
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
//      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
    ];

    int n = 2;
    for (int i = 0; i < DbTools.lColParams.length; i++) {
      String ColParam = DbTools.lColParams[i];
      if (ColParam == "DATE") {
        DataGridCells.add(FiltreTools.SfRowDate(row, n++, Alignment.centerLeft, textColor));
      } else {
        if (ColParam == "ACTION") {
          DataGridCells.add(FiltreTools.SfRow(row, n++, Alignment.center, textColor));
        } else
          DataGridCells.add(FiltreTools.SfRow(row, n++, Alignment.centerLeft, textColor));
      }
    }

    return DataGridRowAdapter(color: backgroundColor, cells: DataGridCells);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(color: gColors.secondary, alignment: Alignment.center, child: Text(summaryValue));
  }
}


//***************************************************************
//***************************************************************
//***************************************************************

DataGridController dataGridController = DataGridController();


class Param_SaisieDataGridSource extends DataGridSource {
  Param_SaisieDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    int i = 0;
    dataGridRows = DbTools.ListParam_Audit_Base.map<DataGridRow>((Param_Saisie param_Saisie) {

      List<DataGridCell> DataGridCells = [
        DataGridCell<int>(columnName: 'label', value: i),
        DataGridCell<String>(columnName: 'value', value: param_Saisie.Param_Saisie_Value),
      ];
      i++;
      return DataGridRow(cells: DataGridCells);
    }).toList();
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;
    Color backgroundColor = Colors.transparent;

    int i =  row.getCells()[0].value;
    String wIco = DbTools.ListParam_Audit_Base[i].Param_Saisie_Icon;
    String wTxt = DbTools.ListParam_Audit_Base[i].Param_Saisie_Label;

    List<Widget> DataGridCells = [
      FiltreTools.SfRowIcon(wTxt, wIco, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor, fBold: true),
//      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
    ];
    return DataGridRowAdapter(color: backgroundColor, cells: DataGridCells);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(color: gColors.secondary, alignment: Alignment.center, child: Text(summaryValue));
  }
}

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Organe_AuditDialog extends StatefulWidget {
  final VoidCallback onMaj;
  const Organe_AuditDialog({Key? key, required this.onMaj}) : super(key: key);

  @override
  State<Organe_AuditDialog> createState() => _Organe_AuditDialogState();
}

class _Organe_AuditDialogState extends State<Organe_AuditDialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  double screenHeight = 0;
//***************************************
//***************************************
//***************************************

  List<double> dColumnWidth_CR = [
    80,
    60,
  ];
  Parc_EntInfoDataGridSource parc_EntInfoDataGridSource = Parc_EntInfoDataGridSource();
  int countfilterConditions = -1;

  int wColSel = -1;

  


  List<GridColumn> getColumns_CR() {
    List<GridColumn> wGridColumn = [
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth_CR[0], dColumnWidth_CR[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ordre', 'Ordre', dColumnWidth_CR[1], dColumnWidth_CR[1], Alignment.centerLeft),
    ];

    int n = 3;
    for (int i = 0; i < DbTools.lColParams.length; i++) {
      String ColParam = DbTools.lColParams[i];
      if (ColParam == "ACTION")
        wGridColumn.add(FiltreTools.SfGridColumn(ColParam, ColParam, dColumnWidth_CR[i+2], dColumnWidth_CR[1], Alignment.center));
      else
        wGridColumn.add(FiltreTools.SfGridColumn(ColParam, ColParam, dColumnWidth_CR[i+2], dColumnWidth_CR[1], Alignment.centerLeft));
    }

    return wGridColumn;
  }

  List<GridTableSummaryRow> getGridTableSummaryRow_CR() {
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

  void Resize_CR(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth_CR[0] = args.width;
      else if (args.column.columnName == 'ordre') dColumnWidth_CR[1] = args.width;
      else
      {
        for (int i = 0; i < DbTools.lColParams.length; i++) {
          String ColParam = DbTools.lColParams[i];
          if (args.column.columnName == ColParam)
          {
            print("🁢🁢🁢🁢🁢🁢🁢  Resize ${args.width}");
            dColumnWidth_CR[i+2] = args.width;
          }
        }
      }
    });
  }

  //***************************************************
  //***************************************************
  //***************************************************

  Param_SaisieDataGridSource param_SaisieDataGridSource = Param_SaisieDataGridSource();

  List<double> dColumnWidth = [
    330,
    250,
  ];
  final Search_TextController = TextEditingController();

  Future initLib() async {
    setState(() {});
  }

  void initState() {
    for (int i = 0; i < DbTools.lColParamswidth.length; i++) {
      String ColParamswidth = DbTools.lColParamswidth[i];
      double iColParamswidth = double.tryParse(ColParamswidth) ?? 0;
      dColumnWidth_CR.add(iColParamswidth);
    }

    initLib();
    super.initState();
    Title = "Intervention";
    Filtre();
  }


  Future Filtre() async {

    FiltreTools.dataGridRows_CR_Filtre.clear();
    if (Search_TextController.text.isEmpty)
      FiltreTools.dataGridRows_CR_Filtre.addAll(FiltreTools.dataGridRows_CR);
    else
    {
      print (" dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");
      for (int i = 0; i < FiltreTools.dataGridRows_CR.length; i++) {
        bool isTrv = false;
        DataGridRow dataGridRows_CR = FiltreTools.dataGridRows_CR[i];
        for (int j = 0; j < dataGridRows_CR.getCells().length; j++) {
          DataGridCell dataGridCell = dataGridRows_CR.getCells()[j];

          print (" dataGridCell ${dataGridCell.value}");

          if (dataGridCell.value.toString().toLowerCase().contains(Search_TextController.text.toLowerCase()))
          {
            isTrv = true;
          }
        }
        if (isTrv)
        {
          print (" ADD");
          FiltreTools.dataGridRows_CR_Filtre.add(dataGridRows_CR);
        }
      }

    }
    parc_EntInfoDataGridSource.handleRefresh();

    parc_EntInfoDataGridSource.sortedColumns.add(SortColumnDetails(name: 'ordre', sortDirection: DataGridSortDirection.ascending));
    parc_EntInfoDataGridSource.sort();


  }
  List<GridColumn> getColumns() {
    List<GridColumn> wGridColumn = [
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ordre', 'Ordre', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
    ];

    return wGridColumn;
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'ordre') dColumnWidth[1] = args.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    // param_SaisieDataGridSource.handleRefresh();



    screenWidth = MediaQuery.of(context).size.width;
    if (Title.isEmpty) return Container();
    return Center(
      child: Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: gColors.white,
            body: Content(context),
          )),
    );
  }

  Widget Content(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: gColors.primary,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
        Container(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height - 412,
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 575,
                      height: 460,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                            headerColor: gColors.secondary,
                            selectionColor: gColors.backgroundColor,
                          ),
                          child: SfDataGrid(
                            //*********************************
                            allowSorting: true,
                            allowFiltering: true,
                            source: param_SaisieDataGridSource,
                            columns: getColumns(),
                            headerRowHeight: 0,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            rowHeight: 28,
                            allowColumnsResizing: true,
                            columnResizeMode: ColumnResizeMode.onResize,
                            selectionMode: SelectionMode.none,
                            controller: dataGridController,
                            onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                              Resize(args);
                              return true;
                            },
                            gridLinesVisibility: GridLinesVisibility.both,
                            columnWidthMode: ColumnWidthMode.fill,
                          ))),

                  Container(width: 5,),
                  ListOrganes( context),


                ],
              )),
        ),
      ]),
    );
  }

  //******************************************
  //******************************************
  //******************************************

  Widget ListOrganes(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ToolsBar(context),
          SizedBox(
              width: MediaQuery.of(context).size.width - 630,
              height: MediaQuery.of(context).size.height - 545,
              child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: gColors.secondary,
                    selectionColor: gColors.backgroundColor,
                  ),
                  child: SfDataGrid(
                    //*********************************

                    onFilterChanged: (DataGridFilterChangeDetails details) {
                      countfilterConditions = parc_EntInfoDataGridSource.filterConditions.length;
                      print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                      setState(() {});
                    },

                    onCellTap: (DataGridCellTapDetails details) {
                      int wRowSel = details.rowColumnIndex.rowIndex;
                      if (wRowSel == 0) return;

                      wColSel = details.rowColumnIndex.columnIndex;
                      DataGridRow wDataGridRow = parc_EntInfoDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                      FiltreTools.Selindex = parc_EntInfoDataGridSource.rows.indexOf(wDataGridRow);
                      DbTools.gParc_Ent = DbTools.ListParc_Ent[FiltreTools.Selindex];
                      if (wColSel == 0)
                      {
                        widget.onMaj();
                      }

                    },


                    //*********************************
                    source: parc_EntInfoDataGridSource,

                    allowSorting: true,
                    allowFiltering: true,
                    columns: getColumns_CR(),
                    tableSummaryRows: getGridTableSummaryRow_CR(),

                    headerRowHeight: 35,
                    rowHeight: 28,
                    allowColumnsResizing: true,
                    columnResizeMode: ColumnResizeMode.onResize,
                    selectionMode: SelectionMode.single,
                    controller: FiltreTools.dataGridController_CR,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                      Resize_CR(args);
                      return true;
                    },
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: ColumnWidthMode.fill,
                  ))),



          Container(
            height: 10,
          ),
        ]);

  }

  Widget ToolsBar(BuildContext context) {
    return


      Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Column(
            children: [
              Row(
                children: [
                  CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),

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
                  Container(
                    width :MediaQuery.of(context).size.width - 800,

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
            ],
          ));
  }

  void ToolsBarSupprFilter() async {
    parc_EntInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }


}
