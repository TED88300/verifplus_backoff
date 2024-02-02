import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Adresses.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Client_Adr extends StatefulWidget {
  const Client_Adr({Key? key}) : super(key: key);

  @override
  State<Client_Adr> createState() => _Client_AdrState();
}

class _Client_AdrState extends State<Client_Adr> {
  TextEditingController textController_Adresse_Code = TextEditingController();
  TextEditingController textController_Adresse_Type = TextEditingController();
  TextEditingController textController_Adresse_Nom = TextEditingController();
  TextEditingController textController_Adresse_Adr1 = TextEditingController();
  TextEditingController textController_Adresse_Adr2 = TextEditingController();
  TextEditingController textController_Adresse_Adr3 = TextEditingController();
  TextEditingController textController_Adresse_CP = TextEditingController();
  TextEditingController textController_Adresse_Ville = TextEditingController();
  TextEditingController textController_Adresse_Pays = TextEditingController();
  TextEditingController textController_Adresse_Rem = TextEditingController();

  List<String> ListParam_ParamFam = [];
  List<String> ListParam_ParamFamID = [];

  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  String FiltreFam = "Tous";
  String FiltreFamID = "";

  String selectedValueFam = "";
  String selectedValueFamID = "";

  final Search_TextController = TextEditingController();
  Future Reload() async {
    await DbTools.getAdresseClient(DbTools.gClient.ClientId);
    print("initLib getAdresseClient ${DbTools.ListAdresse.length}");
    await Filtre();
  }

  void initLib() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Client_Adr");

