import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/ParamSite_Dialog.dart';
import 'package:verifplus_backoff/widgets/Sites/ParamSite_Dialog2.dart';
import 'package:verifplus_backoff/widgets/Sites/Zones_Dialog.dart';
import 'package:image/image.dart' as IMG;
import 'package:http/http.dart' as http;

DataGridController dataGridController = DataGridController();

//*********************************************************************
//*********************************************************************
//*********************************************************************

class SiteDataGridSource extends DataGridSource {
  SiteDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListSitesearchresult.map<DataGridRow>((Site site) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: site.SiteId),
        DataGridCell<String>(columnName: 'nom', value: site.Site_Nom),
        DataGridCell<String>(columnName: 'adresse', value: site.Site_Adr1),
        DataGridCell<String>(columnName: 'nb', value: site.NbZone.toString()),
        DataGridCell<String>(columnName: 'cp', value: site.Site_CP),
        DataGridCell<String>(columnName: 'ville', value: site.Site_Ville),
        DataGridCell<String>(columnName: 'agence', value: site.Site_Depot),
        DataGridCell<String>(columnName: 'cprenom', value: site.Contact_Prenom),
        DataGridCell<String>(columnName: 'cnom', value: site.Contact_Nom),
        DataGridCell<String>(columnName: 'ctel2', value: site.Contact_Tel2),
        DataGridCell<String>(columnName: 'cemail', value: site.Contact_eMail),
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
    bool selected = (DbTools.gSite.SiteId.toString() == row.getCells()[0].value.toString());
    Color textColor = selected ? selectedRowTextColor : Colors.black;
    Color backgroundColor = selected ? gColors.backgroundColor : Colors.transparent;

    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 3, Alignment.centerRight, textColor),
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
}

