import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/ParamSite_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/Zones_Dialog.dart';
import 'package:image/image.dart' as IMG;
import 'package:http/http.dart' as http;
//import 'package:path/path.dart';

class Client_Sit extends StatefulWidget {
  final VoidCallback onMaj;
  const Client_Sit({Key? key, required this.onMaj}) : super(key: key);

  @override
  State<Client_Sit> createState() => _Client_SitState();
}

class _Client_SitState extends State<Client_Sit> {
  TextEditingController textController_Site_Code = TextEditingController();
  TextEditingController textController_Site_Type = TextEditingController();
  TextEditingController textController_Site_Nom = TextEditingController();
  TextEditingController textController_Site_Adr1 = TextEditingController();
  TextEditingController textController_Site_Adr2 = TextEditingController();
  TextEditingController textController_Site_Adr3 = TextEditingController();
  TextEditingController textController_Site_Adr4 = TextEditingController();
  TextEditingController textController_Site_CP = TextEditingController();
  TextEditingController textController_Site_Ville = TextEditingController();
  TextEditingController textController_Site_Pays = TextEditingController();
  TextEditingController textController_Site_Acces = TextEditingController();
  TextEditingController textController_Site_Rem = TextEditingController();

  String selectedUserInter = "";
  String selectedUserInterID = "";

  List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;
  bool imageisload = false;

  final Search_TextController = TextEditingController();
  int SelGroupe = 0;
  int SelSite = 0;
  Groupe wGroupe = Groupe.GroupeInit();
  List<Groupe> List_Grp = [];

  String Grp = "Tous";
  int GrpID = 0;

  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  Future Reload() async {
    print("••••• initLib Client_Site getGroupesClient");
    await DbTools.getGroupesClient(DbTools.gClient.ClientId);
    print("initLib getGroupesClient ${DbTools.ListGroupe.length}");
    print("initLib DbTools.ListGroupe[0].GroupeId ${DbTools.ListGroupe[0].GroupeId}");

    await DbTools.initListFam();
    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    DbTools.gAdresseLivr = DbTools.ListAdresse[0];

    List_Grp.clear();

    Groupe wGroupe = Groupe.GroupeInit();
    wGroupe.Groupe_Nom = "Tous";
    List_Grp.add(wGroupe);
    Grp = wGroupe.Groupe_Nom;
    GrpID = wGroupe.GroupeId;

    for (int i = 0; i < DbTools.ListGroupe.length; i++) {
      var Elt = DbTools.ListGroupe[i];
      List_Grp.add(Elt);
    }

//    await DbTools.getSitesGroupe(DbTools.ListGroupe[0].GroupeId);
    await DbTools.getSitesClient(DbTools.gClient.ClientId);
    print("initLib getSitesClient ${DbTools.ListSite.length}");

    await Filtre();
  }

