import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/pdf/Aff_Bdc.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

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

  bool SignTechOpen = false;
  bool SignClientOpen = false;

  @override
  Future initLib() async {
    print("initLib");
    setState(() {});
  }

  TextEditingController ctrlTech = new TextEditingController();
  TextEditingController ctrlClient = new TextEditingController();
  TextEditingController ctrlNote = new TextEditingController();

  int SatClient = 0;


  void initState() {
    ctrlTech.text = DbTools.gIntervention.Intervention_Signataire_Tech!;
    ctrlClient.text = DbTools.gIntervention.Intervention_Signataire_Client!;
    ctrlNote.text = DbTools.gIntervention.Intervention_Remarque!;
    SatClient = DbTools.gIntervention.Intervention_Sat!;

    initLib();
    super.initState();
  }

  void onSaisie() async {
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build BL $SignTechOpen");
    DbTools.getParam_Saisie_ParamMem("Fact");

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new ElevatedButton(
                onPressed: () async {
                  await HapticFeedback.vibrate();

                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_Bdc()));
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
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InterventionTitleWidget2(),
                gColors.wLigne(),
                buildTitreTech(context),
                gColors.wLigne(),
                SignTechOpen ? _buildSignTech() : _buildVueSignTech(),
                buildTitreClient(context),
                gColors.wLigne(),
                SignClientOpen ? _buildSign() : _buildVueSign(),
                buildTitreNote(context),
                _buildNote(),
                buildTitreSat(context),
                buildSat(),
              ],
            )),
      ),
    );
  }

  Widget _buildSign() => Container(
      color: Colors.grey,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Signataire : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    controller: ctrlClient,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      DbTools.gIntervention.Intervention_Signataire_Client = value;
                      await DbTools.setIntervention(DbTools.gIntervention);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 2.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(),
                    color: Colors.white,
                    child: HandSignature(
                      control: control,
                      type: SignatureDrawType.shape,
                    ),
                  ),
                  CustomPaint(
                    painter: DebugSignaturePainterCP(
                      control: control,
                      cp: false,
                      cpStart: false,
                      cpEnd: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  control.clear();
                  rawImageFit.value = null;
                },
                child: Text('clear'),
              ),
              Spacer(),
              _buildScaledImageView(),
              Spacer(),
              new ElevatedButton(
                onPressed: () async {


                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    side: const BorderSide(
                      width: 1.0,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Valider', style: gColors.bodyTitle1_B_W),
              ),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildNote() => Container(
      color: Colors.grey,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Note : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 200),
                    controller: ctrlNote,
                    minLines: 7,
                    maxLines: 7,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      DbTools.gIntervention.Intervention_Remarque = value;
                      await DbTools.setIntervention(DbTools.gIntervention);

                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildVueSign() => Container(
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Spacer(),
              _buildScaledImageView(),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildVueSignTech() => Container(
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Spacer(),
              _buildScaledImageViewTech(),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildSignTech() => Container(
      color: Colors.grey,
      padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Signataire : ',
                style: gColors.bodyTitle1_N_Gr,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    controller: ctrlTech,
                    style: gColors.bodyTitle1_N_Gr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 3),
                    ),
                    onChanged: (String value) async {
                      DbTools.gIntervention.Intervention_Signataire_Tech = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Center(
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(),
                      color: Colors.white,
                      child: HandSignature(
                        control: controlTech,
                        type: SignatureDrawType.shape,
                      ),
                    ),
                    CustomPaint(
                      painter: DebugSignaturePainterCP(
                        control: controlTech,
                        cp: false,
                        cpStart: false,
                        cpEnd: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 50.0,
              ),
              ElevatedButton(
                onPressed: () {
                  controlTech.clear();
                  rawImageFitTech.value = null;
                },
                child: Text('clear'),
              ),
              Spacer(),
              _buildScaledImageViewTech(),
              Spacer(),
              new ElevatedButton(
                onPressed: () async {
                  rawImageFitTech.value = await controlTech.toImage(
                    color: Colors.black,
                    background: Colors.white,
                    fit: true,
                  );

                  final json = controlTech.toMap();

                  if (rawImageFitTech.value != null) {
                    print("json ${rawImageFitTech.value!.buffer.asUint8List()}");
                    DbTools.gIntervention.Intervention_Signature_Tech = rawImageFitTech.value!.buffer.asUint8List();
                  }
                  var now = new DateTime.now();
                  var formatter = new DateFormat('dd/MM/yyyy');
                  String formattedDate = formatter.format(now);
                  DbTools.gIntervention.Intervention_Signataire_Date = formattedDate;
                  await DbTools.setIntervention(DbTools.gIntervention);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    side: const BorderSide(
                      width: 1.0,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Valider', style: gColors.bodyTitle1_B_W),
              ),
              SizedBox(
                width: 50.0,
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          gColors.wLigne(),
        ],
      ));

  Widget _buildScaledImageView() => Container(
        width: 192.0,
        height: 96.0,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white30,
        ),
        child: DbTools.gIntervention.Intervention_Signature_Client == null || DbTools.gIntervention.Intervention_Signature_Client.length == 0
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Text('Vide'),
                ),
              )
            : Container(
                padding: EdgeInsets.all(0.0),
                color: Colors.white,
                child: Image.memory(DbTools.gIntervention.Intervention_Signature_Client),
              ),
      );

  Widget _buildScaledImageViewTech() => Container(
        width: 192.0,
        height: 96.0,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white30,
        ),
        child: DbTools.gIntervention.Intervention_Signature_Tech == null || DbTools.gIntervention.Intervention_Signature_Tech.length == 0
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Text('Vide'),
                ),
              )
            : Container(
                padding: EdgeInsets.all(0.0),
                color: Colors.white,
                child: Image.memory(DbTools.gIntervention.Intervention_Signature_Tech),
              ),
      );

  static Widget InterventionTitleWidget2() {
    return Material(
      elevation: 4,
      child: Container(
        width: 640,
        height: 57,
        padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "${DbTools.gIntervention.Intervention_Type}/${DbTools.gIntervention.Intervention_Parcs_Type} - ${DbTools.gIntervention.Intervention_Status} - Cr N° : ${DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }

  Widget buildTitreTech(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Cont.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Signature Agent",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: InkWell(
              onTap: () async {
                await HapticFeedback.vibrate();
                SignTechOpen = !SignTechOpen;

                if (SignTechOpen) SignClientOpen = false;

                setState(() {});
              },
              child: Text(
                textAlign: TextAlign.right,
                "${DbTools.gIntervention.Intervention_Signataire_Tech} - ${DbTools.gIntervention.Intervention_Signataire_Date} >",
                style: gColors.bodyTitle1_B_Green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreClient(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Cont_2.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Signature Client",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: InkWell(
              onTap: () async {
                await HapticFeedback.vibrate();
                SignClientOpen = !SignClientOpen;
                if (SignClientOpen) SignTechOpen = false;
                setState(() {});
              },
              child: Text(
                textAlign: TextAlign.right,
                "${DbTools.gIntervention.Intervention_Signataire_Client} - ${DbTools.gIntervention.Intervention_Signataire_Date_Client} >",
                style: gColors.bodyTitle1_B_Green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreNote(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Note2.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Note",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitreSat(BuildContext context) {
    double IcoWidth = 30;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.white,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Icon_Sat.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Satisfaction client",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSat() {
    double IcoWidth = 80;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient= 1;
              DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.setIntervention(DbTools.gIntervention);
              setState(()  {
              });
            },
            child: Image.asset(
              SatClient == 1 ? "assets/images/Sat_A.png" : "assets/images/Sat_Ans.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient= 2;
              DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.setIntervention(DbTools.gIntervention);
              setState(() {

              });
            },
            child: Image.asset(
              SatClient == 2 ? "assets/images/Sat_B.png" : "assets/images/Sat_Bns.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              SatClient= 3;
              DbTools.gIntervention.Intervention_Sat = SatClient;
              await DbTools.setIntervention(DbTools.gIntervention);
              setState(() {});
            },
            child: Image.asset(
              SatClient == 3 ? "assets/images/Sat_C.png" : "assets/images/Sat_Cns.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }

  
/*
  
  Widget _BuildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_Bdc()));
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
    );
  }
  
*/
  
  
}
