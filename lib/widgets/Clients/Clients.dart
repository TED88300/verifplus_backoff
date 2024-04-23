import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Dialog.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';

//*********************************************************************
//*********************************************************************
//*********************************************************************

DataGridController dataGridController = DataGridController();

class ClientInfoDataGridSource extends DataGridSource {
  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  ClientInfoDataGridSource() {
    buildDataGridRows();
    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;


  void buildDataGridRows() {
    dataGridRows = DbTools.ListClientsearchresult.map<DataGridRow>((Client client) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: client.ClientId),
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
    return DataGridRowAdapter(
    color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft,textColor ),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 6, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 7, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 8, Alignment.centerLeft,textColor),
    ]);
  }

  static Widget SfRowSel(DataGridRow row, int Col, AlignmentGeometry alignment) {
    double t = 5;
    double b = 3;

    return InkWell(
        onTap: () async {
          print("onSelectionChanging  row ${row.getCells()[0].value.toString()}  ${row.getCells()[1].value.toString()}");

          bool wRet = await DbTools.getClientMemID(row.getCells()[0].value);
          if (wRet)
          {
//            await showDialog(context: context, builder: (BuildContext context) => new Client_Dialog(client: DbTools.gClient));

          }



        },
        child: Container(
//            padding: EdgeInsets.fromLTRB(0, t, 8, b),
            alignment: alignment,
            child: Row(
              children: [
                Icon(Icons.play_arrow_sharp, color: Colors.black26, size: 20),
                Text(
                  row.getCells()[Col].value.toString(),
                  style: gColors.bodySaisie_N_G,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )));
  }
}
/*

ElevatedButton(
        onPressed: () async {
          emailController.text = "mm@gmail.com";
          passwordController.text = "mm13500";
        },
        child: Text('Démo Client',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
*/

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Clients_screen extends StatefulWidget {
  @override
  _Clients_screenState createState() => _Clients_screenState();
}

class _Clients_screenState extends State<Clients_screen> {
  List<double> dColumnWidth = [
    80,
    115,
    470,
    200,
    250,
    200,
    95,
    300,
    200,
  ];

  ClientInfoDataGridSource clientInfoDataGridSource = ClientInfoDataGridSource();

  final Search_TextController = TextEditingController();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], 15, Alignment.centerLeft),
      FiltreTools.SfGridColumn('forme', 'Forme', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Raison Social', double.nan, 160, Alignment.centerLeft, wColumnWidthMode: ColumnWidthMode.lastColumnFill),
      FiltreTools.SfGridColumn('agence', 'Agencel', dColumnWidth[3], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('famille', 'Famille', dColumnWidth[4], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('commercial', 'Commercial', dColumnWidth[5], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp', dColumnWidth[6], dColumnWidth[6], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville', dColumnWidth[7], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('pays', 'Pays', dColumnWidth[8], 160, Alignment.centerLeft),
    ];
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'forme')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'nom')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'agence')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'famille')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'commercial')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'cp')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'ville')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'pays') dColumnWidth[8] = args.width;
    });
  }

  Future Reload() async {
    await DbTools.getParam_ParamFam("FamClient");
    await DbTools.getClientAll();
    print("Reload getClientAll ${DbTools.ListClient.length}");
    await Filtre();
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

    clientInfoDataGridSource.handleRefresh();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.white,
      child: Column(children: [
        ToolsBar(context),
        Container(
          height: 10,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height - 190,
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
                      Selindex = clientInfoDataGridSource.dataGridRows.indexOf(addedRows.last);
                      Client wClient = DbTools.ListClientsearchresult[Selindex];
                      print("onSelectionChanging Col ${wColSel} wClient ${wClient.ClientId} ${wClient.Client_Nom}");
                          await showDialog(context: context, builder: (BuildContext context) => new Client_Dialog(client: wClient));
                        Reload();
                    }

                    if (removedRows.length > 0 && wColSel ==0)
                      {
                      Selindex = clientInfoDataGridSource.dataGridRows.indexOf(removedRows.last);
                      Client wClient = DbTools.ListClientsearchresult[Selindex];
                      print("onSelectionChanging Col ${wColSel} wClient ${wClient.ClientId} ${wClient.Client_Nom}");
                      await showDialog(context: context, builder: (BuildContext context) => new Client_Dialog(client: wClient));
                      Reload();
                      }
                    },


                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = clientInfoDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    print("onFilterChanged  clientInfoDataGridSource.rows.length ${clientInfoDataGridSource.rows.length}");
                    print("onFilterChanged  clientInfoDataGridSource.dataGridRows.length ${clientInfoDataGridSource.dataGridRows.length}");
                    setState(() {});
                  },
                    onCellTap: (DataGridCellTapDetails details) {
                      wColSel = details.rowColumnIndex.columnIndex;
                      print("onCellTap wColSel ${wColSel}");
                    },

                  //*********************************
                  selectionMode: SelectionMode.multiple,
                  navigationMode: GridNavigationMode.row,
                  allowSorting: true,
                  allowFiltering: true,
                  source: clientInfoDataGridSource,
                  columns: getColumns(),
                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
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

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter un client"),
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
