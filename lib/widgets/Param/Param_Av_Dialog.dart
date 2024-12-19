import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
//import 'package:html_editor_enhanced/html_editor.dart';



import 'package:verifplus_backoff/widgetTools/gColors.dart';


class Param_Av_Dialog {

  Param_Av_Dialog();
  static Future<void> Dialogs_Entete(BuildContext context) async {

    print("     Param_AvDialog");

    await showDialog(
      context: context,
      builder: (BuildContext context) => Param_AvDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Param_AvDialog extends StatefulWidget {

  @override
  _Param_AvDialogState createState() => _Param_AvDialogState();
}

class _Param_AvDialogState extends State<Param_AvDialog> {

  final Param_Av_No   = TextEditingController();
  final Param_Av_Det  = TextEditingController();
  final Param_Av_Proc = TextEditingController();
  final Param_Av_Lnk  = TextEditingController();



  Future Reload() async {

    Param_Av_No.text = DbTools.gParam_Av.Param_Av_No!;
    Param_Av_Det.text = DbTools.gParam_Av.Param_Av_Det!;
    Param_Av_Proc.text = DbTools.gParam_Av.Param_Av_Proc!;
    Param_Av_Lnk.text = DbTools.gParam_Av.Param_Av_Lnk!;




    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }




  void onSaisie() async {

    setState(() {});
  }

  String result = '';



  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      surfaceTintColor: Colors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            Container(
              width: 500,
              child: Text(
                "Avertissement",
                style: gColors.bodyTitle1_B_G,
                textAlign: TextAlign.center,
              ),
            ),


          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.white,
          height: 840,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 10,),

                    gColors.TxtField( 100, 64, "N°", Param_Av_No, ),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DescCadre_Desc(context),
                        Container(width: 20,),
                        DescCadre_Proc(context),
                      ],
                    ),

                    DescCadre_Lnk(context),

                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.primary,
                height: 1,
              ),
              Valider(context),
            ],
          )),
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
      color: gColors.white,
      width: 550,

      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {

              DbTools.gParam_Av.Param_Av_Det = Param_Av_Det.text;
              DbTools.gParam_Av.Param_Av_No = Param_Av_No.text;
              DbTools.gParam_Av.Param_Av_Det = Param_Av_Det.text ;
              DbTools.gParam_Av.Param_Av_Proc = Param_Av_Proc.text;
              DbTools.gParam_Av.Param_Av_Lnk = Param_Av_Lnk.text ;


              await DbTools.setParam_Av(DbTools.gParam_Av);

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }

  Widget DescCadre_Desc(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 600,
          height: 600,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
//                height: 600,
                child : gColors.DescField(context, 578,  Param_Av_Det,wTextInputType :TextInputType.multiline, wErrorText : "",maxChar: 20000, Ligne: 40),

              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Détails',
              style: gColors.bodySaisie_B_B,
            ),
          ),
        ),
      ],
    );
  }

  Widget DescCadre_Proc(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 600,
          height: 600,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
//                height: 600,
                child : gColors.DescField(context, 578,  Param_Av_Proc,wTextInputType :TextInputType.multiline, wErrorText : "",maxChar: 20000, Ligne: 40),

              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Procédure',
              style: gColors.bodySaisie_B_B,
            ),
          ),
        ),
      ],
    );
  }

  Widget DescCadre_Lnk(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 1220,
          height: 100,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
//                height: 600,
                child : gColors.DescField(context, 1178,  Param_Av_Lnk,wTextInputType :TextInputType.multiline, wErrorText : "",maxChar: 20000, Ligne: 50),

              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Liens',
              style: gColors.bodySaisie_B_B,
            ),
          ),
        ),
      ],
    );
  }



}
