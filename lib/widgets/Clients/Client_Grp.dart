import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Client_Grp extends StatefulWidget {
  final VoidCallback onMaj;

  const Client_Grp({Key? key, required this.onMaj}) : super(key: key);

  @override
  State<Client_Grp> createState() => _Client_GrpState();
}

class _Client_GrpState extends State<Client_Grp> {
  TextEditingController textController_Groupe_Code = TextEditingController();
  TextEditingController textController_Groupe_Type = TextEditingController();
  TextEditingController textController_Groupe_Nom = TextEditingController();
  TextEditingController textController_Groupe_Adr1 = TextEditingController();
  TextEditingController textController_Groupe_Adr2 = TextEditingController();
  TextEditingController textController_Groupe_Adr3 = TextEditingController();
  TextEditingController textController_Groupe_Adr4 = TextEditingController();
  TextEditingController textController_Groupe_CP = TextEditingController();
  TextEditingController textController_Groupe_Ville = TextEditingController();
  TextEditingController textController_Groupe_Pays = TextEditingController();
  TextEditingController textController_Groupe_Acces = TextEditingController();
  TextEditingController textController_Groupe_Rem = TextEditingController();

  List<String> ListParam_ParamFam = [];
  List<String> ListParam_ParamFamID = [];

  List<String> ListParam_ParamDepot = [];
  List<String> ListParam_ParamDepotID = [];
  String selectedValueDepot = "";

  int SelGroupe = 0;

  final Search_TextController = TextEditingController();
  Future Reload() async {
    await DbTools.getGroupesClient(DbTools.gClient.ClientId);
    print("initLib getGroupesClient ${DbTools.ListGroupe.length}");
    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    DbTools.gAdresseLivr = DbTools.ListAdresse[0];
    await Filtre();
  }

  void initLib() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Client_Grp");

    await DbTools.getAdresseType( "AGENCE");
    ListParam_ParamDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    });


    DbTools.gGroupe = Groupe.GroupeInit();
    await Reload();
    await AlimSaisie();
  }

  Future Filtre() async {
    List<Groupe> ListGroupesearchresultTmp = [];
    ListGroupesearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListGroupesearchresultTmp.addAll(DbTools.ListGroupe);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListGroupe.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListGroupesearchresultTmp.add(element);
        }
      });
    }
    DbTools.ListGroupesearchresult.clear();
    DbTools.ListGroupesearchresult.addAll(ListGroupesearchresultTmp);
    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gGroupe.Desc()}");

    textController_Adresse_Geo.text = "${DbTools.gGroupe.Groupe_Adr1} ${DbTools.gGroupe.Groupe_CP} ${DbTools.gGroupe.Groupe_Ville}";


    textController_Groupe_Code.text = DbTools.gGroupe.Groupe_Code;
    textController_Groupe_Nom.text = DbTools.gGroupe.Groupe_Nom;
    textController_Groupe_Adr1.text = DbTools.gGroupe.Groupe_Adr1;
    textController_Groupe_Adr2.text = DbTools.gGroupe.Groupe_Adr2;
    textController_Groupe_Adr3.text = DbTools.gGroupe.Groupe_Adr3;
    textController_Groupe_Adr4.text = DbTools.gGroupe.Groupe_Adr4;
    textController_Groupe_CP.text = DbTools.gGroupe.Groupe_CP;
    textController_Groupe_Ville.text = DbTools.gGroupe.Groupe_Ville;
    textController_Groupe_Pays.text = DbTools.gGroupe.Groupe_Pays;
    textController_Groupe_Acces.text = DbTools.gGroupe.Groupe_Acces;
    textController_Groupe_Rem.text = DbTools.gGroupe.Groupe_Rem;

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${DbTools.gGroupe.Groupe_Depot}") == 0) {
        selectedValueDepot = element;
      }
    }

    await DbTools.getSitesGroupe(DbTools.ListGroupe[0].GroupeId);


    setState(() {});


  }

  void ToolsBarCpy() async {
    print("ToolsBarCpy");

    textController_Groupe_Adr1.text =   DbTools.gAdresseLivr.Adresse_Adr1 ;
    textController_Groupe_Adr2.text =   DbTools.gAdresseLivr.Adresse_Adr2 ;
    textController_Groupe_Adr3.text =   DbTools.gAdresseLivr.Adresse_Adr3 ;
    textController_Groupe_Adr4.text =   DbTools.gAdresseLivr.Adresse_Adr4 ;
    textController_Groupe_CP.text =     DbTools.gAdresseLivr.Adresse_CP   ;
    textController_Groupe_Ville.text =  DbTools.gAdresseLivr.Adresse_Ville;
    textController_Groupe_Pays.text =   DbTools.gAdresseLivr.Adresse_Pays ;
    textController_Groupe_Acces.text =   DbTools.gAdresseLivr.Adresse_Acces ;
    textController_Groupe_Rem.text =    DbTools.gAdresseLivr.Adresse_Rem  ;
    setState(() {});
  }


  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.white,
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
                  child: GroupeGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter groupe"),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy , tooltip: "Copier adresse Livraison"),
                  ),


                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