    await DbTools.getParam_ParamFam("TypeAdr");
    ListParam_ParamFam.clear();
    ListParam_ParamFam.addAll(DbTools.ListParam_ParamFam);
    ListParam_ParamFamID.clear();
    ListParam_ParamFamID.addAll(DbTools.ListParam_ParamFamID);

    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);

    Search_TextController.text = "";
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFamID[0];

    for (int i = 0; i < ListParam_FiltreFam.length; i++) {
      String wFiltreFam = ListParam_FiltreFam[i];
      if (DbTools.gViewAdr.compareTo(wFiltreFam) == 0) {
        FiltreFam = ListParam_FiltreFam[i];
        FiltreFamID = ListParam_FiltreFamID[i];
        break;
      }
    }


    print(">>>>>> FiltreFamID $FiltreFamID");


    await Reload();
    await AlimSaisie();
  }

  Future Filtre() async {
    List<Adresse> ListAdressesearchresultTmp = [];
    ListAdressesearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListAdressesearchresultTmp.addAll(DbTools.ListAdresse);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListAdresse.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListAdressesearchresultTmp.add(element);
        }
      });
    }
    DbTools.ListAdressesearchresult.clear();
    FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(FiltreFam)];

    if (FiltreFam.compareTo("Tous") == 0) {
      DbTools.ListAdressesearchresult.addAll(ListAdressesearchresultTmp);
    } else {
      ListAdressesearchresultTmp.forEach((element) {
        if (FiltreFamID.compareTo(element.Adresse_Type) == 0) DbTools.ListAdressesearchresult.add(element);
      });
    }

    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${DbTools.gAdresse.Desc()}");

    selectedValueFam = ListParam_ParamFam[0];
    selectedValueFamID = ListParam_ParamFamID[0];

    if (DbTools.gAdresse.Adresse_Type.isNotEmpty) {
      selectedValueFamID = DbTools.gAdresse.Adresse_Type;
      selectedValueFam = ListParam_ParamFam[ListParam_ParamFamID.indexOf(selectedValueFamID)];
    }

    textController_Adresse_Code.text = DbTools.gAdresse.Adresse_Code;
    textController_Adresse_Type.text = DbTools.gAdresse.Adresse_Type;
    textController_Adresse_Nom.text = DbTools.gAdresse.Adresse_Nom;
    textController_Adresse_Adr1.text = DbTools.gAdresse.Adresse_Adr1;
    textController_Adresse_Adr2.text = DbTools.gAdresse.Adresse_Adr2;
    textController_Adresse_Adr3.text = DbTools.gAdresse.Adresse_Adr3;
    textController_Adresse_CP.text = DbTools.gAdresse.Adresse_CP;
    textController_Adresse_Ville.text = DbTools.gAdresse.Adresse_Ville;
    textController_Adresse_Pays.text = DbTools.gAdresse.Adresse_Pays;
    textController_Adresse_Rem.text = DbTools.gAdresse.Adresse_Rem;
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
                  child: AdresseGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave),
                  ),
                ],
              ),
              ContentAdresseCadre(context),
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
    print("ToolsBarSave");

    DbTools.gAdresse.Adresse_Code = textController_Adresse_Code.text;

    DbTools.gAdresse.Adresse_Type = textController_Adresse_Type.text;
    DbTools.gAdresse.Adresse_Type = selectedValueFamID;

    DbTools.gAdresse.Adresse_Nom = textController_Adresse_Nom.text;
    DbTools.gAdresse.Adresse_Adr1 = textController_Adresse_Adr1.text;
    DbTools.gAdresse.Adresse_Adr2 = textController_Adresse_Adr2.text;
    DbTools.gAdresse.Adresse_Adr3 = textController_Adresse_Adr3.text;
    DbTools.gAdresse.Adresse_CP = textController_Adresse_CP.text;
    DbTools.gAdresse.Adresse_Ville = textController_Adresse_Ville.text;
    DbTools.gAdresse.Adresse_Pays = textController_Adresse_Pays.text;
    DbTools.gAdresse.Adresse_Rem = textController_Adresse_Rem.text;

    await DbTools.setAdresse(DbTools.gAdresse);


    setState(() {});
  }

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    await DbTools.addAdresse(DbTools.gClient.ClientId, FiltreFamID);
    print("DbTools.gLastID ${DbTools.gLastID}");
    await Reload();
    DbTools.getAdresseID(DbTools.gLastID);



    AlimSaisie();
  }

  Widget ContentAdresseCadre(BuildContext context) {
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
              ContentAdresse(context),
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
              'Adresse ${DbTools.gViewAdr}',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentAdresse(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code", textController_Adresse_Code),
                    ],
                  ),
                  DbTools.gViewAdr.isEmpty
                      ? Container()
                      : Container(
                    height: 3,
                  ),

                  gColors.DropdownButtonFam(80, 8, "Type", selectedValueFam, (sts) {
                    setState(() {
                      selectedValueFam = sts!;
                      selectedValueFamID = ListParam_ParamFamID[ListParam_ParamFam.indexOf(selectedValueFam)];
                      print("onCHANGE selectedValueFam $selectedValueFam");
                      print("onCHANGE selectedValueFamID $selectedValueFamID");
                    });
                  }, ListParam_ParamFam, ListParam_ParamFamID),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Adresse_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Adresse", textController_Adresse_Adr1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Adresse_Adr2, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Adresse_Adr3, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 10, "CP", textController_Adresse_CP),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Ville", textController_Adresse_Ville),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Adresse_Rem, Ligne: 12),
                    ],
                  ),
                ]))));
  }

  Widget AdresseGridWidget() {
    List<EasyTableColumn<Adresse>> wColumns = [
      new EasyTableColumn(name: 'Code', grow: 1, stringValue: (row) => row.Adresse_Code),
      new EasyTableColumn(name: 'Type', grow: 1, stringValue: (row) => row.Adresse_Type),
      new EasyTableColumn(name: 'Nom', grow: 1, stringValue: (row) => row.Adresse_Nom),
      new EasyTableColumn(name: 'Adresse', grow: 10, stringValue: (row) => "${row.Adresse_Adr1}"),
      new EasyTableColumn(name: 'Cp', grow: 1, stringValue: (row) => "${row.Adresse_CP}"),
      new EasyTableColumn(name: 'Ville', grow: 5, stringValue: (row) => "${row.Adresse_Ville}"),
    ];
    print("AdresseGridWidget ${DbTools.ListAdressesearchresult.length}");
    EasyTableModel<Adresse>? _model;
    _model = EasyTableModel<Adresse>(rows: DbTools.ListAdressesearchresult, columns: wColumns);
    return new EasyTableTheme(
        child: new EasyTable<Adresse>(visibleRowsCount: 16, _model, onRowTap: (Adresse) async {
          DbTools.gAdresse = Adresse;
          AlimSaisie();
        }),
        data: EasyTableThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColor: Colors.black, expandableName: false),
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
        child: Text("Fam : "),
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
