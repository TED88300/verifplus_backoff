import 'dart:js_interop';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tab_container/tab_container.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Fact.dart';
import 'package:verifplus_backoff/widgets/Agences/Agences.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Grp.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Interv.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Map.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Sit.dart';
import 'package:verifplus_backoff/widgets/Contacts/Ctact_Grp.dart';
import 'package:verifplus_backoff/widgets/Contacts/Ctact_Site.dart';

class Client_Fact_Controller {
  late void Function() AlimSaisie;
}

// SELECT * FROM Clients, Users Where Clients.Client_Commercial = Users.UserID;
// SELECT Clients.* FROM Clients, Groupes, Sites, Users where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = UserID;
// SELECT Clients.*, Intervention_Responsable FROM Clients, Groupes, Sites, Zones, Interventions, Users where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = Users.UserID;
// SELECT Clients.*, Intervention_Responsable2 FROM Clients, Groupes, Sites, Zones, Interventions, Users where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = Users.UserID;
// SELECT Clients.*, Planning_ResourceId FROM Clients, Groupes, Sites, Zones, Interventions, Planning, Users where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = Users.UserID;

class Client_Dialog extends StatefulWidget {
  final Client client;
  const Client_Dialog({Key? key, required this.client}) : super(key: key);

  @override
  State<Client_Dialog> createState() => _Client_DialogState();
}

class _Client_DialogState extends State<Client_Dialog> with SingleTickerProviderStateMixin {
  final Client_Fact_Controller client_Fact_Controller = Client_Fact_Controller();
//  final Client_Fact client_Fact = Client_Fact( client_Fact_Controller: client_Fact_Controller,);

  String Title = "";
  Client wClient = Client.ClientInit();
  TextEditingController textController_Civilite = TextEditingController();
  TextEditingController textController_Nom = TextEditingController();
  TextEditingController textController_Siret = TextEditingController();
  TextEditingController textController_NAF = TextEditingController();
  TextEditingController textController_TVA = TextEditingController();
  TextEditingController textController_Createur = TextEditingController();
  TextEditingController textController_Ct_Debut = TextEditingController();
  TextEditingController textController_Ct_Fin = TextEditingController();
  TextEditingController textController_Organes = TextEditingController();

  bool isClient_CL_Pr = false;
  bool isClient_PersPhys = false;
  bool isClient_OK_DataPerso = false;

  DateTime selectedDate = DateTime.now();

  bool isCt = false;
  String selectedType = "";
  List<Param_Saisie_Param> ListParam_Saisie_ParamType = [];

  String selectedValueFam = "";
  String selectedValueFamID = "";

  List<String> ListParam_ParamFam = [];
  List<String> ListParam_ParamFamID = [];

  double screenWidth = 0;
  double screenHeight = 0;

  TextEditingController controller = TextEditingController();

  List<PlutoMenuItem> HoverMenus = [];
  late Widget wPlutoMenuBar;

  List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";


  List<String> ListParam_ParamRglt = [];
  List<String> ListParam_ParamRgltID = [];
  String selectedValueRglt = "";
  String selectedValueRgltID = "";
  String selectedValueForme = "";
  String selectedUserInter = "";
  String selectedUserInterID = "";



