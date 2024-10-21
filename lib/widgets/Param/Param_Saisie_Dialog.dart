import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Saisie_Param_Dialog.dart';





class Param_Saisie_Dialog {
  Param_Saisie_Dialog();

  static Future<void> Param_Dialog(
    BuildContext context,
    String wTitle,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Param_Saisie_screen(
        wTitle: wTitle,
      ),
    );
  }
}

class Param_Saisie_screen extends StatefulWidget {
  final String wTitle;
  const Param_Saisie_screen({Key? key, required this.wTitle}) : super(key: key);

  @override
  _Param_Saisie_screenState createState() => _Param_Saisie_screenState();
}

class _Param_Saisie_screenState extends State<Param_Saisie_screen> {
  Param_Saisie wParam_Saisie = Param_Saisie.Param_SaisieInit();
  String Title = "Paramètres ";

  static List<String> ListParam_ParamOrgane = [];
  static List<String> ListParam_ParamOrganeID = [];
  String selectedValueOrgane = "";
  String selectedValueOrganeID = "";

  static List<String> ListParam_ParamType = [];
  static List<String> ListParam_ParamTypeID = [];
  String selectedValueType = "";
  String selectedValueTypeID = "";

  static List<String> ListParam_ParamCtrl = [];
  static List<String> ListParam_ParamCtrlID = [];
  String selectedValueCtrl = "";
  String selectedValueCtrlID = "";

  static List<String> ListParam_ParamAff = [];
  static List<String> ListParam_ParamAffID = [];
  String selectedValueAff = "";
  String selectedValueAffID = "";

  bool isChecked_L1 = false;
  bool isChecked_L2 = false;

  Future Reload() async {
    await DbTools.getParam_Saisie(selectedValueOrganeID, selectedValueTypeID);
    print("getParam_Saisie ${DbTools.ListParam_Saisie.length}");
    await Filtre();
    setState(() {});
  }

