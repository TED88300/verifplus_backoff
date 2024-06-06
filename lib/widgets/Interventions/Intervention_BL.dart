import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Art.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/pdf/Aff_BL.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Dialog.dart';

DataGridController dataGridController_BL = DataGridController();
int Subindex = 0;

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Parc_ArtInfoDataGridSource extends DataGridSource {
  Parc_ArtInfoDataGridSource() {
    buildDataGridRows();
    print (" AAAAAA buildDataGridRows dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");
  }

  @override
  List<DataGridRow> get rows => FiltreTools.dataGridRows_CR_Filtre;

  void buildDataGridRows() {
    FiltreTools.dataGridRows_CR = DbTools.ListParc_Art.map<DataGridRow>((Parc_Art Parc_Art) {
      print("Parc_Art ${Parc_Art.Desc()}");
      List<DataGridCell> DataGridCells = [
        DataGridCell<int>(columnName: 'id', value: Parc_Art.ParcsArtId),
        DataGridCell<String>(columnName: 'code', value: Parc_Art.ParcsArt_Id),
        DataGridCell<String>(columnName: 'lib', value: Parc_Art.ParcsArt_Lib),
        DataGridCell<String>(columnName: 'fact', value: Parc_Art.ParcsArt_Fact),
        DataGridCell<String>(columnName: 'livf', value: Parc_Art.ParcsArt_Livr),
        DataGridCell<int>(columnName: 'qte', value: Parc_Art.ParcsArt_Qte),
      ];
      return DataGridRow(cells: DataGridCells);
    }).toList();
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    print (" handleRefresh buildDataGridRows dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController_BL.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;
    Color backgroundColor = Colors.transparent;

    List<Widget> DataGridCells = [
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerRight, textColor),
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

class Intervention_BL extends StatefulWidget {
  const Intervention_BL({Key? key}) : super(key: key);

  @override
  State<Intervention_BL> createState() => _Intervention_BLState();
}

class _Intervention_BLState extends State<Intervention_BL> {
  String DescAffnewParam = "";

  List<double> dColumnWidth_BL = [
    80,
    120,
    1100,
    200,
    200,
    120,
  ];

  Parc_ArtInfoDataGridSource parc_ArtInfoDataGridSource = new Parc_ArtInfoDataGridSource();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<String?>? Parcs_ColsTitle = [];
  final Search_TextController = TextEditingController();

  List<String> subLibArray = [""];
  List<GrdBtn> lGrdBtn = [];
  List<Param_Param> ListParam_ParamTypeOg = [];
  DataGridRow memDataGridRow = DataGridRow(cells: []);

  List<GridColumn> getColumns_BL() {
    List<GridColumn> wGridColumn = [
      FiltreTools.SfGridColumn('id',    'ID', dColumnWidth_BL[0], dColumnWidth_BL[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('code',  'Code', dColumnWidth_BL[1], dColumnWidth_BL[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('lib' ,   'Libellé', dColumnWidth_BL[2], dColumnWidth_BL[2], Alignment.centerLeft),
      FiltreTools.SfGridColumn('fact',  'Facturation', dColumnWidth_BL[3], dColumnWidth_BL[3], Alignment.centerLeft),
      FiltreTools.SfGridColumn('livr',  'Livraison', dColumnWidth_BL[4], dColumnWidth_BL[4], Alignment.centerLeft),
      FiltreTools.SfGridColumn('qte' ,  'Qte', dColumnWidth_BL[5], dColumnWidth_BL[5], Alignment.centerLeft),
    ];

    return wGridColumn;
  }

  List<GridTableSummaryRow> getGridTableSummaryRow_BL() {
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

  void Resize_BL(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')        dColumnWidth_BL[0] = args.width;
      else if (args.column.columnName == 'code') dColumnWidth_BL[1] = args.width;
      else if (args.column.columnName == 'lib' ) dColumnWidth_BL[2] = args.width;
      else if (args.column.columnName == 'fact') dColumnWidth_BL[3] = args.width;
      else if (args.column.columnName == 'livr') dColumnWidth_BL[4] = args.width;
      else if (args.column.columnName == 'qte')  dColumnWidth_BL[5] = args.width;
    });
  }

  Future Reload() async {


    await DbTools.getParcs_ArtInterSum(DbTools.gIntervention.InterventionId!);
    print (" Reload buildDataGridRows dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");
    Filtre();
  }

  Future Filtre() async {
    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(DbTools.ListContact);
    parc_ArtInfoDataGridSource.handleRefresh();

    print (" FILTRE dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");


    FiltreTools.dataGridRows_CR_Filtre.clear();
    if (Search_TextController.text.isEmpty)
      FiltreTools.dataGridRows_CR_Filtre.addAll(FiltreTools.dataGridRows_CR);
    else
    {
      print (" dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");
      for (int i = 0; i < FiltreTools.dataGridRows_CR.length; i++) {
        bool isTrv = false;
        DataGridRow dataGridRows_BL = FiltreTools.dataGridRows_CR[i];
        for (int j = 0; j < dataGridRows_BL.getCells().length; j++) {
          DataGridCell dataGridCell = dataGridRows_BL.getCells()[j];

          print (" dataGridCell ${dataGridCell.value}");

          if (dataGridCell.value.toString().toLowerCase().contains(Search_TextController.text.toLowerCase()))
          {
            isTrv = true;
          }
        }
        if (isTrv)
        {
          print (" ADD");
          FiltreTools.dataGridRows_CR_Filtre.add(dataGridRows_BL);
        }
      }

    }

    parc_ArtInfoDataGridSource.sortedColumns.add(SortColumnDetails(name: 'ordre', sortDirection: DataGridSortDirection.ascending));
    parc_ArtInfoDataGridSource.sort();
    dataGridController_BL.selectedRows.clear();
    dataGridController_BL.selectedRows.add(memDataGridRow);

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  void initState() {

    for (int i = 0; i < DbTools.lColParamswidth.length; i++) {
      String ColParamswidth = DbTools.lColParamswidth[i];
      double iColParamswidth = double.tryParse(ColParamswidth) ?? 0;
      dColumnWidth_BL.add(iColParamswidth);
    }

    DbTools.subTitleArray.clear();
    ListParam_ParamTypeOg.clear();
    int i = 0;
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
//        print("element ${element.Param_Param_ID}  ${element.Param_Param_Text}");
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          lGrdBtn.add(GrdBtn(GrdBtnId: i++, GrdBtn_GroupeId: 4, GrdBtn_Label: element.Param_Param_ID));
          DbTools.subTitleArray.add(element.Param_Param_ID);
          subLibArray.add(element.Param_Param_Text);
          ListParam_ParamTypeOg.add(element);
        }
      }
    });
    DbTools.ParamTypeOg = subLibArray[0];

    Subindex = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);

    DbTools.getParam_ParamMemDet("Param_Div", "${DbTools.subTitleArray[Subindex]}_Desc");
    if (DbTools.ListParam_Param.length > 0) DescAffnewParam = DbTools.ListParam_Param[0].Param_Param_Text;

    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print (" build dataGridRows_BL ${FiltreTools.dataGridRows_CR.length}");

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: ListArticles( context),
    );
  }

  Widget ListArticles(BuildContext context) {
    return Column(children: [
      ToolsBar(context),
      SizedBox(
          height: MediaQuery.of(context).size.height - 590, // HAUTEUR LISTE
          child: new SfDataGridTheme(
              data: new SfDataGridThemeData(
                headerColor: gColors.secondary,
                selectionColor: gColors.backgroundColor,
              ),
              child: new SfDataGrid(
                //*********************************
                onFilterChanged: (DataGridFilterChangeDetails details) {
                  countfilterConditions = parc_ArtInfoDataGridSource.filterConditions.length;
                  print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                  setState(() {});
                },
                onCellTap: (DataGridCellTapDetails details) async{
                  wColSel = details.rowColumnIndex.columnIndex;
                  int wRowSel = details.rowColumnIndex.rowIndex;
                  if (wRowSel == 0) return;

                  DataGridRow wDataGridRow = parc_ArtInfoDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                  Selindex = parc_ArtInfoDataGridSource.rows.indexOf(wDataGridRow);
                  if (wColSel == 0) {
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) => new Organe_Dialog());
                    Reload();
                  }
                },

                //*********************************
                source: parc_ArtInfoDataGridSource,
                allowSorting: true,
                allowFiltering: true,
                columns: getColumns_BL(),
                tableSummaryRows: getGridTableSummaryRow_BL(),

                headerRowHeight: 35,
                rowHeight: 28,
                allowColumnsResizing: true,
                columnResizeMode: ColumnResizeMode.onResize,
                selectionMode: SelectionMode.single,
                controller: dataGridController_BL,
                onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                  Resize_BL(args);
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
                  CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.white : Colors.black12, gColors.primary, Icons.print, ToolsBarPrint, tooltip: "Imprimer"),
                  Container(
                    width: 20,
                  ),
                ],



              ),
            ],
          ));
  }

  void ToolsBarSupprFilter() async {
    parc_ArtInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }

  void ToolsBarPrint() async {
    await HapticFeedback.vibrate();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_BL()));
    setState(() {});
  }




}
