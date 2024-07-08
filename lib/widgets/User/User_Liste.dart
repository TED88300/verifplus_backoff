import 'dart:convert' show utf8;
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/stub_file_picking/platform_file_picker.dart';
import 'package:verifplus_backoff/stub_file_picking/web_file_picker.dart';
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

      int wActif = user.User_Actif ? 1 : 0;
      int wIsole = user.User_Niv_Isole ? 1 : 0;
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: user.UserID),
        DataGridCell<int>(columnName: 'actif', value: wActif),
        DataGridCell<String>(columnName: 'matricule', value: user.User_Matricule),
        DataGridCell<String>(columnName: 'fam', value: user.User_Famille),
        DataGridCell<String>(columnName: 'fonc', value: user.User_Fonction),
        DataGridCell<String>(columnName: 'agence', value: user.User_Depot),
        DataGridCell<String>(columnName: 'nom', value: user.User_Nom),
        DataGridCell<String>(columnName: 'prenom', value: user.User_Prenom),
        DataGridCell<String>(columnName: 'cp', value: user.User_Cp),
        DataGridCell<String>(columnName: 'ville', value: user.User_Ville),
        DataGridCell<String>(columnName: 'tel', value: user.User_Tel),
        DataGridCell<String>(columnName: 'mail', value: user.User_Mail),
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
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 11, Alignment.centerLeft, textColor),
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

class User_ListeState extends State<User_Liste> with TickerProviderStateMixin {
  bool iStrfExp = false;
  late AnimationController acontroller;

  List<double> dColumnWidth = [
    80,
    110,
    135,
    125,
    190,
    200,
    200,
    160,
    100,
    240,
    120,
    230,
  ];

  UserDataGridSource userDataGridSource = UserDataGridSource();

  int wColSel = -1;
  int wRowSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;
  int SelUser = 0;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'Id', dColumnWidth[0], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('actif', 'Actif', dColumnWidth[1], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('matricule', 'Matricule', dColumnWidth[2], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('fam', 'Famille', dColumnWidth[3], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('fonc', 'Fonction', dColumnWidth[4], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('agence', 'Agence', dColumnWidth[5], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Nom', dColumnWidth[6], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('prenom', 'Prenom', dColumnWidth[7], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp', dColumnWidth[8], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville', dColumnWidth[9], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('tel', 'Tel', dColumnWidth[10], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('mail', 'Mail', dColumnWidth[11], 160, Alignment.centerLeft),
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
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'actif')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'matricule')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'fam')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'fonc')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'agence')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'nom')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'prenom')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'cp')
        dColumnWidth[8] = args.width;
      else if (args.column.columnName == 'ville')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'tel')
        dColumnWidth[10] = args.width;
      else if (args.column.columnName == 'mail') dColumnWidth[11] = args.width;
    });
  }

  Future Reload() async {
    await DbTools.getUserAll();


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
    acontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        //print("setSt 2");
        setState(() {});
      });
    acontroller.repeat(reverse: true);
    acontroller.stop();
  }

  @override
  void dispose() {
    acontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserGridWidget();
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
                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = userDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    setState(() {});
                  },
                  onCellTap: (DataGridCellTapDetails details) async {
                    wColSel = details.rowColumnIndex.columnIndex;
                    wRowSel = details.rowColumnIndex.rowIndex;
                    if (wRowSel == 0) return;
                    DataGridRow wDataGridRow = userDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                    Selindex = userDataGridSource.dataGridRows.indexOf(wDataGridRow);
                    if (wColSel == 0) {
                      SelUser = dataGridController.selectedIndex;
                      DbTools.gUser = DbTools.ListUser[Selindex];
                      print(" REM onSelectionChanged  SelUser ${SelUser} SelUser ${SelUser} gUser ${DbTools.gUser.UserID}");
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit(user: DbTools.gUser)));
                      Reload();
                    }
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
                iStrfExp
                    ? CircularProgressIndicator(
                        value: acontroller.value,
                        semanticsLabel: 'Circular progress indicator',
                      )
                    : InkWell(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                            ),
                            Icon(
                              Icons.file_open,
                              color: Colors.red,
                              size: 24.0,
                            ),
                            Container(
                              width: 8,
                            ),
                            Text(
                              "Export Users sur serveur",
                              style: gColors.bodySaisie_N_G,
                            )
                          ],
                        ),
                        onTap: () async {
                          ImportUser(
                            context,
                          );
                        }),
              ],
            ),
          ],
        ));
  }

  void onSetStateOn() async {
    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;
    });
  }

  void onSetStateOff() async {
    setState(() {
      acontroller.stop();
      iStrfExp = false;
    });

    Reload();
  }

  void ToolsBarSupprFilter() async {
    userDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }

