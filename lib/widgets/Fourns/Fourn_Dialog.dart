import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Fourns.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Fourn_Dialog extends StatefulWidget {
  final Fourn fourn;
  const Fourn_Dialog({Key? key, required this.fourn}) : super(key: key);

  @override
  State<Fourn_Dialog> createState() => _Fourn_DialogState();
}

class _Fourn_DialogState extends State<Fourn_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";
  Fourn wFourn = Fourn.FournInit();
  TextEditingController textController_Civilite = TextEditingController();
  TextEditingController textController_Nom = TextEditingController();
  TextEditingController textController_CodeGC = TextEditingController();
  TextEditingController textController_Siret = TextEditingController();
  TextEditingController textController_NAF = TextEditingController();
  TextEditingController textController_TVA = TextEditingController();

  TextEditingController textController_Adr1 = TextEditingController();
  TextEditingController textController_Adr2 = TextEditingController();
  TextEditingController textController_Adr3 = TextEditingController();
  TextEditingController textController_Adr4 = TextEditingController();
  TextEditingController textController_CP = TextEditingController();
  TextEditingController textController_Ville = TextEditingController();
  TextEditingController textController_Pays = TextEditingController();

  TextEditingController textController_Tel1 = TextEditingController();
  TextEditingController textController_Tel2 = TextEditingController();
  TextEditingController textController_eMail = TextEditingController();
  TextEditingController textController_Rem = TextEditingController();

  DateTime selectedDate = DateTime.now();

  double screenWidth = 0;
  double screenHeight = 0;

  TextEditingController controller = TextEditingController();

  List<PlutoMenuItem> HoverMenus = [];
  late Widget wPlutoMenuBar;

  List<String> ListParam_ParamStatut = [];
  List<String> ListParam_ParamStatutID = [];
  String selectedValueStatut = "";
  String selectedValueStatutID = "";

  String wRep = "";


  bool isFourn_SST = false;


  Future initLib() async {
    await DbTools.initListFam();

    wFourn = widget.fourn;
    print("initState ${wFourn.toJson()}");


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

    await DbTools.getParam_ParamFam("Statut");
    ListParam_ParamStatut.clear();
    ListParam_ParamStatut.addAll(DbTools.ListParam_ParamFam);
    ListParam_ParamStatutID.clear();
    ListParam_ParamStatutID.addAll(DbTools.ListParam_ParamFamID);

    selectedValueStatut = ListParam_ParamStatut[0];
    for (int i = 0; i < ListParam_ParamStatut.length; i++) {
      String element = ListParam_ParamStatut[i];
      if (element.compareTo("${wFourn.Fourn_Statut}") == 0) {
        selectedValueStatut = element;
      }
    }


    print("initLib B");

    textController_Nom.text = wFourn.fournNom!;
    textController_CodeGC.text = wFourn.fournCodeGC!;
    textController_Siret.text = wFourn.fournSiret!;
    textController_NAF.text = wFourn.fournNAF!;
    textController_TVA.text = wFourn.fournTVA!;

    textController_Adr1.text = wFourn.fournAdr1!;
    textController_Adr2.text = wFourn.fournAdr2!;
    textController_Adr3.text = wFourn.fournAdr3!;
    textController_Adr4.text = wFourn.fournAdr4!;
    textController_CP.text = wFourn.fournCP!;
    textController_Ville.text = wFourn.fournVille!;
    textController_Pays.text = wFourn.fournPays!;

    textController_Tel1.text = wFourn.fournTel1!;
    textController_Tel2.text = wFourn.fournTel2!;
    textController_eMail.text = wFourn.fournEMail!;
    textController_Rem.text = wFourn.fournRem!;


    isFourn_SST =wFourn.Fourn_F_SST == 1;


    Title = "Fiche fournisseur";
    print("initLib <<<<<<<<<<<<<<<<<<<<<<<<<<<");

    setState(() {});
  }

  void initState() {
    print("Fourn_Dialog initState ${DbTools.gViewCtact}");

    print("initState >");
    initLib();
    super.initState();
    print("initState <");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMaj() async {
    print("Parent onMaj()");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    print("screenWidth $screenWidth");
    if (Title.isEmpty) return Container();

    return Center(
      child: Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: gColors.white,
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
                        Title,
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_W,
                      ),
                      Spacer(),
                      gColors.BtnAffUser(context),
                      Container(
                        width: 150,
                        child: Text(
                          "Version : ${DbTools.gVersion}",
                          style: gColors.bodySaisie_N_W,
                        ),
                      ),
                    ],
                  )),
            ),
            body: Content(context),
          )),
    );
  }

  List<Widget> widgetChildren = [];
  int sel = 0;

  Widget Content(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        ToolsBar(context),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentDetailCadre(context),
            ],
          )),
        ),
      ]),
    );
  }

  Widget ContentDetailCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
              ContentDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 5,
          child: Container(
            width: 600,
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            color: gColors.LinearGradient1,
            child: Text(
              'Fourn #${wFourn.fournId} ${wFourn.fournNom}',
              style: gColors.bodyTitle1_B_Wr,
            ),
          ),
        ),
      ],
    );
  }

  Widget ContentDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            gColors.TxtField(-1, 28, "Code", textController_CodeGC),
                            Container(
                              width: 30,
                            ),
                            gColors.TxtField(-1, 64, "Nom", textController_Nom),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            gColors.TxtField(-1, 32, "Siret", textController_Siret),
                            CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.search, InseeSiret, tooltip: "Rechercher par le Siret"),
                            Container(
                              width: 10,
                            ),
                            gColors.TxtField(-1, 32, "TVA", textController_TVA),
                            gColors.TxtField(-1, 16, "NAF", textController_NAF),
                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              width: 90,
                              child: Text("Statut : ",
                                style: gColors.bodySaisie_N_G,),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    items: ListParam_ParamStatut.map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        "$item",
                                        style: gColors.bodySaisie_B_G,
                                      ),
                                    )).toList(),
                                    value: selectedValueStatut,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValueStatut = value!;
                                        print("selectedValueStatut $selectedValueStatut");
                                        setState(() {});
                                      });
                                    },


                                    buttonStyleData: const ButtonStyleData(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      height: 30,
                                      width: 120,
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


                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gColors.CheckBoxField(80, 8, "Fournisseur", !isFourn_SST, (sts) => setState(() => isFourn_SST = !sts!)),
                            Container(
                              width: 10,
                            ),
                            gColors.CheckBoxField(80, 8, "Sous-traitant", isFourn_SST, (sts) => setState(() => isFourn_SST = sts!)),




                          ],
                        ),


                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "Adresse", textController_Adr1),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "", textController_Adr2, sep: ""),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "", textController_Adr3, sep: ""),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "", textController_Adr4, sep: ""),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 10, "CP", textController_CP),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "Ville", textController_Ville),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "Tel Fixe", textController_Tel1),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "Portable", textController_Tel2),
                          ],
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "eMail", textController_eMail),
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: [
                            gColors.TxtField(80, 40, "Remarque", textController_Rem, Ligne: 4),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2010), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Save", ToolsBarSave, tooltip: "Sauvegarder"),
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.red, "ico_Del", ToolsBarDelete, tooltip: "Supprimer"),
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

  void InseeSiret() async {
    String wSiret = textController_Siret.text;
    print("InseeSiret $wSiret");
    wSiret = wSiret.replaceAll(" ", "");
    print("InseeSiret $wSiret");
    if (wSiret.length != 14) {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Le numéro de Siret doit comporter 14 caractères",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
          )
        ],
      ).show();
    }

