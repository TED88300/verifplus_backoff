import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Art.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

DataGridController dataGridController = DataGridController();
int Subindex = 0;

class ArticleDataGridSource extends DataGridSource {
  ArticleDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    int i = 0;
    dataGridRows = DbTools.ListParc_Art.map<DataGridRow>((Parc_Art parc_Art) {

      List<DataGridCell> DataGridCells = [
        DataGridCell<String>(columnName:  'id'    , value: parc_Art.ParcsArt_Id),
        DataGridCell<String>(columnName:  'lib'   , value: parc_Art.ParcsArt_Lib),
        DataGridCell<int>(columnName:     'qte'   , value: parc_Art.ParcsArt_Qte),
        DataGridCell<String>(columnName:  'livr'  , value: parc_Art.ParcsArt_Livr),
        DataGridCell<String>(columnName:  'fact'  , value: parc_Art.ParcsArt_Fact),
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


    List<Widget> DataGridCells = [
      FiltreTools.SfRow(row, 0, Alignment.centerLeft, textColor, fBold: true),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor, fBold: true),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor, fBold: true),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor, fBold: true),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor, fBold: true),

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

class Organe_SynthDialog extends StatefulWidget {
  @override
  State<Organe_SynthDialog> createState() => _Organe_SynthDialogState();
}

class _Organe_SynthDialogState extends State<Organe_SynthDialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  double screenHeight = 0;

  ArticleDataGridSource articleDataGridSource = ArticleDataGridSource();

  List<double> dColumnWidth = [
    100,
    430,
    100,
    130,
    160,
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
      FiltreTools.SfGridColumn('id'  ,  'Ref'   ,       dColumnWidth[0], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('lib' ,  'Libellé'  ,    dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('qte' ,  'Qte'  ,        dColumnWidth[2], dColumnWidth[2], Alignment.centerRight),
      FiltreTools.SfGridColumn('livr',  'Livaison' ,    dColumnWidth[3], dColumnWidth[3], Alignment.center),
      FiltreTools.SfGridColumn('fact',  'Facturation' , dColumnWidth[4], dColumnWidth[4], Alignment.center),
    ];

    return wGridColumn;
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
                columnName: 'qte',
                summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom),
      ];
  }


  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName ==       'id'   ) dColumnWidth[0] = args.width;
      else if (args.column.columnName ==  'lib'  ) dColumnWidth[1] = args.width;
      else if (args.column.columnName ==  'qte'  ) dColumnWidth[1] = args.width;
      else if (args.column.columnName ==  'livr' ) dColumnWidth[1] = args.width;
      else if (args.column.columnName ==  'fact' ) dColumnWidth[1] = args.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    articleDataGridSource.handleRefresh();
    print(" EQUIP build ${DbTools.ListParc_Art}");
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
                      width: 924,
                      height: 560,
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
                            source: articleDataGridSource,
                            allowSorting: true,
                            allowFiltering: true,
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







                          ))),
                ],
              )),
        ),
      ]),
    );
  }
}
