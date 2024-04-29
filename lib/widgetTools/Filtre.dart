import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class FiltreTools {


  static GridColumn SfGridColumn(String columnName, String columnTitle, double wWidth, double wWidthMin, AlignmentGeometry alignment, {wColumnWidthMode = ColumnWidthMode.none }) {
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
          ),
        ));

  }

  static Widget SfRowSel(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
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


  static Widget SfRow(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
    double t = 5;
    double b = 3;

    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child: Text(
        row.getCells()[Col].value.toString(),
        style: gColors.bodySaisie_N_G.copyWith(color: txtColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  static Widget SfRowDate(DataGridRow row, int Col, AlignmentGeometry alignment, Color txtColor) {
    double t = 5;
    double b = 3;

    return Container(
      padding: EdgeInsets.fromLTRB(8, t, 8, b),
      alignment: alignment,
      child: Text(
        DateFormat('dd/MM/yyyy').format(row.getCells()[Col].value),
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
            size: 20.0,
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
}
