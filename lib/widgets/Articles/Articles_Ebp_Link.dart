import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Link_Ebp.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
//113 Poudre ABC 6kg


class Articles_Ebp_Link extends StatefulWidget {
  @override
  Articles_Ebp_LinkState createState() => Articles_Ebp_LinkState();
}

class Articles_Ebp_LinkState extends State<Articles_Ebp_Link> {
  DaviModel<Articles_Link_Ebp>? _model;

  final Search_TextController = TextEditingController();

  String FiltreType = "Tous";
  String FiltreTypeID = "Tous";
  List<String> ListParam_FiltreType =     ["Tous", "V",     "P",      "S" ,   "ES", "Serv"];
  List<String> ListParam_FiltreTypeLib =  ["Tous", "Vérif", "Pièce",  "Sign" ,"Ech Std", "Serv."];

  bool bReload = true;
  Article_Ebp getArticle(String articleCodearticle){
    Article_Ebp warticleEbp = Article_Ebp.Article_EbpInit();
    try {
      warticleEbp = DbTools.ListArticle_Ebp.firstWhere((element) => articleCodearticle == element.Article_codeArticle);
    } catch (e) {

    }
    if (warticleEbp.Article_descriptionCommercialeEnClair.isEmpty)
      warticleEbp.Article_descriptionCommercialeEnClair = "*** Inconnu ****";

    return warticleEbp;
  }

  Future Reload() async {
    Search_TextController.text = "";

    await DbTools.getArticle_EbpAll();

    await DbTools.getArticles_Link_EbpAll(DbTools.gArticle_Ebp.Article_codeArticle);
    print("ListArticles_Link_Ebp ${DbTools.ListArticles_Link_Ebp.length}");
    for (int i = 0; i < DbTools.ListArticles_Link_Ebp.length; i++) {

      Articles_Link_Ebp element = DbTools.ListArticles_Link_Ebp[i];
      Article_Ebp warticleEbp = getArticle(element.Articles_Link_ChildID);
      DbTools.ListArticles_Link_Ebp[i].Articles_Link_ChildID_Lib = warticleEbp.Article_descriptionCommercialeEnClair;

      if (element.Articles_Link_MoID.isNotEmpty)
        {
          Article_Ebp warticleEbpMo = getArticle(element.Articles_Link_MoID);
          DbTools.ListArticles_Link_Ebp[i].Articles_Link_MoID_Lib = warticleEbpMo.Article_descriptionCommercialeEnClair;
        }
      if (element.Articles_Link_DnID.isNotEmpty)
        {
          Article_Ebp warticleEbpDn = getArticle(element.Articles_Link_DnID);
          DbTools.ListArticles_Link_Ebp[i].Articles_Link_DnID_Lib = warticleEbpDn.Article_descriptionCommercialeEnClair;

        }


    }


    await Filtre();


    bReload = false;
    print("Reload getClientAll ${DbTools.ListClient.length}");
    setState(() {});
  }