//    await Api_Gouv.siret('43447418500015') ;

    if (await Api_Gouv.siret(wSiret)) {
      int iSiret = int.parse(Api_Gouv.siret_SIREN);
//        int iSiret = 404833048;
      int iSiret97 = iSiret % 97;
      print("iSiret $iSiret iSiret97 $iSiret97");
      int iSiret97_2 = 12 + 3 * iSiret97;
      int iCleTva = iSiret97_2 % 97;
      String sCleTva = iCleTva.toString().padLeft(2, '0');
      print("iSiret97_2 $iSiret97_2 iCleTva $iCleTva sCleTva $sCleTva");

      String NoTVA = "FR$sCleTva$iSiret";
      Alert(
        context: context,
        style: confirmStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: "Êtes-vous sûre de vouloir remplacer les données ?\n${Api_Gouv.siret_Nom}\n${Api_Gouv.siret_Rue}\n${Api_Gouv.siret_Cp} ${Api_Gouv.siret_Ville}\n\nNAF : ${Api_Gouv.siret_NAF}\n\nTVA : $NoTVA\n\nCat. Jur. : ${Api_Gouv.siret_Cat}",
        buttons: [
          DialogButton(
              child: Text(
                "Annuler",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black12),
          DialogButton(
              child: Text(
                "Remplacer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                textController_Nom.text = Api_Gouv.siret_Nom;
                textController_NAF.text = Api_Gouv.siret_NAF;
                textController_TVA.text = NoTVA;
                textController_Adr1.text = Api_Gouv.siret_Rue;
                textController_CP.text = Api_Gouv.siret_Cp;
                textController_Ville.text = Api_Gouv.siret_Ville;
                textController_Pays.text = "France";


                await ToolsBarSave();
                await initLib();

                setState(() {});
                Navigator.pop(context);
              },
              color: Colors.green)
        ],
      ).show();
    } else {
      Alert(
        context: context,
        style: alertStyle,
        alertAnimation: fadeAlertAnimation,
        image: Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/AppIco.png'),
        ),
        title: "RECHERCHE DU SIRET DANS INSEE",
        desc: Api_Gouv.siret_Nom,
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  Future ToolsBarSave() async {
    print("ToolsBarSave");

//    wFourn.fournStatut = selectedValueStatut;

    wFourn.fournNom = textController_Nom.text;
    wFourn.fournCodeGC = textController_CodeGC.text;
    wFourn.fournSiret = textController_Siret.text;
    wFourn.fournNAF = textController_NAF.text;
    wFourn.fournTVA = textController_TVA.text;

    wFourn.fournAdr1 = textController_Adr1.text;
    wFourn.fournAdr2 = textController_Adr2.text;
    wFourn.fournAdr3 = textController_Adr3.text;
    wFourn.fournAdr4 = textController_Adr4.text;
    wFourn.fournCP = textController_CP.text;
    wFourn.fournVille = textController_Ville.text;
    wFourn.fournPays = textController_Pays.text;

    wFourn.fournTel1 = textController_Tel1.text;
    wFourn.fournTel2 = textController_Tel2.text;
    wFourn.fournEMail = textController_eMail.text;
    wFourn.fournRem = textController_Rem.text;


    wFourn.Fourn_Statut = selectedValueStatut;


    wFourn.Fourn_F_SST = isFourn_SST ? 1 : 0;


    await DbTools.setFourn(wFourn);
  }

  void ToolsBarDelete() async {
    print("ToolsBarDelete");
    Alert(
      context: context,
      style: alertStyle,
      alertAnimation: fadeAlertAnimation,
      image: Container(
        height: 100,
        width: 100,
        child: Image.asset('assets/images/AppIco.png'),
      ),
      title: "Vérif+ Alerte",
      desc: "Êtes-vous sûre de vouloir supprimer ce fourn ?",
      buttons: [
        DialogButton(
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black12),
        DialogButton(
            child: Text(
              "Suprimer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
//              await DbTools.delFourn(wFourn);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Colors.red)
      ],
    ).show();
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_tks,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  var confirmStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_Green,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  Widget wScreen(String wTxt) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$wTxt $wRep"),
            ],
          ),
        ],
      ),
    );
  }

  Widget DropdownButtonStatut() {
    print("DropdownButtonStatut");

    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: 90,
        child: Text(
          "Statut : ",
          style: gColors.bodySaisie_N_G,
        ),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: ListParam_ParamStatut.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_G,
                ),
              )).toList(),
          value: selectedValueStatut,
          onChanged: (value) {
            setState(() {
              selectedValueStatut = value!;
              print("selectedValueStatut $selectedValueStatut");
              setState(() {});
            });
          },
          buttonStyleData: const ButtonStyleData(
            padding: const EdgeInsets.only(left: 5, right: 5),
            height: 30,
            width: 120,
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
