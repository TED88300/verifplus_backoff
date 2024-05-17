import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Client_Ctact extends StatefulWidget {
  const Client_Ctact({Key? key}) : super(key: key);

  @override
  State<Client_Ctact> createState() => _Client_CtactState();
}

class _Client_CtactState extends State<Client_Ctact> {
  TextEditingController textController_Contact_Civilite = TextEditingController();
  TextEditingController textController_Contact_Prenom = TextEditingController();
  TextEditingController textController_Contact_Nom = TextEditingController();
  TextEditingController textController_Contact_Fonction = TextEditingController();
  TextEditingController textController_Contact_Service = TextEditingController();
  TextEditingController textController_Contact_Tel1 = TextEditingController();
  TextEditingController textController_Contact_Tel2 = TextEditingController();
  TextEditingController textController_Contact_eMail = TextEditingController();
  TextEditingController textController_Contact_Rem = TextEditingController();

  List<String> ListAdresses = [];
  List<int> ListAdressesID = [];
  List<String> ListAdresses_Code = [];
  List<String> ListAdresses_Type = [];

  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  String FiltreFam = "Tous";
  String FiltreFamID = "";

  String selectedValueAdr = "";
  String selectedValueAdr_Code = "";
  String selectedValueAdr_Type = "";
  int selectedValueAdrID = 0;

  final Search_TextController = TextEditingController();

  void initLib() async {
    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);

    Search_TextController.text = "";
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFam[0];

    await DbTools.getAdresseClient(DbTools.gClient.ClientId);
    print("initLib getAdresseClient ${DbTools.ListAdresse.length}");
    ListAdresses.clear();
    ListAdresses_Code.clear();
    ListAdressesID.clear();
    ListAdresses_Type.clear();



    DbTools.ListAdresse.forEach((element) {
      ListAdresses.add("${element.Adresse_Code}/${element.Adresse_Type} - ${element.Adresse_CP} ${element.Adresse_Ville}");
      ListAdresses_Code.add(element.Adresse_Code);
      ListAdresses_Type.add(element.Adresse_Type);
      ListAdressesID.add(element.AdresseId);
    });

    await DbTools.getContactClient(DbTools.gClient.ClientId);
    print("initLib getContactClient ${DbTools.ListContact.length}");


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
    FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(FiltreFam)];
    if (FiltreFam.compareTo("Tous") == 0) {
      DbTools.ListContactsearchresult.addAll(ListContactsearchresultTmp);
    } else {
      ListContactsearchresultTmp.forEach((element) {
        print("FiltreFamID $FiltreFamID ${element.Contact_Type}");

        if (FiltreFamID.compareTo(element.Contact_Type) == 0) {
          DbTools.ListContactsearchresult.add(element);
          print("ADD");
        }
      });
    }

    DbTools.ListContactsearchresult.forEach((element) {
      print("element.Contact_Code ${element.Contact_Code}");
      element.Contact_Type_Lib = "";
      if (element.Contact_Code.isNotEmpty) {
        element.Contact_Type_Lib = ListAdresses[ListAdresses_Code.indexOf(element.Contact_Code)];

      }
    });



    setState(() {});
  }

  void AlimSaisie() {
    selectedValueAdr = ListAdresses[0];
    selectedValueAdr_Code = ListAdresses_Code[0];
    selectedValueAdr_Type = ListAdresses_Type[0];
    selectedValueAdrID = ListAdressesID[0];

    print("DbTools.gContact.Contact_Type ${DbTools.gContact.Contact_Code}");

    if (DbTools.gContact.Contact_Code.isNotEmpty) {
      selectedValueAdr_Code = DbTools.gContact.Contact_Code;
      selectedValueAdr = ListAdresses[ListAdresses_Code.indexOf(selectedValueAdr_Code)];
      selectedValueAdrID = ListAdressesID[ListAdresses_Code.indexOf(selectedValueAdr_Code)];
      selectedValueAdr_Type = ListAdresses_Type[ListAdresses_Code.indexOf(selectedValueAdr_Code)];

    }





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
                  child: ContactGridWidget(),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd),
              ),
              ContentContactCadre(context),
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
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave),
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
                    decoration:
                    gColors.wRechInputDecoration,
                    style: gColors.bodySaisie_B_B,
                  ),
                )),
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
                ),                Container(
                  width: 10,
                ),
                DropdownFiltreFam(),
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

    print("selectedValueAdr_Code $selectedValueAdr_Code");
    print("selectedValueAdrID $selectedValueAdrID");


    DbTools.gContact.Contact_Type = selectedValueAdr_Type;
    DbTools.gContact.Contact_Code = selectedValueAdr_Code;
    DbTools.gContact.Contact_AdresseId = selectedValueAdrID;
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
    await DbTools.addContact(DbTools.gClient.ClientId);
    DbTools.getContactID(DbTools.gLastID);
    AlimSaisie();
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
              'Contact ${DbTools.gContact.Contact_AdresseId}',
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
                          "Adresse",
                          style: gColors.bodySaisie_B_G,
                        ),
                      ),
                      Text(
                        " : ",
                        style: gColors.bodySaisie_B_B,
                      ),

                    ],

                  ),
                  gColors.DropdownButtonFam(0, 0, "", selectedValueAdr, (sts) {
                    setState(() {
                      selectedValueAdr = sts!;
                      selectedValueAdr_Code = ListAdresses_Code[ListAdresses.indexOf(selectedValueAdr)];
                      selectedValueAdr_Type = ListAdresses_Type[ListAdresses.indexOf(selectedValueAdr)];
                      selectedValueAdrID = ListAdressesID[ListAdresses.indexOf(selectedValueAdr_Code)];

                      print("onCHANGE selectedValueAdr $selectedValueAdr");
                      print("onCHANGE selectedValueAdr_Code $selectedValueAdr_Code");
                      print("onCHANGE selectedValueAdr_Type $selectedValueAdr_Type");
                      print("onCHANGE selectedValueAdrID $selectedValueAdrID");
                    });
                  }, ListAdresses, ListAdresses_Type),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Civilité", textController_Contact_Civilite),
                    ],
                  ),
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
                      gColors.TxtField(80, 40, "Remarque", textController_Contact_Rem, Ligne: 5),
                    ],
                  ),
                ]))));
  }

  Widget ContactGridWidget() {
    List<DaviColumn<Contact>> wColumns = [
//      new DaviColumn(name: 'Code', width: 60, stringValue: (row) => "${row.Contact_Code}"),
      new DaviColumn(name: 'Adresse', grow: 15, stringValue: (row) => "${row.Contact_Type_Lib}"),
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
        child: new Davi<Contact>(visibleRowsCount: 16, _model, onRowTap: (Contact) async {
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

  Widget DropdownFiltreFam() {
    print(">>>>>>>>>>>> DropdownFiltreFam ${FiltreFam.length}");
    if (ListParam_FiltreFam.length == 0) return Container();
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("Type : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une Famille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_FiltreFam.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: FiltreFam,
          onChanged: (value) async {
            setState(() {
              FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(value!)];
              FiltreFam = value;
              print(">>>>>>>>>>>>>>>>> FiltreFam $FiltreFamID $FiltreFam");
              Filtre();
            });
          },
          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          buttonHeight: 30,
          buttonWidth: 230,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        )),
      ),
    ]);
  }
}
