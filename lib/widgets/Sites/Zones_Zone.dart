import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/Tools/Srv_Zones.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/Zone_Dialog.dart';

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************

class ZoneDataGridSource extends DataGridSource {
  ZoneDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListZonesearchresult.map<DataGridRow>((Zone zone) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: zone.ZoneId),
        DataGridCell<String>(columnName: 'nom', value: zone.Zone_Nom),
        DataGridCell<String>(columnName: 'adresse', value: zone.Zone_Adr1),
        DataGridCell<String>(columnName: 'cp', value: zone.Zone_CP),
        DataGridCell<String>(columnName: 'ville', value: zone.Zone_Ville),
        DataGridCell<String>(columnName: 'agence', value: zone.Zone_Depot),
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
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 4, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 5, Alignment.centerLeft, textColor),
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

class Zones_Zone extends StatefulWidget {
  final VoidCallback onMaj;
  const Zones_Zone({Key? key, required this.onMaj}) : super(key: key);

  @override
  State<Zones_Zone> createState() => _Zones_ZoneState();
}

class _Zones_ZoneState extends State<Zones_Zone> {
  TextEditingController textController_Zone_Code = TextEditingController();
  TextEditingController textController_Zone_Type = TextEditingController();
  TextEditingController textController_Zone_Nom = TextEditingController();
  TextEditingController textController_Zone_Adr1 = TextEditingController();
  TextEditingController textController_Zone_Adr2 = TextEditingController();
  TextEditingController textController_Zone_Adr3 = TextEditingController();
  TextEditingController textController_Zone_Adr4 = TextEditingController();
  TextEditingController textController_Zone_CP = TextEditingController();
  TextEditingController textController_Zone_Ville = TextEditingController();
  TextEditingController textController_Zone_Pays = TextEditingController();
  TextEditingController textController_Zone_Acces = TextEditingController();
  TextEditingController textController_Zone_Rem = TextEditingController();
  List<String> ListParam_ParamFam = [];
  List<String> ListParam_ParamFamID = [];
  int SelZone = 0;
  List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";
  final Search_TextController = TextEditingController();

  int wColSel = -1;
  int wRowSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  ZoneDataGridSource zoneDataGridSource = ZoneDataGridSource();

  DataGridRow memDataGridRow = DataGridRow(cells: []);

  Future Reload() async {
    await DbTools.getZonesSite(DbTools.gSite.SiteId);
    print("initLib getZonesClient ${DbTools.ListZone.length}");
    await Filtre();
  }

  void initLib() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Zones_Zone");

