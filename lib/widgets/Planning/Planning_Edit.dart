//EDIT
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning_Interv.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Sites/Zone_Dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Planning_Edit extends StatefulWidget {
  final Appointment? wAppointment;
  final VoidCallback onMaj;

  const Planning_Edit(this.wAppointment, this.onMaj);

  @override
  _Planning_EditState createState() => _Planning_EditState();
}

class _Planning_EditState extends State<Planning_Edit> {
  int IntevId = 0;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late Planning_Srv wPlanning_Srv;

  String selectedTypeInter = "";
  String selectedTypeInterID = "";
  String selectedParcTypeInter = "";
  String selectedParcTypeInterID = "";
  String selectedStatusInter = "";
  String selectedStatusInterID = "";
  String selectedFactInter = "";
  String selectedFactInterID = "";

  String selectedUserInter = "";
  String selectedUserInter2 = "";
  String selectedUserInter3 = "";
  String selectedUserInter4 = "";

  int ResourceId = 0;
  String ResourceNom = "";

  TextEditingController textController_Lib = TextEditingController();
  String wIntervenants = "";

  TextEditingController textController_Adresse_Geo = TextEditingController();


  void initLib() async {
    await DbTools.getPlanning_InterventionIdRes(IntevId!);
    ResourceId = int.parse(widget.wAppointment!.resourceIds![0].toString());
    for (int u = 0; u < DbTools.ListUser.length; u++) {
      User user = DbTools.ListUser[u];
      if (user.User_Matricule == ResourceId.toString()) ResourceNom = "${user.User_Nom} ${user.User_Prenom}";
    }

    for (int i = 0; i < DbTools.ListUserH.length; i++) {
      var element = DbTools.ListUserH[i];
      wIntervenants = "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    await DbTools.getInterventionIDSrv(IntevId);
    print("gIntervention ${DbTools.gIntervention.Desc()}");

    await DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable!);
    print("gUser ${DbTools.gUser.Desc()}");
    selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";

    await DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable2!);
    print("gUser ${DbTools.gUser.Desc()}");
    selectedUserInter2 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";

