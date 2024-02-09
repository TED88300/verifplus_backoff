import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Articles_Dialog {
  Articles_Dialog();

  static Future<void> Param_Dialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Articles_screen(),
    );
  }
}

class Articles_screen extends StatefulWidget {
  @override
  _Articles_screenState createState() => _Articles_screenState();
}

class _Articles_screenState extends State<Articles_screen> {
  Art wArt = Art.ArtInit();
  String Title = "Verif+ : Paramètres ";
  bool bReload = true;

  final Search_TextController = TextEditingController();




  static List<String> ListParam_ParamGroupe = [];
  static List<String> ListParam_ParamGroupeID = [];
  String selectedValueGroupe = "";
  String selectedValueGroupeID = "";

  static List<String> ListParam_ParamFam = [];
  static List<String> ListParam_ParamFamID = [];
  String selectedValueFam = "";
  String selectedValueFamID = "";

  static List<String> ListParam_ParamSousFam = [];
  static List<String> ListParam_ParamSousFamID = [];
  String selectedValueSousFam = "";
  String selectedValueSousFamID = "";

  static List<String> ListParam_FiltreGroupe = [];
  static List<String> ListParam_FiltreGroupeID = [];
  String FiltreGroupe = "";
  String FiltreGroupeID = "";
  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];
  String FiltreFam = "";
  String FiltreFamID = "";
  static List<String> ListParam_FiltreSousFam = [];
  static List<String> ListParam_FiltreSousFamID = [];
  String FiltreSousFam = "";
  String FiltreSousFamID = "";

  Future Reload() async {
    bReload = false;
    await DbTools.getArtAll();
    print("getArtAll ${DbTools.ListArt.length}");

    ListParam_ParamSousFam.clear();
    ListParam_ParamSousFamID.clear();


    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("$selectedValueFamID") == 0) {
        ListParam_ParamSousFam.add(element.Param_Param_Text);
        ListParam_ParamSousFamID.add(element.Param_Param_ID);
      }
    });
    selectedValueSousFam = ListParam_ParamSousFam[0];
    selectedValueSousFamID = ListParam_ParamSousFamID[0];

    ListParam_FiltreSousFam.clear();
    ListParam_FiltreSousFamID.clear();

    ListParam_FiltreSousFam.add("Tous");
    ListParam_FiltreSousFamID.add("*");


    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("$FiltreFamID") == 0) {
        ListParam_FiltreSousFam.add(element.Param_Param_Text);
        ListParam_FiltreSousFamID.add(element.Param_Param_ID);
      }
    });
    FiltreSousFam = ListParam_FiltreSousFam[0];
    FiltreSousFamID = ListParam_FiltreSousFamID[0];

    await Filtre();
  }

  Future Filtre() async {
    List<Art> ListArtsearchresultTmp = [];
    List<Art> ListArtsearchresultTmpG = [];
    List<Art> ListArtsearchresultTmpF = [];

    
    ListArtsearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListArtsearchresultTmp.addAll(DbTools.ListArt);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListArt.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListArtsearchresultTmp.add(element);
        }
      });
    }

      if (FiltreGroupe.compareTo("Tous") == 0) {
        ListArtsearchresultTmpG.addAll(ListArtsearchresultTmp);
      } else {
        ListArtsearchresultTmp.forEach((element) {
          if (FiltreGroupe.compareTo(element.Art_Groupe)==0)
            ListArtsearchresultTmpG.add(element);
        });
      }

    if (FiltreFam.compareTo("Tous") == 0) {
      ListArtsearchresultTmpF.addAll(ListArtsearchresultTmpG);
    } else {
      ListArtsearchresultTmpG.forEach((element) {
        if (FiltreFam.compareTo(element.Art_Fam)==0)
          ListArtsearchresultTmpF.add(element);
      });
    }

    DbTools.ListArtsearchresult.clear();

    if (FiltreSousFam.compareTo("Tous") == 0) {
      DbTools.ListArtsearchresult.addAll(ListArtsearchresultTmpF);
    } else {
      ListArtsearchresultTmpF.forEach((element) {
        if (FiltreSousFam.compareTo(element.Art_Sous_Fam)==0)
          DbTools.ListArtsearchresult.add(element);
      });
    }
    bReload = true;

    setState(() {});
  }

  void initLib() async {

    bReload = false;

    await DbTools.getParam_ParamAll();

    Search_TextController.text = "";

    ListParam_ParamGroupe.clear();
    ListParam_ParamGroupeID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("GrpHab") == 0) {
        ListParam_ParamGroupe.add(element.Param_Param_Text);
        ListParam_ParamGroupeID.add(element.Param_Param_ID);
      }
    });
    selectedValueGroupe = ListParam_ParamGroupe[0];
    selectedValueGroupeID = ListParam_ParamGroupeID[0];
    ListParam_FiltreGroupe.clear();
    ListParam_FiltreGroupeID.clear();

    ListParam_FiltreGroupe.add("Tous");
    ListParam_FiltreGroupeID.add("*");

    DbTools.ListParam_Param.forEach((element) {
      if (element.Param_Param_Type.compareTo("GrpHab") == 0) {
        ListParam_FiltreGroupe.add(element.Param_Param_Text);
        ListParam_FiltreGroupeID.add(element.Param_Param_ID);
      }
    });

    FiltreGroupe = ListParam_FiltreGroupe[0];
    FiltreGroupeID = ListParam_FiltreGroupeID[0];

    ListParam_ParamFam.clear();
    ListParam_ParamFamID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Fam") == 0) {
        ListParam_ParamFam.add(element.Param_Param_Text);
        ListParam_ParamFamID.add(element.Param_Param_ID);
      }
    });
    selectedValueFam = ListParam_ParamFam[0];
    selectedValueFamID = ListParam_ParamFamID[0];


    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("*");

    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Fam") == 0) {
        ListParam_FiltreFam.add(element.Param_Param_Text);
        ListParam_FiltreFamID.add(element.Param_Param_ID);
      }
    });
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFam[0];
    await Reload();
  }

  void initState() {
    super.initState();
    initLib();

    Title = "Verif+ : Articles ";
  }

  @override
  Widget build(BuildContext context) {
    print("build ${wArt.Art_Id}");

    return
      Container(
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
                    child: _buildFieldID(context, wArt),
                  ),
                  Container(
                    width: 8,
                  ),
                  Container(
                    width: 280,
                    child: _buildFieldText(context, wArt),
                  ),
                  DropdownButtonGroupe(),
                  DropdownButtonFam(),
                  DropdownButtonSousFam(),
                  Container(
                    width: 1,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.check,
                      color: wArt.Art_Id.isNotEmpty ? Colors.blue : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wArt.Art_Id.isNotEmpty) {
                        wArt.Art_Lib = Art_TextController.text;
                        wArt.Art_Id = Art_IDController.text;
                        wArt.Art_Groupe = selectedValueGroupe;
                        wArt.Art_Fam = selectedValueFam;
                        wArt.Art_Sous_Fam = selectedValueSousFam;
                        await DbTools.setArt(wArt);
                        await Reload();
                        wArt = Art.ArtInit();
                      }
                    },
                  ),
                  Container(
                    width: 1,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.delete,
                      color: wArt.Art_Id.isNotEmpty ? Colors.red : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wArt.Art_Id.isNotEmpty) {
                        await DbTools.delArt(wArt);
                        await Reload();
                        wArt = Art.ArtInit();
                      }
                    },
                  ),
                  InkWell(
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 24.0,
                    ),
                    onTap: () async {
                      Art art = await Art.ArtInit();

                      await DbTools.addArt(art);

                      await Reload();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            _buildFieldTextSearch(context),
            Container(
              height: 10,
            ),ArtGridWidget(),


          ],
        ),

    );
  }

  Widget ArtGridWidget() {
    List<DaviColumn<Art>> wColumns = [
      new DaviColumn(grow: 2, name: 'Id', stringValue: (row) => "${row.Art_Id}"),
      new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.Art_Lib),
      new DaviColumn(name: 'Groupe', grow: 18, stringValue: (row) => row.Art_Groupe),
      new DaviColumn(name: 'Famille', grow: 18, stringValue: (row) => row.Art_Fam),
      new DaviColumn(name: 'Sous-Famille', grow: 18, stringValue: (row) => row.Art_Sous_Fam),
    ];

    print("ArtGridWidget");
    DaviModel<Art>? _model;
    _model = DaviModel<Art>(rows: DbTools.ListArtsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Art>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (Art) => _onRowTap(context, Art),
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

  void _onRowTap(BuildContext context, Art Art) {
    setState(() {
      wArt = Art;
      selectedValueGroupe = wArt.Art_Groupe;

      print("wArt.Art_Groupe ${wArt.Art_Groupe}");
      selectedValueGroupe = ListParam_ParamGroupe[0];
      selectedValueGroupeID = ListParam_ParamGroupeID[0];

      int i = 0;
      ListParam_ParamGroupe.forEach((element) {
        if (element.compareTo("${wArt.Art_Groupe}") == 0) {
          selectedValueGroupe = ListParam_ParamGroupe[i];
          selectedValueGroupeID = ListParam_ParamGroupeID[i];
          return;
        }
        i++;
      });

      print("selectedValueGroupe $selectedValueGroupeID $selectedValueGroupe");

      print("selectedValueFam ${wArt.Art_Fam}");
      selectedValueFamID = ListParam_ParamFamID[0];
      selectedValueFam = ListParam_ParamFam[0];

      i = 0;
      ListParam_ParamFam.forEach((element) {
        if (element.compareTo("${wArt.Art_Fam}") == 0) {
          selectedValueFamID = ListParam_ParamFamID[i];
          selectedValueFam = ListParam_ParamFam[i];
          return;
        }
        i++;
      });

      print("selectedValueFam $selectedValueFamID $selectedValueFam");



      bool trv = false;
      ListParam_ParamSousFam.clear();
      ListParam_ParamSousFamID.clear();
      DbTools.ListParam_ParamAll.forEach((element) {

        print("_onRowTap ${element.Param_Param_Type} $selectedValueFamID");

        if (element.Param_Param_Type.compareTo("$selectedValueFamID") == 0) {
          ListParam_ParamSousFam.add(element.Param_Param_Text);
          ListParam_ParamSousFamID.add(element.Param_Param_ID);
          if (selectedValueSousFam == wArt.Art_Sous_Fam) trv = true;
        }
      });

      print("_onRowTap ListParam_ParamSousFam.length ${ListParam_ParamSousFam.length}");

      if (trv)
        selectedValueSousFam = wArt.Art_Sous_Fam;
      else
        selectedValueSousFam = ListParam_ParamSousFam[0];

      print("_onRowTap $selectedValueSousFam");

      print("_onRowTap ${wArt.Art_Id}");
    });
  }

  Widget _buildFieldTextSearch(BuildContext context) {
    print("_buildFieldTextSearch");
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.blue,
              size: 24.0,
            ),
            Container(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: Search_TextController,
                onChanged: (String? value) async {
//        Search_TextController.text = value!;
                  print("_buildFieldTextSearch search ${Search_TextController.text}");
                  await Filtre();
                },
                decoration: InputDecoration(
                  isDense: true,
                ),
                style: gColors.bodySaisie_B_B,
              ),
            ),
            DropdownFiltreGroupe(),
            DropdownFiltreFam(),
            DropdownFiltreSousFam(),
          ],
        ));
  }

  final Art_TextController = TextEditingController();
  Widget _buildFieldText(BuildContext context, Art Art) {
    print("_buildFieldText ${Art.Art_Id} ${wArt.Art_Lib}");
    Art_TextController.text = Art.Art_Lib;
    return TextFormField(
      controller: Art_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Art_IDController = TextEditingController();
  Widget _buildFieldID(BuildContext context, Art Art) {
    Art_IDController.text = Art.Art_Id;
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
      ),
      controller: Art_IDController,
      style: gColors.bodySaisie_B_B,
    );
  }

 /* Widget _buildDelete(BuildContext context, DaviRow<Art> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delArt(rowData.data);
        await Reload();
      },
    );
  }*/

  Widget DropdownButtonGroupe() {
    print("DropdownButtonGroupe $selectedValueGroupe");

    if (!bReload) return Container();
    if (selectedValueGroupe.isEmpty) return Container();
    if (ListParam_ParamGroupe.length == 0) return Container();
    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("Groupe : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner un Groupe',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamGroupe.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueGroupe,
          onChanged: (value) {
            setState(() {
              selectedValueGroupeID = ListParam_ParamGroupeID[ListParam_ParamGroupe.indexOf(value!)];
              selectedValueGroupe = value;
              print("selectedValueGroupe $selectedValueGroupeID $selectedValueGroupe");
              setState(() {});
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

  Widget DropdownButtonFam() {
    print("DropdownButtonFam $selectedValueFam");
    if (!bReload) return Container();

    if (ListParam_ParamFam.length == 0) return Container();

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
          items: ListParam_ParamFam.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueFam,
          onChanged: (value) {
            setState(() {
              selectedValueFamID = ListParam_ParamFamID[ListParam_ParamFam.indexOf(value!)];
              selectedValueFam = value;
              print("selectedValueFam $selectedValueFamID $selectedValueFam");
              Reload();
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

  Widget DropdownButtonSousFam() {
    print("DropdownButtonSousFam $selectedValueSousFam");
    if (!bReload) return Container();

    if (ListParam_ParamSousFam.length == 0) return Container();

    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("SousFam : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une SousFamille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_ParamSousFam.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: selectedValueSousFam,
          onChanged: (value) {
            setState(() {
              selectedValueSousFamID = ListParam_ParamSousFamID[ListParam_ParamSousFam.indexOf(value!)];
              selectedValueSousFam = value;
              print("selectedValueSousFam $selectedValueSousFamID $selectedValueSousFam");
              setState(() {});
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
          buttonWidth: 280,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        )),
      ),
    ]);
  }
  //*************************************

  Widget DropdownFiltreGroupe() {
    print("DropdownFiltreGroupe $FiltreGroupe");

    if (!bReload) return Container();
    if (ListParam_FiltreGroupe.length <= 1) return Container();

    print("DropdownFiltreGroupe $FiltreGroupe");

    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("Groupe : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner un Groupe',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_FiltreGroupe.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: FiltreGroupe,
          onChanged: (value) {
            FiltreGroupeID = ListParam_FiltreGroupeID[ListParam_FiltreGroupe.indexOf(value!)];
            FiltreGroupe = value;
            print("FiltreGroupe $FiltreGroupeID $FiltreGroupe");
            Filtre();
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

  Widget DropdownFiltreFam() {
    print("DropdownFiltreFam $FiltreFam");
    if (!bReload) return Container();

    if (ListParam_FiltreFam.length <= 1) return Container();
    print("DropdownFiltreFam $FiltreFam");

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


              ListParam_FiltreSousFam.clear();
              ListParam_FiltreSousFamID.clear();

              ListParam_FiltreSousFam.add("Tous");
              ListParam_FiltreSousFamID.add("*");


              DbTools.ListParam_Param.forEach((element) {
                if (element.Param_Param_Type.compareTo("$FiltreFamID") == 0) {
                  ListParam_FiltreSousFam.add(element.Param_Param_Text);
                  ListParam_FiltreSousFamID.add(element.Param_Param_ID);
                }
              });
              FiltreSousFam = ListParam_FiltreSousFam[0];
              FiltreSousFamID = ListParam_FiltreSousFamID[0];



              print(">>>>>>>>>>>>>>>>> FiltreSousFam $FiltreSousFamID $FiltreSousFam");

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

  Widget DropdownFiltreSousFam() {
    print("DropdownFiltreSousFam $FiltreSousFam ${ListParam_FiltreSousFam.length} }");
    if (!bReload) return Container();

    if (ListParam_FiltreSousFam.length <= 1) return Container();
    print("DropdownFiltreSousFam $FiltreSousFam ${ListParam_FiltreSousFam.length} }");

    return Row(children: [
      Container(
        width: 5,
      ),
      Container(
        child: Text("SousFam : "),
      ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            'Séléctionner une SousFamille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          items: ListParam_FiltreSousFam.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  "  $item",
                  style: gColors.bodyTitle1_N_Gr,
                ),
              )).toList(),
          value: FiltreSousFam,
          onChanged: (value) {
            FiltreSousFamID = ListParam_FiltreSousFam[ListParam_FiltreSousFam.indexOf(value!)];
            FiltreSousFam = value;
            print("FiltreSousFam $FiltreSousFamID $FiltreSousFam");
            Filtre();
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
          buttonWidth: 280,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        )),
      ),
    ]);
  }
}
