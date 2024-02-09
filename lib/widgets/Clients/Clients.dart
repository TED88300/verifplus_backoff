import 'dart:js_interop';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Dialog.dart';

class Clients_screen extends StatefulWidget {
  @override
  _Clients_screenState createState() => _Clients_screenState();
}

class _Clients_screenState extends State<Clients_screen> {
  Client wClient = Client.ClientInit();
  String Title = "Verif+ : Paramètres ";
  bool bReload = true;

  final Search_TextController = TextEditingController();

  String FiltreFam = "Tous";
  String FiltreFamID = "";
  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  List<String> ListParam_FiltreDepot = [];
  List<String> ListParam_FiltreDepotID = [];
  String FiltreDepot = "";
  String FiltreDepotID = "";

  Future Reload() async {
    await DbTools.getParam_ParamFam("FamClient");

    ListParam_FiltreFam.clear();
    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);

    await DbTools.getParam_ParamFam("Type_Depot");
    ListParam_FiltreDepot.clear();
    ListParam_FiltreDepot.addAll(DbTools.ListParam_FiltreFam);
    ListParam_FiltreDepotID.clear();
    ListParam_FiltreDepotID.addAll(DbTools.ListParam_FiltreFamID);

    Search_TextController.text = "";
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFam[0];

    FiltreDepot = ListParam_FiltreDepot[0];
    FiltreDepotID = ListParam_FiltreDepotID[0];

    await DbTools.getClientAll();
    bReload = false;
    print("Reload getClientAll ${DbTools.ListClient.length}");
    await Filtre();
  }

  Future Filtre() async {
    List<Client> ListClientsearchresultTmp = [];
    ListClientsearchresultTmp.clear();

    List<Client> ListClientsearchresultTmp2 = [];
    ListClientsearchresultTmp2.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListClientsearchresultTmp.addAll(DbTools.ListClient);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListClient.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListClientsearchresultTmp.add(element);
        }
      });
    }

    ListClientsearchresultTmp2.clear();
    FiltreDepotID = ListParam_FiltreDepotID[ListParam_FiltreDepot.indexOf(FiltreDepot)];

    if (FiltreDepot.compareTo("Tous") == 0) {
      ListClientsearchresultTmp2.addAll(ListClientsearchresultTmp);
    } else {
      ListClientsearchresultTmp.forEach((element) {
        print("FiltreDepot  $FiltreDepot ${element.Client_Depot}");

        if (FiltreDepot.compareTo(element.Client_Depot) == 0) {
          print("ADD  $FiltreDepot ${element.Client_Depot}");
          ListClientsearchresultTmp2.add(element);
        }
      });
    }

    DbTools.ListClientsearchresult.clear();
    FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(FiltreFam)];

    if (FiltreFam.compareTo("Tous") == 0) {
      DbTools.ListClientsearchresult.addAll(ListClientsearchresultTmp2);
    } else {
      ListClientsearchresultTmp2.forEach((element) {
        if (FiltreFamID.compareTo(element.Client_Famille) == 0) DbTools.ListClientsearchresult.add(element);
      });
    }

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();
    await Reload();
  }

  List<PlutoMenuItem> HoverMenus = [];
  late Widget wPlutoMenuBar;

  void initState() {
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


    initLib();
    Title = "Verif+ : Clients ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolsBar(context),
          Container(
            height: 10,
          ),
          ClientGridWidget(),
        ],
      ),
    );
  }

  Widget ClientGridWidget() {
    List<DaviColumn<Client>> wColumns = [
      new DaviColumn(name: 'Id', width: 60, stringValue: (row) => "${row.ClientId}"),
      new DaviColumn(name: 'Forme', width: 100, stringValue: (row) => "${row.Client_Civilite}"),
      new DaviColumn(name: 'Raison Social', width: 500, stringValue: (row) => "${row.Client_Nom}"),
      new DaviColumn(name: 'Code', width: 250, stringValue: (row) => "${row.Client_Depot}"),
      new DaviColumn(name: 'Famille', width: 150, stringValue: (row) => "${(row.Client_Famille.isEmpty || ListParam_FiltreFamID.indexOf(row.Client_Famille) == -1) ? '' : ListParam_FiltreFam[ListParam_FiltreFamID.indexOf(row.Client_Famille)]}"),
      new DaviColumn(name: 'Commercial', width: 300, stringValue: (row) => row.Client_Commercial),
      new DaviColumn(name: 'CP', width: 100, stringValue: (row) => row.Adresse_CP),
      new DaviColumn(name: 'Ville', width: 400, stringValue: (row) => row.Adresse_Ville),
      new DaviColumn(name: 'Pays', width: 250, stringValue: (row) => row.Adresse_Pays),
    ];

    print("ClientGridWidget");
    DaviModel<Client>? _model;
    _model = DaviModel<Client>(rows: DbTools.ListClientsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Client>(_model, visibleRowsCount: 24, onRowTap: (Client) async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => new Client_Dialog(client: Client),
          );
          print("APRES Client_Dialog");
          await Reload();
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

//**********************************
//**********************************
//**********************************

  void ToolsBarAdd() async {
    print("ToolsBarAdd");

    Client wClient = await Client.ClientInit();
    await DbTools.addClient(wClient);
    wClient.ClientId = DbTools.gLastID;
    wClient.Client_Nom = "???";
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Client_Dialog(client: wClient),
    );
    await Reload();
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          children: [
            CommonAppBar.SquareRoundIcon(context, 40, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd, tooltip :"Ajouter un client"),
            Container(
              width: 10,
            ),
            Icon(
              Icons.search,
              color: Colors.blue,
              size: 40.0,
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
            DropdownFiltreDepot(),
            Container(
              width: 10,
            ),
          ],
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
          onChanged: (value) {
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

  Widget DropdownFiltreDepot() {
    print(">>>>>>>>>>>> DropdownFiltreDepot ${FiltreDepot.length}");
    if (ListParam_FiltreDepot.length == 0) return Container();
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("Dépot : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une Depot',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_FiltreDepot.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: FiltreDepot,
          onChanged: (value) {
            setState(() {
              FiltreDepotID = ListParam_FiltreDepotID[ListParam_FiltreDepot.indexOf(value!)];
              FiltreDepot = value;
              print(">>>>>>>>>>>>>>>>> FiltreDepot $FiltreDepotID $FiltreDepot");
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
          buttonWidth: 330,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        )),
      ),
    ]);
  }
}


