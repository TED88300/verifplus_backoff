import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Dialog.dart';

class ClientDataSource extends DataGridSource {
  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  ClientDataSource(List<Client> clients) {
    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);
    buildDataGridRow(clients);
  }

  void buildDataGridRow(List<Client> clientData) {
    dataGridRow = clientData.map<DataGridRow>((client) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: client.ClientId),
        DataGridCell<bool>(columnName: 'contrat', value: client.Client_Contrat),
        DataGridCell<String>(columnName: 'statut', value: client.Client_Statut),
        DataGridCell<String>(columnName: 'forme', value: client.Client_Civilite),
        DataGridCell<String>(columnName: 'nom', value: client.Client_Nom),
        DataGridCell<String>(columnName: 'agence', value: client.Client_Depot),
        DataGridCell<String>(columnName: 'famille', value: "${(client.Client_Famille.isEmpty || ListParam_FiltreFamID.indexOf(client.Client_Famille) == -1) ? '' : ListParam_FiltreFam[ListParam_FiltreFamID.indexOf(client.Client_Famille)]}"),
        DataGridCell<String>(columnName: 'commercial', value: client.Users_Nom),
        DataGridCell<String>(columnName: 'cp', value: client.Adresse_CP),
        DataGridCell<String>(columnName: 'ville', value: client.Adresse_Ville),
        DataGridCell<String>(columnName: 'pays', value: client.Adresse_Pays),
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
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRowBool(row, 1, Alignment.center, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 9, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 10, Alignment.centerLeft, textColor),
    ]);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(alignment: Alignment.center, child: Text(summaryValue));
  }

  @override
  Future<void> handleRefresh() async {
    notifyListeners();
  }
}

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************
class Clients_screen extends StatefulWidget {
  const Clients_screen({Key? key}) : super(key: key);

  @override
  Clients_screenState createState() => Clients_screenState();
}

class Clients_screenState extends State<Clients_screen> {
  late ClientDataSource clientInfoDataGridSource;

  List<double> dColumnWidth = [
    80,
    90,
    115,
    115,
    400,
    180,
    250,
    200,
    95,
    250,
    120,
  ];

//  ClientInfoDataGridSource clientInfoDataGridSource = ClientInfoDataGridSource();

  final Search_TextController = TextEditingController();
  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;
  bool isLoad = false;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], 15, Alignment.centerLeft),
      FiltreTools.SfGridColumn('contrat', 'Ct', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('statut', 'St', dColumnWidth[2], dColumnWidth[2], Alignment.centerLeft),
      FiltreTools.SfGridColumn('forme', 'Forme', dColumnWidth[3], dColumnWidth[3], Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Raison Social', dColumnWidth[4], dColumnWidth[4], Alignment.centerLeft),
      FiltreTools.SfGridColumn('agence', 'Agence', dColumnWidth[5], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('famille', 'Famille', dColumnWidth[6], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('commercial', 'Commercial', dColumnWidth[7], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp', dColumnWidth[8], dColumnWidth[8], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville', dColumnWidth[9], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('pays', 'Pays', dColumnWidth[10], 160, Alignment.centerLeft),
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
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'contrat')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'statut')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'forme')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'nom')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'agence')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'famille')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'commercial')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'cp')
        dColumnWidth[8] = args.width;
      else if (args.column.columnName == 'ville')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'pays')
        dColumnWidth[10] = args.width;
    });
  }

  Future Reload() async {
    await DbTools.getParam_ParamFam("FamClient");


    if (DbTools.gUserLoginTypeUser.contains("Admin"))
        await DbTools.getClientAll();
    else
       await DbTools.getClient_User_CSIP(DbTools.gUserLogin.UserID);

    await Filtre();
    clientInfoDataGridSource = ClientDataSource(DbTools.ListClientsearchresult);
  }

  Future Filtre() async {
    DbTools.ListClientsearchresult.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      DbTools.ListClientsearchresult.addAll(DbTools.ListClient);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListClient.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          DbTools.ListClientsearchresult.add(element);
        }
      });
    }

    clientInfoDataGridSource = ClientDataSource(DbTools.ListClientsearchresult);
    clientInfoDataGridSource.handleRefresh();
    isLoad = true;
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

        !isLoad ? Container() :
        SizedBox(
          height: MediaQuery.of(context).size.height - 190,
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: gColors.secondary,
              selectionColor: gColors.backgroundColor,
            ),
            child: SfDataGrid(
              source: clientInfoDataGridSource,
              columns: getColumns(),
              columnWidthMode: ColumnWidthMode.fill,
              tableSummaryRows: getGridTableSummaryRow(),

//                  frozenRowsCount: 0,
//                frozenColumnsCount: 3,

              controller: dataGridController,
              onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) async {
                if (addedRows.length > 0 && wColSel == 0) {
                  Selindex = clientInfoDataGridSource.dataGridRow.indexOf(addedRows.last);
                  Client wClient = DbTools.ListClientsearchresult[Selindex];
                  print(" ADD onSelectionChanging Add ${Selindex} wClient ${wClient.ClientId} ${wClient.Client_Nom}");
                  await showDialog(context: context, builder: (BuildContext context) => new Client_Dialog(client: wClient));
                  Reload();
                }

                if (removedRows.length > 0 && wColSel == 0) {
                  Selindex = clientInfoDataGridSource.dataGridRow.indexOf(removedRows.last);
                  Client wClient = DbTools.ListClientsearchresult[Selindex];
                  print(" REM onSelectionChanging Rem ${Selindex} wClient ${wClient.ClientId} ${wClient.Client_Nom}");
                  await showDialog(context: context, builder: (BuildContext context) => new Client_Dialog(client: wClient));
                  Reload();
                }
              },
              onFilterChanged: (DataGridFilterChangeDetails details) {
                countfilterConditions = clientInfoDataGridSource.filterConditions.length;
                print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                print("onFilterChanged  clientInfoDataGridSource.rows.length ${clientInfoDataGridSource.rows.length}");
                print("onFilterChanged  clientInfoDataGridSource.dataGridRows.length ${clientInfoDataGridSource.dataGridRow.length}");
                setState(() {});
              },
              onCellTap: (DataGridCellTapDetails details) {
                wColSel = details.rowColumnIndex.columnIndex;
                print("onCellTap wColSel ${wColSel}");
              },

              selectionMode: SelectionMode.multiple,
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
              isScrollbarAlwaysShown : true,

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
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", ToolsBarAdd, tooltip: "Ajouter un client"),
                Container(
                  width: 10,
                ),
                CommonAppBar.SquareRoundPng(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, "ico_Del", ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
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
    clientInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    Search_TextController.clear();
    await Filtre();
    setState(() {});
  }

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    Client wClient = await Client.ClientInit();
    await DbTools.addClient(wClient);
    wClient.ClientId = DbTools.gLastID;
    await DbTools.getAdresseClientType(wClient.ClientId, "FACT");
    await DbTools.getAdresseClientType(wClient.ClientId, "LIVR");
    wClient.Client_Nom = "???";
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Client_Dialog(client: wClient),
    );
    await Reload();
  }
}