  Future Filtre() async {
    DbTools.ListParam_Saisiesearchresult.clear();
    DbTools.ListParam_Saisiesearchresult.addAll(DbTools.ListParam_Saisie);
    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();
    print("getParam_Param ${DbTools.ListParam_Param.length}");

    ListParam_ParamOrgane.clear();
    ListParam_ParamOrganeID.clear();

    ListParam_ParamOrgane.add("Base");
    ListParam_ParamOrganeID.add("Base");


    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        ListParam_ParamOrgane.add(element.Param_Param_Text);
        ListParam_ParamOrganeID.add(element.Param_Param_ID);
      }
    });



    selectedValueOrgane = ListParam_ParamOrgane[0];
    selectedValueOrganeID = ListParam_ParamOrganeID[0];

    print("selectedValueOrgane $selectedValueOrganeID $selectedValueOrgane");

    ListParam_ParamType.clear();
    ListParam_ParamTypeID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {

      if (element.Param_Param_Type.compareTo("Type_Saisie") == 0) {
        ListParam_ParamType.add(element.Param_Param_Text);
        ListParam_ParamTypeID.add(element.Param_Param_ID);
      }
    });

    print("ListParam_ParamType ${ListParam_ParamType.length}");
    selectedValueType = ListParam_ParamType[0];
    selectedValueTypeID = ListParam_ParamTypeID[0];

    print("selectedValueType $selectedValueTypeID $selectedValueType");
    ListParam_ParamCtrl.clear();
    ListParam_ParamCtrlID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Ctrl_Saisie") == 0) {
        ListParam_ParamCtrl.add(element.Param_Param_Text);
        ListParam_ParamCtrlID.add(element.Param_Param_ID);
      }
    });

    print("ListParam_ParamCtrl ${ListParam_ParamCtrl.length}");

    selectedValueCtrl = ListParam_ParamCtrl[0];
    selectedValueCtrlID = ListParam_ParamCtrlID[0];

    print("selectedValueCtrl $selectedValueCtrlID $selectedValueCtrl");

    ListParam_ParamAff.clear();
    ListParam_ParamAffID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Aff_Liste") == 0) {
        ListParam_ParamAff.add(element.Param_Param_Text);
        ListParam_ParamAffID.add(element.Param_Param_ID);
      }
    });

    print("ListParam_ParamAff ${ListParam_ParamAff.length}");

    selectedValueAff = ListParam_ParamAff[0];
    selectedValueAffID = ListParam_ParamAffID[0];

    print("selectedValueAff $selectedValueAffID $selectedValueAff");




    Reload();
  }

  void initState() {
    super.initState();
    initLib();

    Title = "Paramètres - ${widget.wTitle}";
  }

  @override
  Widget build(BuildContext context) {
    print("build ${wParam_Saisie.Param_Saisie_Label} ${wParam_Saisie.Param_Saisie_Ordre_Affichage} ${wParam_Saisie.Param_Saisie_Affichage_L1}  ${wParam_Saisie.Param_Saisie_Affichage_L1_Ordre}");

    return Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 10,
                ),
                selectedValueTypeID.isEmpty
                    ? Container()
                    : DropdownButtonOrgane(),
                Container(
                  width: 10,
                ),
                selectedValueTypeID.isEmpty
                    ? Container()
                    : DropdownButtonType(),
              ],
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: wParam_Saisie.Param_Saisie_ID.isEmpty ? Colors.black26 : Colors.black,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: wParam_Saisie.Param_Saisie_ID.isNotEmpty
                                ? Colors.black
                                : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wParam_Saisie.Param_Saisie_Ordre > 1) {
                              DbTools.ListParam_Saisiesearchresult.forEach(
                                  (element) async {
                                print("AVANT ${element.Param_Saisie_ID}");
                              });

                              for (int i = 0;
                                  i <
                                      DbTools
                                          .ListParam_Saisiesearchresult.length;
                                  i++) {
                                Param_Saisie element =
                                    DbTools.ListParam_Saisiesearchresult[i];

                                if (element.Param_Saisie_Ordre ==
                                    wParam_Saisie.Param_Saisie_Ordre - 1) {
                                  element.Param_Saisie_Ordre =
                                      wParam_Saisie.Param_Saisie_Ordre;
                                  await DbTools.setParam_Saisie(element);
                                } else if (element.Param_Saisie_Ordre ==
                                    wParam_Saisie.Param_Saisie_Ordre) {
                                  element.Param_Saisie_Ordre =
                                      wParam_Saisie.Param_Saisie_Ordre - 1;
                                  await DbTools.setParam_Saisie(element);
                                  wParam_Saisie = element;
                                }
                              }

                              DbTools.ListParam_Saisiesearchresult.forEach(
                                  (element) {
                                print(
                                    "APRES ${element.Param_Saisie_ID}  ${element.Param_Saisie_Ordre}");
                              });
                              //wParam_Saisie.Param_Saisie_Ordre = wParam_Saisie.Param_Saisie_Ordre - 1;
                              Reload();
                              setState(() {});
                            }
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: wParam_Saisie.Param_Saisie_ID.isNotEmpty
                                ? Colors.black
                                : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wParam_Saisie.Param_Saisie_Ordre <
                                DbTools.ListParam_Saisiesearchresult.length) {
                              Param_Saisie tmpparamSaisie =
                                  Param_Saisie.Param_SaisieInit();

                              DbTools.ListParam_Saisiesearchresult.forEach(
                                  (element) async {
                                print(
                                    "AVANT ${element.Param_Saisie_ID}  ${element.Param_Saisie_Ordre}");
                              });

                              for (int i = DbTools
                                          .ListParam_Saisiesearchresult.length -
                                      1;
                                  i >= 0;
                                  i--) {
                                Param_Saisie element =
                                    DbTools.ListParam_Saisiesearchresult[i];

                                if (element.Param_Saisie_Ordre ==
                                    wParam_Saisie.Param_Saisie_Ordre) {
                                  element.Param_Saisie_Ordre =
                                      wParam_Saisie.Param_Saisie_Ordre + 1;
                                  await DbTools.setParam_Saisie(element);
                                  tmpparamSaisie = element;
                                } else if (element.Param_Saisie_Ordre ==
                                    wParam_Saisie.Param_Saisie_Ordre + 1) {
                                  element.Param_Saisie_Ordre =
                                      wParam_Saisie.Param_Saisie_Ordre;
                                  await DbTools.setParam_Saisie(element);
                                }
                              }

                              DbTools.ListParam_Saisiesearchresult.forEach(
                                  (element) {
                                print(
                                    "APRES ${element.Param_Saisie_ID} ${element.Param_Saisie_Ordre}");
                              });
                              //wParam_Saisie.Param_Saisie_Ordre = wParam_Saisie.Param_Saisie_Ordre - 1;
                              Reload();
                              setState(() {});
                              wParam_Saisie = tmpparamSaisie;
                            }
                          },
                        ),
                        Container(
                          width: 8,
                        ),
                        Container(
                          width: 70,
                          child: _buildFieldID(context, wParam_Saisie),
                        ),
                        Container(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            width: 300,
                            child: _buildFieldText(context, wParam_Saisie),
                          ),
                        ),
                        Container(
                          width: 8,
                        ),
                        Container(
                          width: 300,
                          child: _buildFieldAide(context, wParam_Saisie),
                        ),
                        Container(
                          width: 8,
                        ),
                        Container(
                          width: 1,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.check,
                            color: wParam_Saisie.Param_Saisie_ID.isNotEmpty
                                ? Colors.blue
                                : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wParam_Saisie.Param_Saisie_ID.isNotEmpty) {
                              wParam_Saisie.Param_Saisie_ID = Param_Saisie_IDController.text;
                              wParam_Saisie.Param_Saisie_Label = Param_Saisie_LabelController.text;
                              wParam_Saisie.Param_Saisie_Aide = Param_Saisie_AideController.text;
                              wParam_Saisie.Param_Saisie_Controle = selectedValueCtrlID;
                              wParam_Saisie.Param_Saisie_Affichage = selectedValueAffID;
                              wParam_Saisie.Param_Saisie_Ordre_Affichage = int.parse(Param_Saisie_AffController.text);
                              wParam_Saisie.Param_Saisie_Affichage_Titre = Param_Saisie_TitreController.text;
                              wParam_Saisie.Param_Saisie_Affichage_L1_Ordre = int.parse(Param_Saisie_AffControllerL1.text);
                              wParam_Saisie.Param_Saisie_Affichage_L2_Ordre = int.parse(Param_Saisie_AffControllerL2.text);
                              wParam_Saisie.Param_Saisie_Icon = Param_Saisie_IconController.text;
                              wParam_Saisie.Param_Saisie_Triger = Param_Saisie_TrigerController.text;
                              print(">>>>>>>>>>>>> Param_Saisie_Controle |${wParam_Saisie.Param_Saisie_Controle}|");
                              await DbTools.setParam_Saisie(wParam_Saisie);
                              await Reload();
                              wParam_Saisie = Param_Saisie.Param_SaisieInit();
                            }
                          },
                        ),
                        Container(
                          width: 1,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.delete,
                            color: wParam_Saisie.Param_Saisie_ID.isNotEmpty
                                ? Colors.red
                                : Colors.black12,
                            size: 24.0,
                          ),
                          onTap: () async {
                            if (wParam_Saisie.Param_Saisie_ID.isNotEmpty) {
                              await DbTools.delParam_Saisie(wParam_Saisie);
                              await Reload();
                              wParam_Saisie = Param_Saisie.Param_SaisieInit();
                            }
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                            size: 24.0,
                          ),
                          onTap: () {
                            setState(() async {
                              Param_Saisie paramSaisie =
                                  Param_Saisie.Param_SaisieInit();
                              paramSaisie.Param_Saisie_Organe =
                                  selectedValueOrganeID;
                              paramSaisie.Param_Saisie_Type =
                                  selectedValueTypeID;
                              await DbTools.addParam_Saisie(paramSaisie);
                              await Reload();
                              setState(() {
                                wParam_Saisie = paramSaisie;

                                print(
                                    "_onRowTap ${wParam_Saisie.Param_Saisie_ID}");
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    wParam_Saisie.Param_Saisie_ID.isEmpty
                        ? Container() :
                         Row(
                            children: [
                              Container(
                                width: 50,
                              ),
                              Text(
                                'Ctrl : ',
                                style: gColors.bodySaisie_B_B,
                              ),
                              DropdownButtonCtrl(),
                              Container(
                                width: 20,
                              ),
                              Text(
                                'Aff : ',
                                style: gColors.bodySaisie_B_B,
                              ),
                              DropdownButtonAff(),
                              Container(
                                width: 10,
                              ),
                              Container(
                                width: 50,
                                child: _buildFieldAff(context, wParam_Saisie),
                              ),
                              Text(
                                'Col : ',
                                style: gColors.bodySaisie_B_B,
                              ),

                              Container(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  width: 30,
                                  child: _buildFieldTitre(context, wParam_Saisie),
                                ),
                              ),
                              Container(
                                width: 20,
                              ),
                              Text(
                                'L1 : ',
                                style: gColors.bodySaisie_B_B,
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                value: wParam_Saisie.Param_Saisie_Affichage_L1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    wParam_Saisie.Param_Saisie_Affichage_L1 =
                                        value!;
                                    if (value)
                                      wParam_Saisie.Param_Saisie_Affichage_L2 =
                                          !value;
                                  });
                                },
                              ),
                              Container(
                                width: 10,
                              ),
                              Container(
                                width: 50,
                                child: _buildFieldAffL1(context, wParam_Saisie),
                              ),
                              Container(
                                width: 20,
                              ),
                              Text(
                                'L2 : ',
                                style: gColors.bodySaisie_B_B,
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                value: wParam_Saisie.Param_Saisie_Affichage_L2,
                                onChanged: (bool? value) {
                                  setState(() {
                                    wParam_Saisie.Param_Saisie_Affichage_L2 =
                                        value!;
                                    if (value)
                                      wParam_Saisie.Param_Saisie_Affichage_L1 =
                                          !value;
                                  });
                                },
                              ),
                              Container(
                                width: 20,
                              ),
                              Container(
                                width: 50,
                                child: _buildFieldAffL2(context, wParam_Saisie),
                              ),
                              Container(
                                width: 20,
                              ),
                              Container(
                                width: 100,
                                child: _buildFieldIcon(context, wParam_Saisie),
                              ),
                              Container(
                                width: 20,
                              ),
                              Container(
                                width: 100,
                                child: _buildFieldTriger(context, wParam_Saisie),
                              ),
                              Container(
                                width: 20,
                              ),
                              
                            ],
                          ),
                  ],
                )),
            Container(
              height: 10,
            ),
            Param_SaisieGridWidget(),          ],
        ),
    );
  }

  Widget Param_SaisieGridWidget() {
    List<DaviColumn<Param_Saisie>> wColumns = [
      new DaviColumn(
          name: 'Id',
          stringValue: (row) =>
              "${row.Param_Saisie_ID} ${row.Param_Saisie_Ordre}"
              ""),
      DaviColumn(
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<Param_Saisie> data) {
            return InkWell(
              child: const Icon(Icons.list_alt, size: 16),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Param_Saisie_Param_screen(wType: data.data.Param_Saisie_ID)));
              },
            );
          }),
      new DaviColumn(
          name: 'Libellé',
          grow: 18,
          stringValue: (row) => row.Param_Saisie_Label),
      new DaviColumn(
          name: 'Aide', grow: 18, stringValue: (row) => row.Param_Saisie_Aide),
      new DaviColumn(
          name: 'Contrôle',
          grow: 8,
          stringValue: (row) => row.Param_Saisie_Controle),
      new DaviColumn(
          name: 'Affichage',
          grow: 8,
          stringValue: (row) =>
              "${row.Param_Saisie_Affichage} ${row.Param_Saisie_Ordre_Affichage}"),

      new DaviColumn(
          name: 'Colonne',
          grow: 8,
          stringValue: (row) =>
          "${row.Param_Saisie_Affichage_Titre}"),
      new DaviColumn(
          name: 'Titre',
          grow: 6,
          stringValue: (row) =>
              "${row.Param_Saisie_Affichage_L1 ? "L1 ${row.Param_Saisie_Affichage_L1_Ordre}" : ""}${row.Param_Saisie_Affichage_L2 ? "L2 ${row.Param_Saisie_Affichage_L2_Ordre}" : ""}"),
      new DaviColumn(
          name: 'Icône',
          grow: 4,
          stringValue: (row) =>
          "${row.Param_Saisie_Icon}"),
      new DaviColumn(
          name: 'Triger',
          grow: 4,
          stringValue: (row) =>
          "${row.Param_Saisie_Triger}"),



    ];

    print("Param_SaisieGridWidget");
    DaviModel<Param_Saisie>? _model;

    _model = DaviModel<Param_Saisie>(
        rows: DbTools.ListParam_Saisiesearchresult, columns: wColumns);

    return new DaviTheme(
        child: new Davi<Param_Saisie>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (paramParam) => _onRowTap(context, paramParam),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(
              color: gColors.secondary,
              bottomBorderHeight: 2,
              bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(
              height: 24,
              alignment: Alignment.center,
              textStyle: gColors.bodySaisie_B_B,
              resizeAreaWidth: 3,
              resizeAreaHoverColor: Colors.black,
              sortIconColors: SortIconColors.all(Colors.black),
              expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

  void _onRowTap(BuildContext context, Param_Saisie paramParam) {
    setState(() {
      wParam_Saisie = paramParam;
      ListParam_ParamCtrlID.forEach((element) {
        if (element.compareTo(paramParam.Param_Saisie_Controle) == 0) {
          selectedValueCtrlID = element;
          selectedValueCtrl =
              ListParam_ParamCtrl[ListParam_ParamCtrlID.indexOf(element)];
        }
      });

      ListParam_ParamAffID.forEach((element) {
        if (element.compareTo(paramParam.Param_Saisie_Affichage) == 0) {
          selectedValueAffID = element;
          selectedValueAff =
              ListParam_ParamAff[ListParam_ParamAffID.indexOf(element)];
        }
      });

      print("_onRowTap ${wParam_Saisie.Param_Saisie_ID}");
    });
  }

  final Param_Saisie_LabelController = TextEditingController();
  Widget _buildFieldText(BuildContext context, Param_Saisie paramParam) {
    print(
        "_buildFieldText ${paramParam.Param_Saisie_ID} ${wParam_Saisie.Param_Saisie_Label}");
    Param_Saisie_LabelController.text = paramParam.Param_Saisie_Label;
    return TextFormField(
      controller: Param_Saisie_LabelController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_IDController = TextEditingController();
  Widget _buildFieldID(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_IDController.text = paramParam.Param_Saisie_ID;
    return TextFormField(
      controller: Param_Saisie_IDController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_AideController = TextEditingController();
  Widget _buildFieldAide(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_AideController.text = paramParam.Param_Saisie_Aide;
    return TextFormField(
      controller: Param_Saisie_AideController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }


  final Param_Saisie_TitreController = TextEditingController();
  Widget _buildFieldTitre(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_TitreController.text = paramParam.Param_Saisie_Affichage_Titre;
    return TextFormField(
      controller: Param_Saisie_TitreController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }





  final Param_Saisie_CtrlController = TextEditingController();
  Widget _buildFieldCtrl(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_CtrlController.text = paramParam.Param_Saisie_Controle;
    return TextFormField(
      controller: Param_Saisie_CtrlController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_AffController = TextEditingController();

  Widget _buildFieldAff(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_AffController.text =
        paramParam.Param_Saisie_Ordre_Affichage.toString();

    print("Param_Saisie_AffController.text ${Param_Saisie_AffController.text}");

    return TextFormField(
      controller: Param_Saisie_AffController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only numb
    );
  }

  final Param_Saisie_AffControllerL1 = TextEditingController();
  Widget _buildFieldAffL1(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_AffControllerL1.text =
        paramParam.Param_Saisie_Affichage_L1_Ordre.toString();

    return TextFormField(
      controller: Param_Saisie_AffControllerL1,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only numb
    );
  }

  final Param_Saisie_AffControllerL2 = TextEditingController();
  Widget _buildFieldAffL2(BuildContext context, Param_Saisie paramParam) {
    Param_Saisie_AffControllerL2.text =
        paramParam.Param_Saisie_Affichage_L2_Ordre.toString();
    return TextFormField(
      controller: Param_Saisie_AffControllerL2,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only numb
    );
  }

  final Param_Saisie_IconController = TextEditingController();
  Widget _buildFieldIcon(BuildContext context, Param_Saisie paramParam) {
    print(
        "_buildFieldIcon ${paramParam.Param_Saisie_Icon} ");
    Param_Saisie_IconController.text = paramParam.Param_Saisie_Icon;
    return TextFormField(
      controller: Param_Saisie_IconController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_TrigerController = TextEditingController();
  Widget _buildFieldTriger(BuildContext context, Param_Saisie paramParam) {
    print(
        "_buildFieldTriger ${paramParam.Param_Saisie_Triger} ");
    Param_Saisie_TrigerController.text = paramParam.Param_Saisie_Triger;
    return TextFormField(
      controller: Param_Saisie_TrigerController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }
  
  Widget _buildDelete(BuildContext context, DaviRow<Param_Saisie> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delParam_Saisie(rowData.data);
        await Reload();
      },
    );
  }

  Widget DropdownButtonOrgane() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un organe',
        style: gColors.bodyTitle1_N_Gr,
      ),
      items: ListParam_ParamOrgane.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodyTitle1_N_Gr,
            ),
          )).toList(),
      value: selectedValueOrgane,
      onChanged: (value) {
        setState(() {
          selectedValueOrganeID =
              ListParam_ParamOrganeID[ListParam_ParamOrgane.indexOf(value!)];
          selectedValueOrgane = value;

          print(
              "selectedValueOrgane $selectedValueOrganeID $selectedValueOrgane");
          Reload();
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


        ));
  }

  Widget DropdownButtonType() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un Type',
        style: gColors.bodyTitle1_N_Gr,
      ),
      items: ListParam_ParamType.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodyTitle1_N_Gr,
            ),
          )).toList(),
      value: selectedValueType,
      onChanged: (value) {
        setState(() {
          selectedValueTypeID =
              ListParam_ParamTypeID[ListParam_ParamType.indexOf(value!)];
          selectedValueType = value;
          print(
              "selectedValueType $selectedValueTypeID $selectedValueType");
          Reload();
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


        ));
  }

  Widget DropdownButtonCtrl() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un Ctrl',
        style: gColors.bodySaisie_N_G,
      ),
      items: ListParam_ParamCtrl.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "$item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueCtrl,
      onChanged: (value) {
        setState(() {
          selectedValueCtrlID =
              ListParam_ParamCtrlID[ListParam_ParamCtrl.indexOf(value!)];
          selectedValueCtrl = value;
          print(
              "selectedValueCtrl $selectedValueCtrlID $selectedValueCtrl");
        });
      },
          buttonStyleData: const ButtonStyleData(
              height: 50,
              width: 150
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
          ),
    ));
  }

  Widget DropdownButtonAff() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un Aff',
        style: gColors.bodySaisie_N_G,
      ),
      items: ListParam_ParamAff.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueAff,
      onChanged: (value) {
        setState(() {
          selectedValueAffID =
              ListParam_ParamAffID[ListParam_ParamAff.indexOf(value!)];
          selectedValueAff = value;
          print("selectedValueAff $selectedValueAffID $selectedValueAff");
        });
      },
          buttonStyleData: const ButtonStyleData(
              height: 50,
              width: 150
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
          ),

        ));
  }


  
  
  
}