//*********************************************************************
//*********************************************************************
//*********************************************************************

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

  Groupe wGroupe = Groupe.GroupeInit();
  List<Groupe> List_Grp = [];

  List<String> List_GrpStr = [];
  List<String> List_GrpID = [];

  String selectedGrp = "";
  int selectedGrpID = 0;

  String Grp = "Tous";
  int GrpID = 0;
  final List<XFile> _list = [];
  bool _dragging = false;
  Offset? offset;

  SiteDataGridSource siteDataGridSource = SiteDataGridSource();

  int wColSel = -1;
  int wRowSel = -1;
  int Selindex = 0;
  int countfilterConditions = -1;

  DataGridRow memDataGridRow = DataGridRow(cells: []);

  bool isDC = false;

  Future Reload() async {
    print("••••• Reload Selindex ${Selindex}");
    await DbTools.getGroupesClient(DbTools.gClient.ClientId);
    print("Reload getGroupesClient ${DbTools.ListGroupe.length}");
    print("Reload DbTools.ListGroupe[0].GroupeId ${DbTools.ListGroupe[0].GroupeId}");

    await DbTools.initListFam();
    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    print(" Reload  selectedUserInter ${selectedUserInter} ${selectedUserInterID}");


    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    DbTools.gAdresseLivr = DbTools.ListAdresse[0];

    List_Grp.clear();
    Groupe wGroupe = Groupe.GroupeInit();
    wGroupe.Groupe_Nom = "Tous";
    List_Grp.add(wGroupe);
    Grp = wGroupe.Groupe_Nom;
    GrpID = wGroupe.GroupeId;

    List_GrpStr.clear();
    List_GrpID.clear();

    for (int i = 0; i < DbTools.ListGroupe.length; i++) {
      var Elt = DbTools.ListGroupe[i];
      List_Grp.add(Elt);
      List_GrpID.add("${Elt.GroupeId}");
      List_GrpStr.add(Elt.Groupe_Nom);
    }


    await DbTools.getSitesClient(DbTools.gClient.ClientId);
    print("Reload getSitesClient ${DbTools.ListSite.length}");

    if (DbTools.ListSite.length > 0)
        DbTools.gSite = DbTools.ListSite[0];


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

    print("DbTools.ListSite liste ${DbTools.ListSite.length}");


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
//    if (DbTools.ListSitesearchresult.length > 0) DbTools.gSite = DbTools.ListSitesearchresult[0];

    await siteDataGridSource.handleRefresh();
    AlimSaisie();

    setState(() {});
  }

  Future AlimSaisie() async {
    print(" AlimSaisie Desc ${DbTools.gSite.Desc()}");

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

    isDC = DbTools.gSite.Site_DecConf!;

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


    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];
    if (DbTools.gSite.Site_ResourceId > 0) {
      DbTools.getUserMat("${DbTools.gSite.Site_ResourceId!}");
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      selectedUserInterID = DbTools.gUser.User_Matricule;
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
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: GroupeGridWidget(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: SiteGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Save", ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                  Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", ToolsBarAdd, tooltip: "Ajouter site"),
                        ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Copy", ToolsBarCpy, tooltip: "Copier adresse Livraison"),
                  ),
                  DbTools.gSite.Site_Nom.isEmpty
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.orange, "ico_Contact", ToolsBarCtact, tooltip: "Contacts"),
                        ),
                  (DbTools.gSite.Site_Nom != "???" || DbTools.ListZone.length > 0)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(10, 220, 0, 0),
                          child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Suppression"),
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

  Widget ToolsBargrid(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
        child: Column(
          children: [
            Row(
              children: [
                CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
              ],
            ),
          ],
        ));
  }

  void ToolsBarSupprFilter() async {
    siteDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }

  Widget ToolsBarSearch(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: Column(
          children: [
            Row(
              children: [
                CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
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
                  width: 10,
                ),
              ],
            ),
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


  void Tools2() async {
    await ParamSite_Dialog2.ParamSite_Dialog(context);
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
    DbTools.gSite.Site_DecConf = isDC;
    DbTools.gSite.Site_GroupeId = GrpID;

    print("ToolsBarSave ${DbTools.gSite.SiteId} $GrpID $Grp");
    await DbTools.setSite(DbTools.gSite);


    print("ToolsBarSave getSitesClient ${DbTools.ListSite.length}  ${DbTools.gSite.Site_GroupeId} ${Selindex}");



    Reload();
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
              'Site #${DbTools.gSite.SiteId}',
              style: gColors.bodySaisie_B_G,
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
              style: gColors.bodySaisie_B_G,
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
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Règlementations',
              style: gColors.bodySaisie_B_G,
            ),
          ),
        ),
      ],
    );
  }

  Widget Regles() {
    String wRegl = "";
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


    print("Regles A");

    String siteRegl = DbTools.gSite.Site_Regle!;
    if (siteRegl.isNotEmpty) {
      itemlistApp = json.decode(siteRegl).cast<bool>().toList();

      for (int i = 0; i < itemlistApp.length; i++) {
        var element = itemlistApp[i];
        if (element) {
          wRegl = "$wRegl${wRegl.isNotEmpty ? ", " : ""}${listRegl[i]}";
        }
      }
    }

    print("Regles B");


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



    String siteAPSAD = DbTools.gSite.Site_APSAD!;
    if (siteAPSAD.isNotEmpty) {
      itemlistAPSAD = json.decode(siteAPSAD).cast<bool>().toList();
      for (int i = 0; i < itemlistAPSAD.length; i++) {
        var element = itemlistAPSAD[i];
        if (element) {
          wAPSAD = "$wAPSAD${wAPSAD.isNotEmpty ? ", " : ""}${listAPSAD[i]}";
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Regl", Tools, tooltip: "Réglementation"),
                Container(
                  width: 10,
                ),
                Text(
                  "Règlementations applicables\nà l'établissement du client",
                  style: gColors.bodySaisie_N_G,
                ),
              ],
            ),
          ),
          Container(
            width: 280,
            height: 75,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              wRegl,
              style: gColors.bodySaisie_N_G,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "apsad", Tools2, tooltip: "APSAD"),
                Container(
                  width: 10,
                ),
                Text(
                  "APSAD",
                  style: gColors.bodySaisie_N_G,
                ),
              ],
            ),
          ),
          Container(
            width: 280,
            height: 75,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              wAPSAD,
              style: gColors.bodySaisie_N_G,
              maxLines: 2,
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
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            Tooltip(
                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(color: Colors.orange),
                message: "Selection fichier photo",
                child: InkWell(
                  child: Container(
                    width: 30,
                    child: Image.asset("assets/images/ico_Photo.png"),
                  ),
                  onTap: () async {
                    await _startFilePicker(onSetState);
                  },
                )),
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




    print(" ContentSite  selectedUserInter ${selectedUserInter} ${selectedUserInterID}");

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
                      gColors.DropdownButtonTypeInterC(100, 8, "Groupe", "$Grp", (sts) {
                        setState(() {
                          Grp = sts!;
                          GrpID = int.parse(List_GrpID[List_GrpStr.indexOf(Grp)]);
                          print("onCHANGE Groupe $sts $GrpID");
                        });
                      }, List_GrpStr, List_GrpID),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.DropdownButtonTypeInterC(100, 8, "Collaborateur", selectedUserInter, (sts) {
                        setState(() {
                          selectedUserInter = sts!;
                          selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
                          print("onCHANGE selectedUserInter4 $selectedUserInter");
                          print("onCHANGE selectedUserInterID4 $selectedUserInterID");
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
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        height: MediaQuery.of(context).size.height - 450,
        child: DaviTheme(
            child: new Davi<Groupe>(visibleRowsCount: 17, _model, onRowTap: (aGroupe) async {
              DbTools.gGroupe = aGroupe;
              selectedGrpID = List_Grp.indexOf(aGroupe);
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
              headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
              row: RowThemeData(color: (rowIndex) {
                return selectedGrpID == rowIndex ? gColors.secondarytxt : Colors.white;
              }),
              cell: CellThemeData(
                contentHeight: 26,
                textStyle: gColors.bodySaisie_N_G,
              ),
            )));
  }

  List<double> dColumnWidth = [
    80,
    300,
    300,
    100,
    120,
    160,
    260,
    260,
    260,
    260,
    260,
  ];
  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'nom')
        dColumnWidth[1] = args.width;
      else if (args.column.columnName == 'adresse')
        dColumnWidth[2] = args.width;
      else if (args.column.columnName == 'nb')
        dColumnWidth[3] = args.width;
      else if (args.column.columnName == 'cp')
        dColumnWidth[4] = args.width;
      else if (args.column.columnName == 'ville')
        dColumnWidth[5] = args.width;
      else if (args.column.columnName == 'agence')
        dColumnWidth[6] = args.width;
      else if (args.column.columnName == 'cprenom')
        dColumnWidth[7] = args.width;
      else if (args.column.columnName == 'cnom')
        dColumnWidth[8] = args.width;
      else if (args.column.columnName == 'ctel2')
        dColumnWidth[9] = args.width;
      else if (args.column.columnName == 'cemail') dColumnWidth[10] = args.width;
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[0], Alignment.centerLeft),
      FiltreTools.SfGridColumn('nom', 'Nom', dColumnWidth[1], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('adresse', 'Adresse', dColumnWidth[2], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cp', 'Cp', dColumnWidth[3], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('ville', 'Ville', dColumnWidth[4], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('nb', 'Nb', dColumnWidth[5], 160, Alignment.centerRight),
      FiltreTools.SfGridColumn('agence', 'Agence', dColumnWidth[6], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cprenom', 'Prenom', dColumnWidth[7], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cnom', 'Nom', dColumnWidth[8], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('ctel2', 'Portable', dColumnWidth[9], 160, Alignment.centerLeft),
      FiltreTools.SfGridColumn('cemail', 'eMail', dColumnWidth[10], 160, Alignment.centerLeft),
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

  Widget SiteGridWidget() {
    return Container(
      child: Column(children: [
//        ToolsBargrid(context),
        Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
            height: MediaQuery.of(context).size.height - 450,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor: gColors.transparent,
                ),
                child: SfDataGrid(
                  //*********************************
                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = siteDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    setState(() {});
                  },
                  onCellTap: (DataGridCellTapDetails details) async {
                    wColSel = details.rowColumnIndex.columnIndex;
                    wRowSel = details.rowColumnIndex.rowIndex;
                    if (wRowSel == 0) return;
                    DataGridRow wDataGridRow = siteDataGridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                    Selindex = siteDataGridSource.dataGridRows.indexOf(wDataGridRow);
                    DbTools.gSite = DbTools.ListSitesearchresult[Selindex];

                    //selectedGrpID = List_GrpID.indexOf("${DbTools.gSite.Site_GroupeId}") + 1;

                    AlimSaisie();
                    if (wColSel == 0) {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => new Zones_Dialog(
                                site: DbTools.gSite,
                              ));
                      Reload();
                    }
                  },

                  //*********************************

                  allowSorting: true,
                  allowFiltering: true,
                  source: siteDataGridSource,
                  columns: getColumns(),
                  tableSummaryRows: getGridTableSummaryRow(),

                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  selectionMode: SelectionMode.none,
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
          buttonStyleData: const ButtonStyleData(
            padding: const EdgeInsets.only(left: 4, right: 4),
            height: 30,
            width: 250,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
          ),
        )),
      ),
    ]);
  }


}
