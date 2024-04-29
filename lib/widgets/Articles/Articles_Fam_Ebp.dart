import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Articles_Fam_Ebp extends StatefulWidget {
  const Articles_Fam_Ebp({Key? key}) : super(key: key);

  @override
  _Articles_Fam_EbpState createState() => _Articles_Fam_EbpState();
}

class _Articles_Fam_EbpState extends State<Articles_Fam_Ebp> {
  Article_Fam_Ebp wArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();

  String Title = "Paramètres ";
  bool isSSfam = false;
  bool bReload = true;
  bool bsetSt = true;

  List<DaviColumn<Article_Fam_Ebp>> wColumns = [];

  DaviModel<Article_Fam_Ebp>? _model;

  Future Reload() async {
    print("Articles_Fam_Ebp Reload");
    await DbTools.getArticle_Fam_EbpAll();
    bReload = false;
    await Filtre();
  }

  int CountSsF() {
    int wRet = 0;
    for (int i = 0; i < DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp element = DbTools.ListArticle_Fam_Ebp[i];
      if (element.Article_Fam_Code_Parent.compareTo(wArticle_Fam_Ebp.Article_Fam_Code) == 0)
        wRet++;
    }

    return wRet;
  }

  Future Filtre() async {
    wArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();

    print("Articles_Fam_Ebp Filtre");
    DbTools.ListArticle_Fam_Ebpsearchresult.clear();
    for (int i = 0; i < DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp element = DbTools.ListArticle_Fam_Ebp[i];
      if (DbTools.gArticle_Fam_Ebp.Article_Fam_Code.isEmpty) {
        if (element.Article_Fam_Code_Parent.isEmpty) DbTools.ListArticle_Fam_Ebpsearchresult.add(element);
      } else {
        if (element.Article_Fam_Code_Parent.compareTo(DbTools.gArticle_Fam_Ebp.Article_Fam_Code) == 0) DbTools.ListArticle_Fam_Ebpsearchresult.add(element);
      }
    }


    wColumns.clear();
    wColumns.add(DaviColumn(
        grow: 2,
        name: 'Id',
        stringValue: (row) => "${row.Article_FamId}"
            ""));

    if (DbTools.gArticle_Fam_Ebp.Article_Fam_Code.isEmpty)
      wColumns.add(new DaviColumn(
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<Article_Fam_Ebp> data) {
            return InkWell(
              child: const Icon(Icons.list_alt, size: 16),
              onTap: () async {
                DbTools.gArticle_Fam_Ebp = data.data;
                print("SS Fam");
                Reload();
//              Navigator.push(context, MaterialPageRoute(builder: (context) => Articles_SsFam_Ebp()));
              },
            );
          }));
    wColumns.add(new DaviColumn(name: 'Code', grow: 1, stringValue: (row) => row.Article_Fam_Code));
    wColumns.add(new DaviColumn(name: 'Description', grow: 18, stringValue: (row) => row.Article_Fam_Description));
    wColumns.add(new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.Article_Fam_Libelle));

    _model = DaviModel<Article_Fam_Ebp>(rows: DbTools.ListArticle_Fam_Ebpsearchresult, columns: wColumns);

    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  void initState() {


    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build FAM Art");


    if (!bReload && DbTools.gDemndeReload) {
      Reload();
    }


    DbTools.gDemndeReload = false;

    int wCountSsF = CountSsF();

    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  child: _buildText(context, wArticle_Fam_Ebp.Article_Fam_Code),
                ),
                Container(
                  width: 8,
                ),
                Container(
                  width: 280,
                  child: _buildFieldDesgn(context, wArticle_Fam_Ebp),
                ),
                Container(
                  width: 8,
                ),
                InkWell(
                  child: Icon(
                    Icons.auto_awesome_outlined,
                    color: wArticle_Fam_Ebp.Article_Fam_Code.isNotEmpty ? Colors.blue : Colors.black12,
                    size: 24.0,
                  ),
                  onTap: () async {
                    if (Article_Fam_Ebp_DesgnController.text.contains("-")) {
                      if (Article_Fam_Ebp_DesgnController.text.indexOf("-") < Article_Fam_Ebp_DesgnController.text.length - 1) {
                        String wLib = Article_Fam_Ebp_DesgnController.text.substring(Article_Fam_Ebp_DesgnController.text.indexOf("-") + 1);
                        print("cut $wLib");
                        wArticle_Fam_Ebp.Article_Fam_Libelle = gColors.capitalize(wLib);
                        setState(() {});
                      }
                    }
                    else
                      {
                        wArticle_Fam_Ebp.Article_Fam_Libelle = gColors.capitalize(Article_Fam_Ebp_DesgnController.text);
                      }
                  },
                ),
                Container(
                  width: 8,
                ),
                InkWell(
                  child: Icon(
                    Icons.copy_all,
                    color: wArticle_Fam_Ebp.Article_Fam_Code.isNotEmpty ? Colors.blue : Colors.black12,
                    size: 24.0,
                  ),
                  onTap: () async {
                    if (Article_Fam_Ebp_DesgnController.selection.start == Article_Fam_Ebp_DesgnController.selection.end) {
                      if (Article_Fam_Ebp_DesgnController.selection.start > 0) {
                        print("cut ${Article_Fam_Ebp_DesgnController.selection.start}");
                        String wLib = Article_Fam_Ebp_DesgnController.text.substring(0, Article_Fam_Ebp_DesgnController.selection.start);
                        print("cut $wLib");
                        wArticle_Fam_Ebp.Article_Fam_Libelle = gColors.capitalize(wLib);
                      }
                    } else {
                      String wLib = Article_Fam_Ebp_DesgnController.text.substring(Article_Fam_Ebp_DesgnController.selection.start, Article_Fam_Ebp_DesgnController.selection.end);
                      print("cut $wLib");
                      wArticle_Fam_Ebp.Article_Fam_Libelle = gColors.capitalize(wLib);
                    }
                    setState(() {});
                  },
                ),
                Container(
                  width: 8,
                ),
                InkWell(
                  child: Icon(
                    Icons.copy_rounded,
                    color: wArticle_Fam_Ebp.Article_Fam_Code.isNotEmpty ? Colors.blue : Colors.black12,
                    size: 24.0,
                  ),
                  onTap: () async {
                    wArticle_Fam_Ebp.Article_Fam_Libelle = Article_Fam_Ebp_DesgnController.text;
                    setState(() {});
                  },
                ),
                Container(
                  width: 280,
                  child: _buildFieldLib(context, wArticle_Fam_Ebp),
                ),
                Container(
                  width: 8,
                ),
                Container(
                  width: 140,
                  child: _buildText(context, "[${wArticle_Fam_Ebp.Article_Fam_Libelle.length}] Ss Fam $wCountSsF"),
                ),
                Container(
                  width: 8,
                ),
                InkWell(
                  child: Icon(
                    Icons.check,
                    color: wArticle_Fam_Ebp.Article_Fam_Code.isNotEmpty ? Colors.blue : Colors.black12,
                    size: 24.0,
                  ),
                  onTap: () async {
                    if (wArticle_Fam_Ebp.Article_Fam_Code.isNotEmpty) {
                      wArticle_Fam_Ebp.Article_Fam_Description = Article_Fam_Ebp_DesgnController.text;
                      wArticle_Fam_Ebp.Article_Fam_Libelle = Article_Fam_Ebp_LibController.text;
                      await DbTools.setArticle_Fam(wArticle_Fam_Ebp);
//                      await Reload();
                      wArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Article_Fam_EbpGridWidget(),
        ],
      ),
    );
  }

  Widget Article_Fam_EbpGridWidget() {
    return new DaviTheme(
        child: new Davi<Article_Fam_Ebp>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (articleFamEbp) => _onRowTap(context, articleFamEbp),
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

  void _onRowTap(BuildContext context, Article_Fam_Ebp articleFamEbp) {
    setState(() {
      wArticle_Fam_Ebp = articleFamEbp;
      print("_onRowTap ${wArticle_Fam_Ebp.Article_FamId}");
    });
  }

  Widget _buildText(BuildContext context, String wText) {
    return Text(
      wText,
      style: gColors.bodySaisie_B_B,
    );
  }

  final Article_Fam_Ebp_DesgnController = TextEditingController();
  Widget _buildFieldDesgn(BuildContext context, Article_Fam_Ebp articleFamEbp) {
    Article_Fam_Ebp_DesgnController.text = articleFamEbp.Article_Fam_Description;
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
      ),
      controller: Article_Fam_Ebp_DesgnController,
      style: gColors.bodySaisie_B_B,
    );
  }

  final Article_Fam_Ebp_LibController = TextEditingController();
  Widget _buildFieldLib(BuildContext context, Article_Fam_Ebp articleFamEbp) {
    Article_Fam_Ebp_LibController.text = articleFamEbp.Article_Fam_Libelle;
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
      ),
      controller: Article_Fam_Ebp_LibController,
      style: gColors.bodySaisie_B_B,
    );
  }
}
