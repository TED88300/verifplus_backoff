import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

DataGridController dataGridController = DataGridController();
int Subindex = 0;

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
  @override
  State<Organe_AuditDialog> createState() => _Organe_AuditDialogState();
}

class _Organe_AuditDialogState extends State<Organe_AuditDialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  double screenHeight = 0;

  Param_SaisieDataGridSource param_SaisieDataGridSource = Param_SaisieDataGridSource();

  List<double> dColumnWidth = [
    330,
    250,
  ];

  Future initLib() async {
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
    Title = "Intervention";
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
    param_SaisieDataGridSource.handleRefresh();
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
          height: MediaQuery.of(context).size.height - 393,
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              )),
        ),
      ]),
    );
  }
}
