import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Zones.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/Zone_Dialog.dart';

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


  List<String> ListParam_ParamDepot = [];
  List<String> ListParam_ParamDepotID = [];
  String selectedValueDepot = "";
  String selectedValueDepotID = "";


  final Search_TextController = TextEditingController();
  Future Reload() async {
    await DbTools.getZonesSite(DbTools.gSite.SiteId);
    print("initLib getZonesClient ${DbTools.ListZone.length}");
    await Filtre();
  }

  void initLib() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Zones_Zone");

    await DbTools.getParam_ParamFam("Type_Depot");
    ListParam_ParamDepot.clear();
    ListParam_ParamDepot.addAll(DbTools.ListParam_ParamFam);
    ListParam_ParamDepotID.clear();
    ListParam_ParamDepotID.addAll(DbTools.ListParam_ParamFamID);
    selectedValueDepot = ListParam_ParamDepot[0];
    selectedValueDepotID = ListParam_ParamDepotID[0];

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



    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gZone.Desc()}");


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
    selectedValueDepotID = ListParam_ParamDepotID[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${DbTools.gZone.Zone_Depot}") == 0) {
        selectedValueDepot = element;
        selectedValueDepotID = ListParam_ParamDepotID[i];
      }
    }

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "Zone";
    DbTools.gViewAdr = "";
    widget.onMaj();
  }

  void ToolsBarCpy() async {
    print("ToolsBarCpy");
    textController_Zone_Adr1.text =   DbTools.gAdresseLivr.Adresse_Adr1 ;
    textController_Zone_Adr2.text =   DbTools.gAdresseLivr.Adresse_Adr2 ;
    textController_Zone_Adr3.text =   DbTools.gAdresseLivr.Adresse_Adr3 ;
    textController_Zone_Adr4.text =   DbTools.gAdresseLivr.Adresse_Adr4 ;
    textController_Zone_CP.text =     DbTools.gAdresseLivr.Adresse_CP   ;
    textController_Zone_Ville.text =  DbTools.gAdresseLivr.Adresse_Ville;
    textController_Zone_Pays.text =   DbTools.gAdresseLivr.Adresse_Pays ;
    textController_Zone_Acces.text =   DbTools.gAdresseLivr.Adresse_Acces ;
    textController_Zone_Rem.text =    DbTools.gAdresseLivr.Adresse_Rem  ;
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
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter zone"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy, tooltip: "Copier adresse Livraison"),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),

                  DbTools.gZone.Zone_Nom.isEmpty ? Container() :
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.orange, Icons.people_outline_outlined, ToolsBarCtact, tooltip: "Contacts"),
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
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextFormField(
                    controller: Search_TextController,
                    onChanged: (String? value) async {
                      print("_buildFieldTextSearch search ${Search_TextController.text}");
                      await Filtre();
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () async {
                            Search_TextController.clear();
                            await Filtre();
                          },
                        )),
                    style: gColors.bodySaisie_B_B,
                  ),
                )),
                Container(
                  width: 10,
                ),

                Container(
                  width: 10,
                ),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
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

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    await DbTools.addZone(DbTools.gSite.SiteId);

    print("DbTools.gLastID ${DbTools.gLastID}");

    await Reload();
    DbTools.getZoneID(DbTools.gLastID);
    AlimSaisie();
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
                  Row(
                    children: [
                      DropdownButtonDepot(),                    ],
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

  Widget ZoneGridWidget() {
    List<EasyTableColumn<Zone>> wColumns = [

      EasyTableColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellBuilder: (BuildContext context, RowData<Zone> aZone) {
            return InkWell(
                child: const Icon(Icons.edit, size: 16),
                onTap: () async {
                  DbTools.gZone = aZone.row;
                  await showDialog(context: context, builder: (BuildContext context) => new Zone_Dialog( ));
                });
          }),

      new EasyTableColumn(name: 'Code', width: 100, stringValue: (row) => row.Zone_Code),
      new EasyTableColumn(name: 'Nom', width: 420, stringValue: (row) => row.Zone_Nom),
      new EasyTableColumn(name: 'Adresse', width: 420, stringValue: (row) => "${row.Zone_Adr1}"),
      new EasyTableColumn(name: 'Cp', width: 100, stringValue: (row) => "${row.Zone_CP}"),
      new EasyTableColumn(name: 'Ville', width: 300, stringValue: (row) => "${row.Zone_Ville}"),
    ];
    print("ZoneGridWidget ${DbTools.ListZonesearchresult.length}");
    EasyTableModel<Zone>? _model;
    _model = EasyTableModel<Zone>(rows: DbTools.ListZonesearchresult, columns: wColumns);
    return new EasyTableTheme(
        child: new EasyTable<Zone>(
            visibleRowsCount: 25,
            _model, onRowTap: (Zone) async {
          DbTools.gZone = Zone;
          AlimSaisie();
        }),
        data: EasyTableThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColor: Colors.black, expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }


  Widget DropdownButtonDepot() {
    return Row(children: [
      Container(
        width: 60,
        child: Text("Agence : ", style: gColors.bodySaisie_B_G,),
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
                  selectedValueDepotID = ListParam_ParamDepotID[ListParam_ParamDepot.indexOf(value!)];
                  selectedValueDepot = value;
                  print("selectedValueDepot $selectedValueDepotID $selectedValueDepot");
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