  String wRep = "";
  Future initLib() async {

    await DbTools.initListFam();

    HoverMenus = gColors.makeMenus(context);
    print("initState ${HoverMenus.length}");
    wPlutoMenuBar = new PlutoMenuBar(
      mode: PlutoMenuBarMode.tap,
      backgroundColor: gColors.primary,
      activatedColor: Colors.white,
      indicatorColor: Colors.deepOrange,
      textStyle: gColors.bodyTitle1_N_Wr,
      menuIconColor: Colors.white,
      moreIconColor: Colors.white,
      menus: HoverMenus,
    );

    await DbTools.getParam_ParamFam("RgltClient");
    ListParam_ParamRglt.clear();
    ListParam_ParamRglt.addAll(DbTools.ListParam_ParamFam);
    ListParam_ParamRgltID.clear();
    ListParam_ParamRgltID.addAll(DbTools.ListParam_ParamFamID);

    selectedValueRglt = ListParam_ParamRglt[0];
    for (int i = 0; i < ListParam_ParamRglt.length; i++) {
      String element = ListParam_ParamRglt[i];
      if (element.compareTo("${wClient.Client_Rglt}") == 0) {
        selectedValueRglt = element;
      }
    }

    selectedValueForme = DbTools.ListParam_ParamForme[0];
    for (int i = 0; i < DbTools.ListParam_ParamForme.length; i++) {
      String wForme = DbTools.ListParam_ParamForme[i];
      print("element [$wForme]");
      if (wForme.compareTo("${wClient.Client_Civilite}") == 0) {
        selectedValueForme = wForme;
      }
    }
    print("selectedValueForme ($selectedValueForme)");

    print("initLib > ${widget.client.ClientId}");
    await DbTools.getParam_Saisie_Param("Type");
    ListParam_Saisie_ParamType.clear();
    ListParam_Saisie_ParamType.addAll(DbTools.ListParam_Saisie_Param);
    if (ListParam_Saisie_ParamType.length > 0) selectedType = ListParam_Saisie_ParamType[0].Param_Saisie_Param_Label;

    await DbTools.getParam_ParamFam("FamClient");
    ListParam_ParamFam.clear();
    ListParam_ParamFam.addAll(DbTools.ListParam_ParamFam);
    ListParam_ParamFamID.clear();
    ListParam_ParamFamID.addAll(DbTools.ListParam_ParamFamID);

    wClient = widget.client;
    DbTools.gClient = wClient;

    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    if (wClient.Client_Commercial.isNotEmpty) {
      DbTools.getUserid("${wClient.Client_Commercial}");
      if (DbTools.gUser.UserID > 0 )
        {
          selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
          print("selectedUserInter $selectedUserInter");
          selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
        }
    }

    await DbTools.getAdresseType( "AGENCE");
    ListParam_ParamDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    });

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${wClient.Client_Depot}") == 0) {
        selectedValueDepot = element;
      }
    }

    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "FACT");
    await DbTools.getContactClientAdrType(DbTools.gClient.ClientId, DbTools.gAdresse.AdresseId, "FACT");
    isClient_CL_Pr = wClient.Client_CL_Pr;
    isCt = wClient.Client_Contrat;

    isClient_PersPhys = wClient.Client_PersPhys;
    isClient_OK_DataPerso = wClient.Client_OK_DataPerso;
    textController_Civilite.text = wClient.Client_Civilite;
    textController_Nom.text = wClient.Client_Nom;
    textController_Siret.text = wClient.Client_Siret;
    textController_NAF.text = wClient.Client_NAF;
    textController_TVA.text = wClient.Client_TVA;
    textController_Createur.text = wClient.Client_Createur;
    textController_Ct_Debut.text = wClient.Client_Ct_Debut;
    textController_Ct_Fin.text = wClient.Client_Ct_Fin;

    selectedValueFam = ListParam_ParamFam[0];
    selectedValueFamID = ListParam_ParamFamID[0];
    if (wClient.Client_Famille.isNotEmpty) {
      selectedValueFamID = wClient.Client_Famille;
      selectedValueFam = ListParam_ParamFam[ListParam_ParamFamID.indexOf(selectedValueFamID)];
    }
    print("selected ${wClient.Client_Famille} FAMILLE  $selectedValueFamID $selectedValueFam");
    Title = "Vérif+ : Fiche client";
    print("initLib <<<<<<<<<<<<<<<<<<<<<<<<<<<");

    setState(() {});
  }

  void initState() {
    print("initState >");
    initLib();
    super.initState();
    print("initState <");
  }

  void onMaj() async {
    print("Parent onMaj()");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    print("screenWidth $screenWidth");
    if (Title.isEmpty) return Container();

    return Center(
      child: Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: gColors.white,
            appBar: AppBar(
              backgroundColor: gColors.primary,
              automaticallyImplyLeading: false,
              title: Container(
                  color: gColors.primary,
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      InkWell(
                        child: SizedBox(
                            height: 100.0,
                            width: 100.0, // fixed width and height
                            child: new Image.asset(
                              'assets/images/AppIcow.png',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      Text(
                        Title,
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_W,
                      ),
                      Spacer(),
                      Container(
                        width: 150,
                        child: Text(
                          "Version : ${DbTools.gVersion}",
                          style: gColors.bodySaisie_N_W,
                        ),
                      ),
                    ],
                  )),
            ),
            body: Content(context),
          )),
    );
  }

  List<Widget> widgetChildren = [];
  int sel = 0;

  Widget Content(BuildContext context) {
    widgetChildren = [
      Client_Fact(client_Fact_Controller: client_Fact_Controller,),
      (DbTools.gViewCtact.compareTo("Groupe") == 0) ? Ctact_Grp(onMaj: onMaj,) : Client_Grp(onMaj: onMaj,),
      (DbTools.gViewCtact.compareTo("Site") == 0) ? Ctact_Site(onMaj: onMaj,) : Client_Sit(onMaj: onMaj,),
      Client_Interv(onMaj: onMaj,),
      wScreen("Docs ventes"),
      wScreen("Articles/parc"),
      wScreen("Stat"),
      wScreen("Fichiers"),
      wScreen("Notes"),
      Client_Map(),
    ];


    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        ToolsBar(context),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentDetailCadre(context),
              Container(
                width: screenWidth,
                height: screenHeight - 300,
//                color: Colors.red,
                child: taBarContainer(),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  Widget taBarContainer() {
    return TabContainer(
      tabDuration : Duration(milliseconds: 600),
      color: gColors.primary,
      children: widgetChildren,
      selectedTextStyle: gColors.bodyTitle1_B_Wr,
      unselectedTextStyle: gColors.bodyTitle1_B_Gr,
      tabExtent: 40,
      tabs: [
        'Fact. / Livr.',
        'Groupes',
        'Sites',
        'Historique',
        'Docs ventes',
        'Articles/parc',
        'Stat',
        'Fichiers',
        'Notes',
        'Carte',
      ],
    );
  }



  Widget ContentDetailCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
              ContentDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 5,
          child: Container(
            width: 600,
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            color: gColors.LinearGradient1,
            child: Text(
              'Client #${wClient.ClientId} ${wClient.Client_Nom}',
              style: gColors.bodyTitle1_B_Wr,
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentDetail(BuildContext context) {
    return

//      Expanded(child:
        FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DropdownButtonForme(),
//                        gColors.TxtField(-1, 16, "Forme", textController_Civilite),
                        Container(
                          width: 30,
                        ),
                        gColors.TxtField(-1, 64, "Nom", textController_Nom),
                        gColors.CheckBoxField(80, 8, "Prospect", isClient_CL_Pr, (sts) => setState(() => isClient_CL_Pr = sts!)),
                        Container(
                          width: 30,
                        ),
                        gColors.CheckBoxField(150, 8, "Personne physique", isClient_PersPhys, (sts) => setState(() => isClient_PersPhys = sts!)),
                        Container(
                          width: 30,
                        ),
                        gColors.CheckBoxField(80, 8, "Data Client", isClient_OK_DataPerso, (sts) => setState(() => isClient_OK_DataPerso = sts!)),
                      ],
                    ),
                    Row(
                      children: [
                        gColors.DropdownButtonFam(80, 8, "Famille", selectedValueFam, (sts) {
                          setState(() {
                            selectedValueFam = sts!;
                            selectedValueFamID = ListParam_ParamFamID[ListParam_ParamFam.indexOf(selectedValueFam)];
                            print("onCHANGE selectedValueFam $selectedValueFam");
                            print("onCHANGE selectedValueFamID $selectedValueFamID");
                          });
                        }, ListParam_ParamFam, ListParam_ParamFamID),
                        gColors.TxtField(-1, 32, "Siret", textController_Siret),
                        CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.search, InseeSiret, tooltip : "Rechercher par le Siret"),
                        Container(
                          width: 10,
                        ),
                        gColors.TxtField(-1, 32, "TVA", textController_TVA),
                        gColors.TxtField(-1, 16, "NAF", textController_NAF),
                        gColors.TxtField(-1, 60, "Créateur client", textController_Createur),
                      ],
                    ),
                    Row(
                      children: [
                        gColors.DropdownButtonTypeInter(80, 8, "Commercial", selectedUserInter, (sts) {
                          setState(() {
                            selectedUserInter = sts!;
                            selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
                          });
                        }, DbTools.List_UserInter, DbTools.List_UserInterID),
                        DropdownButtonDepot(),
                        DropdownButtonRglt(),
                      ],
                    ),

                    Container(
                      height: 5,
                    ),
                    Row(
                      children: [
                        gColors.CheckBoxField(150, 8, "Engagement / Contrat", isCt, (sts) => setState(() => isCt = sts!)),
                        Container(
                          width: 40,
                        ),
                        gColors.DropdownButtonType(
                          80,
                          8,
                          "Type",
                          selectedType,
                          (sts) {
                            setState(() {
                              selectedType = sts!;
                            });
                          },
                          ListParam_Saisie_ParamType,
                        ),
                        Container(
                          width: 40,
                        ),
                        InkWell(
                          child: Row(
                            children: [
                              Text(
                                "Début :  ",
                                style: gColors.bodySaisie_N_G,
                              ),
                              Text(
                                "${textController_Ct_Debut.text.isEmpty ? '' : DateFormat('dd/MM/yyyy').format(DateTime.parse(textController_Ct_Debut.text))}",
                                style: gColors.bodyText_B_G,
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (textController_Ct_Debut.text.isEmpty)
                              selectedDate = DateTime.now();
                            else
                              selectedDate = DateTime.parse(textController_Ct_Debut.text);
                            await _selectDate(context);
                            textController_Ct_Debut.text = selectedDate.toString().substring(0, 10);
                          },
                        ),
                        Container(
                          width: 40,
                        ),
                        InkWell(
                          child: Row(
                            children: [
                              Text(
                                "Fin :  ",
                                style: gColors.bodySaisie_N_G,
                              ),
                              Text(
                                "${textController_Ct_Fin.text.isEmpty ? '' : DateFormat('dd/MM/yyyy').format(DateTime.parse(textController_Ct_Fin.text))}",
                                style: gColors.bodyText_B_G,
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (textController_Ct_Fin.text.isEmpty)
                              selectedDate = DateTime.now();
                            else
                              selectedDate = DateTime.parse(textController_Ct_Fin.text);
                            await _selectDate(context);
                            textController_Ct_Fin.text = selectedDate.toString().substring(0, 10);
                          },
                        ),
                      ],
                    ),
                  ],
                )
                //)
                ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2010), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave , tooltip : "Sauvegarder"),
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.red, Icons.delete, ToolsBarDelete, tooltip : "Supprimer"),
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

  void InseeSiret() async {
    String wSiret = textController_Siret.text;
    print("InseeSiret $wSiret");
    wSiret = wSiret.replaceAll(" ", "");
    print("InseeSiret $wSiret");
    if (wSiret.length != 14) {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Le numéro de Siret doit comporter 14 caractères",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
          )
        ],
      ).show();
    }

