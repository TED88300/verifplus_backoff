import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Zone_Interv_Add {
  Zone_Interv_Add();
  static Future<void> Dialogs_Add(BuildContext context, bool isNew) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Zone_IntervAdd(isNew: isNew),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Zone_IntervAdd extends StatefulWidget {
  bool isNew = false;
  Zone_IntervAdd({
    Key? key,
    required this.isNew,
  }) : super(key: key);

  @override
  _Zone_IntervAddState createState() => _Zone_IntervAddState();
}

class _Zone_IntervAddState extends State<Zone_IntervAdd> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  String selectedTypeInter = "";
  String selectedTypeInterID = "";
  String selectedParcTypeInter = "";
  String selectedParcTypeInterID = "";

  @override
  void initLib() async {

    print(" DbTools.gZone.ZoneId ${DbTools.gZone.ZoneId}");


    print("Zone_Interv_Add initLib");
    selectedTypeInter = DbTools.List_TypeInter[0];
    selectedTypeInterID = DbTools.List_TypeInterID[0];
    selectedParcTypeInter = DbTools.List_ParcTypeInter[0];
    selectedParcTypeInterID = DbTools.List_ParcTypeInterID[0];
    setState(() {});
  }

  @override
  void initState() {
    initLib();
  }



  double SelHeight = 380;
  @override
  Widget ListeInterv(BuildContext context) {
    return gColors.DropdownButtonTypeInter(
      150,
      8,
      "Type d'intervention",
      selectedTypeInter,
      (sts) {
        setState(() {
          selectedTypeInter = sts!;
          selectedTypeInterID = DbTools.List_TypeInterID[DbTools.List_TypeInter.indexOf(selectedTypeInter)];
          print("onCHANGE selectedTypeInter $selectedTypeInter");
          print("onCHANGE selectedTypeInterID $selectedTypeInterID");
        });
      },
      DbTools.List_TypeInter,
      DbTools.List_TypeInterID,
    );
  }

  @override
  Widget ListeOrg(BuildContext context) {
    print("ListeOrg DbTools.List_ParcTypeInter ${DbTools.List_ParcTypeInter.length} ${DbTools.List_ParcTypeInterID.length}");

    return gColors.DropdownButtonTypeInter(
      150,
      8,
      "Type d'Organe",
      selectedParcTypeInter,
      (sts) {
        setState(() {
          selectedParcTypeInter = sts!;
          selectedParcTypeInterID = DbTools.List_ParcTypeInterID[DbTools.List_ParcTypeInter.indexOf(selectedParcTypeInter)];
          print("onCHANGE selectedParcTypeInter $selectedParcTypeInter");
          print("onCHANGE selectedParcTypeInterID $selectedParcTypeInterID");
        });
      },
      DbTools.List_ParcTypeInter,
      DbTools.List_ParcTypeInterID,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            Container(
              width: 440,
              child: Text(
                "Intervention : Création",
                style: gColors.bodyTitle1_B_B,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height : 150,
        color: gColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: gColors.primary,
              height: 1,
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 110,
                ),
                ListeInterv(context),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 110,
                ),
                ListeOrg(context),
              ],
            ),
            Container(
              height: 10,
            ),
            Valider(context),
            Container(
              height: 10,
            ),
            Container(
              color: gColors.primary,
              height: 1,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: Colors.black12,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black12,),

            child: Text('Annuler', style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {

              print(" selectedTypeInter ${selectedTypeInter}");
              print(" selectedParcTypeInter ${selectedParcTypeInter}");


              String wNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
              await DbTools.addIntervention(DbTools.gZone.ZoneId, wNow, selectedTypeInterID);
              print("addIntervention DbTools.gLastID ${DbTools.gLastID}");
              await DbTools.getInterventionIDSrv(DbTools.gLastID);
              DbTools.gIntervention.Intervention_Parcs_Type = selectedParcTypeInterID;

              DbTools.gIntervention.Intervention_Status = "A programmer";


              await DbTools.setIntervention(DbTools.gIntervention);
              //await DbTools.addParc_Ent(DbTools.gIntervention.InterventionId!,selectedParcTypeInterID);
              print("addParc_Ent DbTools.gLastID ${DbTools.gLastID}");
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
