import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_CR.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning.dart';


class Organe_EquipDialog extends StatefulWidget {

  @override
  State<Organe_EquipDialog> createState() => _Organe_EquipDialogState();
}

class _Organe_EquipDialogState extends State<Organe_EquipDialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  double screenHeight = 0;

  Future initLib() async {
      setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
    Title = "Intervention";
  }
  

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    if (Title.isEmpty) return Container();

    return Center(
      child: Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: gColors.white,


            body: Content(context),
          )),
    );
  }



  Widget Content(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           Container(
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
              Text("Det Equipement"),
            ],
          ),
        ],
      ),
    ),            ],
          )),
        ),
      ]),
    );
  }




}
