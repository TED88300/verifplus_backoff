import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Ctact_Site extends StatefulWidget {
  final VoidCallback onMaj;
  const Ctact_Site({Key? key, required this.onMaj}) : super(key: key);



  @override
  State<Ctact_Site> createState() => _Ctact_SiteState();
}

class _Ctact_SiteState extends State<Ctact_Site> {
  TextEditingController textController_Contact_Civilite = TextEditingController();
  TextEditingController textController_Contact_Prenom = TextEditingController();
  TextEditingController textController_Contact_Nom = TextEditingController();
  TextEditingController textController_Contact_Fonction = TextEditingController();
  TextEditingController textController_Contact_Service = TextEditingController();
  TextEditingController textController_Contact_Tel1 = TextEditingController();
  TextEditingController textController_Contact_Tel2 = TextEditingController();
  TextEditingController textController_Contact_eMail = TextEditingController();
  TextEditingController textController_Contact_Rem = TextEditingController();

  final Search_TextController = TextEditingController();

  Future initLib() async {
    DbTools.gContact = Contact.ContactInit();
    Search_TextController.text = "";
    await DbTools.getContactType(DbTools.gClient.ClientId, DbTools.gSite.SiteId, "SITE");
    Filtre();
    AlimSaisie();
  }

  Future Filtre() async {
    List<Contact> ListContactsearchresultTmp = [];
    ListContactsearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListContactsearchresultTmp.addAll(DbTools.ListContact);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListContact.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListContactsearchresultTmp.add(element);
        }
      });
    }

    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(ListContactsearchresultTmp);

    setState(() {});
  }

  void AlimSaisie() {
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
    return Container(

      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        color: Colors.white,

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
                  child: ContactGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.purple, Colors.white, Icons.keyboard_backspace, ToolsBarCtact, tooltip: "Adresse"),
                  ),

                ],
              ),
              ContentContactCadre(context),
            ],
          ),
        ],
      ),
    );
  }

  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "";
    DbTools.gViewAdr = "";
    widget.onMaj();
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
                  width: 10,
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

    await Filtre();
  }

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    await DbTools.addContactAdrType(DbTools.gClient.ClientId, DbTools.gSite.SiteId, "SITE");
    await DbTools.getContactType(DbTools.gClient.ClientId, DbTools.gSite.SiteId, "SITE");
    DbTools.getContactID(DbTools.gLastID);

    DbTools.gContact.Contact_Civilite = "M";
    DbTools.gContact.Contact_Prenom = "John";
    DbTools.gContact.Contact_Nom = "Doe";
    await DbTools.setContact(DbTools.gContact);

    print("ToolsBarAdd");
    await initLib();
  }

  Widget ContentContactCadre(BuildContext context) {
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
              'Contact',
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
                      Container(
                        width: 80,
                        child: Text(
                          "Site",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Text(
                        " : ",
                        style: gColors.bodySaisie_B_B,
                      ),

                      Text(
                        "${DbTools.gSite.Site_Nom}",
                        style: gColors.bodySaisie_B_B,
                      ),

                    ],
                  ),
                  DropdownButtonCiv(),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Prénom", textController_Contact_Prenom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Contact_Nom),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Fonction", textController_Contact_Fonction),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Service", textController_Contact_Service),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Tel Fixe", textController_Contact_Tel1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Portable", textController_Contact_Tel2),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "eMail", textController_Contact_eMail),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Contact_Rem, Ligne: 11),
                    ],
                  ),
                ]))));
  }

  Widget ContactGridWidget() {
    List<DaviColumn<Contact>> wColumns = [
      new DaviColumn(name: 'Civ.', width: 60, stringValue: (row) => "${row.Contact_Civilite}"),
      new DaviColumn(name: 'Nom', grow: 10, stringValue: (row) => "${row.Contact_Nom}"),
      new DaviColumn(name: 'Prenom', grow: 10, stringValue: (row) => "${row.Contact_Prenom}"),
      new DaviColumn(name: 'Fonction', grow: 2, stringValue: (row) => "${row.Contact_Fonction}"),
      new DaviColumn(name: 'Sercice', grow: 2, stringValue: (row) => row.Contact_Service),
      new DaviColumn(name: 'Fixe', grow: 1, stringValue: (row) => row.Contact_Tel1),
      new DaviColumn(name: 'Portable', grow: 1, stringValue: (row) => row.Contact_Tel2),
      new DaviColumn(name: 'eMail', grow: 5, stringValue: (row) => row.Contact_eMail),
    ];
    print("ContactGridWidget ${DbTools.ListContactsearchresult.length}");
    DaviModel<Contact>? _model;
    _model = DaviModel<Contact>(rows: DbTools.ListContactsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Contact>(visibleRowsCount: 18, _model, onRowTap: (Contact) async {
          DbTools.gContact = Contact;
          AlimSaisie();
        }),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

  Widget DropdownButtonCiv() {
    return Row(children: [
      Container(
        width: 84,
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
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }

}