  Future Filtre() async {

    List<Articles_Link_Ebp> listarticlesLinkEbpsearchresult = [];
    listarticlesLinkEbpsearchresult.clear();

    print("Filtre ${Search_TextController.text}");
    if (Search_TextController.text.isEmpty) {
      listarticlesLinkEbpsearchresult.addAll(DbTools.ListArticles_Link_Ebp);
    } else {
      DbTools.ListArticles_Link_Ebp.forEach((element) {
        String wSearch = "${element.Desc()}";
        if (wSearch.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          listarticlesLinkEbpsearchresult.add(element);
        }
      });
    }

    DbTools.ListArticles_Link_Ebpsearchresult.clear();
    if (FiltreType.compareTo("Tous") == 0) {
      DbTools.ListArticles_Link_Ebpsearchresult.addAll(listarticlesLinkEbpsearchresult);
    } else {
      listarticlesLinkEbpsearchresult.forEach((element) {
        if (FiltreTypeID.compareTo(element.Articles_Link_TypeChildID) == 0) DbTools.ListArticles_Link_Ebpsearchresult.add(element);
      });
    }




    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();
    await Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {

    print("build");
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolsBar(context),
          Container(
            height: 10,
          ),
          Article_EbpGridWidget(),
        ],
      ),
    );

    return
      Article_EbpGridWidget();
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Article_EbpGridWidget() {
    List<DaviColumn<Articles_Link_Ebp>> wColumns = [
      new DaviColumn(name: 'Id', width : 60, stringValue: (row) => "${row.Articles_LinkId}"),
//      new DaviColumn(name: 'Type', width : 90, stringValue: (row) => "${row.Articles_Link_TypeChildID}"),
      new DaviColumn(name: 'Code', width : 120, stringValue: (row) => "${row.Articles_Link_ChildID}"),
      new DaviColumn(name: 'Description', grow : 100,  stringValue: (row) => row.Articles_Link_ChildID_Lib.replaceAll("\n", "").replaceAll("\r", "")),
/*
      new DaviColumn(name: "Main d'Œuvre", width : 120, stringValue: (row) => "${row.Articles_Link_MoID}"),
      new DaviColumn(name: 'Description', grow : 100,  stringValue: (row) => row.Articles_Link_MoID_Lib.replaceAll("\n", "").replaceAll("\r", "")),
      new DaviColumn(name: 'Temps', width : 100,  stringValue: (row) => row.Articles_Link_Tps, cellAlignment : Alignment.centerRight),
      new DaviColumn(name: "Dénaturation", width : 120, stringValue: (row) => "${row.Articles_Link_DnID}"),
      new DaviColumn(name: 'Description', grow : 100,  stringValue: (row) => row.Articles_Link_DnID_Lib.replaceAll("\n", "").replaceAll("\r", "")),
*/


    ];
    _model = DaviModel<Articles_Link_Ebp>(rows: DbTools.ListArticles_Link_Ebpsearchresult,       columns: wColumns,);


    return new DaviTheme(
        child: new Davi<Articles_Link_Ebp>(
          _model,
          visibleRowsCount: 28,
          onRowTap: (articlesLinkEbp) => _onRowTap(context, articlesLinkEbp),

        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        )


    );
  }

//**********************************
//**********************************
//**********************************
  void _onRowTap(BuildContext context, Articles_Link_Ebp articlesLinkEbp) async {
    DbTools.gArticles_Link_Ebp = articlesLinkEbp;
//    await Navigator.push(context, MaterialPageRoute(builder: (context) => Articles_Ebp_Edit(Articles_Link_Ebp: Articles_Link_Ebp)));
    Reload();
  }

  void columnInResizing(BuildContext context, DaviColumn<Articles_Link_Ebp> wColumn) async {

  }
  void onHover(int i) async {

  }


//**********************************
//**********************************
//**********************************




  Widget ToolsBar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
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
                      await Filtre();
                    },
                    decoration:gColors.wRechInputDecoration,
                    style: gColors.bodySaisie_B_B,
                  ),
                )),
            Container(
              width: 10,
            ),
        /*    IconButton(
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
            DropdownFiltreType(),
            Container(
              width: 10,
            ),*/
          ],
        ));
  }

  Widget DropdownFiltreType() {
    print(">>>>>>>>>>>> DropdownFiltreType ${FiltreType.length}");
    if (ListParam_FiltreTypeLib.length == 0) return Container();
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
                'Séléctionner une Typeille',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: ListParam_FiltreTypeLib.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
              value: FiltreType,
              onChanged: (value) {
                setState(() {
                  FiltreTypeID = ListParam_FiltreType[ListParam_FiltreTypeLib.indexOf(value!)];
                  FiltreType = value;
                  print(">>>>>>>>>>>>>>>>> FiltreType $FiltreTypeID $FiltreType");
                  Filtre();
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: const EdgeInsets.only(left: 14, right: 14),
                height: 30,
                width: 350,
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