//    await Api_Gouv.siret('43447418500015') ;

    if (await Api_Gouv.siret(wSiret)) {
      int iSiret = int.parse(Api_Gouv.siret_SIREN);
//        int iSiret = 404833048;
      int iSiret97 = iSiret % 97;
      print("iSiret $iSiret iSiret97 $iSiret97");
      int iSiret97_2 = 12 + 3 * iSiret97;
      int iCleTva = iSiret97_2 % 97;
      String sCleTva = iCleTva.toString().padLeft(2, '0');
      print("iSiret97_2 $iSiret97_2 iCleTva $iCleTva sCleTva $sCleTva");

      String NoTVA = "FR$sCleTva$iSiret";
      Alert(
        context: context,
        style: confirmStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Êtes-vous sûre de vouloir remplacer les données ?\n${Api_Gouv.siret_Nom}\n${Api_Gouv.siret_Rue}\n${Api_Gouv.siret_Cp} ${Api_Gouv.siret_Ville}\n\nNAF : ${Api_Gouv.siret_NAF}\n\nTVA : $NoTVA\n\nCat. Jur. : ${Api_Gouv.siret_Cat}",
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
                "Remplacer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                textController_Nom.text = Api_Gouv.siret_Nom;
                textController_NAF.text = Api_Gouv.siret_NAF;
                textController_TVA.text = NoTVA;
                await ToolsBarSave();
                await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "FACT");

                DbTools.gAdresse.Adresse_Adr1 = Api_Gouv.siret_Rue;
                DbTools.gAdresse.Adresse_CP = Api_Gouv.siret_Cp;
                DbTools.gAdresse.Adresse_Ville = Api_Gouv.siret_Ville;
                DbTools.gAdresse.Adresse_Pays = "France";
                await DbTools.setAdresse(DbTools.gAdresse);

                await initLib();

                client_Fact_Controller.AlimSaisie();

                setState(() {});
                Navigator.pop(context);
              },
              color: Colors.green)
        ],
      ).show();
    } else {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: Api_Gouv.siret_Nom,
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  Future ToolsBarSave() async {
    print("ToolsBarSave");
    wClient.Client_Famille = selectedValueFamID;

    wClient.Client_Rglt = selectedValueRglt;
    wClient.Client_Depot = selectedValueDepot;

    wClient.Client_CL_Pr = isClient_CL_Pr;
    wClient.Client_PersPhys = isClient_PersPhys;
    wClient.Client_OK_DataPerso = isClient_OK_DataPerso;
    wClient.Client_Civilite = textController_Civilite.text;
    wClient.Client_Nom = textController_Nom.text;
    wClient.Client_Siret = textController_Siret.text;
    wClient.Client_NAF = textController_NAF.text;
    wClient.Client_TVA = textController_TVA.text;
    wClient.Client_Commercial = selectedUserInterID;
    wClient.Client_Createur = textController_Createur.text;

    wClient.Client_Contrat = isCt;
    wClient.Client_TypeContrat = selectedType;
    wClient.Client_Ct_Debut = textController_Ct_Debut.text;
    wClient.Client_Ct_Fin = textController_Ct_Fin.text;

    await DbTools.setClient(wClient);
  }

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
      desc: "Êtes-vous sûre de vouloir supprimer ce client ?",
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
              await DbTools.delClient(wClient);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Colors.red)
      ],
    ).show();
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

  var confirmStyle = AlertStyle(
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
      titleStyle: gColors.bodyTitle1_B_Green,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

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

  Widget wScreen(String wTxt) {
    return Container(

      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$wTxt $wRep"),
            ],
          ),
        ],
      ),
    );
  }

  Widget DropdownButtonDepot() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: 70,
        child: Text("Agence : ",
          style: gColors.bodySaisie_N_B,),
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
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
          value: selectedValueDepot,
          onChanged: (value) {
            setState(() {
              selectedValueDepot = value!;
              print("selectedValueDepot $selectedValueDepot");
              setState(() {});
            });
          },
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
        )),
      ),
    ]);
  }

  Widget DropdownButtonRglt() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: 90,
        child: Text("Règlement : ",
          style: gColors.bodySaisie_N_G,),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text(
                'Séléctionner un règlement',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: ListParam_ParamRglt.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
              value: selectedValueRglt,
              onChanged: (value) {
                setState(() {
                  selectedValueRglt = value!;
                  print("selectedValueRglt $selectedValueRglt");
                  setState(() {});
                });
              },
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }

  Widget DropdownButtonForme() {
    return Row(children: [

      Container(
        width: 70,
        child: Text("Forme : ",
          style: gColors.bodySaisie_N_G,),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text(
                'Séléctionner une Forme',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: DbTools.ListParam_ParamForme.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
              value: textController_Civilite.text,
              onChanged: (value) {
                setState(() {
                  textController_Civilite.text = value!;
                  print("selectedValueForme ${textController_Civilite.text}");
                  setState(() {});
                });
              },
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }
  
  
  
  
  
}
