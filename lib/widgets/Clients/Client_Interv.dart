import 'package:flutter/material.dart';
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

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;


  void buildDataGridRows() {
    dataGridRows = DbTools.ListIntervention.map<DataGridRow>((Intervention Interv) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName:     'id'      , value: Interv.InterventionId),
        DataGridCell<String>(columnName:  'groupe'  , value: Interv.Groupe_Nom),
        DataGridCell<String>(columnName:  'site'    , value: Interv.Site_Nom),
        DataGridCell<String>(columnName:  'zone'    , value: Interv.Zone_Nom),
        DataGridCell<String>(columnName:  'date'    , value: Interv.Intervention_Date),
        DataGridCell<String>(columnName:  'org'     , value: DbTools.getParam_Param_Text("Type_Organe", Interv.Intervention_Parcs_Type!)),
        DataGridCell<String>(columnName:  'type'    , value: Interv.Intervention_Type),
        DataGridCell<String>(columnName:  'status'  , value: Interv.Intervention_Status),
        DataGridCell<String>(columnName:  'factu'   , value: Interv.Intervention_Facturation),
        DataGridCell<String>(columnName:  'RespCom' , value: DbTools.getUserid_Nom(Interv.Intervention_Responsable!)),
        DataGridCell<String>(columnName:  'RespTech', value: DbTools.getUserid_Nom(Interv.Intervention_Responsable2!)),
        DataGridCell<String>(columnName:  'Rem'     , value: Interv.Intervention_Remarque!.replaceAll("\n", " - ")),
        DataGridCell<int>(columnName:     'organes' , value: Interv.Cnt),
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
    Color textColor = dataGridController.selectedRows.contains(row)  ? selectedRowTextColor : Colors.black;

    Color backgroundColor = Colors.transparent;
    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 12, Alignment.centerRight,textColor),
    ]);
  }
}

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Client_Interv extends StatefulWidget {
  final VoidCallback onMaj;
  const Client_Interv({Key? key, required this.onMaj}) : super(key: key);

  @override
  _Client_IntervState createState() => _Client_IntervState();
}

class _Client_IntervState extends State<Client_Interv> {
  List<double> dColumnWidth = [
    80,
    130,
    200,
    170,
    130,
    130,
    130,
    130,
    110,
    190,
    190,
    373,
    110,
  ];

  IntervInfoDataGridSource intervInfoDataGridSource = IntervInfoDataGridSource();

  final Search_TextController = TextEditingController();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id'        ,           'ID'      , dColumnWidth[0 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('groupe'    ,           'Groupe'  , dColumnWidth[1 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('site'      ,           'Site'    , dColumnWidth[2 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('zone'      ,           'Zone'    , dColumnWidth[3 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('date'      ,           'Date'    , dColumnWidth[4 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('org'       ,           'Organes'     , dColumnWidth[5 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('type'      ,           'Type'    , dColumnWidth[6 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('status'    ,           'Status'  , dColumnWidth[7 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('factu'     ,           'Fact'   , dColumnWidth[8 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RespCom'   ,           'RespCom' , dColumnWidth[9 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('RespTech'  ,           'RespTech', dColumnWidth[10], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('Rem'       ,           'Remarques'     , double.nan, dColumnWidth[1], Alignment.centerLeft, wColumnWidthMode :ColumnWidthMode.lastColumnFill),
      FiltreTools.SfGridColumn('organes'   ,           'Cpt' , dColumnWidth[12], dColumnWidth[1], Alignment.centerRight),
    ];

  }

  void Resize(ColumnResizeUpdateDetails args)
  {
    setState(() {
      if (args.column.columnName ==      'id'         ) dColumnWidth[0 ] = args.width;
      else if (args.column.columnName == 'groupe'     ) dColumnWidth[1 ] = args.width;
      else if (args.column.columnName == 'site'       ) dColumnWidth[2 ] = args.width;
      else if (args.column.columnName == 'zone'       ) dColumnWidth[3 ] = args.width;
      else if (args.column.columnName == 'date'       ) dColumnWidth[4 ] = args.width;
      else if (args.column.columnName == 'org'        ) dColumnWidth[5 ] = args.width;
      else if (args.column.columnName == 'type'       ) dColumnWidth[6 ] = args.width;
      else if (args.column.columnName == 'status'     ) dColumnWidth[7 ] = args.width;
      else if (args.column.columnName == 'factu'      ) dColumnWidth[8 ] = args.width;
      else if (args.column.columnName == 'RespCom'    ) dColumnWidth[9 ] = args.width;
      else if (args.column.columnName == 'RespTech'   ) dColumnWidth[10] = args.width;
      else if (args.column.columnName == 'Rem'        ) dColumnWidth[11] = args.width;
      else if (args.column.columnName == 'organes'    ) dColumnWidth[12] = args.width;
    });
  }





  Future Reload() async {
    await DbTools.initListFam();
    await DbTools.getInterventionsClient(DbTools.gClient.ClientId);

    print("••••• ••••• ••••• ••••• ••••• ••••• getInterventionsClient <<<<<<>>>>>>");

    intervInfoDataGridSource.handleRefresh();
    setState(() {});

  }

  @override
  void initState() {
    super.initState();
    Reload();
  }


  @override
  Widget build(BuildContext context) {
    return
      Container(
    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),      child: Column(children: [
        ToolsBar(context),

        SizedBox(
            height: MediaQuery.of(context).size.height - 422,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor : gColors.backgroundColor,
                ),
                child: SfDataGrid(
                  //*********************************
                  onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) async {
                    if (addedRows.length > 0 && wColSel ==0)
                    {
                      Selindex = intervInfoDataGridSource.dataGridRows.indexOf(addedRows.last);
                      DbTools.gIntervention = DbTools.ListIntervention[Selindex];
                      await DbTools.getGroupe(DbTools.gIntervention.GroupeId!);
                      await DbTools.getSite(DbTools.gIntervention.SiteId!);
                      await DbTools.getZone(DbTools.gIntervention.ZoneId!);
                      await showDialog(context: context, builder: (BuildContext context) => new Intervention_Dialog(site: DbTools.gSite,));
                      Reload();
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
                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  selectionMode: SelectionMode.multiple,
                  controller: dataGridController,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                    Resize( args);
                    return true;
                  },
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill,
                ))),
        Container(
          height: 10,
        ),
      ]),
    );
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
              ],
            ),
          ],
        ));
  }


  void ToolsBarSupprFilter() async {
    intervInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }



}
