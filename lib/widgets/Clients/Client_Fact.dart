import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Dialog.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Map_Dialog.dart';

class Client_Fact extends StatefulWidget {
  final Client_Fact_Controller client_Fact_Controller;
  const Client_Fact({Key? key, required this.client_Fact_Controller}) : super(key: key);

  @override
  State<Client_Fact> createState() => _Client_FactState(client_Fact_Controller);
}

class _Client_FactState extends State<Client_Fact> {

  _Client_FactState(Client_Fact_Controller _controller) {
    _controller.AlimSaisie = AlimSaisie;
  }

  double halfwidth = 0;
  TextEditingController textController_Adresse_Geo = TextEditingController();
  TextEditingController textController_Adresse_Adr1 = TextEditingController();
  TextEditingController textController_Adresse_Adr2 = TextEditingController();
  TextEditingController textController_Adresse_Adr3 = TextEditingController();
  TextEditingController textController_Adresse_Adr4 = TextEditingController();
  TextEditingController textController_Adresse_CP = TextEditingController();
  TextEditingController textController_Adresse_Ville = TextEditingController();
  TextEditingController textController_Adresse_Pays = TextEditingController();
  TextEditingController textController_Adresse_Acces = TextEditingController();
  TextEditingController textController_Adresse_Rem = TextEditingController();

  TextEditingController textController_Contact_Civilite = TextEditingController();
  TextEditingController textController_Contact_Prenom = TextEditingController();
  TextEditingController textController_Contact_Nom = TextEditingController();
  TextEditingController textController_Contact_Fonction = TextEditingController();
  TextEditingController textController_Contact_Service = TextEditingController();
  TextEditingController textController_Contact_Tel1 = TextEditingController();
  TextEditingController textController_Contact_Tel2 = TextEditingController();
  TextEditingController textController_Contact_eMail = TextEditingController();
  TextEditingController textController_Contact_Rem = TextEditingController();

  TextEditingController textController_Livr_Adresse_Geo = TextEditingController();
  TextEditingController textController_Livr_Adresse_Adr1 = TextEditingController();
  TextEditingController textController_Livr_Adresse_Adr2 = TextEditingController();
  TextEditingController textController_Livr_Adresse_Adr3 = TextEditingController();
  TextEditingController textController_Livr_Adresse_Adr4 = TextEditingController();
  TextEditingController textController_Livr_Adresse_CP = TextEditingController();
  TextEditingController textController_Livr_Adresse_Ville = TextEditingController();
  TextEditingController textController_Livr_Adresse_Pays = TextEditingController();
  TextEditingController textController_Livr_Adresse_Acces = TextEditingController();
  TextEditingController textController_Livr_Adresse_Rem = TextEditingController();

  TextEditingController textController_Livr_Contact_Civilite = TextEditingController();
  TextEditingController textController_Livr_Contact_Prenom = TextEditingController();
  TextEditingController textController_Livr_Contact_Nom = TextEditingController();
  TextEditingController textController_Livr_Contact_Fonction = TextEditingController();
  TextEditingController textController_Livr_Contact_Service = TextEditingController();
  TextEditingController textController_Livr_Contact_Tel1 = TextEditingController();
  TextEditingController textController_Livr_Contact_Tel2 = TextEditingController();
  TextEditingController textController_Livr_Contact_eMail = TextEditingController();
  TextEditingController textController_Livr_Contact_Rem = TextEditingController();

  String selectedValueFam = "";
  String selectedValueFamID = "";

  bool wIs_Hierarchie = true;

