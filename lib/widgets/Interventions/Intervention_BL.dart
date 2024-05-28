import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Art.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Dialog.dart';

DataGridController dataGridController_CR = DataGridController();
int Subindex = 0;

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Parc_ArtInfoDataGridSource extends DataGridSource {
  Parc_ArtInfoDataGridSource() {
    buildDataGridRows();
    print (" AAAAAA buildDataGridRows dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");

  }

  @override
  List<DataGridRow> get rows => FiltreTools.dataGridRows_CR_Filtre;

  void buildDataGridRows() {
    FiltreTools.dataGridRows_CR = DbTools.ListParc_Art.map<DataGridRow>((Parc_Art Parc_Art) {
      List<DataGridCell> DataGridCells = [
        DataGridCell<int>(columnName: 'id', value: Parc_Art.ParcsArtId),
        DataGridCell<String>(columnName: 'Lib', value: Parc_Art.ParcsArt_Lib),
      ];
      return DataGridRow(cells: DataGridCells);
    }).toList();



  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    print (" handleRefresh buildDataGridRows dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController_CR.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;
    Color backgroundColor = Colors.transparent;

    List<Widget> DataGridCells = [
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
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

  List<double> dColumnWidth_CR = [
    80,
    60,
  ];

  Parc_ArtInfoDataGridSource parc_ArtInfoDataGridSource = Parc_ArtInfoDataGridSource();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<String?>? Parcs_ColsTitle = [];
  final Search_TextController = TextEditingController();

  List<String> subLibArray = [""];
  List<GrdBtn> lGrdBtn = [];

  List<Param_Param> ListParam_ParamTypeOg = [];

  DataGridRow memDataGridRow = DataGridRow(cells: []);


  List<GridColumn> getColumns_CR() {
    List<GridColumn> wGridColumn = [
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth_CR[0], dColumnWidth_CR[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ordre', 'Ordre', dColumnWidth_CR[1], dColumnWidth_CR[1], Alignment.centerLeft),
//      FiltreTools.SfGridColumn('desc'      ,           'Organes'     , double.nan, dColumnWidth[2], Alignment.centerLeft, wColumnWidthMode :ColumnWidthMode.lastColumnFill),
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

  Future Reload() async {


    await DbTools.getParcs_ArtInter(DbTools.gIntervention.InterventionId!);
    print (" Reload buildDataGridRows dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");
    Filtre();
  }

  Future Filtre() async {
    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(DbTools.ListContact);
    parc_ArtInfoDataGridSource.handleRefresh();

    print (" FILTRE dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");


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

    parc_ArtInfoDataGridSource.sortedColumns.add(SortColumnDetails(name: 'ordre', sortDirection: DataGridSortDirection.ascending));
    parc_ArtInfoDataGridSource.sort();
    dataGridController_CR.selectedRows.clear();
    dataGridController_CR.selectedRows.add(memDataGridRow);

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
      dColumnWidth_CR.add(iColParamswidth);
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
    print (" build dataGridRows_CR ${FiltreTools.dataGridRows_CR.length}");

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: ListOrganes( context),
    );
  }

  Widget ListOrganes(BuildContext context) {
    return Column(children: [
      ToolsBar(context),
      SizedBox(
          height: MediaQuery.of(context).size.height - 590, // HAUTEUR LISTE
          child: SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: gColors.secondary,
                selectionColor: gColors.backgroundColor,
              ),
              child: SfDataGrid(
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
                columns: getColumns_CR(),
                tableSummaryRows: getGridTableSummaryRow_CR(),

                headerRowHeight: 35,
                rowHeight: 28,
                allowColumnsResizing: true,
                columnResizeMode: ColumnResizeMode.onResize,
                selectionMode: SelectionMode.single,
                controller: dataGridController_CR,
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
    parc_ArtInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }
}
