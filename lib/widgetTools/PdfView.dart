import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';


class PdfView extends StatefulWidget {

  final Widget pdf;

  const PdfView({Key? key, required this.pdf}) : super(key: key);


  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  void initLib() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 56;
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
                  "Vérif+ : Documents",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_Wr,
                ),
                Spacer(),
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
      backgroundColor: gColors.primary,
      body: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        color: gColors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              child: widget.pdf,
            )


          ],
        ),
      ),
    );
  }


}
