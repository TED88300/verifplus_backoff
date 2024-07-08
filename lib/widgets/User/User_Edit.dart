import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/PdfView.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Param_Dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/services.dart';
import 'package:verifplus_backoff/widgets/User/User_Edit_Desc.dart';
import 'package:verifplus_backoff/widgets/User/User_Edit_Hab.dart';

class User_Edit extends StatefulWidget {
  final User user;
  const User_Edit({Key? key, required this.user}) : super(key: key);
  @override
  User_EditState createState() => User_EditState();
}

class User_EditState extends State<User_Edit> {
  double dWidth = 0;
  double dWidthLabel = 0;

  static List<String> ListParam_ParamFonction = [];
  static List<String> ListParam_ParamFonctionID = [];
  String selectedValueFonction = "";
  String selectedValueFonctionID = "";

  static List<String> ListParam_ParamService = [];
  static List<String> ListParam_ParamServiceID = [];
  String selectedValueService = "";
  String selectedValueServiceID = "";

  static List<String> ListParam_ParamFamille = [];
  static List<String> ListParam_ParamFamilleID = [];
  String selectedValueFamille = "";
  String selectedValueFamilleID = "";

  static List<String> ListParam_ParamUser_NivHab = [];
  static List<int> ListParam_ParamUser_NivHabID = [];
  String selectedValueUser_NivHab = "";
  int selectedValueUser_NivHabID = 0;

  static List<String> ListParam_ParamUser_TypeUser = [];
  String selectedValueUser_TypeUser = "";

  static List<String> ListParam_ParamDepot = [];
  String selectedValueDepot = "";

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;
  bool isLoad = false;
  late ImageProvider<Object> wImageO;

  bool User_Actif = false;
  bool User_Niv_Isole = false;