    await DbTools.getAdresseType("AGENCE");
    ListParam_ParamDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    });
    selectedValueDepot = ListParam_ParamDepot[0];
    DbTools.gZone = Zone.ZoneInit();
    await Reload();
    await AlimSaisie();
  }

  Future Filtre() async {
    List<Zone> ListZonesearchresultTmp = [];
    ListZonesearchresultTmp.clear();
    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");
    if (Search_TextController.text.isEmpty) {
      ListZonesearchresultTmp.addAll(DbTools.ListZone);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListZone.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListZonesearchresultTmp.add(element);
        }
      });
    }
    DbTools.ListZonesearchresult.clear();
    DbTools.ListZonesearchresult.addAll(ListZonesearchresultTmp);

    await zoneDataGridSource.handleRefresh();
    print("🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢🁢 memDataGridRow ${memDataGridRow.getCells()}");
    dataGridController.selectedRows.clear();
    dataGridController.selectedRows.add(memDataGridRow);

    AlimSaisie();

    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gZone.Desc()}");

    textController_Adresse_Geo.text = "${DbTools.gZone.Zone_Adr1} ${DbTools.gZone.Zone_CP} ${DbTools.gZone.Zone_Ville}";

    textController_Zone_Code.text = DbTools.gZone.Zone_Code;
    textController_Zone_Nom.text = DbTools.gZone.Zone_Nom;
    textController_Zone_Adr1.text = DbTools.gZone.Zone_Adr1;
    textController_Zone_Adr2.text = DbTools.gZone.Zone_Adr2;
    textController_Zone_Adr3.text = DbTools.gZone.Zone_Adr3;
    textController_Zone_Adr4.text = DbTools.gZone.Zone_Adr4;
    textController_Zone_CP.text = DbTools.gZone.Zone_CP;
    textController_Zone_Ville.text = DbTools.gZone.Zone_Ville;
    textController_Zone_Pays.text = DbTools.gZone.Zone_Pays;
    textController_Zone_Acces.text = DbTools.gZone.Zone_Acces;
    textController_Zone_Rem.text = DbTools.gZone.Zone_Rem;

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${DbTools.gZone.Zone_Depot}") == 0) {
        selectedValueDepot = element;
      }
    }
    await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_tks,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  void ToolsBarDelete() async {
    print("ToolsBarDelete");
    Alert(
      context: context,
      style: alertStyle,
      alertAnimation: fadeAlertAnimation,
      image: Container(
        height: 100,
        width: 100,
        child: Image.asset('assets/images/AppIco.png'),
      ),
      title: "Vérif+ Alerte",
      desc: "Êtes-vous sûre de vouloir supprimer cette Zone ?",
      buttons: [
        DialogButton(
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black12),
        DialogButton(
            child: Text(
              "Suprimer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await DbTools.delZone(DbTools.gZone);
              await Reload();
              setState(() {});
              Navigator.of(context).pop();
            },
            color: Colors.red)
      ],
    ).show();
  }

  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "Zone";
    DbTools.gViewAdr = "";
    widget.onMaj();
  }

  void ToolsBarCpy() async {
    print("ToolsBarCpy");
    textController_Zone_Adr1.text = DbTools.gAdresseLivr.Adresse_Adr1;
    textController_Zone_Adr2.text = DbTools.gAdresseLivr.Adresse_Adr2;
    textController_Zone_Adr3.text = DbTools.gAdresseLivr.Adresse_Adr3;
    textController_Zone_Adr4.text = DbTools.gAdresseLivr.Adresse_Adr4;
    textController_Zone_CP.text = DbTools.gAdresseLivr.Adresse_CP;
    textController_Zone_Ville.text = DbTools.gAdresseLivr.Adresse_Ville;
    textController_Zone_Pays.text = DbTools.gAdresseLivr.Adresse_Pays;
    textController_Zone_Acces.text = DbTools.gAdresseLivr.Adresse_Acces;
    textController_Zone_Rem.text = DbTools.gAdresseLivr.Adresse_Rem;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolsBar(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: ZoneGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Save", ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", ToolsBarAdd, tooltip: "Ajouter zone"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Copy", ToolsBarCpy, tooltip: "Copier adresse Livraison"),
                  ),
                  DbTools.gZone.Zone_Nom.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.orange, "ico_Contact", ToolsBarCtact, tooltip: "Contacts"),
                        ),
                  (DbTools.gZone.Zone_Nom != "???" || DbTools.ListIntervention.length > 0)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
                        ),
                ],
              ),
              ContentZoneCadre(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                ),
                Icon(
                  Icons.search,
                  color: Colors.blue,
                  size: 30.0,
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: Search_TextController,
                    decoration: gColors.wRechInputDecoration,
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
            Container(
              height: 1,
              color: gColors.primary,
            )
          ],
        ));
  }

  void ToolsBarSave() async {
    print("ToolsBarSave");

    DbTools.gZone.Zone_Code = textController_Zone_Code.text;
    DbTools.gZone.Zone_Nom = textController_Zone_Nom.text;
    DbTools.gZone.Zone_Adr1 = textController_Zone_Adr1.text;
    DbTools.gZone.Zone_Adr2 = textController_Zone_Adr2.text;
    DbTools.gZone.Zone_Adr3 = textController_Zone_Adr3.text;
    DbTools.gZone.Zone_Adr4 = textController_Zone_Adr4.text;
    DbTools.gZone.Zone_CP = textController_Zone_CP.text;
    DbTools.gZone.Zone_Ville = textController_Zone_Ville.text;
    DbTools.gZone.Zone_Pays = textController_Zone_Pays.text;
    DbTools.gZone.Zone_Acces = textController_Zone_Acces.text;
    DbTools.gZone.Zone_Rem = textController_Zone_Rem.text;

    await DbTools.setZone(DbTools.gZone);

    await Reload();

    setState(() {});
  }

  TextEditingController textController_Adresse_Geo = TextEditingController();

  Widget AutoAdresse(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_N_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_N_G,
                ),
              ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_B_G,
          ),
        ),
        Container(
            width: wWidth,
            child: TypeAheadField(
              animationStart: 0,
              animationDuration: Duration.zero,
              textFieldConfiguration: TextFieldConfiguration(
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                ),
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Colors.white,
              ),
              suggestionsCallback: (pattern) async {
                await Api_Gouv.ApiAdresse(textController_Adresse_Geo.text);
                List<String> matches = <String>[];
                Api_Gouv.properties.forEach((propertie) {
                  matches.add(propertie.label!);
                });
                return matches;
              },
              itemBuilder: (context, sone) {
                return Card(
                    child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(sone.toString()),
                ));
              },
              onSuggestionSelected: (suggestion) {
                Api_Gouv.properties.forEach((propertie) {
                  if (propertie.label!.compareTo(suggestion) == 0) {
                    Api_Gouv.gProperties = propertie;
                  }
                });
                textController_Adresse_Geo.text = suggestion;
              },
            )),
        Container(
          width: 20,
        ),
      ],
    );
  }

  void ToolsBarAdd() async {
    await DbTools.addZone(DbTools.gSite.SiteId);
    await Reload();
    DbTools.getZoneID(DbTools.gLastID);
    DbTools.gZone.Zone_Nom = "???";
    await DbTools.setZone(DbTools.gZone);
    await Filtre();
    AlimSaisie();
  }

  void ToolsBarCopySearch() async {
    print("ToolsBarCopySearch_Livr ${Api_Gouv.gProperties.toJson()}");
    textController_Zone_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Zone_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Zone_Ville.text = Api_Gouv.gProperties.city!;
  }

  Widget ToolsBar_Insee(BuildContext context) {
    return Container(
        width: 400,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 320,
                  child: AutoAdresse(80, 200, "Recherche", textController_Adresse_Geo),
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearch, tooltip: "Copier recherche"),
              ],
            ),
          ],
        ));
  }

  Widget ContentZoneCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 380,
          margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentZone(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Zone',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentZone(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  ToolsBar_Insee(context),
                  Row(
                    children: [
                      DropdownButtonDepot(),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code", textController_Zone_Code),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Zone_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Adresse", textController_Zone_Adr1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Zone_Adr2, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Zone_Adr3, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Zone_Adr4, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 10, "CP", textController_Zone_CP),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Ville", textController_Zone_Ville),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code Accès", textController_Zone_Acces),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Zone_Rem, Ligne: 21),
                    ],
                  ),
                ]))));
  }

  List<double> dColumnWidth = [
    80,
    450,
    350,
    120,
    160,
    160,
  ];
  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'nom')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'adresse')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'cp')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'ville') dColumnWidth[4] = args.width;
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Nom', double.nan, 160, Alignment.centerLeft, wColumnWidthMode: ColumnWidthMode.lastColumnFill),
      FiltreTools.SfGridColumn('adresse', 'Adresse', dColumnWidth[2], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp', dColumnWidth[3], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville', dColumnWidth[4], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('agence', 'Agence', dColumnWidth[5], 160, Alignment.centerLeft),
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

  Widget ZoneGridWidget() {
    return Container(
      child: Column(children: [
//        ToolsBargrid(context),
        Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
            height: MediaQuery.of(context).size.height - 280,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor: gColors.backgroundColor,
                ),
                child: SfDataGrid(
                  //*********************************


                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = zoneDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    setState(() {});
                  },
                  onCellTap: (DataGridCellTapDetails details) async{
                    wColSel = details.rowColumnIndex.columnIndex;
                   wRowSel = details.rowColumnIndex.rowIndex;
                if (wRowSel == 0) return;
                    DataGridRow wDataGridRow = zoneDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                    Selindex = zoneDataGridSource.dataGridRows.indexOf(wDataGridRow);
                    AlimSaisie();
                    if (wColSel == 0) {

                      DbTools.gIntervention = Intervention.InterventionInit();
                      await showDialog(context: context, builder: (BuildContext context) => new Zone_Dialog());
                      Reload();
                    }



                  },

                  //*********************************

                  allowSorting: true,
                  allowFiltering: true,
                  source: zoneDataGridSource,
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
                  isScrollbarAlwaysShown: true,
                ))),
        Container(
          height: 10,
        ),
      ]),
    );
  }

  Widget DropdownButtonDepot() {
    return Row(children: [
      Container(
        width: 60,
        child: Text(
          "Agence : ",
          style: gColors.bodySaisie_B_G,
        ),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une agence',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamDepot.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueDepot,
          onChanged: (value) {
            setState(() {
              selectedValueDepot = value!;
              print("selectedValueDepot  $selectedValueDepot");
              setState(() {});
            });
          },
          buttonPadding: const EdgeInsets.only(left: 4, right: 4),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          buttonHeight: 30,
          buttonWidth: 290,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        )),
      ),
    ]);
  }
}
