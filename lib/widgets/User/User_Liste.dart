import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/User/User_Edit.dart';


DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************

class UserDataGridSource extends DataGridSource {
  UserDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListUser.map<DataGridRow>((User user) {
      int wActif = user.User_Actif ? 1 : 0 ;
      int wIsole = user.User_Niv_Isole ? 1 : 0 ;
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName:     'id'        , value: user.UserID),
        DataGridCell<int>(columnName:    'actif'     , value: wActif),
        DataGridCell<String>(columnName:  'matricule' , value: user.User_Matricule),
        DataGridCell<String>(columnName:  'type'      , value: user.User_TypeUser),
        DataGridCell<String>(columnName:  'niv'       , value: user.User_NivHab),
        DataGridCell<int>(columnName:    'isole'     , value: wIsole),
        DataGridCell<String>(columnName:  'agence'    , value: user.User_Depot ),
        DataGridCell<String>(columnName:  'nom'       , value: user.User_Nom   ),
        DataGridCell<String>(columnName:  'prenom'    , value: user.User_Prenom),
        DataGridCell<String>(columnName:  'cp'        , value: user.User_Cp    ),
        DataGridCell<String>(columnName:  'ville'     , value: user.User_Ville ),
        DataGridCell<String>(columnName:  'tel'       , value: user.User_Tel   ),
        DataGridCell<String>(columnName:  'mail'      , value: user.User_Mail  ),
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
    Color textColor = dataGridController.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;

    Color backgroundColor = Colors.transparent;
    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRowBoolint(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRowBoolint(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 12, Alignment.centerLeft, textColor),
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


class User_Liste extends StatefulWidget {
  @override
  User_ListeState createState() => User_ListeState();
}

class User_ListeState extends State<User_Liste> {


  List<double> dColumnWidth = [
    80,
    120,
    140,
    150,
    150,
    120,
    150,
    150,
    160,
    100,
    170,
    120,
    170,

  ];

  UserDataGridSource userDataGridSource = UserDataGridSource();

  int wColSel = -1;
  int wRowSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;
  int SelUser = 0;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id'       , 'Id'       , dColumnWidth[0 ], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('actif'    , 'Actif'    , dColumnWidth[1 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('matricule', 'Matricule', dColumnWidth[2 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('type'     , 'Type'     , dColumnWidth[3 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('niv'      , 'Niv'      , dColumnWidth[4 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('isole'    , 'Isole'    , dColumnWidth[5 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('agence'   , 'Agence'   , dColumnWidth[6 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom'      , 'Nom'      , dColumnWidth[7 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('prenom'   , 'Prenom'   , dColumnWidth[8 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp'       , 'Cp'       , dColumnWidth[9 ], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville'    , 'Ville'    , dColumnWidth[10], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('tel'      , 'Tel'      , dColumnWidth[11], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('mail'     , 'Mail'     , dColumnWidth[12], 160, Alignment.centerLeft),
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
          ],
          position: GridTableSummaryRowPosition.bottom),
      ];
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
           if (args.column.columnName ==      'id' )             dColumnWidth[0] = args.width;
           else if (args.column.columnName == 'actif'    )       dColumnWidth[1 ] = args.width;
           else if (args.column.columnName == 'matricule')       dColumnWidth[2 ] = args.width;
           else if (args.column.columnName == 'type'     )       dColumnWidth[3 ] = args.width;
           else if (args.column.columnName == 'niv'      )       dColumnWidth[4 ] = args.width;
           else if (args.column.columnName == 'isole'    )       dColumnWidth[5 ] = args.width;
           else if (args.column.columnName == 'agence'   )       dColumnWidth[6 ] = args.width;
           else if (args.column.columnName == 'nom'      )       dColumnWidth[7 ] = args.width;
           else if (args.column.columnName == 'prenom'   )       dColumnWidth[8 ] = args.width;
           else if (args.column.columnName == 'cp'       )       dColumnWidth[9 ] = args.width;
           else if (args.column.columnName == 'ville'    )       dColumnWidth[10] = args.width;
           else if (args.column.columnName == 'tel'      )       dColumnWidth[11] = args.width;
           else if (args.column.columnName == 'mail'     )       dColumnWidth[12] = args.width;

    });
  }


  Future Reload() async {
    await DbTools.getUserAll();


    for (int j = 0; j < DbTools.ListParam_ParamAll.length; j++) {
    Param_Param param = DbTools.ListParam_ParamAll[j];
      if (param.Param_Param_Type.compareTo("NivHab") == 0) {
        print("NivHab ${param.Param_ParamId} ${param.Param_Param_ID}");
      }
    }

    for (int j = 0; j < DbTools.ListParam_ParamAll.length; j++) {
      Param_Param param = DbTools.ListParam_ParamAll[j];
      if (param.Param_Param_Type.compareTo("TypeUser") == 0) {
        print("TypeUser ${param.Param_ParamId} ${param.Param_Param_ID}");
      }
    }

    for (int i = 0; i < DbTools.ListUser.length; i++) {

        DbTools.ListUser[i].User_NivHab = "???";

      //      print("wUser.User_NivHabID ${wUser.User_NivHabID} ${DbTools.ListParam_Param.length}");
      for (int j = 0; j < DbTools.ListParam_ParamAll.length; j++) {
        Param_Param param = DbTools.ListParam_ParamAll[j];
        if (param.Param_Param_Type.compareTo("NivHab") == 0) {
//          print("param.Param_ParamId ${param.Param_ParamId}");
          if (param.Param_ParamId == DbTools.ListUser[i].User_NivHabID) {
            DbTools.ListUser[i].User_NivHab = param.Param_Param_ID;
            break;
          }
        }
      }
    };


    for (int i = 0; i < DbTools.ListUser.length; i++) {


      DbTools.ListUser[i].User_TypeUser = "???";


      //      print("wUser.User_TypeUserID ${wUser.User_TypeUserID} ${DbTools.ListParam_Param.length}");
      for (int j = 0; j < DbTools.ListParam_ParamAll.length; j++) {
        Param_Param param = DbTools.ListParam_ParamAll[j];
        if (param.Param_Param_Type.compareTo("TypeUser") == 0) {
//          print("param.Param_ParamId ${param.Param_ParamId}");
          if (param.Param_ParamId == DbTools.ListUser[i].User_TypeUserID) {
            DbTools.ListUser[i].User_TypeUser = param.Param_Param_ID;
            break;
          }
        }
      }
    };




    await userDataGridSource.handleRefresh();

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();

    await Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return
      UserGridWidget();
  }

  //********************************************
  //********************************************
  //********************************************

  Widget UserGridWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: [
        ToolsBargrid(context),
        SizedBox(
            height: MediaQuery.of(context).size.height - 170,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor: gColors.backgroundColor,
                ),
                child: SfDataGrid(
                  //*********************************
                  onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) async {
                    if (addedRows.length > 0 && wColSel == 0) {
                      Selindex = userDataGridSource.dataGridRows.indexOf(addedRows.last);
                      SelUser = dataGridController.selectedIndex;
                      DbTools.gUser = DbTools.ListUser[Selindex];
                      print(" ADD onSelectionChanged  SelUser ${SelUser} gUser ${DbTools.gUser.UserID}");
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit(user: DbTools.gUser)));
                      Reload();
                    }

                    if (removedRows.length > 0 && wColSel == 0) {
                      Selindex = userDataGridSource.dataGridRows.indexOf(removedRows.last);
                      SelUser = dataGridController.selectedIndex;
                      DbTools.gUser = DbTools.ListUser[Selindex];
                      print(" REM onSelectionChanged  SelUser ${SelUser} SelUser ${SelUser} gUser ${DbTools.gUser.UserID}");
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit(user: DbTools.gUser)));
                      Reload();
                    }


                  },




                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = userDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    setState(() {});
                  },
                  onCellTap: (DataGridCellTapDetails details) {
                    wColSel = details.rowColumnIndex.columnIndex;
                    wRowSel = details.rowColumnIndex.rowIndex;
                  },

                  //*********************************

                  allowSorting: true,
                  allowFiltering: true,
                  source: userDataGridSource,
                  columns: getColumns(),
                  tableSummaryRows: getGridTableSummaryRow(),

                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.row,
                  controller: dataGridController,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                    Resize(args);
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

  Widget ToolsBargrid(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
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
    userDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }


  Widget UserGridWidgetvp() {
    List<DaviColumn<User>> wColumns = [
      new DaviColumn(
          name: 'Id',
          width: 60,
          stringValue: (row) => "${row.UserID}"
              ""),
      new DaviColumn(
          name: 'Actif',
          width: 50,
          cellBuilder: (BuildContext context, DaviRow<User> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Actif,
              onChanged: (bool? value) {},
            );
          }),

      //cellBuilder: (context, row) =>  Checkbox(checkColor: Colors.red, value: row.data.User_Actif),),

      new DaviColumn(name: 'Matricule', width: 90, stringValue: (row) => "${row.User_Matricule}"),
      new DaviColumn(name: 'Type', width: 100, stringValue: (row) => row.User_TypeUser),
      new DaviColumn(name: 'Niveau', width: 90, stringValue: (row) => row.User_NivHab),

      new DaviColumn(name: 'Isolé', width: 50, cellBuilder: (BuildContext context, DaviRow<User> row) {
            return Checkbox(checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Niv_Isole,
              onChanged: (bool? value) {},
            );       }),

      new DaviColumn(name: 'Agence', grow: 18, stringValue: (row) => "${row.User_Depot}"),
      new DaviColumn(name: 'Nom', grow: 18, stringValue: (row) => "${row.User_Nom}"),
      new DaviColumn(name: 'Prénom', grow: 18, stringValue: (row) => "${row.User_Prenom}"),
      new DaviColumn(name: 'Code postal', stringValue: (row) => "${row.User_Cp}"),
      new DaviColumn(name: 'Ville', grow: 18, stringValue: (row) => "${row.User_Ville}"),
      new DaviColumn(name: 'Tel', grow: 6, stringValue: (row) => "${row.User_Tel}"),
      new DaviColumn(name: 'Mail', grow: 8, stringValue: (row) => "${row.User_Mail}"),
    ];

    print("Param_GammeGridWidget");
    DaviModel<User>? _model;

    _model = DaviModel<User>(rows: DbTools.ListUser, columns: wColumns);

    return new DaviTheme(
        child: new Davi<User>(
          _model,
          visibleRowsCount: 32,
          onRowTap: (User) => _onRowTap(context, User),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

  void _onRowTap(BuildContext context, User user) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit(user: user)));
    Reload();
  }
}