  void initLib() async {
    await DbTools.getAdresseType("AGENCE");
    ListParam_ParamDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    });

    DbTools.gSite = Site.SiteInit();
    DbTools.ListSitesearchresult.clear();
    await Reload();
    await AlimSaisie();
  }

  Future Filtre() async {
    List<Site> ListSitesearchresultTmp = [];
    ListSitesearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListSitesearchresultTmp.addAll(DbTools.ListSite);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListSite.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListSitesearchresultTmp.add(element);
        }
      });
    }

    DbTools.ListSitesearchresult.clear();
    DbTools.ListSitesearchresult.addAll(ListSitesearchresultTmp);
    if (DbTools.ListSitesearchresult.length > 0) DbTools.gSite = DbTools.ListSitesearchresult[0];

    SelSite = 0;
    DbTools.gSite = DbTools.ListSitesearchresult[0];
    AlimSaisie();

    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gSite.Desc()}");

    textController_Adresse_Geo.text = "${DbTools.gSite.Site_Adr1} ${DbTools.gSite.Site_CP} ${DbTools.gSite.Site_Ville}";

    textController_Site_Code.text = DbTools.gSite.Site_Code;

    textController_Site_Nom.text = DbTools.gSite.Site_Nom;
    textController_Site_Adr1.text = DbTools.gSite.Site_Adr1;
    textController_Site_Adr2.text = DbTools.gSite.Site_Adr2;
    textController_Site_Adr3.text = DbTools.gSite.Site_Adr3;
    textController_Site_Adr4.text = DbTools.gSite.Site_Adr4;
    textController_Site_CP.text = DbTools.gSite.Site_CP;
    textController_Site_Ville.text = DbTools.gSite.Site_Ville;
    textController_Site_Pays.text = DbTools.gSite.Site_Pays;
    textController_Site_Acces.text = DbTools.gSite.Site_Acces;
    textController_Site_Rem.text = DbTools.gSite.Site_Rem;

    for (int i = 0; i < DbTools.ListGroupe.length; i++) {
      var Elt = DbTools.ListGroupe[i];
      if (Elt.GroupeId == DbTools.gSite.Site_GroupeId) {
        Grp = Elt.Groupe_Nom;
        GrpID = Elt.GroupeId;
        break;
      }
    }

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${DbTools.gSite.Site_Depot}") == 0) {
        selectedValueDepot = element;
      }
    }

    print("AlimSaisie ${DbTools.gSite.SiteId} -----> $GrpID $Grp");
    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    if (DbTools.gSite.Site_ResourceId > 0) {
      DbTools.getUserid("${DbTools.gSite.Site_ResourceId!}");
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter $selectedUserInter");
      selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    imageisload = false;
    String wUserImg = "Site_${DbTools.gSite.SiteId}.jpg";
    pic = await gColors.getImage(wUserImg);
    print("pic $wUserImg"); // ${pic}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 200,
        height: 200,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar.png'),
        height: 200,
      );
    }
    imageisload = true;

    await DbTools.getZonesSite(DbTools.gSite.SiteId);

    setState(() {});
  }

  void initState() {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Client_Sit");
    wImage = Image(
      image: AssetImage('assets/images/Avatar.png'),
      height: 200,
    );
    initLib();
    super.initState();
  }

  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "Site";
    DbTools.gViewAdr = "";
    widget.onMaj();
  }

  void ToolsBarCpy() async {
    print("ToolsBarCpy");
    textController_Site_Adr1.text = DbTools.gAdresseLivr.Adresse_Adr1;
    textController_Site_Adr2.text = DbTools.gAdresseLivr.Adresse_Adr2;
    textController_Site_Adr3.text = DbTools.gAdresseLivr.Adresse_Adr3;
    textController_Site_Adr4.text = DbTools.gAdresseLivr.Adresse_Adr4;
    textController_Site_CP.text = DbTools.gAdresseLivr.Adresse_CP;
    textController_Site_Ville.text = DbTools.gAdresseLivr.Adresse_Ville;
    textController_Site_Pays.text = DbTools.gAdresseLivr.Adresse_Pays;
    textController_Site_Acces.text = DbTools.gAdresseLivr.Adresse_Acces;
    textController_Site_Rem.text = DbTools.gAdresseLivr.Adresse_Rem;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolsBarSearch(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: GroupeGridWidget(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: SiteGridWidget(),
                ),
              ),
              Column(
                children: [
                  SelGroupe == 0
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter site"),
                        ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy, tooltip: "Copier adresse Livraison"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                  DbTools.gSite.Site_Nom.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.orange, Icons.people_outline_outlined, ToolsBarCtact, tooltip: "Contacts"),
                        ),
                  (DbTools.gSite.Site_Nom != "???" || DbTools.ListZone.length > 0)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                          child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.red, Icons.delete, ToolsBarDelete, tooltip: "Suppression"),
                        ),
                ],
              ),
              ContentSiteCadre(context),
              Column(
                children: [
                  ContentSitePhoto(context),
                  ContentSiteRegle(context),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget ToolsBarSearch(BuildContext context) {
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
            Container(
              height: 1,
              color: gColors.primary,
            )
          ],
        ));
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
      desc: "Êtes-vous sûre de vouloir supprimer ce Site ?",
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
              await DbTools.delSite(DbTools.gSite);
              await Reload();
              setState(() {});
              Navigator.of(context).pop();
            },
            color: Colors.red)
      ],
    ).show();
  }

  void Tools() async {
    await ParamSite_Dialog.ParamSite_dialog(context);
    setState(() {});
  }

  void ToolsBarSave() async {
    print("ToolsBarSave");

    DbTools.gSite.Site_Code = textController_Site_Code.text;
    DbTools.gSite.Site_Nom = textController_Site_Nom.text;
    DbTools.gSite.Site_Adr1 = textController_Site_Adr1.text;
    DbTools.gSite.Site_Adr2 = textController_Site_Adr2.text;
    DbTools.gSite.Site_Adr3 = textController_Site_Adr3.text;
    DbTools.gSite.Site_Adr4 = textController_Site_Adr4.text;
    DbTools.gSite.Site_CP = textController_Site_CP.text;
    DbTools.gSite.Site_Ville = textController_Site_Ville.text;
    DbTools.gSite.Site_Pays = textController_Site_Pays.text;
    DbTools.gSite.Site_Acces = textController_Site_Acces.text;
    DbTools.gSite.Site_Rem = textController_Site_Rem.text;
//    DbTools.gSite.Site_GroupeId = GrpID;
    DbTools.gSite.Site_ResourceId = int.parse(selectedUserInterID);
    DbTools.gSite.Site_Depot = selectedValueDepot;

    print("ToolsBarSave ${DbTools.gSite.SiteId} $GrpID $Grp");

    await DbTools.setSite(DbTools.gSite);

    await DbTools.getSitesGroupe(DbTools.gSite.Site_GroupeId);
    SelGroupe = List_Grp.indexWhere((element) => element.GroupeId == DbTools.gSite.Site_GroupeId);

    print("initLib getSitesClient ${DbTools.ListSite.length}  ${DbTools.gSite.Site_GroupeId} ${SelGroupe}");
    await Filtre();

    setState(() {});
  }

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    await DbTools.addSite(
      DbTools.gGroupe.GroupeId,
    );
    await DbTools.getSitesGroupe(
      DbTools.gGroupe.GroupeId,
    );
    DbTools.getSiteID(DbTools.gLastID);
    DbTools.gSite.Site_Nom = "???";
    await DbTools.setSite(DbTools.gSite);
    await Filtre();
    AlimSaisie();
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
    textController_Site_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Site_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Site_Ville.text = Api_Gouv.gProperties.city!;
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

  Widget ContentSiteCadre(BuildContext context) {
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
              ContentSite(context),
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
              'Site',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentSitePhoto(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 280,
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
              Photo(),
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
              'Photo',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentSiteRegle(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 280,
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
              Regles(),
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
              'Règlementation',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget Regles() {
    String wMes = "";

    List<String> listMes = [
      "Règle APSAD R1 / Sprinkleurs",
      "Règle APSAD D2 / Brouillard d'eau",
      "Règle APSAD R3 / Maintenance colonnes incendies",
      "Règle APSAD R4 / Extincteurs portatifs et mobiles",
      "Règle APSAD R5 / RIA et PIA",
      "Règle APSAD R7  / Détection incendie",
      "Règle APSAD R12 / Extinction mousse à haut foisonnement",
      "Règle APSAD R13 / Extinction automatique à gaz",
      "Règle APSAD R16 / Compartimentage",
      "Règle APSAD R17 / Désenfumage naturel",
      "ERT (Etablissement recevant des travailleurs)",
      "ERP (Etablissement recevant du public)",
      "IGH (Immeuble de grander hauteur)",
      "DREAL (Direction régionale de l'environnement, de l'aménagement et du logement)",
      "Autres",
    ];
    List<bool> itemlistApp = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];

    String siteApsad = DbTools.gSite.Site_APSAD!;
    if (siteApsad.isNotEmpty) {
      itemlistApp = json.decode(siteApsad).cast<bool>().toList();

      for (int i = 0; i < itemlistApp.length; i++) {
        var element = itemlistApp[i];
        if (element) {
          wMes = "$wMes${wMes.isNotEmpty ? ", " : ""}${listMes[i]}";
        }
      }
    }

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.settings_applications, Tools, tooltip: "Réglementation"),
          ),
          Container(
            width: 280,
            height: 175,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),

              child: Text(
                wMes,
                style: gColors.bodySaisie_N_G,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),

        ]))));
  }

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    AlimSaisie();
  }

  Widget Photo() {
    String wImgPath = "${DbTools.SrvImg}Site_${DbTools.gSite.SiteId}.jpg";
//    print("wImgPath $wImgPath");
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Image.asset("assets/images/Photo.png"),
              onPressed: () async {
                await _startFilePicker(onSetState);
              },
            ),

            Container(width: 10),
            DropTarget(
              onDragDone: (detail) async {
                setState(() {
                  _list.addAll(detail.files);
                });
                if (detail.files.length > 0) {
                  var file = _list[0];
                  print('onDragDone ${file.path} - ${file.name}');
                  print('onDragDone ${await file.lastModified()} ${await file.length()}  ${file.mimeType}');

                  Uint8List bytes = await file.readAsBytes();
                  IMG.Image? img = await IMG.decodeImage(bytes);
                  IMG.Image resized = await IMG.copyResize(img!, width: 940, maintainAspect: true);
                  List<int> stream2 = await IMG.encodeJpg(resized);
                  String wPath = DbTools.SrvUrl;
                  var uri = Uri.parse(wPath.toString());
                  var request = new http.MultipartRequest("POST", uri);
                  request.fields.addAll({
                    'tic12z': DbTools.SrvToken,
                    'zasq': 'uploadphoto',
                    'imagepath': "Site_${DbTools.gSite.SiteId}.jpg",
                  });

                  var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream2, filename: "xxx.jpg");
                  request.files.add(multipartFile);
                  var response = await request.send();
                  print(response.statusCode);
                  response.stream.transform(utf8.decoder).listen((value) {
                    print("value " + value);
                    print("Fin");
                    DbTools.notif.BroadCast();
                    onSetState();
                  });
                }
              },
              onDragUpdated: (details) {
                setState(() {
                  offset = details.localPosition;
                });
              },
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                  offset = detail.localPosition;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                  offset = null;
                });
              },
              child: (imageisload)
                  ? wImage
                  : Container(
                      height: 200,
                      width: 200,
                      color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
                      child: Stack(
                        children: [
                          if (_list.isEmpty) const Center(child: Text("Drop here")) else Text(_list.map((e) => e.path).join("\n")),
                          if (offset != null)
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '$offset',
                                style: gColors.bodySaisie_N_G,
                              ),
                            )
                        ],
                      ),
                    ),
            )
          ],
        ));
  }

  _startFilePicker(VoidCallback onSetState) async {
    print("UploadFilePicker > Site_${DbTools.gSite.SiteId}.jpg");
    await Upload.UploadFilePicker("Site_${DbTools.gSite.SiteId}.jpg", onSetState);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  Widget ContentSite(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  ToolsBar_Insee(context),
                  Row(
                    children: [
                      DropdownButtonDepot(),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.DropdownButtonTypeInter(80, 8, "Resp Com", selectedUserInter, (sts) {
                        setState(() {
                          selectedUserInter = sts!;
                          selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
                        });
                      }, DbTools.List_UserInter, DbTools.List_UserInterID),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code", textController_Site_Code),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Site_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Adresse", textController_Site_Adr1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Site_Adr2, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Site_Adr3, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Site_Adr4, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 10, "CP", textController_Site_CP),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Ville", textController_Site_Ville),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Site_Rem, Ligne: 9),
                    ],
                  ),
                ]))));
  }

  Widget GroupeGridWidget() {
    List<DaviColumn<Groupe>> wColumns = [
      new DaviColumn(name: 'Groupes', grow: 1, stringValue: (row) => row.Groupe_Nom),
    ];

    DaviModel<Groupe>? _model;
    _model = DaviModel<Groupe>(rows: List_Grp, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Groupe>(
            visibleRowsCount: 17,
            _model, onRowTap: (aGroupe) async {
          DbTools.gGroupe = aGroupe;
          SelGroupe = List_Grp.indexOf(aGroupe);

          if (DbTools.gGroupe.Groupe_Nom == "Tous")
            await DbTools.getSitesClient(DbTools.gClient.ClientId);
          else
            await DbTools.getSitesGroupe(aGroupe.GroupeId);
          await Filtre();
          DbTools.gSite = Site.SiteInit();
          if (DbTools.ListSitesearchresult.length > 0) {
            DbTools.gSite = DbTools.ListSitesearchresult[0];
          }
          AlimSaisie();
          setState(() {});
        }),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(
              height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          row: RowThemeData(color: (rowIndex) {
            return SelGroupe == rowIndex ? gColors.secondarytxt : Colors.white;
          }),
          cell: CellThemeData(
            contentHeight: 26,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

  Widget SiteGridWidget() {
    List<DaviColumn<Site>> wColumns = [
      DaviColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<Site> aSite) {
            return InkWell(
                child: const Icon(Icons.edit, size: 16),
                onTap: () async {
                  DbTools.gSite = aSite.data;
                  DbTools.gViewAdr = "";
                  DbTools.gViewCtact = "";
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => new Zones_Dialog(
                            site: DbTools.gSite,
                          ));
                });
          }),
      new DaviColumn(name: 'Code', width: 50, stringValue: (row) => row.Site_Code),
      new DaviColumn(name: 'Nom', width: 340, stringValue: (row) => row.Site_Nom),
      new DaviColumn(name: 'Adresse', width: 240, stringValue: (row) => "${row.Site_Adr1}"),
      new DaviColumn(name: 'Cp', width: 80, stringValue: (row) => "${row.Site_CP}"),
      new DaviColumn(name: 'Ville', width: 180, stringValue: (row) => "${row.Site_Ville}"),
      new DaviColumn(name: 'Grp', width: 180, stringValue: (row) => "${row.Site_GroupeId}"),
    ];
    DaviModel<Site>? _model;
    _model = DaviModel<Site>(rows: DbTools.ListSitesearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Site>(
          visibleRowsCount: 17,
          _model,
          onRowTap: (aSite) async {
            SelSite = DbTools.ListSitesearchresult.indexOf(aSite);
            DbTools.gSite = aSite;
            AlimSaisie();
          },
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          row: RowThemeData(color: (rowIndex) {
            return SelSite == rowIndex ? gColors.secondarytxt : Colors.white;
          }),
          cell: CellThemeData(
            contentHeight: 26,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
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
