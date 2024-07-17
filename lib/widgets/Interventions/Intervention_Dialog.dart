import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tab_container/tab_container.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_BL.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_CR.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_Signature.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning.dart';
import 'package:verifplus_backoff/widgets/Sites/ParamSite_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/Zone_Dialog.dart';

class Intervention_Dialog extends StatefulWidget {
  final Site site;
  const Intervention_Dialog({Key? key, required this.site}) : super(key: key);

  @override
  State<Intervention_Dialog> createState() => _Intervention_DialogState();
}

class _Intervention_DialogState extends State<Intervention_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";

  String selectedUserInter = "";
  String selectedUserInterID = "";

  String selectedUserInter2 = "";
  String selectedUserInterID2 = "";

  String selectedUserInter3 = "";
  String selectedUserInterID3 = "";

  String selectedUserInter4 = "";
  String selectedUserInterID4 = "";

  String selectedUserInter5 = "";
  String selectedUserInterID5 = "";

  String selectedUserInter6 = "";
  String selectedUserInterID6 = "";


  double screenWidth = 0;
  double screenHeight = 0;

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;
  bool imageisload = false;

  String wRegl = "";

  bool isDC = false;

  String wIntervenants = "";

  DateTime firstDate = DateTime(2100);
  DateTime lastDate = DateTime(1900);
  int wHours = 0;

  DateTime firstDateEff = DateTime(2100);
  DateTime lastDateEff = DateTime(1900);
  int wHoursEff = 0;

  String wPartage = "";
  String wContrib = "";

  Color wColor = Colors.transparent;

  bool isLoad = true;

  final MultiSelectController _controllerPartage = MultiSelectController();
  final MultiSelectController _controllerContrib = MultiSelectController();

  Future initLib() async {

    print(" initLib DbTools.gSite ${DbTools.gSite.SiteId}");


    await DbTools.getAll4Intervention();

    imageisload = false;
    String wUserImg = "Site_${DbTools.gSite.SiteId}.jpg";
    pic = await gColors.getImage(wUserImg);
    print("pic $wUserImg"); // ${pic}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 100,
        height: 100,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/ico_Photo.png'),
        height: 100,
      );
    }
    imageisload = true;

