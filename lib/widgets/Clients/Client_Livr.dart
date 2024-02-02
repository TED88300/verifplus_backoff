
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Map_Dialog.dart';


class Client_Livr extends StatefulWidget {

  const Client_Livr({Key? key}) : super(key: key);

  @override
  State<Client_Livr> createState() => _Client_LivrState();
}

class _Client_LivrState extends State<Client_Livr> {


  TextEditingController textController_Adresse_Geo = TextEditingController();
  TextEditingController textController_Adresse_Adr1 = TextEditingController();
  TextEditingController textController_Adresse_Adr2 = TextEditingController();
  TextEditingController textController_Adresse_Adr3 = TextEditingController();
  TextEditingController textController_Adresse_CP = TextEditingController();
  TextEditingController textController_Adresse_Ville = TextEditingController();
  TextEditingController textController_Adresse_Pays = TextEditingController();
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

  String selectedValueFam = "";
  String selectedValueFamID = "";

  void initLib() async {
    await DbTools.getAdresseClientType(DbTools.gClient.ClientId, "LIVR");
    await DbTools.getContactClientAdrType(DbTools.gClient.ClientId, DbTools.gAdresse.AdresseId, "LIVR");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DbTools.ListContact ${DbTools.ListContact.length}");


    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DbTools.ListContact ${DbTools.ListContact[0].Contact_Nom}");


    AlimSaisie();
  }

  void AlimSaisie() {
    textController_Adresse_Geo.text = "${DbTools.gAdresse.Adresse_Adr1} ${DbTools.gAdresse.Adresse_CP} ${DbTools.gAdresse.Adresse_Ville}";

    textController_Adresse_Adr1.text = DbTools.gAdresse.Adresse_Adr1;
    textController_Adresse_Adr2.text = DbTools.gAdresse.Adresse_Adr2;
    textController_Adresse_Adr3.text = DbTools.gAdresse.Adresse_Adr3;
    textController_Adresse_CP.text = DbTools.gAdresse.Adresse_CP;
    textController_Adresse_Ville.text = DbTools.gAdresse.Adresse_Ville;
    textController_Adresse_Pays.text = DbTools.gAdresse.Adresse_Pays;
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
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LIVR build");

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
          ContentAdresseCadre(context),
          ContentContactCadre(context),
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
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave),
                Container(
                  width: 10,
                ),
                Container(
                  width: 850,
                  child: AutoAdresse(80, 120, "Recherche", textController_Adresse_Geo),
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_forward, ToolsBarCopySearch),
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

  void ToolsBarSave() async {
    print("ToolsBarSave");

    DbTools.gAdresse.Adresse_Adr1 = textController_Adresse_Adr1.text;
    DbTools.gAdresse.Adresse_Adr2 = textController_Adresse_Adr2.text;
    DbTools.gAdresse.Adresse_Adr3 = textController_Adresse_Adr3.text;
    DbTools.gAdresse.Adresse_CP = textController_Adresse_CP.text;
    DbTools.gAdresse.Adresse_Ville = textController_Adresse_Ville.text;
    DbTools.gAdresse.Adresse_Pays = textController_Adresse_Pays.text;
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
    setState(() {});
  }

  void ToolsBarCopySearch() async {
    print("ToolsBarCopySearch ${Api_Gouv.gProperties.toJson()}");
    textController_Adresse_Adr1.text = Api_Gouv.gProperties.name!;
    textController_Adresse_CP.text = Api_Gouv.gProperties.postcode!;
    textController_Adresse_Ville.text = Api_Gouv.gProperties.city!;
  }

  Widget ContentAdresseCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: ContentAdresse(context),
        ),
        Positioned(
          left: 50,
          top: 12,
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

  Widget ContentAdresse(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(children: [
              gColors.TxtField(80, 120, "Adresse", textController_Adresse_Adr1),
              gColors.TxtField(80, 120, "", textController_Adresse_Adr2, sep: ""),
              gColors.TxtField(80, 120, "", textController_Adresse_Adr3, sep: ""),
              Row(
                children: [
                  gColors.TxtField(80, 10, "Code postal", textController_Adresse_CP),
                  gColors.TxtField(-1, 100, "Ville", textController_Adresse_Ville),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.question_mark, CpVillmeSearch),
                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.map_outlined, MapDialog),


                ],
              )
            ])));
  }

  void MapDialog() async {

    MapTools.gMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");

    await Client_Map_Dialog.Client_Map_dialog(context, "${textController_Adresse_Adr1.text} ${textController_Adresse_CP.text} ${textController_Adresse_Ville.text}" );

    if (MapTools.gMapTools_Geocoding.Geo_formattedAddress.isNotEmpty)
      {
        String address ="";
        String street ="";
        String postcode  ="";
        String city ="";


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

        print("address  $address ");
        print("street  $street ");
        print("postcode   $postcode  ");
        print("city  $city ");

        textController_Adresse_Adr1.text = "$address $street ";
        textController_Adresse_CP.text = postcode;
        textController_Adresse_Ville.text = city;



      }




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

  Widget ContentContactCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
              ContentContact(context),
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
              'Contact de Livraison',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentContact(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  Row(
                    children: [
                      gColors.TxtField(80, 20, "Civilité", textController_Contact_Civilite),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 120, "Prénom", textController_Contact_Prenom),
                      gColors.TxtField(80, 120, "Nom", textController_Contact_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 120, "Fonction", textController_Contact_Fonction),
                      gColors.TxtField(80, 120, "Service", textController_Contact_Service),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 120, "Tel Fixe", textController_Contact_Tel1),
                      gColors.TxtField(80, 120, "Portable", textController_Contact_Tel2),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 120, "eMail", textController_Contact_eMail),
                    ],
                  ),
                ]))));
  }
}