//**********************************
//**********************************
//**********************************

  void ImportUser(
    BuildContext context,
  ) async {
    List<User> ListUser = [];
    ListUser.addAll(DbTools.ListUser);

    String wTable = "Users";
    await PlatformFilePicker().startWebCsvPicker((files) async {
      onSetStateOn();

      if (files.length == 1) {
        FlutterWebFile file = files.first;
///        print("ImportUser " + file.file.name);

        List<int> input = file.fileBytes;
        String convertedValue = utf8.decode(input);
        List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(eol: "\r\n", fieldDelimiter: ";", shouldParseNumbers: false).convert(convertedValue);

        String wSql1 = "INSERT INTO $wTable (";

        List<dynamic> Titre = rowsAsListOfValues[0];
//        print("Titre " + Titre.toString());
        for (int j = 0; j < Titre.length; j++) {
          String Champs = Titre[j];
          if (j > 0) wSql1 += ",";
          String wChamps = Champs.substring(1);
          wSql1 += wChamps;
        }
        wSql1 += ") VALUES";
//        print("wSql1 " + wSql1.toString());

        for (int i = 1; i < rowsAsListOfValues.length; i++) {
          List<dynamic> Ligne = rowsAsListOfValues[i];
          String wSql2 = "";
          if (i > 1) wSql2 += ",";
          wSql2 += " (";
//          print("Ligne " + Ligne.toString());
          for (int j = 0; j < Ligne.length; j++) {
            String Champs = Ligne[j];
            if (j > 0) wSql2 += ",";
            if (Titre[j].substring(0, 1) == "s") {
              wSql2 += "\"$Champs\"";
            } else {
              wSql2 += Champs;
            }
          }
          wSql2 += ")";
          wSql1 += wSql2;
        }
        wSql1 += ";";

//        print("" + wSql1.toString());


        String wSql = "TRUNCATE $wTable";
        bool ret = await DbTools.add_API_Post("upddel", wSql);
        ret = await DbTools.add_API_Post("upddel", wSql1);

        await DbTools.getUserAll();
        List<String> wListFam = [];
        List<String> wListFonc = [];
        List<String> wListServ = [];

      for (int i = 0; i < DbTools.ListUser.length; i++) {
          User wUser = DbTools.ListUser[i];
          print("wUser.User_Matricule ${wUser.User_Matricule} ${wUser.User_Nom}");
          for (int j = 0; j < ListUser.length; j++) {
            User wUservp = ListUser[j];

            print("           wUservp.User_Matricule ${wUservp.User_Matricule}");

            if (wUser.User_Matricule == wUservp.User_Matricule)
              {
                wUser.User_PassWord = wUservp.User_PassWord;
                DbTools.setUser(wUser);
                break;
              }
          }

          if (!wListFam.contains(wUser.User_Famille))
            {
              wListFam.add(wUser.User_Famille);
            }
          if (!wListFonc.contains(wUser.User_Fonction))
          {
            wListFonc.add(wUser.User_Fonction);
          }
          if (!wListServ.contains(wUser.User_Service))
          {
            wListServ.add(wUser.User_Service);
          }
      }


        wSql = "Delete FROM Param_Param  Where Param_Param.Param_Param_Type = 'Type_Famille';";
        ret = await DbTools.add_API_Post("upddel", wSql);
        for (int j = 0; j < wListFam.length; j++) {
          print("wListFam ${wListFam[j]}");
          wSql = "INSERT INTO Param_Param (Param_ParamId, Param_Param_Type, Param_Param_ID, Param_Param_Text) VALUES (NULL, 'Type_Famille', \"${wListFam[j]}\", \"${wListFam[j]}\")";
          ret = await DbTools.add_API_Post("upddel", wSql);
        }


        wSql = "Delete FROM Param_Param  Where Param_Param.Param_Param_Type = 'Type_Fonction';";
        ret = await DbTools.add_API_Post("upddel", wSql);
        for (int j = 0; j < wListFonc.length; j++) {
          print("wListFonc ${wListFonc[j]}");
          wSql = "INSERT INTO Param_Param (Param_ParamId, Param_Param_Type, Param_Param_ID, Param_Param_Text) VALUES (NULL, 'Type_Fonction', \"${wListFonc[j]}\", \"${wListFonc[j]}\")";
          ret = await DbTools.add_API_Post("upddel", wSql);
        }

        wSql = "Delete FROM Param_Param  Where Param_Param.Param_Param_Type = 'Type_Service';";
        ret = await DbTools.add_API_Post("upddel", wSql);
        for (int j = 0; j < wListServ.length; j++) {
          print("wListServ ${wListServ[j]}");
          wSql = "INSERT INTO Param_Param (Param_ParamId, Param_Param_Type, Param_Param_ID, Param_Param_Text) VALUES (NULL, 'Type_Service', \"${wListServ[j]}\", \"${wListServ[j]}\")";
          ret = await DbTools.add_API_Post("upddel", wSql);
        }







        onSetStateOff();
      }
    });
  }
}