//    await DbTools.getGroupeID(widget.site.Site_GroupeId);

    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    selectedUserInter2 = DbTools.List_UserInter[0];
    selectedUserInterID2 = DbTools.List_UserInterID[0];

    selectedUserInter3 = DbTools.List_UserInter[0];
    selectedUserInterID3 = DbTools.List_UserInterID[0];

    selectedUserInter4 = DbTools.List_UserInter[0];
    selectedUserInterID4 = DbTools.List_UserInterID[0];

    if (DbTools.gIntervention.Intervention_Responsable!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable!);
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable2!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable2!);
      selectedUserInter2 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID2 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable3!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable3!);
      selectedUserInter3 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID3 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable4!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable4!);
      selectedUserInter4 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID4 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }


    if (DbTools.gIntervention.Intervention_Responsable5!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable5!);
      selectedUserInter5 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID5 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }
    if (DbTools.gIntervention.Intervention_Responsable6!.isNotEmpty) {
      DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable6!);
      selectedUserInter6 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID6 = DbTools.gUser.User_Matricule; //DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }


    await DbTools.getContactType(DbTools.gClient.ClientId, DbTools.gSite.SiteId, "SITE");


     wRegl = "";
    String wAPSAD = "";

    List<String> listRegl = [
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


    ];

    print(" initLib2 DbTools.gSite ${DbTools.gSite.Site_Regle}");


    print(" Regles A");

    String siteRegl = widget.site.Site_Regle!;
    if (siteRegl.isNotEmpty) {
      itemlistApp = json.decode(siteRegl).cast<bool>().toList();

      for (int i = 0; i < itemlistApp.length; i++) {
        var element = itemlistApp[i];
        if (element) {
          wRegl = "$wRegl${wRegl.isNotEmpty ? ", " : ""}${listRegl[i]}";
        }
      }
    }
    print(" Regles A siteRegl ${siteRegl} wRegl ${wRegl}");

    print(" Regles B");


    List<String> listAPSAD = [
      "APSAD N1 / Sprinkleurs",
      "APSAD N2 / Brouillard d'eau",
      "APSAD N3 / Maintenance colonnes incendies",
      "APSAD N4 / Extincteurs portatifs et mobiles",
      "APSAD N5 / RIA et PIA",
      "APSAD N7  / Détection incendie",
      "APSAD N12 / Extinction mousse à haut foisonnement",
      "APSAD N13 / Extinction automatique à gaz",
      "APSAD N16 / Compartimentage",
      "APSAD N17 / Désenfumage naturel",

    ];

    List<bool> itemlistAPSAD = [
    ];



    String siteAPSAD = widget.site.Site_APSAD!;
    if (siteAPSAD.isNotEmpty) {
      itemlistAPSAD = json.decode(siteAPSAD).cast<bool>().toList();
      for (int i = 0; i < itemlistAPSAD.length; i++) {
        var element = itemlistAPSAD[i];
        if (element) {
          wAPSAD = "$wAPSAD${wAPSAD.isNotEmpty ? ", " : ""}${listAPSAD[i]}";
        }
      }
    }



    isDC = wAPSAD.length > 0;

    Title = "Intervention :  INT${DbTools.gIntervention.InterventionId.toString().padLeft(6, "0")} du ${DbTools.gIntervention.Intervention_Date}";

    wColor = gColors.getColorStatus(DbTools.gIntervention.Intervention_Status!);

    firstDate = DateTime(2100);
    lastDate = DateTime(1900);
    wHours = 0;

    wIntervenants = "";
    for (int i = 0; i < DbTools.ListUserH.length; i++) {
      var element = DbTools.ListUserH[i];
      wIntervenants = "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    for (int i = 0; i < DbTools.ListPlanning.length; i++) {
      var wplanningSrv = DbTools.ListPlanning[i];
      wHours += wplanningSrv.Planning_InterventionendTime.difference(wplanningSrv.Planning_InterventionstartTime).inHours;
      if (firstDate.isAfter(wplanningSrv.Planning_InterventionstartTime)) firstDate = wplanningSrv.Planning_InterventionstartTime;
      if (lastDate.isBefore(wplanningSrv.Planning_InterventionendTime)) lastDate = wplanningSrv.Planning_InterventionendTime;
    }

    firstDateEff = DateTime(2100);
    lastDateEff = DateTime(1900);
    wHoursEff = 0;

    for (int i = 0; i < DbTools.ListParc_Ent.length; i++) {
      var wParc_Ent = DbTools.ListParc_Ent[i];
      wHoursEff += wParc_Ent.Parcs_Intervention_Timer!;
      String wDate = wParc_Ent.Parcs_Date_Rev!;
      if (wDate.isNotEmpty) {
        DateTime dateTimeWithTimeZone = DateTime.parse(wDate);
        if (firstDateEff.isAfter(dateTimeWithTimeZone)) firstDateEff = dateTimeWithTimeZone;

        if (lastDateEff.isBefore(dateTimeWithTimeZone)) lastDateEff = dateTimeWithTimeZone;
      }
    }

    wHoursEff = (wHoursEff / 3600).round();

    _controllerPartage.clearAllSelection();
    if (DbTools.gIntervention.Intervention_Partages!.isNotEmpty) {
      List<ValueItem> wValueItem = DbTools.ValueItem_parseStringToArray(DbTools.gIntervention.Intervention_Partages!);
      try {
        _controllerPartage.setSelectedOptions(wValueItem);
      } catch (e) {
        print(" ERROR ${e} ");
      }
    }


    _controllerContrib.clearAllSelection();
    if (DbTools.gIntervention.Intervention_Contributeurs!.isNotEmpty) {
      List<ValueItem> wValueItem = DbTools.ValueItem_parseStringToArray(DbTools.gIntervention.Intervention_Contributeurs!);


      try {
        _controllerContrib.setSelectedOptions(wValueItem);
      } catch (e) {
        print(" ERROR ${e} ");
      }
    }


    isLoad = true;


    print(" DbTools.gSite.Site_Regle! ${widget.site.Site_Regle!}");

    setState(() {});
  }

  void initState() {
    wImage = Image(
      image: AssetImage('assets/images/Blank.png'),
      height: 100,
    );
    initLib();
    super.initState();
    Title = "Intervention";
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
                      Container(
                        width: 25,
                      ),
                      Text(
                        Title,
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_Wr,
                      ),
                      Container(
                        width: 10,
                      ),
                      gColors.gCircle(wColor),
                      Spacer(),
                      gColors.BtnAffUser(context),
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
      Intervention_CR(),
      Intervention_BL(),
      wScreen("BC"),
      wScreen("Devis"),
      Intervention_Signature(),
    ];
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentAdresseCadre(context),
              Container(
                width: screenWidth,
                height: screenHeight - 468, // HAUTEUR TAB
//                color: Colors.red,
                child: isLoad ? taBarContainer() : Container(),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  Widget taBarContainer() {
    return TabContainer(
      tabDuration: Duration(milliseconds: 600),
      color: gColors.primary,
      children: widgetChildren,
      selectedTextStyle: gColors.bodyTitle1_B_Wr,
      unselectedTextStyle: gColors.bodyTitle1_B_Gr,
      tabExtent: 40,
      tabs: [
        Text('Compte Rendu'),
        Text('Bon de Livraison'),
        Text('Bon de Commande'),
        Text('Devis'),
        Text('Signature'),
      ],
    );
  }

  Widget ContentAdresseCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentAdresse(context),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 1,
                height: 390,
                color: Colors.black,
              ),
              Column(
                children: [
                  ContentDetailCadre(context),
                  ContentIntervenantCadre(context),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 1,
                height: 390,
                color: Colors.black,
              ),
              Column(
                children: [
                  ContentPartageCadre(context),
                  ContentContributeurCadre(context),
                  ContentTechniciensCadre(context),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 1,
                height: 390,
                color: Colors.black,
              ),
              Column(
                children: [
                  ContentFacturationCadre(context),
                  ContentErpCadre(context),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 5,
          child: Container(
              child: Row(
            children: [
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Client #${DbTools.gClient.ClientId} ${DbTools.gClient.Client_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget ContentAdresse(BuildContext context) {
    String wImgPath = "${DbTools.SrvImg}Site_${DbTools.gSite.SiteId}.jpg";
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 500,
                  height: 344,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                  ),
                                  gColors.Txt(50, 'Groupe', '${DbTools.gGroupe.GroupeId} ${DbTools.gGroupe.Groupe_Nom}'),
                                ],
                              ),
                              Container(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                  ),
                                  gColors.Txt(
                                    50,
                                    'Zone',
                                    '${DbTools.gZone.ZoneId} ${DbTools.gZone.Zone_Nom}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          wImage,
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "ico_Marker", ToolsEmpty, tooltip: ""),
                          Container(
                            width: 10,
                          ),
                          gColors.Txt(50, "Site", "${widget.site.Site_Code} ${widget.site.Site_Nom}\n${widget.site.Site_Adr1} ${widget.site.Site_CP} ${widget.site.Site_Ville}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonAppBar.SquareRoundIcon(context, 20, 8, Colors.white, Colors.blue, Icons.mail, ToolsEmpty, tooltip: "", bordercolor: Colors.transparent),
                          Container(
                            width: 10,
                          ),
                          gColors.TxtColumn(100, "Contact du site", "${DbTools.gContact.Contact_Prenom} ${DbTools.gContact.Contact_Nom} - ${DbTools.gContact.Contact_Tel1.isEmpty ? DbTools.gContact.Contact_Tel2 : DbTools.gContact.Contact_Tel1} - ${DbTools.gContact.Contact_eMail}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                          ),
                          gColors.Txt(160, "Dernière visite réccurente", "${DbTools.gIntervention.Intervention_Status}"),
                          Container(
                            width: 30,
                          ),
                          (DbTools.gIntervention.Intervention_Status == "Clôturée" && DbTools.gIntervention.Intervention_Type == "Installation")
                              ? TextButton(
                                  child: Text(
                                    "Programmer",
                                    style: gColors.bodySaisie_N_B,
                                  ),
                                  style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)), foregroundColor: MaterialStateProperty.all<Color>(Colors.black), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.black)))),
                                  onPressed: () async {
                                    await DbTools.copyInterventionAll(DbTools.gIntervention.InterventionId!);

                                    Alert(
                                      context: context,
                                      style: gColors.alertStyle,
                                      alertAnimation: gColors.fadeAlertAnimation,
                                      image: Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset('assets/images/AppIco.png'),
                                      ),
                                      title: "Vérif+ Alerte",
                                      desc: "Une nouvelle intervention à bien été programmée",
                                      buttons: [
                                        DialogButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              Navigator.pop(context);
                                            },
                                            color: gColors.primaryGreen)
                                      ],
                                    ).show();
                                  },
                                )
                              : Container(),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "ico_Regl", Tools, tooltip: ""),
                          Container(
                            width: 10,
                          ),
                          gColors.Txt(190, "Règlementations applicables", "${wRegl}", tWidth: 268),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                          ),
                          gColors.CheckBoxFieldReadOnly(310, 8, "Site bénéficiant d'une déclaration de conformité", isDC),
                        ],
                      ),
                      Container(height: 1),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: RawMaterialButton(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          fillColor: gColors.GrdBtn_Colors4sel,
                          onPressed: () async {
                            await showDialog(context: context, builder: (BuildContext context) => new Zone_Dialog(isPar: false,));
                            setState(() {});
                          },
                          child: const Text(
                            '     INTERVENTION     ',
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(height: 10),
                    ],
                  ),
                ),
              ],
            )));
  }

  void ToolsEmpty() async {}

  void Tools() async {
    await ParamSite_Dialog.ParamSite_dialog(context, readonly: true);
    setState(() {});
  }

  void ToolsPlanning() async {
    print("ToolsPlanning");
    await showDialog(context: context, builder: (BuildContext context) => new Planning(bAppBar: true));
    setState(() {});
  }

  Widget wScreen(String wTxt) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Container(
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
                Text("$wTxt"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // DETAILS
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentDetailCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 480,
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
              ContentDetail(context),
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
              'Détails',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Container(
              width: 458,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10),
                  Row(
                    children: [
                      gColors.Txt(40, "Type", "${DbTools.gIntervention.Intervention_Type} ${DbTools.gIntervention.Intervention_Parcs_Type}"),
                      Container(width: 10),
                      gColors.Txt(45, "Statut", "${DbTools.gIntervention.Intervention_Status}"),
                      Container(width: 10),
                      gColors.gCircle(wColor),
                    ],
                  ),
                  Container(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Plannifier du ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${DateFormat('dd/MM/yyyy').format(firstDate)}",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          " au ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${DateFormat('dd/MM/yyyy').format(lastDate)}",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          " pour ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${wHours} heures",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Effectuée du ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${DateFormat('dd/MM/yyyy').format(firstDateEff)}",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          " au ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${DateFormat('dd/MM/yyyy').format(lastDateEff)}",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          " en ",
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${wHoursEff} heures",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Row(
                    children: [
                      gColors.Txt(80, "Remarques", "${DbTools.gIntervention.Intervention_Remarque}"),
                    ],
                  ),
                ],
              )),
        ));
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // INTERVENANT
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentIntervenantCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 480,
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
              IntervenantDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Intervenant',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
      ],
    );
  }

  Widget IntervenantDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  Container(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              gColors.Txt(60, "Agence", "${DbTools.gClient.Client_Depot}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Commercial", "${selectedUserInter}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Manager com", "${selectedUserInter2}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Manager Tech", "${selectedUserInter3}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Pilot Projet", "${selectedUserInter4}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Cond. travaux", "${selectedUserInter5}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(160, "Chef d'équipe", "${selectedUserInter6}"),
                            ],
                          ),


                        ],
                      )),
                ]))));
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // TECHNICIENS
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentTechniciensCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 380,
          height: 140,

          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
            width: 350,
            child:Text(
            wIntervenants,

            style: gColors.bodySaisie_B_G,
          ),),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Techniciens',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),


      ],
    );
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // PARTAGE
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentPartageCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 380,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
              PartageDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Partage intervention',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 20,
          width: 500,
          height: 550,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget PartageDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  Container(
                    width: 500,
                    child: MultiSelectDropDown(
                      controller: _controllerPartage,
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        print("selectedOptions ${selectedOptions.toString()}");
                      },
                      options: DbTools.List_ValueItem_User,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      optionTextStyle: gColors.bodySaisie_B_B,
                      //selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                  ),
                ]))));
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // CONTRIBUTEUR
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentContributeurCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 380,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
              ContributeurDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Contributeur intervention',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 20,
          width: 500,
          height: 550,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget ContributeurDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  Container(
                    width: 500,
                    child: MultiSelectDropDown(
                      controller: _controllerContrib,
                      onOptionSelected: (List<ValueItem> selectedOptions) {},
                      options: DbTools.List_ValueItem_User,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                  ),
                ]))));
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // FACTURATION
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentFacturationCadre(BuildContext context) {
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
              FacturationDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Infos Facturation',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
      ],
    );
  }

  Widget FacturationDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  Container(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              gColors.Txt(120, "Statut Facturation", "???"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(120, "Type Facturation", "???"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(120, "Contrat", "${DbTools.gClient.Client_TypeContrat}"),
                            ],
                          ),
                          Container(height: 10),
                        ],
                      )),
                ]))));
  }

  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************
  // ERP
  // *******************************************************************************
  // *******************************************************************************
  // *******************************************************************************

  Widget ContentErpCadre(BuildContext context) {
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
              ErpDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Références ERP',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
      ],
    );
  }

  Widget ErpDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(children: [
                  Container(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              gColors.Txt(110, "Commande", "???"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(110, "Bon de livraison", "???"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(110, "Facture", "???"),
                            ],
                          ),
                          Container(height: 10),
                        ],
                      )),
                ]))));
  }
}