  void initLib() async {
    wIs_Hierarchie = await DbTools.Count_Hierarchie(DbTools.gClient.ClientId);
    print(">>>>>>>>>>>>>>@@@@@@@@@@>>>>>>>>>> wCount_Hierarchie $wIs_Hierarchie");

    print("••••• initLib Client_Fact getAdresseClientType");
    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    DbTools.gAdresseLivr = DbTools.ListAdresse[0];
    print("••••• initLib Client_Fact getContactClientAdrType");
    await DbTools.getContactClientAdrType(DbTools.gClient.ClientId, DbTools.gAdresse.AdresseId, "LIVR");
    DbTools.gContactLivr = DbTools.ListContact[0];
    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "FACT");
    await DbTools.getContactClientAdrType(DbTools.gClient.ClientId, DbTools.gAdresse.AdresseId, "FACT");

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> getAdresseClientType ${DbTools.ListContact.length}");
    AlimSaisie();
  }

  void AlimSaisie() {
    textController_Adresse_Geo.text = "${DbTools.gAdresse.Adresse_Adr1} ${DbTools.gAdresse.Adresse_CP} ${DbTools.gAdresse.Adresse_Ville}";

    textController_Adresse_Adr1.text = DbTools.gAdresse.Adresse_Adr1;
    textController_Adresse_Adr2.text = DbTools.gAdresse.Adresse_Adr2;
    textController_Adresse_Adr3.text = DbTools.gAdresse.Adresse_Adr3;
    textController_Adresse_Adr4.text = DbTools.gAdresse.Adresse_Adr4;
    textController_Adresse_CP.text = DbTools.gAdresse.Adresse_CP;
    textController_Adresse_Ville.text = DbTools.gAdresse.Adresse_Ville;
    textController_Adresse_Pays.text = DbTools.gAdresse.Adresse_Pays;
    textController_Adresse_Acces.text = DbTools.gAdresse.Adresse_Acces;
    textController_Adresse_Rem.text = DbTools.gAdresse.Adresse_Rem;
    textController_Contact_Civilite.text = DbTools.gContact.Contact_Civilite;

    textController_Contact_Prenom.text = DbTools.gContact.Contact_Prenom;
    textController_Contact_Nom.text = DbTools.gContact.Contact_Nom;
    textController_Contact_Fonction.text = DbTools.gContact.Contact_Fonction;
    textController_Contact_Service.text = DbTools.gContact.Contact_Service;
    textController_Contact_Tel1.text = DbTools.gContact.Contact_Tel1;
    textController_Contact_Tel2.text = DbTools.gContact.Contact_Tel2;
    textController_Contact_eMail.text = DbTools.gContact.Contact_eMail;
    textController_Contact_Rem.text = DbTools.gContact.Contact_Rem;

    textController_Livr_Adresse_Geo.text = "${DbTools.gAdresse.Adresse_Adr1} ${DbTools.gAdresse.Adresse_CP} ${DbTools.gAdresse.Adresse_Ville}";
    textController_Livr_Adresse_Adr1.text = DbTools.gAdresseLivr.Adresse_Adr1;
    textController_Livr_Adresse_Adr2.text = DbTools.gAdresseLivr.Adresse_Adr2;
    textController_Livr_Adresse_Adr3.text = DbTools.gAdresseLivr.Adresse_Adr3;
    textController_Livr_Adresse_Adr4.text = DbTools.gAdresseLivr.Adresse_Adr4;
    textController_Livr_Adresse_CP.text = DbTools.gAdresseLivr.Adresse_CP;
    textController_Livr_Adresse_Ville.text = DbTools.gAdresseLivr.Adresse_Ville;
    textController_Livr_Adresse_Pays.text = DbTools.gAdresseLivr.Adresse_Pays;
    textController_Livr_Adresse_Acces.text = DbTools.gAdresseLivr.Adresse_Acces;
    textController_Livr_Adresse_Rem.text = DbTools.gAdresseLivr.Adresse_Rem;

    textController_Livr_Contact_Civilite.text = DbTools.gContactLivr.Contact_Civilite;
    textController_Livr_Contact_Prenom.text = DbTools.gContactLivr.Contact_Prenom;
    textController_Livr_Contact_Nom.text = DbTools.gContactLivr.Contact_Nom;
    textController_Livr_Contact_Fonction.text = DbTools.gContactLivr.Contact_Fonction;
    textController_Livr_Contact_Service.text = DbTools.gContactLivr.Contact_Service;
    textController_Livr_Contact_Tel1.text = DbTools.gContactLivr.Contact_Tel1;
    textController_Livr_Contact_Tel2.text = DbTools.gContactLivr.Contact_Tel2;
    textController_Livr_Contact_eMail.text = DbTools.gContactLivr.Contact_eMail;
    textController_Livr_Contact_Rem.text = DbTools.gContactLivr.Contact_Rem;

    print("textController_Adresse_Adr2 ${textController_Adresse_Adr2.text}");
    print("textController_Livr_Adresse_Adr2 $textController_Livr_Adresse_Adr2");
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    halfwidth = MediaQuery.of(context).size.width / 2 - 28;
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FACT build");
    return Container(

      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),

      color: Colors.white,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: halfwidth,
            child: FactCadre(context),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              height: 200,
            child:
            Column(children: [
              CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy ,tooltip : "Copier Facturation sur livraison"),
              Spacer(),
              wIs_Hierarchie ?
              CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.blueAccent, Colors.white, Icons.manage_accounts_outlined, ToolsBarCpyTools, isEnable: false,tooltip : "Modèle sans Groupe, sans Zone") :
              CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.blueAccent, Colors.white, Icons.manage_accounts_outlined, ToolsBarCpyTools,tooltip : "Modèle sans Groupe, sans Zone"),

            ],)

          ),

          Container(
            width: halfwidth,
            child: LivrCadre(context),
          ),
        ],
      ),
    );
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        width: halfwidth - 20,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                Container(
                  width: 10,
                ),
                Container(
                  width: halfwidth - 100,
                  child: AutoAdresse(80, halfwidth - 220, "Recherche", textController_Adresse_Geo),
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearch, tooltip: "Copier recherche"),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
            ),
            Container(
              height: 1,
              color: Colors.black26,
            )
          ],
        ));
  }

  void MapDialog() async {
    MapTools.gMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");

    await Client_Map_Dialog.Client_Map_dialog(context, "${textController_Adresse_Adr1.text} ${textController_Adresse_CP.text} ${textController_Adresse_Ville.text}");

    if (MapTools.gMapTools_Geocoding.Geo_formattedAddress.isNotEmpty) {
      String address = "";
      String street = "";
      String postcode = "";
      String city = "";

      MapTools.gMapTools_Geocoding.Geo_addressComponents!.forEach((component) {
        var componentType = component.types![0];
        switch (componentType) {
          case "street_number":
            address = component.longName!;
            break;
          case "route":
            street = component.longName!;
            break;
          case "locality":
            city = component.longName!;
            break;
          case "postal_code":
            postcode = component.longName!;
            break;
        }
      });

      print("address  $address");
      print("street  $street");
      print("postcode   $postcode");
      print("city  $city");

      textController_Adresse_Adr1.text = "$address $street ";
      textController_Adresse_CP.text = postcode;
      textController_Adresse_Ville.text = city;
    }
  }

  void ToolsBarSave() async {
    print("ToolsBarSave");

    DbTools.gAdresse.Adresse_Adr1 = textController_Adresse_Adr1.text;
    DbTools.gAdresse.Adresse_Adr2 = textController_Adresse_Adr2.text;
    DbTools.gAdresse.Adresse_Adr3 = textController_Adresse_Adr3.text;
    DbTools.gAdresse.Adresse_Adr4 = textController_Adresse_Adr4.text;
    DbTools.gAdresse.Adresse_CP = textController_Adresse_CP.text;
    DbTools.gAdresse.Adresse_Ville = textController_Adresse_Ville.text;
    DbTools.gAdresse.Adresse_Pays = textController_Adresse_Pays.text;
    DbTools.gAdresse.Adresse_Acces = textController_Adresse_Acces.text;
    DbTools.gAdresse.Adresse_Rem = textController_Adresse_Rem.text;

    await DbTools.setAdresse(DbTools.gAdresse);

    DbTools.gContact.Contact_Civilite = textController_Contact_Civilite.text;
    DbTools.gContact.Contact_Prenom = textController_Contact_Prenom.text;
    DbTools.gContact.Contact_Nom = textController_Contact_Nom.text;
    DbTools.gContact.Contact_Fonction = textController_Contact_Fonction.text;
    DbTools.gContact.Contact_Service = textController_Contact_Service.text;
    DbTools.gContact.Contact_Tel1 = textController_Contact_Tel1.text;
    DbTools.gContact.Contact_Tel2 = textController_Contact_Tel2.text;
    DbTools.gContact.Contact_eMail = textController_Contact_eMail.text;
    DbTools.gContact.Contact_Rem = textController_Contact_Rem.text;

    await DbTools.setContact(DbTools.gContact);

    AlimSaisie();

    setState(() {});
  }

  void ToolsBarSave_Livr() async {
    print("ToolsBarSave_Livr");

    DbTools.gAdresseLivr.Adresse_Adr1 = textController_Livr_Adresse_Adr1.text;
    DbTools.gAdresseLivr.Adresse_Adr2 = textController_Livr_Adresse_Adr2.text;
    DbTools.gAdresseLivr.Adresse_Adr3 = textController_Livr_Adresse_Adr3.text;
    DbTools.gAdresseLivr.Adresse_Adr4 = textController_Livr_Adresse_Adr4.text;
    DbTools.gAdresseLivr.Adresse_CP = textController_Livr_Adresse_CP.text;
    DbTools.gAdresseLivr.Adresse_Ville = textController_Livr_Adresse_Ville.text;
    DbTools.gAdresseLivr.Adresse_Pays = textController_Livr_Adresse_Pays.text;
    DbTools.gAdresseLivr.Adresse_Acces = textController_Livr_Adresse_Acces.text;
    DbTools.gAdresseLivr.Adresse_Rem = textController_Livr_Adresse_Rem.text;

    await DbTools.setAdresse(DbTools.gAdresseLivr);

    DbTools.gContactLivr.Contact_Civilite = textController_Livr_Contact_Civilite.text;


    DbTools.gContactLivr.Contact_Prenom = textController_Livr_Contact_Prenom.text;
    DbTools.gContactLivr.Contact_Nom = textController_Livr_Contact_Nom.text;
    DbTools.gContactLivr.Contact_Fonction = textController_Livr_Contact_Fonction.text;
    DbTools.gContactLivr.Contact_Service = textController_Livr_Contact_Service.text;
    DbTools.gContactLivr.Contact_Tel1 = textController_Livr_Contact_Tel1.text;
    DbTools.gContactLivr.Contact_Tel2 = textController_Livr_Contact_Tel2.text;
    DbTools.gContactLivr.Contact_eMail = textController_Livr_Contact_eMail.text;
    DbTools.gContactLivr.Contact_Rem = textController_Livr_Contact_Rem.text;

    await DbTools.setContact(DbTools.gContactLivr);

    AlimSaisie();

    setState(() {});
  }

  void ToolsBarCpyTools() async {

    await DbTools.Add_Hierarchie(DbTools.gClient.ClientId);
    wIs_Hierarchie = await DbTools.Count_Hierarchie(DbTools.gClient.ClientId);
    setState(() {});
  }

    void ToolsBarCpy() async {
    print("ToolsBarCpy");

    textController_Livr_Adresse_Geo.text = "${DbTools.gAdresse.Adresse_Adr1} ${DbTools.gAdresse.Adresse_CP} ${DbTools.gAdresse.Adresse_Ville}";

    textController_Livr_Adresse_Adr1.text = DbTools.gAdresse.Adresse_Adr1;
    textController_Livr_Adresse_Adr2.text = DbTools.gAdresse.Adresse_Adr2;
    textController_Livr_Adresse_Adr3.text = DbTools.gAdresse.Adresse_Adr3;
    textController_Livr_Adresse_Adr4.text = DbTools.gAdresse.Adresse_Adr4;
    textController_Livr_Adresse_CP.text = DbTools.gAdresse.Adresse_CP;
    textController_Livr_Adresse_Ville.text = DbTools.gAdresse.Adresse_Ville;
    textController_Livr_Adresse_Pays.text = DbTools.gAdresse.Adresse_Pays;
    textController_Livr_Adresse_Acces.text = DbTools.gAdresse.Adresse_Acces;
    textController_Livr_Adresse_Rem.text = DbTools.gAdresse.Adresse_Rem;

    textController_Livr_Contact_Civilite.text = DbTools.gContact.Contact_Civilite;
    textController_Livr_Contact_Prenom.text = DbTools.gContact.Contact_Prenom;
    textController_Livr_Contact_Nom.text = DbTools.gContact.Contact_Nom;
    textController_Livr_Contact_Fonction.text = DbTools.gContact.Contact_Fonction;
    textController_Livr_Contact_Service.text = DbTools.gContact.Contact_Service;
    textController_Livr_Contact_Tel1.text = DbTools.gContact.Contact_Tel1;
    textController_Livr_Contact_Tel2.text = DbTools.gContact.Contact_Tel2;
    textController_Livr_Contact_eMail.text = DbTools.gContact.Contact_eMail;
    textController_Livr_Contact_Rem.text = DbTools.gContact.Contact_Rem;

    setState(() {});
  }

  void ToolsBarCopySearch() async {
    print("ToolsBarCopySearch ${Api_Gouv.gProperties.toJson()}");
    textController_Adresse_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Adresse_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Adresse_Ville.text = Api_Gouv.gProperties.city!;
  }

  Widget FactCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: halfwidth - 20,
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              children: [
                ToolsBar(context),
                FactAdresseCadre(context),
                FactContactCadre(context),
              ],
            )),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Facturation',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget FactAdresseCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: halfwidth - 40,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: FactAdresse(context),
        ),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Adresse de facturation',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

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
                  style: gColors.bodySaisie_B_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
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

  Widget FactAdresse(BuildContext context) {
    double width = halfwidth - 60;
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            width: width,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Column(children: [
              gColors.TxtFieldCalc(80, width, "Adresse", textController_Adresse_Adr1),
              gColors.TxtFieldCalc(80, width, "", textController_Adresse_Adr2, sep: ""),
              gColors.TxtFieldCalc(80, width, "", textController_Adresse_Adr3, sep: ""),
              gColors.TxtFieldCalc(80, width, "", textController_Adresse_Adr4, sep: ""),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  gColors.TxtFieldCalc(80, 180, "Code postal", textController_Adresse_CP),
                  Container(
                    width: 10,
                  ),
                  gColors.TxtFieldCalc(-1, width - 264, "Ville", textController_Adresse_Ville),
                  Container(
                    width: 10,
                  ),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.question_mark, CpVillmeSearch, tooltip: "Recherche Adresse"),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.map_outlined, MapDialog, tooltip: "Carte"),
                ],
              ),
              Row(
                children: [
                  gColors.TxtFieldCalc(80, width / 2 - 30, "Pays", textController_Adresse_Pays),
                  Container(
                    width: 10,
                  ),
                  gColors.TxtFieldCalc(-1, width / 2 - 50, "Code d'accès", textController_Adresse_Acces),

                ],
              )
            ])));
  }

  void CpVillmeSearch() async {
    if (textController_Adresse_CP.text.length > 0)
      await Api_Gouv.ReadServer_CpVilles(textController_Adresse_CP.text);
    else
      await Api_Gouv.ReadServer_CpVilles(textController_Adresse_Ville.text);
    showDialog(
      context: context,
      builder: (BuildContext context) => CpV_dialog(context),
    );
  }

  Widget ListViewCpVille(data) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              color: (index.isOdd ? Colors.black12 : Colors.white),
              child: ListTile(
                onTap: () async {
                  setState(() {
                    textController_Adresse_CP.text = Api_Gouv.tCp[index];
                    textController_Adresse_Ville.text = Api_Gouv.tVille[index];
                  });
                  Navigator.of(context).pop();
                },
                title: Text("${Api_Gouv.tCp[index]} - ${Api_Gouv.tVille[index]}"),
              ));
        },
      ),
    );
  }

  Widget CpV_dialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: gColors.LinearGradient1,
        child: Text("Code postal - Ville",
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
        height: 280,
        child: ListViewCpVille(Api_Gouv.tCp),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget FactContactCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
              FactContact(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Contact de facturation',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget FactContact(BuildContext context) {
    double width = halfwidth / 2 - 30;
    double wLabel = 70;
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  DropdownButtonCivFact(),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Prénom", textController_Contact_Prenom),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Nom", textController_Contact_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Fonction", textController_Contact_Fonction),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Service", textController_Contact_Service),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Tel Fixe", textController_Contact_Tel1),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Portable", textController_Contact_Tel2),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "eMail", textController_Contact_eMail),
                    ],
                  ),
                ]))));
  }

  //************************************************************************************************
  //**************************************  LIVRAISON   ********************************************
  //************************************************************************************************

  Widget LivrCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: halfwidth - 20,
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              children: [
                ToolsBar_Livr(context),
                LivrAdresseCadre(context),
                LivrContactCadre(context),
              ],
            )),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Livraison',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget LivrAdresseCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: halfwidth - 40,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: LivrAdresse(context),
        ),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Adresse de livraison',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget LivrContactCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: halfwidth - 40,
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
              LivrContact(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Contact de livraison',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget LivrAdresse(BuildContext context) {
    double width = halfwidth - 60;

    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            width: width,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Column(children: [
              gColors.TxtFieldCalc(80, width, "Adresse", textController_Livr_Adresse_Adr1),
              gColors.TxtFieldCalc(80, width, "", textController_Livr_Adresse_Adr2, sep: ""),
              gColors.TxtFieldCalc(80, width, "", textController_Livr_Adresse_Adr3, sep: ""),
              gColors.TxtFieldCalc(80, width, "", textController_Livr_Adresse_Adr4, sep: ""),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  gColors.TxtFieldCalc(80, 180, "Code postal", textController_Livr_Adresse_CP),
                  Container(
                    width: 10,
                  ),
                  gColors.TxtFieldCalc(-1, width - 264, "Ville", textController_Livr_Adresse_Ville),
                  Container(
                    width: 10,
                  ),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.question_mark, CpVillmeSearch_Livr, tooltip: "Recherche Adresse"),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.map_outlined, MapDialog_Livr, tooltip: "Carte"),
                ],
              ),
              Row(
                children: [
                  gColors.TxtFieldCalc(80, width / 2 - 30, "Pays", textController_Livr_Adresse_Pays),
                  Container(
                    width: 10,
                  ),
                  gColors.TxtFieldCalc(-1, width / 2 - 50, "Code d'accès", textController_Livr_Adresse_Acces),

                ],
              )

            ])));
  }

  Widget LivrContact(BuildContext context) {
    double width = halfwidth / 2 - 30;
    double wLabel = 70;
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [

                  DropdownButtonCivLIVR(),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Prénom", textController_Livr_Contact_Prenom),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Nom", textController_Livr_Contact_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Fonction", textController_Livr_Contact_Fonction),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Service", textController_Livr_Contact_Service),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "Tel Fixe", textController_Livr_Contact_Tel1),
                      Container(
                        width: 8,
                      ),
                      gColors.TxtFieldCalc(wLabel, width, "Portable", textController_Livr_Contact_Tel2),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtFieldCalc(wLabel, width, "eMail", textController_Livr_Contact_eMail),
                    ],
                  ),
                ]))));
  }

  Widget ToolsBar_Livr(BuildContext context) {
    return Container(
        width: halfwidth - 20,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave_Livr, tooltip: "Sauvegarder"),
                Container(
                  width: 10,
                ),
                Container(
                  width: halfwidth - 100,
                  child: AutoAdresse(80, halfwidth - 220, "Recherche", textController_Livr_Adresse_Geo),
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearch_Livr, tooltip: "Copier recherche"),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
            ),
            Container(
              height: 1,
              color: Colors.black26,
            )
          ],
        ));
  }

  Widget AutoAdresse_Livr(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
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
            width: wWidth * 6,
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
                await Api_Gouv.ApiAdresse(textController_Livr_Adresse_Geo.text);
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

                textController_Livr_Adresse_Geo.text = suggestion;
              },
            )),
        Container(
          width: 20,
        ),
      ],
    );
  }

  void ToolsBarCopySearch_Livr() async {
    print("ToolsBarCopySearch_Livr ${Api_Gouv.gProperties.toJson()}");
    textController_Livr_Adresse_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Livr_Adresse_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Livr_Adresse_Ville.text = Api_Gouv.gProperties.city!;
  }

  void MapDialog_Livr() async {
    MapTools.gMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");

    await Client_Map_Dialog.Client_Map_dialog(context, "${textController_Livr_Adresse_Adr1.text} ${textController_Livr_Adresse_CP.text} ${textController_Livr_Adresse_Ville.text}");

    if (MapTools.gMapTools_Geocoding.Geo_formattedAddress.isNotEmpty) {
      String address = "";
      String street = "";
      String postcode = "";
      String city = "";

      MapTools.gMapTools_Geocoding.Geo_addressComponents!.forEach((component) {
        var componentType = component.types![0];
        switch (componentType) {
          case "street_number":
            address = component.longName!;
            break;
          case "route":
            street = component.longName!;
            break;
          case "locality":
            city = component.longName!;
            break;
          case "postal_code":
            postcode = component.longName!;
            break;
        }
      });

      print("address  $address");
      print("street  $street");
      print("postcode   $postcode");
      print("city  $city");

      textController_Livr_Adresse_Adr1.text = "$address $street ";
      textController_Livr_Adresse_CP.text = postcode;
      textController_Livr_Adresse_Ville.text = city;
    }
  }

  void CpVillmeSearch_Livr() async {
    if (textController_Livr_Adresse_CP.text.length > 0)
      await Api_Gouv.ReadServer_CpVilles(textController_Livr_Adresse_CP.text);
    else
      await Api_Gouv.ReadServer_CpVilles(textController_Livr_Adresse_Ville.text);
    showDialog(
      context: context,
      builder: (BuildContext context) => CpV_dialog_Livr(context),
    );
  }

  Widget ListViewCpVille_Livr(data) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              color: (index.isOdd ? Colors.black12 : Colors.white),
              child: ListTile(
                onTap: () async {
                  setState(() {
                    textController_Livr_Adresse_CP.text = Api_Gouv.tCp[index];
                    textController_Livr_Adresse_Ville.text = Api_Gouv.tVille[index];
                  });
                  Navigator.of(context).pop();
                },
                title: Text("${Api_Gouv.tCp[index]} - ${Api_Gouv.tVille[index]}"),
              ));
        },
      ),
    );
  }

  Widget CpV_dialog_Livr(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: gColors.LinearGradient1,
        child: Text("Code postal - Ville",
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
        height: 280,
        child: ListViewCpVille_Livr(Api_Gouv.tCp),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget DropdownButtonCivFact() {
    return Row(children: [
      Container(
        width: 74,
        child: Text("Civilité",
          style: gColors.bodySaisie_B_G,),
      ),
      Container(
        width: 12,
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Text(
          ":",
          style: gColors.bodySaisie_B_G,
        ),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text(
                'Séléctionner une civilité',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: DbTools.ListParam_ParamCiv.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
              value: textController_Contact_Civilite.text,
              onChanged: (value) {
                setState(() {
                  textController_Contact_Civilite.text = value!;
                  print("textController_Contact_Civilite $textController_Contact_Civilite.text");
                  setState(() {});
                });
              },
              buttonPadding: const EdgeInsets.only(left: 0, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }

  Widget DropdownButtonCivLIVR() {
    return Row(children: [
      Container(
        width: 74,
        child: Text("Civilité",
          style: gColors.bodySaisie_B_G,),
      ),
      Container(
        width: 12,
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Text(
          ":",
          style: gColors.bodySaisie_B_G,
        ),
      ),

      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: Text(
                'Séléctionner une civilité',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: DbTools.ListParam_ParamCiv.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
              value: textController_Livr_Contact_Civilite.text,
              onChanged: (value) {
                setState(() {
                  textController_Livr_Contact_Civilite.text = value!;
                  print("textController_Livr_Contact_Civilite $textController_Livr_Contact_Civilite.text");
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
