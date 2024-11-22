
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_container/tab_container.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Ebp.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Articles/Articles_Ebp_Link.dart';
import 'package:verifplus_backoff/widgets/Articles/Articles_Ebp_Link_Verif.dart';

class Articles_Ebp_Edit extends StatefulWidget {
  final Article_Ebp article_Ebp;
  const Articles_Ebp_Edit({Key? key, required this.article_Ebp}) : super(key: key);
  @override
  Articles_Ebp_EditState createState() => Articles_Ebp_EditState();
}

class Articles_Ebp_EditState extends State<Articles_Ebp_Edit> {
  double dWidth = 0;
  double dWidthLabel = 0;
  late Image wImage;
  Uint8List pic = Uint8List.fromList([0]);
  bool isLoad = false;

  double Promo_HT = 0;
  double Promo_TTC = 0;

  double screenWidth = 0;
  double screenHeight = 0;

  TextEditingController tec_Article_Libelle = TextEditingController();
  TextEditingController tec_Article_descriptionCommerciale = TextEditingController();
  TextEditingController tec_Article_Notes = TextEditingController();
  TextEditingController tec_Article_Offres = TextEditingController();
  TextEditingController tec_Article_Liens = TextEditingController();
  TextEditingController tec_Article_Promo_PVHT = TextEditingController();

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    Reload();
  }

  List<Widget> _getChildren1 = [];
  List<Widget> widgetChildren = [];

  int sel = 0;
  Widget Content(BuildContext context) {

    widgetChildren = [
      ArtEdit(),
//      Articles_Ebp_Link_Verif(),
      Articles_Ebp_Link(),
    ];



    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//        ToolsBar(context),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ArtEntete(),
              Container(
                width: screenWidth,
                height: screenHeight - 325,
//                color: Colors.red,
                child: taBarContainer(),
              ),
            ],
          )),
        ),
      ]),
    );
  }



  Widget taBarContainer() {
    return TabContainer(
      tabDuration : Duration(milliseconds: 600),
      color: gColors.primary,

      children: widgetChildren,

      selectedTextStyle: gColors.bodyTitle1_B_W,
      unselectedTextStyle: gColors.bodyTitle1_B_Gr,


      tabs: [
        Text('Description'),
        Text('Articles liés'),

      ],
    );
  }



  Future Reload() async {


    tec_Article_Libelle.text = widget.article_Ebp.Article_Libelle;
    tec_Article_descriptionCommerciale.text = widget.article_Ebp.Article_descriptionCommercialeEnClair;
    tec_Article_Notes.text = widget.article_Ebp.Article_Notes;
    tec_Article_Offres.text = widget.article_Ebp.Article_Offres;
    tec_Article_Liens.text = widget.article_Ebp.Article_Liens;

    tec_Article_Promo_PVHT.text = widget.article_Ebp.Article_Promo_PVHT.toString();

    String wUserImg = "ArticlesImg_Ebp_${widget.article_Ebp.Article_codeArticle}.jpg";
    pic = await gColors.getImage(wUserImg);

    print("pic $wUserImg");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 270,
        height: 270,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar_Org.png'),
        height: 270,
      );
    }

    isLoad = true;
    setState(() {});
  }

  void initLib() async {
    await Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    dWidth = MediaQuery.of(context).size.width;
    dWidthLabel = 100;
    print("tec_Article_Promo_PVHT.text = ${tec_Article_Promo_PVHT.text}");

    if (tec_Article_Promo_PVHT.text.isNotEmpty) {
      print("tec_Article_Promo_PVHT.text = ${tec_Article_Promo_PVHT.text}");
      Promo_HT = double.tryParse(tec_Article_Promo_PVHT.text)!;
      print("Promo_HT = $Promo_HT");
      Promo_TTC = Promo_HT * (widget.article_Ebp.Article_tauxTVA / 100 + 1);
      print("Promo_TTC = $Promo_TTC");
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gColors.primary,
        automaticallyImplyLeading: false,
        title: Container(
            color: gColors.primary,
            child: Row(
              children: [
                Container(
                  width: 5,
                ),
                InkWell(
                  child: SizedBox(
                      height: 100.0,
                      width: 100.0, // fixed width and height
                      child: new Image.asset(
                        'assets/images/AppIcow.png',
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text(
                  "Article EBP",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
                ),
                Spacer(),
                gColors.BtnAffUser(context),
                Container(
                  width: 120,
                  child: Text(
                    "Version : ${DbTools.gVersion}",
                    style: gColors.bodySaisie_N_W,
                  ),
                ),
              ],
            )),
      ),
      body: !isLoad ? Container() : Content(context),
    );
  }

  Widget ArtEntete() {
    print("ArtEntete ${_getChildren1.length}");

    return Column(
      children: [
        Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,

              children: [
            Container(
              width: dWidth,
              child: EditArt1(),
            ),
          ]),
        ),
      ],
    );
  }

  Widget ArtEdit() {
    print("ArtEdit dWidth $dWidth");

    return Container(
      color: Colors.white,
        child: Column(
      children: [
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: dWidth,
              child: EditArt2(),
            ),
          ]),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 250,
              child: EditArt3(),
            ),
            Container(
              width: 280,
              child: EditArt3p(),
            ),
            Container(
              width: 180,
              child: EditArt3Pousse(),
            ),
            Container(
              width: 240,
              child: EditArt4(),
            ),
          ]),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: dWidth - 320,
              child: EditArt5(),
            ),
            Container(
              width: 300,
              child: wImage,
            ),
          ]),
        ),
      ],
    ));
  }

  //********************************************
  //********************************************
  //********************************************

  Widget EditArt1() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: const EdgeInsets.fromLTRB(5, 5, 25, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildText("Code Article", widget.article_Ebp.Article_codeArticle, 0),
                    _buildText("Goupe", widget.article_Ebp.Article_Groupe, 0),
                    _buildText("Famille", widget.article_Ebp.Article_Fam, 0),
                    _buildText("Sous-Famille", widget.article_Ebp.Article_Sous_Fam, 0),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.article_Ebp.Article_descriptionCommercialeEnClair,
                      style: gColors.bodyTitle1_B_Gr,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            )));
  }

  //********************************************
  //********************************************
  //********************************************

  void ToolsBarSave() async {
    print("ToolsBarSave");

    widget.article_Ebp.Article_Libelle = tec_Article_Libelle.text;
    widget.article_Ebp.Article_descriptionCommercialeEnClair = tec_Article_descriptionCommerciale.text ;
    widget.article_Ebp.Article_Notes = tec_Article_Notes.text;
    widget.article_Ebp.Article_Offres = tec_Article_Offres.text;
    widget.article_Ebp.Article_Liens = tec_Article_Liens.text;
    widget.article_Ebp.Article_Promo_PVHT = double.parse(tec_Article_Promo_PVHT.text) ;
    await DbTools.setArticle_Ebp(widget.article_Ebp);

    setState(() {});
  }


  Widget EditArt2() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 290,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

                  CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave, tooltip: "Sauvegarder"),
                  _buildField("Description", tec_Article_descriptionCommerciale, nbLigne: 10),

              Container(
                height: 12,
              ),

              Row(
                children: [
                  Container(
                    width: 8,
                  ),
                  Tooltip(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                    decoration: BoxDecoration(color: Colors.orange),
                    message: "Copie Sélection",
                    child: InkWell(
                    child: Icon(
                      Icons.copy_all,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (tec_Article_descriptionCommerciale.selection.start == tec_Article_descriptionCommerciale.selection.end) {
                        if (tec_Article_descriptionCommerciale.selection.start > 0) {
                          print("cut ${tec_Article_descriptionCommerciale.selection.start}");
                          String wLib = tec_Article_descriptionCommerciale.text.substring(0, tec_Article_descriptionCommerciale.selection.start);
                          print("cut $wLib");
                          tec_Article_Libelle.text = gColors.capitalize(wLib);
                        }
                      } else {
                        String wLib = tec_Article_descriptionCommerciale.text.substring(tec_Article_descriptionCommerciale.selection.start, tec_Article_descriptionCommerciale.selection.end);
                        print("cut $wLib");
                        tec_Article_Libelle.text = gColors.capitalize(wLib);
                      }
                      setState(() {});
                    },
                  ),),
                  Container(
                    width: 8,
                  ),
                  Tooltip(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                    decoration: BoxDecoration(color: Colors.orange),
                    message: "Copie tout",
                    child: InkWell(
                    child: Icon(
                      Icons.copy_rounded,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    onTap: () async {
                      tec_Article_Libelle.text = tec_Article_descriptionCommerciale.text;
                      setState(() {});
                    },
                  ),),
                ],
              ),
              Container(
                height: 12,
              ),
              _buildField("Libellé", tec_Article_Libelle),
            ],
          ),
        ));
  }

  Widget EditArt3() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 73,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildTextw("Prix de vente HT", widget.article_Ebp.Article_PVHT.toString(), 120, 80, wpb: 3),
              _buildTextw("Taux de TVA", widget.article_Ebp.Article_tauxTVA.toString(), 120, 80, wpb: 3),
              _buildTextw("Prix de vente TTC", widget.article_Ebp.Article_PVTTC.toString(), 120, 80, wpb: 3),
            ],
          ),
        ));
  }

  Widget EditArt3p() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 73,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildFieldDouble("Prix PROMO HT", tec_Article_Promo_PVHT),
              Container(
                height: 10,
              ),
              _buildTextw("Prix PROMO TTC", Promo_TTC.toStringAsFixed(2), 160, 80),
            ],
          ),
        ));
  }

  Widget EditArt3Pousse() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 73,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(8, 2, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              gColors.CheckBoxField(100, 8, "Article Poussé", widget.article_Ebp.Article_Pousse, (sts) => setState(() => widget.article_Ebp.Article_Pousse = sts!)),
              gColors.CheckBoxField(100, 8, "Article Nouveau", widget.article_Ebp.Article_New, (sts) => setState(() => widget.article_Ebp.Article_New = sts!)),
            ],
          ),
        ));
  }

  Widget EditArt4() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 73,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildTextw("Stock Réel", widget.article_Ebp.Article_stockReel.toString(), 100, 80, wpb: 3),
              _buildTextw("Stock Virtuel", widget.article_Ebp.Article_stockVirtuel.toString(), 100, 80, wpb: 3),
            ],
          ),
        ));
  }

  Widget EditArt5() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 520,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildField("Détail", tec_Article_Notes, nbLigne: 15),
              _buildField("Offres", tec_Article_Offres, nbLigne: 10),
              _buildField("Liens", tec_Article_Liens, nbLigne: 5),
            ],
          ),
        ));
  }

  Widget _buildField(String label, TextEditingController textEditingController, {int nbLigne = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
          width: dWidthLabel,
          child: Text("$label ${label.isNotEmpty ? ":" : ""} "),
        ),
        Expanded(
          child: TextFormField(
            maxLines: nbLigne,
            minLines: nbLigne,
            controller: textEditingController,
            decoration: InputDecoration(
              isDense: true,
            ),
            style: gColors.bodySaisie_B_B,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldDouble(String label, TextEditingController textEditingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
          width: 120,
          child: Text("$label"),
        ),
        Container(
          child: Text("${label.isNotEmpty ? ":" : ""} "),
        ),
        Container(
          width: 5,
        ),
        Expanded(
          child: TextFormField(
            onChanged: (String? value) async {
              print("_buildFieldDouble  $value");
              setState(() {});
            },
            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: textEditingController,
            decoration: InputDecoration(
              isDense: true,
            ),
            style: gColors.bodySaisie_B_B,
          ),
        ),
        Container(
          width: 5,
        ),

      ],
    );
  }

  Widget _buildText(String label, String wText, double tWidth, {double wpb = 0}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, wpb),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
            ),
            Container(
              child: Text("$label ${label.isNotEmpty ? ":" : ""} "),
            ),
            Container(
              width: tWidth == 0 ? null : tWidth,
              child: Text(
                wText,
                style: gColors.bodySaisie_B_B,
              ),
            ),
          ],
        ));
  }

  Widget _buildTextw(String label, String wText, double lWidth, double tWidth, {double wpb = 0}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, wpb),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
            ),
            Container(
              width: lWidth,
              child: Text("$label"),
            ),
            Container(
              width: 5,
              child: Text("${label.isNotEmpty ? ":" : ""} "),
            ),
            Container(
              width: tWidth,
              child: Text(
                wText,
                style: gColors.bodySaisie_B_B,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ));
  }
}
