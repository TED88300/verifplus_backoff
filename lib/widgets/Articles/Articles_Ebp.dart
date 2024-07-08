import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Articles/Article_Ebp_Edit.dart';

//113 Poudre ABC 6kg

class Article_Ebp_Liste extends StatefulWidget {
  @override
  Article_Ebp_ListeState createState() => Article_Ebp_ListeState();
}

class Article_Ebp_ListeState extends State<Article_Ebp_Liste> {
  DaviModel<Article_Ebp>? _model;

  final Search_TextController = TextEditingController();

  String FiltreFam = "Tous";
  String FiltreFamID = "";

  List<String> ListParam_FiltreFam = [];
  List<String> ListParam_FiltreFamID = [];

  bool bReload = true;

  Future Reload() async {
    await DbTools.getArticle_Fam_EbpAll();

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

//    ListParam_FiltreFam.addAll(DbTools.ListParam_FiltreFam);
    //   ListParam_FiltreFamID.addAll(DbTools.ListParam_FiltreFamID);

    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("Tous");

    DbTools.ListArticle_Fam_Ebpsearchresult.clear();
    for (int i = 0; i < DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp element = DbTools.ListArticle_Fam_Ebp[i];
      if (DbTools.gArticle_Fam_Ebp.Article_Fam_Code.isEmpty) {
        if (element.Article_Fam_Code_Parent.isEmpty)
          {
            ListParam_FiltreFam.add("${element.Article_Fam_Description}");
            ListParam_FiltreFamID.add(element.Article_Fam_Code);
          }
      }
    }

    print(" Reload ListParam_FiltreFam ${DbTools.ListParam_FiltreFam.length}");
    print(" Reload ListParam_FiltreFamID ${DbTools.ListParam_FiltreFamID.length}");

    Search_TextController.text = "112";
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFamID[0];

    await DbTools.getArticle_EbpAll();

    await Filtre();

    bReload = false;
    print("Reload getClientAll ${DbTools.ListClient.length}");
    setState(() {});
  }

  Future Filtre() async {
    List<Article_Ebp> listarticleEbpsearchresulttmp = [];
    listarticleEbpsearchresulttmp.clear();

    if (Search_TextController.text.isEmpty) {
      listarticleEbpsearchresulttmp.addAll(DbTools.ListArticle_Ebp);
    } else {
      DbTools.ListArticle_Ebp.forEach((element) {
        String wSearch = "${element.Article_codeArticle}${element.Article_descriptionCommercialeEnClair}";
        if (wSearch.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          listarticleEbpsearchresulttmp.add(element);
        }
      });
    }

    DbTools.ListArticle_Ebpsearchresult.clear();
    if (FiltreFam.compareTo("Tous") == 0) {
      DbTools.ListArticle_Ebpsearchresult.addAll(listarticleEbpsearchresulttmp);
    } else {
      for (int i = 0; i < DbTools.ListArticle_Fam_Ebp.length; i++) {
        Article_Fam_Ebp element = DbTools.ListArticle_Fam_Ebp[i];
        if (FiltreFam.compareTo(element.Article_Fam_Libelle) == 0) {
          FiltreFamID = element.Article_Fam_Code;
          break;
        }
      }
      listarticleEbpsearchresulttmp.forEach((element) {
        if (FiltreFamID.compareTo(element.Article_codeFamilleArticles) == 0) {
          DbTools.ListArticle_Ebpsearchresult.add(element);
        }
      });
    }

    print(" Reload ListArticle_Ebpsearchresult ${DbTools.ListArticle_Ebpsearchresult.length}");

    DbTools.ListArticle_Ebpsearchresult.forEach((element) {
      print(" Reload element ${element.Article_codeArticle} ${element.Article_codeFamilleArticles} ${element.Article_LibelleFamilleArticle}");
    });

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();
    Search_TextController.text = "112";

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

    return Article_EbpGridWidget();
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Article_EbpGridWidget() {
    List<DaviColumn<Article_Ebp>> wColumns = [
      new DaviColumn(name: 'Id', width: 60, stringValue: (row) => "${row.ArticleID}"),
      new DaviColumn(name: 'Code', width: 90, stringValue: (row) => "${row.Article_codeArticle}"),
//      new DaviColumn(name: 'Libellé', width: 300, stringValue: (row) => row.Article_Libelle),
      new DaviColumn(name: 'Description', width: 650, stringValue: (row) => row.Article_descriptionCommercialeEnClair.replaceAll("\n", "").replaceAll("\r", "")),
      new DaviColumn(name: 'Groupe', width: 200, stringValue: (row) => row.Article_Groupe),
      new DaviColumn(name: 'Famille', width: 400, stringValue: (row) => row.Article_LibelleFamilleArticle),
      new DaviColumn(name: 'Sous-Famille', grow: 200, stringValue: (row) => row.Article_LibelleSousFamilleArticle),
    ];

    _model = DaviModel<Article_Ebp>(
      rows: DbTools.ListArticle_Ebpsearchresult,
      columns: wColumns,
    );

//    print("columnsLength ${_model!.columnsLength}");
//    _model!.columnInResizing : (DaviColumn<Article_Ebp> wColumn) => columnInResizing(context, wColumn);

    return new DaviTheme(
        child: new Davi<Article_Ebp>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (articleEbp) => _onRowTap(context, articleEbp),
        ),
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
  void _onRowTap(BuildContext context, Article_Ebp articleEbp) async {
    DbTools.gArticle_Ebp = articleEbp;
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Articles_Ebp_Edit(article_Ebp: articleEbp)));
    Reload();
  }

  void columnInResizing(BuildContext context, DaviColumn<Article_Ebp> wColumn) async {}
  void onHover(int i) async {}

//**********************************
//**********************************
//**********************************

  void ToolsBarAdd() async {
    print("ToolsBarAdd");
    Article_Ebp warticleEbp = await Article_Ebp.Article_EbpInit();

    await DbTools.addArticle_Ebp(warticleEbp);
    warticleEbp.ArticleID = DbTools.gLastID;
    warticleEbp.Article_descriptionCommercialeEnClair = "???";

    DbTools.gArticle_Ebp = warticleEbp;
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Articles_Ebp_Edit(article_Ebp: warticleEbp),
    );
    await Reload();
  }

  Widget ToolsBar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          children: [
            CommonAppBar.SquareRoundIcon(context, 40, 8, Colors.green, Colors.white, Icons.add, ToolsBarAdd),
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
                decoration: gColors.wRechInputDecoration,
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
            ),
            Container(
              width: 10,
            ),
            DropdownFiltreFam(),
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