    await DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable3!);
    print("gUser ${DbTools.gUser.Desc()}");
    selectedUserInter3 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";

    await DbTools.getUserMat(DbTools.gIntervention.Intervention_Responsable4!);
    print("gUser ${DbTools.gUser.Desc()}");
    selectedUserInter4 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";



    setState(() {});
  }

  @override
  void initState() {
    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      wPlanning_Srv = DbTools.ListPlanning[p];
      if (wPlanning_Srv.PlanningId == int.parse(widget.wAppointment!.recurrenceId.toString())) {
        IntevId = wPlanning_Srv.Planning_InterventionId!;
        break;
      }
    }
    if (IntevId >= 0) {
      print("IntevId $IntevId");
      DbTools.getPlanning_Interv_ID(IntevId);
      print(">> gPlanning_Interv ${DbTools.gPlanning_Interv.Desc()}");
    } else {
      DbTools.gPlanning_Interv = Planning_Interv.Planning_RdvInit();
    }
    _startDate = widget.wAppointment!.startTime;
    _endDate = widget.wAppointment!.endTime;

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

    textController_Lib.text = "${wPlanning_Srv.Planning_Libelle}";
    initLib();

    super.initState();
  }


  Widget AutoAdresse(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        )
            : Container(
          width: lWidth,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_B_G,
          ),
        ),
        Container(
            width: wWidth,
            child: TypeAheadField(
              animationStart: 0,
              animationDuration: Duration.zero,
              textFieldConfiguration: TextFieldConfiguration(
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                ),
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Colors.white,
              ),
              suggestionsCallback: (pattern) async {
                await Api_Gouv.ApiAdresse(textController_Adresse_Geo.text);
                List<String> matches = <String>[];
                Api_Gouv.properties.forEach((propertie) {
                  matches.add(propertie.label!);
                });
                return matches;
              },
              itemBuilder: (context, sone) {
                return Card(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(sone.toString()),
                    ));
              },
              onSuggestionSelected: (suggestion) {
                Api_Gouv.properties.forEach((propertie) {
                  if (propertie.label!.compareTo(suggestion) == 0) {
                    Api_Gouv.gProperties = propertie;
                  }
                });
                textController_Adresse_Geo.text = suggestion;
              },
            )),
        Container(
          width: 20,
        ),
      ],
    );
  }

  Widget ToolsBar_Insee(BuildContext context) {
    return Container(
//        width: 400,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
//                  width: 320,
                  child: AutoAdresse(80, 690, "Recherche", textController_Adresse_Geo),
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.black, Icons.arrow_downward, ToolsBarCopySearch, tooltip: "Copier recherche"),
              ],
            ),
          ],
        ));
  }

  void ToolsBarCopySearch() async {
    print("ToolsBarCopySearch_Livr ${Api_Gouv.gProperties.toJson()}");
    textController_Lib.text = "${textController_Lib.text} ${Api_Gouv.gProperties.name!} ${Api_Gouv.gProperties.postcode!} ${Api_Gouv.gProperties.city!}".trim();
    wPlanning_Srv.Planning_Libelle = textController_Lib.text;
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(

      insetPadding: const EdgeInsets.all(10),
      elevation: 0,
      child: Container(
        width: 1200,
        height: 900,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: ListTile(
                  title: Text(
                    'Edition Planning ${wPlanning_Srv.PlanningId}',
                    style: gColors.bodyTitle1_B_G,
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )),
            gColors.wLigne(),
            (IntevId < 0)
                ? Container()
                : Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      gColors.Txt(100, "Client", "${DbTools.gPlanning_Interv.Planning_Interv_Client_Nom} /  ${DbTools.gPlanning_Interv.Planning_Interv_Groupe_Nom} / ${DbTools.gPlanning_Interv.Planning_Interv_Site_Nom} / ${DbTools.gPlanning_Interv.Planning_Interv_Zone_Nom}"),
                    ],
                  ),
            (IntevId < 0)
                ? Container()
                : Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      gColors.Txt(100, "Intervention", "[${DbTools.gPlanning_Interv.Planning_Interv_InterventionId}] ${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Type} / ${DbTools.getParam_Param_Text("Type_Organe", DbTools.gIntervention.Intervention_Parcs_Type!)} /${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Status}"),
                    ],
                  ),

            Container(
              height: 15,
            ),
            (IntevId < 0) ? Container() :
            Row(
              children: [
                Container(
                  width: 20,
                ),
                gColors.Txt(160, "Commercial intervention", "${selectedUserInter}"),
              ],
            ),
            (IntevId < 0) ? Container() :
            Row(
              children: [
                Container(
                  width: 20,
                ),
                gColors.Txt(160, "Manager commercial", "${selectedUserInter2}"),
              ],
            ),
            (IntevId < 0) ? Container() :
            Row(
              children: [
                Container(
                  width: 20,
                ),
                gColors.Txt(160, "Manager Technique", "${selectedUserInter3}"),
              ],
            ),
            (IntevId < 0) ? Container() :
            Row(
              children: [
                Container(
                  width: 20,
                ),
                gColors.Txt(160, "Référent technique", "${selectedUserInter4}"),
              ],
            ),
            Container(
              width: 20,
            ),
            Row(
              children: [
                Container(
                  width: 20,
                ),

                gColors.Txt(160, "Technicien", "[$ResourceId] $ResourceNom"),

              ],
            ),
            (IntevId < 0)
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                        ),
                        gColors.TxtColumn(160, "Ressources affectées", "${wIntervenants}"),
                      ],
                    ),
                  ),

                 Container(
                    child: ListTile(
                        title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Début',
                                style: gColors.bodyTitle1_N_Gr,
                                textAlign: TextAlign.start,
                              ),
                              TextField(
                                readOnly: true,
                                controller: TextEditingController(text: (DateFormat('dd/MM/yy HH:mm')).format(_startDate)),
                                onChanged: (String value) {
                                  _startDate = DateTime.parse(value);
                                  _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: gColors.bodyTitle1_B_Gr,
                                decoration: InputDecoration(
                                  isDense: true,
                                  suffix: SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        ButtonTheme(
                                            minWidth: 50.0,
                                            child: MaterialButton(
                                              elevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                              disabledElevation: 0,
                                              hoverElevation: 0,
                                              onPressed: () async {
                                                final DateTime? date = await showDatePicker(

                                                    context: context,
                                                    initialDate: _startDate,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.dark().copyWith(
                                                          colorScheme: ColorScheme.dark(
                                                            primary: Colors.blue,
                                                            onPrimary: Colors.white,
                                                            surface: Colors.white,
                                                            onSurface: gColors.primary,
                                                          ),
                                                          dialogBackgroundColor:Colors.blue[900],
                                                        ),
                                                        child: child!,
                                                      );
                                                    });

                                                if (date != null && date != _startDate) {
                                                  setState(() {
                                                    final Duration difference = _endDate.difference(_startDate);
                                                    _startDate = DateTime(date.year, date.month, date.day, _startTime.hour, _startTime.minute);
                                                    _endDate = _startDate.add(difference);
                                                    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
                                                  });
                                                }
                                              },
                                              shape: const CircleBorder(),
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                Icons.date_range,
                                                color: Colors.blueGrey,
                                                size: 20,
                                              ),
                                            )),
                                        ButtonTheme(
                                            minWidth: 50.0,
                                            child: MaterialButton(
                                              elevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                              disabledElevation: 0,
                                              hoverElevation: 0,
                                              shape: const CircleBorder(),
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                final TimeOfDay? time = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData(
                                                          brightness: Brightness.light,
                                                          colorScheme: _getColorScheme(false),
                                                          primaryColor: gColors.backgroundColor,
                                                        ),
                                                        child: child!,
                                                      );
                                                    });

                                                if (time != null && time != _startTime) {
                                                  setState(() {
                                                    _startTime = time;
                                                    final Duration difference = _endDate.difference(_startDate);
                                                    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day, _startTime.hour, _startTime.minute);
                                                    _endDate = _startDate.add(difference);
                                                    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.access_time,
                                                color: Colors.blueGrey,
                                                size: 20,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  focusColor: gColors.backgroundColor,
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gColors.backgroundColor, width: 2.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Fin', style: gColors.bodyTitle1_N_Gr, textAlign: TextAlign.start),
                              TextField(
                                readOnly: true,
                                controller: TextEditingController(text: (DateFormat('dd/MM/yy HH:mm')).format(_endDate)),
                                onChanged: (String value) {
                                  _endDate = DateTime.parse(value);
                                  _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: gColors.bodyTitle1_B_Gr,
                                decoration: InputDecoration(
                                  isDense: true,
                                  suffix: SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ButtonTheme(
                                            minWidth: 50.0,
                                            child: MaterialButton(
                                              elevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                              disabledElevation: 0,
                                              hoverElevation: 0,
                                              shape: const CircleBorder(),
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                final DateTime? date = await showDatePicker(
                                                    context: context,
                                                    initialDate: _endDate,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2100),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData(
                                                          brightness: Brightness.light,
                                                          colorScheme: _getColorScheme(false),
                                                          primaryColor: gColors.backgroundColor,
                                                        ),
                                                        child: child!,
                                                      );
                                                    });

                                                if (date != null && date != _endDate) {
                                                  setState(() {
                                                    final Duration difference = _endDate.difference(_startDate);
                                                    _endDate = DateTime(date.year, date.month, date.day, _endTime.hour, _endTime.minute);
                                                    if (_endDate.isBefore(_startDate)) {
                                                      _startDate = _endDate.subtract(difference);
                                                      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                                                    }
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.date_range,
                                                color: Colors.blueGrey,
                                                size: 20,
                                              ),
                                            )),
                                        ButtonTheme(
                                            minWidth: 50.0,
                                            child: MaterialButton(
                                              elevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                              disabledElevation: 0,
                                              hoverElevation: 0,
                                              shape: const CircleBorder(),
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                final TimeOfDay? time = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData(
                                                          brightness: Brightness.light,
                                                          colorScheme: _getColorScheme(false),
                                                          primaryColor: gColors.backgroundColor,
                                                        ),
                                                        child: child!,
                                                      );
                                                    });

                                                if (time != null && time != _endTime) {
                                                  setState(() {
                                                    _endTime = time;
                                                    final Duration difference = _endDate.difference(_startDate);
                                                    _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, _endTime.hour, _endTime.minute);
                                                    if (_endDate.isBefore(_startDate)) {
                                                      _startDate = _endDate.subtract(difference);
                                                      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                                                    }
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.access_time,
                                                color: Colors.blueGrey,
                                                size: 20,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  focusColor: gColors.backgroundColor,
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gColors.backgroundColor, width: 2.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))),
            Container(
              height: 110,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 2),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                ToolsBar_Insee(context),
                Text(
                  'Libellè',
                  style: gColors.bodyTitle1_N_Gr,
                  textAlign: TextAlign.start,
                ),
                TextField(
                  controller: textController_Lib,
                  onChanged: (String value) {
                    print("value $value");
                    wPlanning_Srv.Planning_Libelle = value;
                  },
                  keyboardType: TextInputType.multiline,
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ]),
            ),
            Spacer(),
            Container(
                child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  (IntevId < 0) ? Container() :
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      fillColor: gColors.GrdBtn_Colors4sel,
                      onPressed: () async {
// INTERVENTION
                        DbTools.gClient.ClientId = DbTools.gPlanning_Interv.Planning_Interv_ClientId!;
                        await DbTools.getGroupesClient(DbTools.gClient.ClientId);
                        DbTools.gGroupe.GroupeId = DbTools.gPlanning_Interv.Planning_Interv_GroupeId!;
                        await DbTools.getSitesGroupe(DbTools.gGroupe.GroupeId);
                        DbTools.gSite.SiteId = DbTools.gPlanning_Interv.Planning_Interv_SiteId!;
                        await DbTools.getZonesSite(DbTools.gSite.SiteId);
                        DbTools.gZone.ZoneId = DbTools.gPlanning_Interv.Planning_Interv_ZoneId!;
                        await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
                        await showDialog(context: context, builder: (BuildContext context) => new Zone_Dialog());

//                        Navigator.pop(context);
                      },
                      child: const Text(
                        '     INTERVENTION     ',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    splashRadius: 20,
                    onPressed: () async {
//DELETE
                      await DbTools.delPlanning(wPlanning_Srv);
                      print("Call onMaj");
                      widget.onMaj();

                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RawMaterialButton(
                      onPressed: () {
// ANNULER
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ANNULER',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      fillColor: gColors.backgroundColor,
                      onPressed: () async {
// SAVE
                        wPlanning_Srv.Planning_InterventionstartTime = _startDate;
                        wPlanning_Srv.Planning_InterventionendTime = _endDate;
                        await DbTools.setPlanning(wPlanning_Srv);
                        widget.onMaj();

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'SAUVER',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  ColorScheme _getColorScheme(bool isDatePicker) {
    if (gColors.wTheme.colorScheme.brightness == Brightness.dark) {
      return ColorScheme.dark(
        primary: gColors.backgroundColor,
        secondary: gColors.backgroundColor,
        surface: isDatePicker ? gColors.backgroundColor : Colors.grey[850]!,
      );
    }

    return ColorScheme.light(
      primary: gColors.backgroundColor,
      secondary: gColors.backgroundColor,
      surface: isDatePicker ? gColors.backgroundColor : Colors.white,
    );
  }
}
