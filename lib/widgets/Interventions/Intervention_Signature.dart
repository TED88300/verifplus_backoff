
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/pdf/Aff_CR.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Intervention_Signature extends StatefulWidget {
  @override
  Intervention_SignatureState createState() => Intervention_SignatureState();
}

class Intervention_SignatureState extends State<Intervention_Signature> {
  double IcoWidth = 30;

  final control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  final controlTech = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ValueNotifier<ByteData?> rawImageFitTech = ValueNotifier<ByteData?>(null);

  @override
  Future initLib() async {
    print("initLib");
    setState(() {});
  }

  int SatClient = 0;

  void initState() {
    SatClient = DbTools.gIntervention.Intervention_Sat;

    initLib();
    super.initState();
  }

  void onSaisie() async {
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    DbTools.getParam_Saisie_ParamMem("Fact");

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new ElevatedButton(
                  onPressed: () async {
                    await HapticFeedback.vibrate();
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_CR()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.primaryGreen,
                      side: const BorderSide(
                        width: 1.0,
                        color: gColors.primaryGreen,
                      )),
                  child: Text('Imprimer', style: gColors.bodyTitle1_B_W),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
//        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: ContentSignatureCadre(context),
        ),
      ),
    );
  }

  void ToolsEmpty() async {}

  Widget ContentSignatureCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 300,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//          padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 55, bottom: 0, left: 10, right: 0),
              width: 300,
              height: 300,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "Icon_Cont", ToolsEmpty, tooltip: ""),
                        Container(
                          width: 10,
                        ),
                        gColors.Txt(110, "Signature Agent", "${DbTools.gIntervention.Intervention_Signataire_Tech} - ${DbTools.gIntervention.Intervention_Signataire_Date}"),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "Icon_Cont_2", ToolsEmpty, tooltip: ""),
                        Container(
                          width: 10,
                        ),
                        gColors.Txt(110, "Signature Client", "${DbTools.gIntervention.Intervention_Signataire_Client} - ${DbTools.gIntervention.Intervention_Signataire_Date_Client}"),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "Icon_Note2", ToolsEmpty, tooltip: ""),
                        Container(
                          width: 10,
                        ),
                        gColors.Txt(110, "Note", "${DbTools.gIntervention.Intervention_Remarque!}"),
                      ],
                    ),




                  ]),

                  Container(
                    width: 600,
                  ),

                  Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.blue, "Icon_Sat", ToolsEmpty, tooltip: ""),
                        Container(
                          width: 10,
                        ),
                        gColors.Txt(130, "Satisfaction client", ""),
                      ],
                    ),
                    buildTitreSat(context),



                  ])
                ],
              ),
            )

            ),
        Positioned(
          left: 50,
          top: 5,
          child: Container(
              child: Row(
            children: [
              Container(
                width: 300,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'COMPTE RENDU',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }



  Widget buildTitreSat(BuildContext context) {
    double IcoWidth = 20;
    double IcoWidth2 = 40;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: gColors.white,
      child: Row(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {},
                child: Image.asset(
                  SatClient == 1 ? "assets/images/Sat_A.png" : "assets/images/Sat_Ans.png",
                  height: IcoWidth2,
                  width: IcoWidth2,
                ),
              ),
              Container(
                width: 10,
              ),
              InkWell(
                onTap: () async {},
                child: Image.asset(
                  SatClient == 2 ? "assets/images/Sat_B.png" : "assets/images/Sat_Bns.png",
                  height: IcoWidth2,
                  width: IcoWidth2,
                ),
              ),
              Container(
                width: 10,
              ),
              InkWell(
                onTap: () async {},
                child: Image.asset(
                  SatClient == 3 ? "assets/images/Sat_C.png" : "assets/images/Sat_Cns.png",
                  height: IcoWidth2,
                  width: IcoWidth2,
                ),
              ),
              Container(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
