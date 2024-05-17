import 'package:flutter/material.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  void initLib() async {
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 400;
    double height = 380; //MediaQuery.of(context).size.height - 200;
    return
      Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: gColors.primary,
    );
  }



}
