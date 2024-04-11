import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Adresses.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Agences extends StatefulWidget {

  const Agences({Key? key}) : super(key: key);

  @override
  State<Agences> createState() => _AgencesState();
}

class _AgencesState extends State<Agences> {
  TextEditingController textController_Agence_Code = TextEditingController();
  TextEditingController textController_Agence_Type = TextEditingController();
  TextEditingController textController_Agence_Nom = TextEditingController();
  TextEditingController textController_Agence_Adr1 = TextEditingController();
  TextEditingController textController_Agence_Adr2 = TextEditingController();
  TextEditingController textController_Agence_Adr3 = TextEditingController();
  TextEditingController textController_Agence_Adr4 = TextEditingController();
  TextEditingController textController_Agence_CP = TextEditingController();
  TextEditingController textController_Agence_Ville = TextEditingController();
  TextEditingController textController_Agence_Pays = TextEditingController();
  TextEditingController textController_Agence_Acces = TextEditingController();
  TextEditingController textController_Agence_Rem = TextEditingController();

  List<Adresse> ListAgence = [];
  List<Adresse> ListAgencesearchresult = [];

  Adresse gAgence = Adresse.AdresseInit();
  

  final Search_TextController = TextEditingController();
  Future Reload() async {
    await DbTools.getAdresseType( "AGENCE");
    await Filtre();
  }

  void initLib() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Agences");

    await Reload();
    await AlimSaisie();
  }

  Future Filtre() async {
    List<Adresse> ListAgencesearchresultTmp = [];
    ListAgencesearchresultTmp.clear();

    ListAgence =  DbTools.ListAdresse;

    print("_buildFieldTextSearch ListAgence ${ListAgence.length}");


    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListAgencesearchresultTmp.addAll(ListAgence);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      ListAgence.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListAgencesearchresultTmp.add(element);
        }
      });
    }
    ListAgencesearchresult.clear();
    ListAgencesearchresult.addAll(ListAgencesearchresultTmp);


    print("_buildFieldTextSearch ListAgencesearchresult ${ListAgencesearchresult.length}");


    setState(() {});
  }

  Future AlimSaisie() async {
    print("AlimSaisie ${gAgence.Desc()}");


    textController_Agence_Code.text = gAgence.Adresse_Code;
    textController_Agence_Nom.text = gAgence.Adresse_Nom;
    textController_Agence_Adr1.text = gAgence.Adresse_Adr1;
    textController_Agence_Adr2.text = gAgence.Adresse_Adr2;
    textController_Agence_Adr3.text = gAgence.Adresse_Adr3;
    textController_Agence_Adr4.text = gAgence.Adresse_Adr4;
    textController_Agence_CP.text = gAgence.Adresse_CP;
    textController_Agence_Ville.text = gAgence.Adresse_Ville;
    textController_Agence_Pays.text = gAgence.Adresse_Pays;
    textController_Agence_Acces.text = gAgence.Adresse_Acces;
    textController_Agence_Rem.text = gAgence.Adresse_Rem;





    setState(() {});


  }

  void ToolsBarCpy() async {
    print("ToolsBarCpy");

    textController_Agence_Adr1.text =   gAgence.Adresse_Adr1 ;
    textController_Agence_Adr2.text =   gAgence.Adresse_Adr2 ;
    textController_Agence_Adr3.text =   gAgence.Adresse_Adr3 ;
    textController_Agence_Adr4.text =   gAgence.Adresse_Adr4 ;
    textController_Agence_CP.text =     gAgence.Adresse_CP   ;
    textController_Agence_Ville.text =  gAgence.Adresse_Ville;
    textController_Agence_Pays.text =   gAgence.Adresse_Pays ;
    textController_Agence_Acces.text =   gAgence.Adresse_Acces ;
    textController_Agence_Rem.text =    gAgence.Adresse_Rem  ;
    setState(() {});
  }




  void initState() {



    initLib();
    super.initState();
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: AgenceGridWidget(),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip: "Ajouter agence"),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.green, Colors.white, Icons.copy, ToolsBarCpy , tooltip: "Copier adresse Livraison"),
                  ),


                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child:
                    CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  ),
                ],
              ),
              ContentAgenceCadre(context),
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

  void ToolsBarAdr() async {
    print("ToolsBarAdr");
    DbTools.gViewAdr = "Agence";
    DbTools.gViewCtact = "";
  }


  void ToolsBarCtact() async {
    print("ToolsBarCtact");
    DbTools.gViewCtact = "Agence";
    DbTools.gViewAdr = "";
  }



  void ToolsBarSave() async {
    print("ToolsBarSave");

    gAgence.Adresse_Code = textController_Agence_Code.text;
    gAgence.Adresse_Nom = textController_Agence_Nom.text;
    gAgence.Adresse_Adr1 = textController_Agence_Adr1.text;
    gAgence.Adresse_Adr2 = textController_Agence_Adr2.text;
    gAgence.Adresse_Adr3 = textController_Agence_Adr3.text;
    gAgence.Adresse_Adr4 = textController_Agence_Adr4.text;
    gAgence.Adresse_CP = textController_Agence_CP.text;
    gAgence.Adresse_Ville = textController_Agence_Ville.text;
    gAgence.Adresse_Pays = textController_Agence_Pays.text;
    gAgence.Adresse_Acces = textController_Agence_Acces.text;
    gAgence.Adresse_Rem = textController_Agence_Rem.text;


    await DbTools.setAdresse(gAgence);

    await Reload();

    setState(() {});
  }

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    await DbTools.addAdresse(DbTools.gClient.ClientId, "AGENCE");

    print("DbTools.gLastID ${DbTools.gLastID}");

    await Reload();
    DbTools.getAdresseID(DbTools.gLastID);
    AlimSaisie();
  }

  Widget ContentAgenceCadre(BuildContext context) {
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
              ContentAgence(context),
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
              'Agence',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentAgence(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(children: [


                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code", textController_Agence_Code),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Nom", textController_Agence_Nom),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Adresse", textController_Agence_Adr1),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Agence_Adr2, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Agence_Adr3, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "", textController_Agence_Adr4, sep: ""),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 10, "CP", textController_Agence_CP),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Ville", textController_Agence_Ville),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Pays", textController_Agence_Pays),
                    ],
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Code Accès", textController_Agence_Acces),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      gColors.TxtField(80, 40, "Remarque", textController_Agence_Rem, Ligne: 10),
                    ],
                  ),
                ]))));
  }

  Widget AgenceGridWidget() {
    List<DaviColumn<Adresse>> wColumns = [
      new DaviColumn(name: 'Code', width: 100, stringValue: (row) => row.Adresse_Code),
      new DaviColumn(name: 'Nom', width: 450, stringValue: (row) => row.Adresse_Nom),
      new DaviColumn(name: 'Adresse', width: 450, stringValue: (row) => "${row.Adresse_Adr1}"),
      new DaviColumn(name: 'Cp', width: 100, stringValue: (row) => "${row.Adresse_CP}"),
      new DaviColumn(name: 'Ville', width: 320, stringValue: (row) => "${row.Adresse_Ville}"),
    ];
    print("AdresseGridWidget ${ListAgencesearchresult.length}");
    DaviModel<Adresse>? _model;
    _model = DaviModel<Adresse>(rows: ListAgencesearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Adresse>(visibleRowsCount: 16, _model, onRowTap: (Adresse) async {
          gAgence = Adresse;
          AlimSaisie();
        }),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 28,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }


}