/*
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.purple, Icons.maps_home_work_outlined, ToolsBarAdr),
                  ),

*/

                  DbTools.gGroupe.Groupe_Nom.isEmpty ? Container() :
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.orange, Icons.people_outline_outlined, ToolsBarCtact, tooltip: "Contacts"),
                  ),

                  (DbTools.gGroupe.Groupe_Nom != "???" || DbTools.ListSite.length > 0)
                      ? Container()
                      : Container(
                    padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.red, Icons.delete, ToolsBarDelete, tooltip: "Suppression"),
                  ),

                ],
              ),
              ContentGroupeCadre(context),
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

  void ToolsBarAdr() async {
    print("ToolsBarAdr");
    DbTools.gViewAdr = "Groupe";
    DbTools.gViewCtact = "";
    widget.onMaj();
  }


  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "Groupe";
    DbTools.gViewAdr = "";
    widget.onMaj();
  }



  void ToolsBarSave() async {
    print("ToolsBarSave");


    DbTools.gGroupe.Groupe_Code = textController_Groupe_Code.text;
    DbTools.gGroupe.Groupe_Nom = textController_Groupe_Nom.text;
    DbTools.gGroupe.Groupe_Adr1 = textController_Groupe_Adr1.text;
    DbTools.gGroupe.Groupe_Adr2 = textController_Groupe_Adr2.text;
    DbTools.gGroupe.Groupe_Adr3 = textController_Groupe_Adr3.text;
    DbTools.gGroupe.Groupe_Adr4 = textController_Groupe_Adr4.text;
    DbTools.gGroupe.Groupe_CP = textController_Groupe_CP.text;
    DbTools.gGroupe.Groupe_Ville = textController_Groupe_Ville.text;
    DbTools.gGroupe.Groupe_Pays = textController_Groupe_Pays.text;
    DbTools.gGroupe.Groupe_Acces = textController_Groupe_Acces.text;
    DbTools.gGroupe.Groupe_Rem = textController_Groupe_Rem.text;
    DbTools.gGroupe.Groupe_Depot = selectedValueDepot;

    await DbTools.setGroupe(DbTools.gGroupe);

    await Reload();

    setState(() {});
  }

  void ToolsBarAdd() async {
    await DbTools.addGroupe(DbTools.gClient.ClientId, "SITE");
    await Reload();
    DbTools.getGroupeID(DbTools.gLastID);
    DbTools.gGroupe.Groupe_Nom = "???";
    await DbTools.setGroupe(DbTools.gGroupe);
    await Filtre();
    AlimSaisie();
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
      desc: "Êtes-vous sûre de vouloir supprimer ce Groupe ?",
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
              await DbTools.delGroupe(DbTools.gGroupe);
              await Reload();
              setState(() {});
              Navigator.of(context).pop();
            },
            color: Colors.red)
      ],
    ).show();
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

  void ToolsBarCopySearch() async {
    print("ToolsBarCopySearch_Livr ${Api_Gouv.gProperties.toJson()}");
    textController_Groupe_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Groupe_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Groupe_Ville.text = Api_Gouv.gProperties.city!;
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

  Widget ContentGroupeCadre(BuildContext context) {
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
              ContentGroupe(context),
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
              'Groupe',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentGroupe(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  ToolsBar_Insee(context),
                  Row(
                    children: [
                      DropdownButtonDepot(),                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code", textController_Groupe_Code),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Groupe_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Adresse", textController_Groupe_Adr1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Groupe_Adr2, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Groupe_Adr3, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Groupe_Adr4, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 10, "CP", textController_Groupe_CP),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Ville", textController_Groupe_Ville),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Pays", textController_Groupe_Pays),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code Accès", textController_Groupe_Acces),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Groupe_Rem, Ligne: 8),
                    ],
                  ),
                ]))));
  }

  Widget GroupeGridWidget() {
    List<DaviColumn<Groupe>> wColumns = [
      new DaviColumn(name: 'Code', width: 100, stringValue: (row) => row.Groupe_Code),
      new DaviColumn(name: 'Nom', width: 450, stringValue: (row) => row.Groupe_Nom),
      new DaviColumn(name: 'Adresse', width: 450, stringValue: (row) => "${row.Groupe_Adr1}"),
      new DaviColumn(name: 'Cp', width: 100, stringValue: (row) => "${row.Groupe_CP}"),
      new DaviColumn(name: 'Ville', width: 310, stringValue: (row) => "${row.Groupe_Ville}"),
    ];
    DaviModel<Groupe>? _model;
    _model = DaviModel<Groupe>(rows: DbTools.ListGroupesearchresult, columns: wColumns);
    return

        new DaviTheme(
            child: new Davi<Groupe>(
                visibleRowsCount: 16,
                _model,
                onRowTap: (aGroupe) async {
                  SelGroupe = DbTools.ListGroupesearchresult.indexOf(aGroupe);
                  DbTools.gGroupe = aGroupe;
                  AlimSaisie();
                }),
            data: DaviThemeData(
              header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
              headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),

              row: RowThemeData(color: (rowIndex) {
                return SelGroupe == rowIndex ? gColors.secondarytxt : Colors.white;
              }),

              cell: CellThemeData(
                contentHeight: 28,
                textStyle: gColors.bodySaisie_N_G,
              ),
            ),
      );



  }

  Widget DropdownButtonDepot() {
    return Row(children: [
      Container(
        width: 83,
        child: Text(
          "Agence",
          style: gColors.bodySaisie_N_G,
        ),
      ),
      Container(
        width: 12,
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Text(
          ":",
          style: gColors.bodySaisie_N_G,
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
              buttonWidth: 250,
              dropdownMaxHeight: 250,
              itemHeight: 32,
            )),
      ),


    ]);
  }


}
