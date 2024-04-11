import 'dart:convert';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/ParamSite_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/Zones_Dialog.dart';

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
  List<String> List_Grp = [];
  List<int> List_GrpID = [];
  String Grp = "Tous";
  int GrpID = 0;

  Future Reload() async {




    await DbTools.getGroupesClient(DbTools.gClient.ClientId);
    print("initLib getGroupesClient ${DbTools.ListGroupe.length}");
    print("initLib DbTools.ListGroupe[0].GroupeId ${DbTools.ListGroupe[0].GroupeId}");

    await DbTools.initListFam();
    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];



    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    DbTools.gAdresseLivr = DbTools.ListAdresse[0];

    List_Grp.clear();
    List_GrpID.clear();

    for (int i = 0; i < DbTools.ListGroupe.length; i++) {
      var Elt = DbTools.ListGroupe[i];
      List_Grp.add(Elt.Groupe_Nom);
      List_GrpID.add(Elt.GroupeId);
      if (i == 0) {
        Grp = Elt.Groupe_Nom;
        GrpID = Elt.GroupeId;
      }
    }

    await DbTools.getSitesGroupe(DbTools.ListGroupe[0].GroupeId);
    print("initLib getSitesClient ${DbTools.ListSite.length}");

    await Filtre();
  }

  void initLib() async {




    await DbTools.getAdresseType( "AGENCE");
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
    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gSite.Desc()}");

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


    print("AlimSaisie ${DbTools.gSite.SiteId} $GrpID $Grp");


    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    if (DbTools.gSite.Site_ResourceId!>0) {
      DbTools.getUserid("${DbTools.gSite.Site_ResourceId!}");
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter $selectedUserInter");
      selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    imageisload = false;
    String wUserImg = "Site_${DbTools.gSite.SiteId}.jpg";
    pic =      await gColors.getImage(wUserImg);
    print("pic $wUserImg");// ${pic}");
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
      margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                  Container(
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
                ],
              ),
              ContentSiteCadre(context),
              ContentSitePhoto(context),
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
    DbTools.gSite.Site_GroupeId = GrpID;
    DbTools.gSite.Site_ResourceId = int.parse(selectedUserInterID);
    DbTools.gSite.Site_Depot = selectedValueDepot;

    print("ToolsBarSave ${DbTools.gSite.SiteId} $GrpID $Grp");

    await DbTools.setSite(DbTools.gSite);

    await DbTools.getSitesGroupe(GrpID);
    SelGroupe = DbTools.ListGroupe.indexWhere((element) => element.GroupeId == GrpID);

    print("initLib getSitesClient ${DbTools.ListSite.length}");
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
              'Site',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    AlimSaisie();
  }


  Widget Photo() {
    String wImgPath = "${DbTools.SrvImg}Site_${DbTools.gSite.SiteId}.jpg";
    print("wImgPath $wImgPath");
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
            (imageisload) ? wImage : Container(),
            Container(width: 10),

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
    String wMes = "";

    List<String> listMes = [
      "Règle APSAD R4, R5, R17",
      "ERT",
      "ERP",
      "Habitation",
      "IGH",
      "ICPE",
      "DREAL",
      "Autres",
    ];
    List<bool> itemlistApp = [false, false, false, false, false, false, false, false];

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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  Row(
                    children: [
                      DropdownButtonDepot(),                    ],
                  ),





                  Row(
                    children: [
                      gColors.DropdownButtonTypeInter(90, 8, "Resp. Comm", selectedUserInter, (sts) {
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
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code Accès", textController_Site_Acces),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                        child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.settings_applications, Tools, tooltip: "Réglementation"),
                      ),
                      Container(
                        width: 290,
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          wMes,
                          maxLines: 3,
                          style: gColors.bodySaisie_N_G,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Site_Rem, Ligne: 6),
                    ],
                  ),
                ]))));
  }

  Widget GroupeGridWidget() {
    List<DaviColumn<Groupe>> wColumns = [
      new DaviColumn(name: 'Groupes', grow: 1, stringValue: (row) => row.Groupe_Nom),
    ];

    print("GroupeGridWidget ${DbTools.ListGroupe.length}");
    DaviModel<Groupe>? _model;
    _model = DaviModel<Groupe>(rows: DbTools.ListGroupe, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Groupe>(visibleRowsCount: 17, _model, onRowTap: (aGroupe) async {
          DbTools.gGroupe = aGroupe;

          SelGroupe = DbTools.ListGroupe.indexOf(aGroupe);

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
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
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
      new DaviColumn(name: 'Nom', width: 240, stringValue: (row) => row.Site_Nom),
      new DaviColumn(name: 'Adresse', width: 240, stringValue: (row) => "${row.Site_Adr1}"),
      new DaviColumn(name: 'Cp', width: 80, stringValue: (row) => "${row.Site_CP}"),
      new DaviColumn(name: 'Ville', width: 180, stringValue: (row) => "${row.Site_Ville}"),
    ];
    print("SiteGridWidget ${DbTools.ListSitesearchresult.length}");
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
