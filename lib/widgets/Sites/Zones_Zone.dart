import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
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
  int SelZone = 0;
  List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";
  final Search_TextController = TextEditingController();
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
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter zone"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy, tooltip: "Copier adresse Livraison"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                  DbTools.gZone.Zone_Nom.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.orange, Icons.people_outline_outlined, ToolsBarCtact, tooltip: "Contacts"),
                        ),
                  (DbTools.gZone.Zone_Nom != "???" || DbTools.ListIntervention.length > 0)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                          child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.red, Icons.delete, ToolsBarDelete, tooltip: "Suppression"),
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
                  size: 20.0,
                ),

                Container(
                  width: 10,
                ),
                Expanded(child:
                TextFormField(
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
                  icon: Icon(Icons.cancel,
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

  Widget ZoneGridWidget() {
    List<DaviColumn<Zone>> wColumns = [
      DaviColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<Zone> aZone) {
            return InkWell(
                child: const Icon(Icons.edit, size: 16),
                onTap: () async {
                  DbTools.gZone = aZone.data;
                  await showDialog(context: context, builder: (BuildContext context) => new Zone_Dialog());
                });
          }),
      new DaviColumn(name: 'Code', width: 100, stringValue: (row) => row.Zone_Code),
      new DaviColumn(name: 'Nom', width: 420, stringValue: (row) => row.Zone_Nom),
      new DaviColumn(name: 'Adresse', width: 420, stringValue: (row) => "${row.Zone_Adr1}"),
      new DaviColumn(name: 'Cp', width: 100, stringValue: (row) => "${row.Zone_CP}"),
      new DaviColumn(name: 'Ville', width: 300, stringValue: (row) => "${row.Zone_Ville}"),
    ];
    print("ZoneGridWidget ${DbTools.ListZonesearchresult.length}");
    DaviModel<Zone>? _model;
    _model = DaviModel<Zone>(rows: DbTools.ListZonesearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Zone>(visibleRowsCount: 25, _model, onRowTap: (aZone) async {
          SelZone = DbTools.ListZonesearchresult.indexOf(aZone);

          DbTools.gZone = aZone;
          AlimSaisie();
        }),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          row: RowThemeData(color: (rowIndex) {
            return SelZone == rowIndex ? gColors.secondarytxt : Colors.white;
          }),
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
