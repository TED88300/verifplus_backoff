import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/gObj.dart';




class FiltreTools {

  static List<DataGridRow> dataGridRows_CR = <DataGridRow>[];
  static List<DataGridRow> dataGridRows_CR_Filtre = <DataGridRow>[];
  static int Selindex = -1;

  static DataGridController dataGridController_CR = DataGridController();


  static GridColumn SfGridColumn(String columnName, String columnTitle, double wWidth, double wWidthMin, AlignmentGeometry alignment, {wColumnWidthMode = ColumnWidthMode.none }) {

    TextAlign wTextAlign = TextAlign.left;
    if (alignment == Alignment.center)
      wTextAlign = TextAlign.center;
    else if (alignment == Alignment.centerRight)
      wTextAlign = TextAlign.right;

    wTextAlign = TextAlign.right;
    return GridColumn(
        columnName: columnName,
        width: wWidth,
        minimumWidth: wWidthMin,
        columnWidthMode: wColumnWidthMode,
        label: Container(
          alignment: alignment,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            columnTitle,
            style: gColors.bodySaisie_B_G,
            overflow: TextOverflow.ellipsis,
            textAlign: wTextAlign,
          ),
        ));

  }

  static Widget SfRowSel(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor, {bool bCircle = false}) {

    Color wColor = Colors.transparent;
    if (bCircle)
      {


        wColor = gColors.getColorStatus(row.getCells()[9].value!);
      }


    double t = 5;
    double b = 3;

    return Container(
        padding: EdgeInsets.fromLTRB(0, t, 8, b),
        alignment: alignment,
        child: Row(
          children: [
            Icon(Icons.play_arrow_sharp, color: Colors.black26, size: 20),
//              Spacer(),
            Text(
              row.getCells()[Col].value.toString(),
              style: gColors.bodySaisie_N_G.copyWith(color: txtColor),
              overflow: TextOverflow.ellipsis,
            ),
            (!bCircle) ? Container() :
            Container(
              width: 5,
            ),
            (!bCircle) ? Container() :
            gColors.gCircle(wColor),

          ],
        ));
  }

  static Widget SfRowBool(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
    double t = 5;
    double b = 3;
    return Container(
        padding: EdgeInsets.fromLTRB(0, t, 8, b),
        alignment: alignment,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            (row.getCells()[Col].value.toString() == "true") ?
            Icon(Icons.check, color: Colors.blueAccent, size: 20)
            : Container(),
          ],
        ));
  }

  static Widget SfRowBoolint(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
    double t = 5;
    double b = 3;
    return Container(
        padding: EdgeInsets.fromLTRB(0, t, 8, b),
        alignment: alignment,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            (row.getCells()[Col].value == 1) ?
            Icon(Icons.check, color: Colors.blueAccent, size: 20)
                : Container(),
          ],
        ));
  }


  static Widget SfRow(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor,  {bool fBold = false }    )
  {
    double t = 5;
    double b = 3;

    TextStyle wTextStyle = gColors.bodySaisie_N_G;
    if (fBold)
      wTextStyle = gColors.bodySaisie_B_G;
    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child: Text(
        row.getCells()[Col].value.toString(),
        style: wTextStyle.copyWith(color: txtColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget SfRowImage(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor,  {bool fBold = false }    )
  {
    double t = 5;
    double b = 3;

    String wArtID = row.getCells()[Col].value.toString();


    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child:gObj.buildImage(wArtID, 40),
    );
  }



  static Widget SfRowIcon(String wTxt ,String wIco , AlignmentGeometry alignment, Color txtColor,  {bool fBold = false }    )
  {
    double t = 5;
    double b = 3;
    TextStyle wTextStyle = gColors.bodySaisie_N_G;
    if (fBold)
      wTextStyle = gColors.bodySaisie_B_G;

    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child:
      Row(children: [
        wIco.isEmpty ? Container() :
        Container(
          child: Image.asset("assets/images/${wIco}.png", fit: BoxFit.cover),
        ),
        SizedBox(width: 19,),
        Text(
          wTxt,
          style: wTextStyle.copyWith(color: txtColor),
          overflow: TextOverflow.ellipsis,
        ),
      ],)

    );
  }

  static Widget SfRowPlus(String wTxt ,String wIco , AlignmentGeometry alignment, Color txtColor,  {bool fBold = false }    )
  {
    double t = 5;
    double b = 3;
    TextStyle wTextStyle = gColors.bodySaisie_N_G;
    if (fBold)
      wTextStyle = gColors.bodySaisie_B_G;

    return Container(
        padding: EdgeInsets.fromLTRB(8, t, 8, b),
        alignment: alignment,
        child:
        Row(children: [
          wIco.isEmpty ? Container() :
          Container(
            child: Image.asset("assets/images/${wIco}.png", fit: BoxFit.cover),
          ),
          SizedBox(width: 19,),
          Text(
            wTxt,
            style: wTextStyle.copyWith(color: txtColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],)

    );
  }


  static Widget SfRowDate(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
    double t = 5;
    double b = 3;

    String wTmp = "";
    try {
       wTmp = DateFormat('dd/MM/yyyy').format(row.getCells()[Col].value);
    } catch (e) {
    }


    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child: Text(wTmp,
        style: gColors.bodySaisie_N_G.copyWith(color: txtColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  static Widget TitreFiltre(String wTitre) {
    return Container(
      color: gColors.primary,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,
          ),
          Container(
            width: 10,
          ),
          Text(
            wTitre,
            style: gColors.bodySaisie_B_W,
          ),
        ],
      ),
    );
  }

  static DateTime gDateDeb = DateTime.now();
  static DateTime gDateFin = DateTime.now();
  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);



  static  void selDateTools(int aSel)
  {

    DateTime date = DateTime.now();

    switch (aSel) {
      case 0: // Aujourd'hui
        gDateDeb = date;
        gDateFin = gDateDeb;
        break;
      case 1: // Aujourd'hui
        gDateDeb = date.add(Duration(days: -1));
        gDateFin = gDateDeb;
        break;
      case 2: // Avant hier
        gDateDeb = date.add(Duration(days: -2));
        gDateFin = gDateDeb;
        break;
      case 3: // Semaine courante
        gDateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        gDateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 4: // Semaine précédante
        date = date.add(Duration(days: -7));
        gDateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        gDateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 5: // Semaine précédant précédante
        date = date.add(Duration(days: -14));
        gDateDeb = getDate(date.subtract(Duration(days: date.weekday - 1)));
        gDateFin = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
        break;
      case 6: // Mois courant
        gDateDeb = DateTime(date.year, date.month, 1);
        gDateFin = DateTime(date.year, date.month +1, 0);
        break;
      case 7: // Mois précédent
        gDateDeb = DateTime(date.year, date.month-1, 1);
        gDateFin = DateTime(date.year, date.month , 0);
        break;
      case 8: // Mois précédent le précédent
        gDateDeb = DateTime(date.year, date.month-2, 1);
        gDateFin = DateTime(date.year, date.month-1 , 0);
        break;
      case 9: // Année précédente
        gDateDeb = DateTime(date.year, 1, 1);
        gDateFin = date;
        break;
      case 10: // Année précédent la précédente
        gDateDeb = DateTime(date.year-1, 1, 1);
        gDateFin = DateTime(date.year-1, 12 , 31);
        break;
      default :
        gDateDeb = DateTime.now();
        gDateFin = DateTime.now();
        break;


    }


    print(" Sel ${aSel} gDateDeb ${DateFormat('dd/MM/yyyy').format(gDateDeb)} ${DateFormat('dd/MM/yyyy').format(gDateFin)}");



  }




}
