import 'package:flutter/material.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Habilitations extends StatefulWidget {
  @override
  State<Habilitations> createState() => _HabilitationsState();
}

class _HabilitationsState extends State<Habilitations> {
  Future Reload() async {}

  Future Filtre() async {
    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }

  bool isSwitcheda = false;
  void _toggleSwitcha(bool value) {
    setState(() {
      isSwitcheda = value;
    });
  }

  bool isSwitchedb = false;
  void _toggleSwitchb(bool value) {
    setState(() {
      isSwitchedb = value;
    });
  }

  bool isSwitchedc = false;
  void _toggleSwitchc(bool value) {
    setState(() {
      isSwitchedc = value;
    });
  }


  bool isSwitchedd = false;
  void _toggleSwitchd(bool value) {
    setState(() {
      isSwitchedd = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "Habilitations",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: gColors.white,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Image.asset("assets/images/IM6a.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Faire signer et remettre le compte-rendu d'intervention au client",
                      style: gColors.bodySaisie_B_G,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child:
                    Switch(
                      value: isSwitcheda,
                      onChanged: _toggleSwitcha,
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.redAccent,
                        inactiveThumbColor:  Colors.red
                    )

                  ),
                ],
              ),
            ),
          ),
                Container(height: 20),
          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: gColors.white,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Image.asset("assets/images/IM6b.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Faire signer et remettre le bon de livraison non valorisé au client",
                      style: gColors.bodySaisie_B_G,
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child:
                      Switch(
                          value: isSwitchedb,
                          onChanged: _toggleSwitchb,
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.redAccent,
                          inactiveThumbColor:  Colors.red
                      )

                  ),
                ],
              ),
            ),
          ),
          Container(height: 20),

          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: gColors.white,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Image.asset("assets/images/IM6c.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Faire signer et remettre le bon de commande chiffré au client",
                      style: gColors.bodySaisie_B_G,
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child:
                      Switch(
                          value: isSwitchedc,
                          onChanged: _toggleSwitchc,
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.redAccent,
                          inactiveThumbColor:  Colors.red
                      )

                  ),
                ],
              ),
            ),
          ),
          Container(height: 20),

          Container(
            width: 800,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: gColors.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: gColors.white,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Image.asset("assets/images/IM6d.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "Faire, présenter, remettre le devis au client",
                      style: gColors.bodySaisie_B_G,
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child:
                      Switch(
                          value: isSwitchedd,
                          onChanged: _toggleSwitchd,
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.redAccent,
                          inactiveThumbColor:  Colors.red
                      )

                  ),
                ],
              ),
            ),
          ),
          Container(height: 160),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "Légende :",
                    style: gColors.bodySaisie_B_G,
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child:
                    Switch(
                        value: false,
                        onChanged: null,
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.redAccent,
                        inactiveThumbColor:  Colors.red
                    )

                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "Non-habilité",
                    style: gColors.bodySaisie_B_G,
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child:
                    Switch(
                        value: true,
                        onChanged: null,
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.lightGreenAccent,
                        inactiveThumbColor:  Colors.green
                    )

                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "Habilité",
                    style: gColors.bodySaisie_B_G,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