  List<Widget> imgList = [];
  List<int> imgListi = [];

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    Reload();
  }

  Future Reload() async {
    await DbTools.getClient_User_CSIP(widget.user.User_Matricule);

    await DbTools.getParam_ParamAll();
    print("ListParam_ParamAll ${DbTools.ListParam_Param.length}");

    String wUserImg = "User_${widget.user.User_Matricule}.jpg";
    pic = await gColors.getImage(wUserImg);

    print("pic $wUserImg"); // ${pic}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 100,
        height: 100,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar.png'),
        height: 100,
      );
    }

    imgList.clear();
    for (int i = 0; i < 10; i++) {
      String wDocImgPathDel = "User_${widget.user.User_Matricule}_Doc_$i.pdf";
      final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
      Uint8List? _bytes = await gColors.getImage(wDocImgPathDel);

      print("_bytes length ${_bytes.length}");
      if (_bytes.length > 0) {
        SfPdfViewer wSfPdfViewer = SfPdfViewer.memory(
          _bytes,
          key: _pdfViewerKey,
          enableDocumentLinkAnnotation: false,
          enableTextSelection: false,
          interactionMode: PdfInteractionMode.pan,
        );

        Widget wWidget = Column(
          children: [
            Container(
              width: 200,
              height: 200,
              child: wSfPdfViewer,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(wSfPdfViewer: wSfPdfViewer)));
                    Reload();
                  },
                  icon: Icon(Icons.open_with, color: Colors.green),
                ),
                IconButton(
                  onPressed: () async {
                    print("delete $wDocImgPathDel");
                    await DbTools.removephoto_API_Post(wDocImgPathDel);
                    PaintingBinding.instance.imageCache.clear();
                    imageCache.clear();
                    imageCache.clearLiveImages();
                    await DefaultCacheManager().emptyCache(); //clears all data in cache.
                    await DefaultCacheManager().removeFile(wDocImgPathDel);
                    Reload();
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                )
              ],
            )
          ],
        );

        imgList.add(wWidget);
        imgListi.add(i);
      }
    }

    ListParam_ParamService.clear();
    ListParam_ParamServiceID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Service") == 0) {
        ListParam_ParamService.add(element.Param_Param_Text);
        ListParam_ParamServiceID.add(element.Param_Param_ID);
      }
    });
    selectedValueService = ListParam_ParamService[0];
    selectedValueServiceID = ListParam_ParamServiceID[0];
    for (int i = 0; i < ListParam_ParamService.length; i++) {
      String element = ListParam_ParamService[i];
      if (element.compareTo("${widget.user.User_Service}") == 0) {
        selectedValueService = element;
        selectedValueServiceID = ListParam_ParamServiceID[i];
      }
    }

    ListParam_ParamFamille.clear();
    ListParam_ParamFamilleID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Famille") == 0) {
        ListParam_ParamFamille.add(element.Param_Param_Text);
        ListParam_ParamFamilleID.add(element.Param_Param_ID);
      }
    });
    selectedValueFamille = ListParam_ParamFamille[0];
    selectedValueFamilleID = ListParam_ParamFamilleID[0];
    for (int i = 0; i < ListParam_ParamFamille.length; i++) {
      String element = ListParam_ParamFamille[i];
      if (element.compareTo("${widget.user.User_Famille}") == 0) {
        selectedValueFamille = element;
        selectedValueFamilleID = ListParam_ParamFamilleID[i];
      }
    }

    ListParam_ParamUser_NivHab.clear();
    ListParam_ParamUser_NivHabID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("NivHab") == 0) {
        ListParam_ParamUser_NivHab.add(element.Param_Param_Text);
        ListParam_ParamUser_NivHabID.add(element.Param_ParamId);
      }
    });
    selectedValueUser_NivHab = ListParam_ParamUser_NivHab[0];
    selectedValueUser_NivHabID = ListParam_ParamUser_NivHabID[0];

    ListParam_ParamUser_TypeUser.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("TypeUser") == 0) {
        ListParam_ParamUser_TypeUser.add(element.Param_Param_Text);
      }
    });
    selectedValueUser_TypeUser = ListParam_ParamUser_TypeUser[0];

    for (int i = 0; i < ListParam_ParamUser_TypeUser.length; i++) {
      String element = ListParam_ParamUser_TypeUser[i];
      if (element == widget.user.User_TypeUser) {
        selectedValueUser_TypeUser = ListParam_ParamUser_TypeUser[i];
      }
    }

    ListParam_ParamFonction.clear();
    ListParam_ParamFonctionID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Fonction") == 0) {
        ListParam_ParamFonction.add(element.Param_Param_Text);
        ListParam_ParamFonctionID.add(element.Param_Param_ID);
      }
    });
    selectedValueFonction = ListParam_ParamFonction[0];
    selectedValueFonctionID = ListParam_ParamFonctionID[0];
    for (int i = 0; i < ListParam_ParamFonction.length; i++) {
      String element = ListParam_ParamFonction[i];
      if (element.compareTo("${widget.user.User_Fonction}") == 0) {
        selectedValueFonction = element;
        selectedValueFonctionID = ListParam_ParamFonctionID[i];
      }
    }

    await DbTools.getAdresseType("AGENCE");
    ListParam_ParamDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListParam_ParamDepot.add(wAdresse.Adresse_Nom);
    });

    selectedValueDepot = ListParam_ParamDepot[0];
    for (int i = 0; i < ListParam_ParamDepot.length; i++) {
      String element = ListParam_ParamDepot[i];
      if (element.compareTo("${widget.user.User_Depot}") == 0) {
        selectedValueDepot = element;
      }
    }

    TECs[0].text = widget.user.User_Nom;
    TECs[1].text = widget.user.User_Prenom;
    TECs[2].text = widget.user.User_Adresse1;
    TECs[3].text = widget.user.User_Adresse2;
    TECs[4].text = widget.user.User_Cp;
    TECs[5].text = widget.user.User_Ville;
    TECs[6].text = widget.user.User_Tel;
    TECs[7].text = widget.user.User_Mail;
    TECs[8].text = widget.user.User_PassWord;
    TECs[9].text = widget.user.User_Matricule;

    print("isload");
    isLoad = true;
    User_Actif = widget.user.User_Actif;
    User_Niv_Isole = widget.user.User_Niv_Isole;

    setState(() {});
  }

  void initLib() async {
    await Reload();
  }

  List<TextEditingController> TECs = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void initState() {
    initLib();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dWidth = MediaQuery.of(context).size.width;
    dWidthLabel = dWidth / 15;

    print("Scaffold User_Actif $User_Actif");

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
                    "Edition Utilisateur ",
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
        body: !isLoad
            ? Container()
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          width: 100,
                          child: Text("Matricule : "),
                        ),
                        Container(
                          width: 120,
                          child: TextFormField(
                            controller: TECs[9],
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                            style: gColors.bodySaisie_B_B,
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          width: 30,
                          child: Text("Actif"),
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            return gColors.primary;
                          }),
                          value: User_Actif,
                          onChanged: (bool? value) {
                            User_Actif = !User_Actif;

                            print("User_Actif $User_Actif");
                            setState(() {});
                          },
                        ),
                        Spacer(),
                        InkWell(
                          child: Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                          onTap: () async {
                            widget.user.User_Nom = TECs[0].text;
                            widget.user.User_Prenom = TECs[1].text;
                            widget.user.User_Adresse1 = TECs[2].text;
                            widget.user.User_Adresse2 = TECs[3].text;
                            widget.user.User_Cp = TECs[4].text;
                            widget.user.User_Ville = TECs[5].text;
                            widget.user.User_Tel = TECs[6].text;
                            widget.user.User_Mail = TECs[7].text;
                            widget.user.User_PassWord = TECs[8].text;
                            widget.user.User_Matricule = TECs[9].text;
                            widget.user.User_Service = selectedValueService;
                            widget.user.User_Famille = selectedValueFamille;
                            widget.user.User_NivHabID = selectedValueUser_NivHabID;
                            widget.user.User_TypeUser = selectedValueUser_TypeUser;
                            widget.user.User_Fonction = selectedValueFonction;
                            widget.user.User_Depot = selectedValueDepot;
                            widget.user.User_Actif = User_Actif;
                            widget.user.User_Niv_Isole = User_Niv_Isole;
                            DbTools.setUser(widget.user);
                            Navigator.pop(context);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                          onTap: () async {
                            await Reload();
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.copy,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                          onTap: () async {
                            widget.user.User_Nom = TECs[0].text + " ***COPY***";
                            widget.user.User_Prenom = TECs[1].text;
                            widget.user.User_Adresse1 = "";
                            widget.user.User_Adresse2 = "";
                            widget.user.User_Cp = "";
                            widget.user.User_Ville = "";
                            widget.user.User_Tel = "";
                            widget.user.User_Mail = "";
                            widget.user.User_PassWord = "";
                            widget.user.User_Matricule = "";
                            widget.user.User_Service = selectedValueService;
                            widget.user.User_Famille = selectedValueFamille;
                            widget.user.User_Fonction = selectedValueFonction;
                            widget.user.User_Actif = false;
                            DbTools.addUser(widget.user);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButtonUser_TypeUser(),
                        /*Container(
                          width: 15,
                        ),
                        DropdownButtonUser_NivHab(),
                        Container(
                          width: 10,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.badge,
                            color: Colors.orange,
                            size: 24.0,
                          ),
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit_Hab(user: widget.user, wImage: wImage)));
                            await Reload();
                          },
                        ),
                        Container(
                          width: 10,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.badge,
                            color: Colors.red,
                            size: 24.0,
                          ),
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit_Desc(user: widget.user, wImage: wImage)));
                            await Reload();
                          },
                        ),
                        Container(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text("Droits isolés"),
                        ),
                        Container(
                          width: 10,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            return gColors.primary;
                          }),
                          value: User_Niv_Isole,
                          onChanged: (bool? value) {
                            User_Niv_Isole = !User_Niv_Isole;
                            print("User_Niv_Isole $User_Niv_Isole");
                            setState(() {});
                          },
                        ),
                        Container(
                          width: 15,
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                          width: dWidth / 2,
                          child: Column(
                            children: [
                              EditUser(),
                              Container(
                                child: Text(
                                  "LISTING CLIENT",
                                  style: gColors.bodyText_B_B,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: ClientGridWidget(),
                              ),
                            ],
                          )),
                      Container(
                        width: dWidth / 2,
                        child: EditUser2(),
                      ),
                    ]),
                  ),
                ],
              ));
  }

  //********************************************
  //********************************************
  //********************************************

  Widget EditUser2() {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 560,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownButtonFamille(),
                ],
              ),
              Row(
                children: [
                  DropdownButtonService(),
                ],
              ),
              Row(
                children: [
                  DropdownButtonFonction(),
                ],
              ),
              Row(
                children: [
                  DropdownButtonDepot(),
                ],
              ),
              Row(
                children: [
                  Photo(),
                ],
              ),
              Row(
                children: [
                  Doc(),
                ],
              ),
            ],
          ),
        ));
  }

  Widget DropdownButtonService() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: dWidthLabel,
        child: Text("Service : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une service',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamService.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueService,
          onChanged: (value) {
            setState(() {
              selectedValueServiceID = ListParam_ParamServiceID[ListParam_ParamService.indexOf(value!)];
              selectedValueService = value;
              print("selectedValueService $selectedValueServiceID $selectedValueService");
              setState(() {});
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
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Service", wTitle: "Paramètres Services")));
          await Reload();
        },
      ),
    ]);
  }

  Widget DropdownButtonFonction() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: dWidthLabel,
        child: Text("Fonction : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une Fonction',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamFonction.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueFonction,
          onChanged: (value) {
            setState(() {
              selectedValueFonctionID = ListParam_ParamFonctionID[ListParam_ParamFonction.indexOf(value!)];
              selectedValueFonction = value;
              print("selectedValueFonction $selectedValueFonctionID $selectedValueFonction");
              setState(() {});
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
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Fonction", wTitle: "Paramètres Fonctions")));
          await Reload();
        },
      ),
    ]);
  }

  Widget DropdownButtonUser_NivHab() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: 50,
        child: Text("Niveau"),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une User_NivHab',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamUser_NivHab.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueUser_NivHab,
          onChanged: (value) {
            setState(() {
              selectedValueUser_NivHabID = ListParam_ParamUser_NivHabID[ListParam_ParamUser_NivHab.indexOf(value!)];
              selectedValueUser_NivHab = value;
              print("selectedValueUser_NivHab $selectedValueUser_NivHabID $selectedValueUser_NivHab");
              setState(() {});
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
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "NivHab", wTitle: "Paramètres Niveaux")));
          await Reload();
        },
      ),
    ]);
  }

  Widget DropdownButtonUser_TypeUser() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: 40,
        child: Text("Type"),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une User_TypeUser',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamUser_TypeUser.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueUser_TypeUser,
          onChanged: (value) {
            setState(() {

              selectedValueUser_TypeUser = value!;
              print("selectedValueUser_TypeUser $selectedValueUser_TypeUser");
              setState(() {});
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
 /*     IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "TypeUser", wTitle: "Paramètres Types")));
          await Reload();
        },
      ),*/
    ]);
  }

  Widget DropdownButtonFamille() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: dWidthLabel,
        child: Text("Famille : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une famille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamFamille.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueFamille,
          onChanged: (value) {
            setState(() {
              selectedValueFamilleID = ListParam_ParamFamilleID[ListParam_ParamFamille.indexOf(value!)];
              selectedValueFamille = value;
              print("selectedValueFamille $selectedValueFamilleID $selectedValueFamille");
              setState(() {});
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
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Famille", wTitle: "Paramètres Familles")));
          await Reload();
        },
      ),
    ]);
  }

  Widget DropdownButtonDepot() {
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        width: dWidthLabel,
        child: Text("Agence : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une agence',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamDepot.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueDepot,
          onChanged: (value) {
            setState(() {
              selectedValueDepot = value!;
              print("selectedValueDepot $selectedValueDepot");
              setState(() {});
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
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Depot", wTitle: "Paramètres Depots")));
          await Reload();
        },
      ),
    ]);
  }

  //********************************************
  //********************************************
  //********************************************

  Widget EditUser() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Container(
          height: 380,
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
              _buildField("Nom", TECs[0]),
              _buildField("Prénom", TECs[1]),
              gColors.wSimpleLigne(),
              _buildField("Adresse", TECs[2]),
              _buildField("", TECs[3]),
              _buildField("Code postal", TECs[4]),
              _buildField("Ville", TECs[5]),
              gColors.wSimpleLigne(),
              _buildField("Téléphone ", TECs[6]),
              _buildField("Mail", TECs[7]),
              gColors.wSimpleLigne(),
              _buildField("Mot de passe", TECs[8]),
            ],
          ),
        ));
  }

  Widget _buildField(String label, TextEditingController textEditingController) {
    return Row(
      children: [
        Container(
          width: 5,
        ),
        Container(
          width: dWidthLabel,
          child: Text("$label ${label.isNotEmpty ? ":" : ""} "),
        ),
        Expanded(
          child: TextFormField(
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

  //**************************************************
  //**************************************************
  //**************************************************

  Widget Photo() {
    String wImgPath = "${DbTools.SrvImg}User_${widget.user.User_Matricule}.jpg";
    print("wImgPath $wImgPath");
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Image.asset("assets/images/Photo.png"),
              onPressed: () async {
                await _startFilePicker(onSetState);
              },
            ),
            Container(width: 10),
            wImage,
            Container(width: 10),
            ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(48), // Image radius
                child: wImage,
              ),
            )
          ],
        ));
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget Doc() {
    String wImgPath = "${DbTools.SrvImg}User_${widget.user.User_Matricule}.jpg";

    print("DOCDOCDOCDOC wImgPath $wImgPath  imgList.length ${imgList.length}");

    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//      height: 100,
        child: Row(
          children: [
            Column(
              children: [
                Container(width: 8),
                IconButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Image.asset("assets/images/Doc.png"),
                  onPressed: () async {
                    for (int i = 0; i < 10; i++) {
                      if (!imgListi.contains(i)) {
                        await _startFileDoc(onSetState, i);
                        break;
                      }
                    }
                  },
                ),
                Container(height: 8),
                Text(
                  "${imgList.length} Fichiers",
                  style: gColors.bodySaisie_B_B,
                ),
              ],
            ),
            Container(width: 10),
            Container(
              width: 550,
              height: 240,
//            color: Colors.red,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imgList.length, // number of items in your list
                  itemBuilder: (BuildContext context, int Itemindex) {
                    return imgList[Itemindex];
                  }),
            ),
          ],
        ));
  }

  _startFilePicker(VoidCallback onSetState) async {
    print("UploadFilePicker > User_${widget.user.User_Matricule}.jpg");
    await Upload.UploadFilePicker("User_${widget.user.User_Matricule}.jpg", onSetState);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  _startFileDoc(VoidCallback onSetState, int i) async {
    print("UploadFilePicker > User_${widget.user.User_Matricule}.jpg");
    await Upload.UploadDocPicker("User_${widget.user.User_Matricule}_Doc_$i.pdf", onSetState);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  Widget ClientGridWidget() {
    List<DaviColumn<Client>> wColumns = [
      new DaviColumn(name: 'Id', width: 60, stringValue: (row) => "${row.ClientId}"),
      new DaviColumn(name: 'Forme', width: 80, stringValue: (row) => "${row.Client_Civilite}"),
      new DaviColumn(name: 'Raison Social', width: 450, stringValue: (row) => "${row.Client_Nom}"),
      new DaviColumn(name: 'Agence', width: 200, stringValue: (row) => "${row.Client_Depot}"),
      new DaviColumn(name: 'Origine', width: 100, stringValue: (row) => row.Client_Origine_CSIP),
    ];

    print("ClientGridWidget");
    DaviModel<Client>? _model;
    _model = DaviModel<Client>(rows: DbTools.ListClient, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Client>(
          _model,
          visibleRowsCount: 11,
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
}
