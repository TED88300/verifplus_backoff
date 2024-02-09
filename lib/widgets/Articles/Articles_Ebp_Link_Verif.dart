import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';


//113 Poudre ABC 6kg


class Articles_Ebp_Link_Verif extends StatefulWidget {
  @override
  Articles_Ebp_Link_VerifState createState() => Articles_Ebp_Link_VerifState();
}

class Articles_Ebp_Link_VerifState extends State<Articles_Ebp_Link_Verif> {
  DaviModel<Articles_Link_Verif_Ebp>? _model;

  final Search_TextController = TextEditingController();

  String FiltreType = "Tous";
  String FiltreTypeID = "Tous";
  List<String> ListParam_FiltreType =     ["Tous"];
  List<String> ListParam_FiltreTypeLib =  ["Tous"];





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

    await DbTools.getArticles_Link_Verif_EbpAll(DbTools.gArticle_Ebp.Article_codeArticle);
    print("ListArticles_Link_Verif_Ebp ${DbTools.ListArticles_Link_Verif_Ebp.length}");
    for (int i = 0; i < DbTools.ListArticles_Link_Verif_Ebp.length; i++) {
      Articles_Link_Verif_Ebp element = DbTools.ListArticles_Link_Verif_Ebp[i];
      Article_Ebp warticleEbp = getArticle(element.Articles_Link_Verif_ChildID);
      DbTools.ListArticles_Link_Verif_Ebp[i].Articles_Link_Verif_ChildID_Lib = warticleEbp.Article_descriptionCommercialeEnClair;
    }

    await Filtre();


    bReload = false;
    print("Reload getClientAll ${DbTools.ListClient.length}");
    setState(() {});
  }

  Future Filtre() async {

    List<Articles_Link_Verif_Ebp> listarticlesLinkVerifEbpsearchresult = [];
    listarticlesLinkVerifEbpsearchresult.clear();

    print("Filtre ${Search_TextController.text}");
    if (Search_TextController.text.isEmpty) {
      listarticlesLinkVerifEbpsearchresult.addAll(DbTools.ListArticles_Link_Verif_Ebp);
    } else {
      DbTools.ListArticles_Link_Verif_Ebp.forEach((element) {
        String wSearch = "${element.Desc()}";
        if (wSearch.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          listarticlesLinkVerifEbpsearchresult.add(element);
        }
      });
    }

    DbTools.ListArticles_Link_Verif_Ebpsearchresult.clear();
    if (FiltreType.compareTo("Tous") == 0) {
      DbTools.ListArticles_Link_Verif_Ebpsearchresult.addAll(listarticlesLinkVerifEbpsearchresult);
    } else {
      listarticlesLinkVerifEbpsearchresult.forEach((element) {
        if (FiltreTypeID.compareTo(element.Articles_Link_Verif_TypeVerif) == 0) DbTools.ListArticles_Link_Verif_Ebpsearchresult.add(element);
      });
    }




    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();

    await DbTools.getParam_Saisie("Base","Verif");

//    ListParam_FiltreType.clear();
//    ListParam_FiltreTypeLib.clear();
    for (int i = 0; i < DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = DbTools.ListParam_Saisie[i];
      print("element.Param_Saisie_Icon ${element.Param_Saisie_Label} ${element.Param_Saisie_Icon} ${element.Param_Saisie_Ordre}");
      if(element.Param_Saisie_Icon == "Audit_det")
        {
          ListParam_FiltreType.add(element.Param_Saisie_ID);
          ListParam_FiltreTypeLib.add(element.Param_Saisie_Label);

        }
    }

    print("ListParam_FiltreType ${ListParam_FiltreType.length}");
    print("ListParam_FiltreTypeLib ${ListParam_FiltreTypeLib.length}");



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
    List<DaviColumn<Articles_Link_Verif_Ebp>> wColumns = [
      new DaviColumn(name: 'Id', width : 60, stringValue: (row) => "${row.Articles_Link_VerifId}"),
      new DaviColumn(name: 'Vérif', width : 120, stringValue: (row) => "${row.Articles_Link_Verif_TypeVerif}"),
      new DaviColumn(name: 'Type', width : 90, stringValue: (row) => "${row.Articles_Link_Verif_TypeChildID}"),
      new DaviColumn(name: 'Code', width : 120, stringValue: (row) => "${row.Articles_Link_Verif_ChildID}"),
      new DaviColumn(name: 'Description', grow : 100,  stringValue: (row) => row.Articles_Link_Verif_ChildID_Lib.replaceAll("\n", "").replaceAll("\r", "")),

    ];
    _model = DaviModel<Articles_Link_Verif_Ebp>(rows: DbTools.ListArticles_Link_Verif_Ebpsearchresult,       columns: wColumns,);


    return new DaviTheme(
        child: new Davi<Articles_Link_Verif_Ebp>(
          _model,
          visibleRowsCount: 28,
          onRowTap: (articlesLinkVerifEbp) => _onRowTap(context, articlesLinkVerifEbp),

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
  void _onRowTap(BuildContext context, Articles_Link_Verif_Ebp articlesLinkVerifEbp) async {
    DbTools.gArticles_Link_Verif_Ebp = articlesLinkVerifEbp;
//    await Navigator.push(context, MaterialPageRoute(builder: (context) => Articles_Ebp_Edit(Articles_Link_Verif_Ebp: Articles_Link_Verif_Ebp)));
    Reload();
  }

  void columnInResizing(BuildContext context, DaviColumn<Articles_Link_Verif_Ebp> wColumn) async {

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
            DropdownFiltreType(),
            Container(
              width: 10,
            ),
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
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.white,
              ),
              buttonHeight: 30,
              buttonWidth: 340,
              dropdownMaxHeight: 250,
              itemHeight: 32,
            )),
      ),
    ]);
  }




}
