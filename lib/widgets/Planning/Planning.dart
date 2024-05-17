import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning_Interv.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Srv_Zones.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning_Edit.dart';
import 'package:verifplus_backoff/widgets/Planning/SelectInterv.dart';

class Planning extends StatefulWidget {
  final bool bAppBar;
  const Planning({Key? key, required this.bAppBar}) : super(key: key);

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {

  Appointment? _selectedAppointment;
  final CalendarController _calendarController = CalendarController();

  _ShiftDataSource _events = _ShiftDataSource(<Appointment>[], <CalendarResource>[]);

  late CalendarView _currentView;
  int _selectedColorIndex = 0;
  String _client = '';

  int selUserID = -1;

  bool isLegendVisible = false;
  Widget wLegend = Container();

  String clientNom = '';
  String groupeNom = '';
  String siteNom = '';
  String zoneNom = '';
  String interventionNom = '';

  dynamic appointment_resizeStart;
  dynamic appointment_dragStart;

  List<String> ListDepot = [];
  String Depot = "";

  late List<Color> _colorCollection;

  late List<Appointment> _appointments;
  late List<DateTime> _visibleDates;
  final List<String> _nameCollection = <String>[];
  final List<CalendarResource> _employeeCollection = <CalendarResource>[];
  final List<TimeRegion> _specialTimeRegions = <TimeRegion>[];

//  List<Widget> wUserWidget = [];
  bool isload = false;
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineWorkWeek,
    CalendarView.timelineWeek,
    CalendarView.timelineMonth,
  ];

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;

    _currentView = _calendarController.view!;

    print("_onViewChanged _currentView : $_currentView");

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

  Future Reload() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>> Reload A");
    await DbTools.getParam_Saisie_Param("Status");

    print(">>>>>>>>>>>>>>>>>>>>>>>>>> Reload B");
    await DbTools.getPlanning_IntervAll();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>> Reload C");
    _appointments = await genAppointmentsSrv();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>> Reload D");
    _events = _ShiftDataSource(_appointments, _employeeCollection);
    print(">>>>>>>>>>>>>>>>>>>>>>>>>> Reload E");
  }

  void initLib() async {
    await DbTools.initListFam();
    await DbTools.getAdresseType("AGENCE");
    ListDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListDepot.add(wAdresse.Adresse_Nom);
    });

    if (DbTools.gClient.ClientId > 0) {
      clientNom = DbTools.gClient.Client_Nom;
      await DbTools.getGroupesClient(DbTools.gClient.ClientId);
    } else {
      DbTools.gClient = Client.ClientInit();
      DbTools.gClient.ClientId = -1;
    }

    print(" DbTools.gClient.ClientId ${DbTools.gClient.ClientId} ${clientNom}");

    if (DbTools.gGroupe.GroupeId > 0) {
      groupeNom = DbTools.gGroupe.Groupe_Nom!;
      await DbTools.getSitesGroupe(DbTools.gGroupe.GroupeId);
    } else {
      DbTools.gGroupe = Groupe.GroupeInit();
      DbTools.gGroupe.GroupeId = -1;
    }

    if (DbTools.gSite.SiteId > 0) {
      siteNom = DbTools.gSite.Site_Nom!;
      await DbTools.getZonesSite(DbTools.gSite.SiteId);
    } else {
      DbTools.gSite = Site.SiteInit();
      DbTools.gSite.SiteId = -1;
    }

    if (DbTools.gZone.ZoneId > 0) {
      zoneNom = DbTools.gZone.Zone_Nom!;
      await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);
    } else {
      DbTools.gZone = Zone.ZoneInit();
      DbTools.gZone.ZoneId = -1;
    }

    if (DbTools.gIntervention.InterventionId! >= 0) {
      interventionNom = "${DbTools.gIntervention.Intervention_Type!} ${DbTools.gIntervention.Intervention_Parcs_Type!} ${DbTools.gIntervention.Intervention_Status!}";
      await DbTools.getInterventionID(DbTools.gPlanning_Interv.Planning_Interv_InterventionId!);
    } else {
      DbTools.gIntervention = Intervention.InterventionInit();
      DbTools.gIntervention.InterventionId = -1;
    }

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));

    _currentView = CalendarView.timelineWorkWeek;
    _calendarController.view = _currentView;

    await DbTools.getClientAll();

    await addUser();

    _addSpecialRegions();

    await Reload();
    isload = true;

    List<Container> wDets = [];

    for (int p = 0; p < DbTools.ListParam_Saisie_Param.length; p++) {
      Param_Saisie_Param wparamSaisieParam = DbTools.ListParam_Saisie_Param[p];
      Color wColor = gColors.getColor(wparamSaisieParam.Param_Saisie_Param_Color);
      Container wDet = Container(
          margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                color: wColor,
              ),
              Text(
                wparamSaisieParam.Param_Saisie_Param_Label,
                style: gColors.bodyTitle1_N_Gr,
              )
            ],
          ));

      wDets.add(wDet);
    }

    Container wDet = Container(
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
              color: Color(0xFFf3a9dd),
            ),
            Text(
              "Libre",
              style: gColors.bodyTitle1_N_Gr,
            )
          ],
        ));

    wDets.add(wDet);


     wDet = Container(
        margin: EdgeInsets.fromLTRB(50, 0, 10, 0),
        child: Row(
          children: [
            Text(
              "Clic : ",
              style: gColors.bodyTitle1_B_Gr,
            ),
            Text(
              "Vue Intervention",
              style: gColors.bodyTitle1_N_Gr,
            )
          ],
        ));

    wDets.add(wDet);

    wDet = Container(
        margin: EdgeInsets.fromLTRB(50, 0, 10, 0),
        child: Row(
          children: [
            Text(
              "Clic Long : ",
              style: gColors.bodyTitle1_B_Gr,
            ),
            Text(
              "Déplacement",
              style: gColors.bodyTitle1_N_Gr,
            )
          ],
        ));

    wDets.add(wDet);


    wLegend = Container(
      padding: EdgeInsets.fromLTRB(25, 5, 5, 0),
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: wDets),
    );

    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  Widget AppBar() {
    return !widget.bAppBar
        ? Container()
        : Container(
            height: 60,
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
                  "Planning",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
                ),
                Spacer(),
                gColors.BtnAffUser(context),
                Container(
                  width: 150,
                  child: Text(
                    "Version : ${DbTools.gVersion}",
                    style: gColors.bodySaisie_N_W,
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    gColors.wTheme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    Color wColor = gColors.GrdBtn_Colors3sel;
    int wHours = 0;

    if (DbTools.gIntervention.InterventionId! > 0) {
      for (int p = 0; p < DbTools.ListParam_Saisie_Param.length; p++) {
        Param_Saisie_Param wparamSaisieParam = DbTools.ListParam_Saisie_Param[p];
        if (wparamSaisieParam.Param_Saisie_Param_Label.compareTo(DbTools.gIntervention.Intervention_Status!) == 0) {
          wColor = gColors.getColor(wparamSaisieParam.Param_Saisie_Param_Color);
          break;
        }
      }

      late Planning_Srv wplanningSrv;
      for (int p = 0; p < DbTools.ListPlanning.length; p++) {
        wplanningSrv = DbTools.ListPlanning[p];
        if (wplanningSrv.Planning_InterventionId == DbTools.gIntervention.InterventionId) {
          wHours += wplanningSrv.Planning_InterventionendTime.difference(wplanningSrv.Planning_InterventionstartTime).inHours;
//              print("wPlanning_Srv ${wPlanning_Srv.Planning_InterventionstartTime} ${wPlanning_Srv.Planning_InterventionendTime} $wHours");
        }
      }
    }

    print("build isload $isload");

    int wMargeBasse = 0;
    if (DbTools.gIntervention.InterventionId! > 0)
      wMargeBasse += 35;

    if (isLegendVisible)
      wMargeBasse += 160;

    return Material(
        child: Container(
            child: !isload
                ? Container(

              child: Column(
                  children: [
                  AppBar(),
                Row(
                  children: [
                    Container(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: 1881,
                      child: AffSelIntervention(),
                    ),
                  ],
                ),
                    Container(
                      height: 175,
                    ),

                CircularProgressIndicator(),


              ],
            ),

            )
                : Column(
                    children: [
                      AppBar(),
                      Row(
                        children: [
                          Container(
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: 1881,
                            child: AffSelIntervention(),
                          ),


                        ],
                      ),
                      (DbTools.gIntervention.InterventionId! <= 0)
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.fromLTRB(20, 05, 20, 05),
                              color: wColor,
                              child: Text(
                                '$interventionNom => $wHours heures affetées',
                                style: gColors.bodyTitle1_N_Wr,
                                textAlign: TextAlign.start,
                              ),
                            ),
                      Container(
                        height: screenHeight - wMargeBasse,
                        child: _getDragAndDropCalendar(_calendarController, _events, _onViewChanged, onTap, onLongPress),
                      ),
                      !isLegendVisible
                          ? Container()
                          : Container(
                              height: 30,
                              child: wLegend,
                            ),
                    ],
                  )));
  }

  Widget AffSelIntervention() {
    double w = 200;
    return Container(
//        color: Colors.greenAccent,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),

        width: 1680,
        child: InkWell(
          child: Row(
            children: [
              CommonAppBar.SquareRoundPng(context, 20, 8, Colors.green, Colors.white, "ico_Legend", ToolsBarLegend, tooltip: "Afficher Légende"),
              Container(
                width: 5,
              ),
              CommonAppBar.SquareRoundPng(context, 20, 8, Colors.white, Colors.red, "ico_Filtre", ToolsBarFiltre, tooltip: "Filtre"),
              Container(
                width: 5,
              ),
              gColors.Txt2(50, 'Dépot', '${Depot}', tWidth: w),
              Container(
                width: 5,
              ),
              gColors.Txt2(50, 'Client', '${clientNom}', tWidth: w+10),
              Container(
                width: 5,
              ),
              gColors.Txt2(60, 'Groupe', '${groupeNom}', tWidth: w),
              Container(
                width: 5,
              ),
              gColors.Txt2(50, 'Site', '${siteNom}', tWidth: w+10),
              Container(
                width: 5,
              ),
              gColors.Txt2(50, 'Zone', '${zoneNom}', tWidth: w),
              Container(
                width: 5,
              ),
              gColors.Txt2(90, 'Intervention', '${interventionNom}', tWidth: w+140),
            ],
          ),
          onTap: ()  async{
            print(" onTap");
            ToolsBarFiltre();
          },
        ));
  }

  void ToolsBarFiltre() async {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return SelectInter(
          onChanged: (selChangedDetails details) async {
            Depot           = details.depot!;
            clientNom       = details.client!.Client_Nom;
            if (clientNom.isNotEmpty) DbTools.gClient = details.client!;
            groupeNom       = details.groupe!.Groupe_Nom;
            if (groupeNom.isNotEmpty) DbTools.gGroupe = details.groupe!;
            siteNom         = details.site!.Site_Nom;
            if (siteNom.isNotEmpty) DbTools.gSite   = details.site!;
            zoneNom         = details.zone!.Zone_Nom;
            if (zoneNom.isNotEmpty) DbTools.gZone   = details.zone!;
            interventionNom = details.intervention!.Intervention_Date!;
            String wDate = "----/----/-------";
            if (details.intervention!.Intervention_Date!.isNotEmpty) wDate = details.intervention!.Intervention_Date!;

            interventionNom =  "[${details.intervention!.InterventionId}] ${wDate} ${details.intervention!.Intervention_Type} ${details.intervention!.Intervention_Parcs_Type} ${details.intervention!.Intervention_Status}";


            if (interventionNom.isNotEmpty) DbTools.gIntervention = details.intervention!;
          },
        );
      },
    ).then((dynamic value) => setState(() {
      /// update the color picker changes
    }));
  }



  void ToolsBarLegend() async {
    print("ToolsBarLegend");
    isLegendVisible = !isLegendVisible;
    print("ToolsBarLegend ${isLegendVisible}");
    setState(() {});
  }

  Future addUser() async {
//    wUserWidget.clear();
    await DbTools.getUserAll();

    print(">>>>>>>>>>>>>>>>>>>>>>>>>> getUserAll");

    Uint8List pic = Uint8List.fromList([0]);
    _employeeCollection.clear();

    for (int u = 0; u < DbTools.ListUser.length; u++) {
      User user = DbTools.ListUser[u];
      String wInitP = user.User_Prenom.isEmpty ? "" : "${user.User_Prenom[0]} ";
      String wUserImg = "User_${user.UserID}.jpg";
      pic = await gColors.getImage(wUserImg);
      late ImageProvider wImage;
      if (pic.length > 0) {
        wImage = MemoryImage(pic);
      }

      _employeeCollection.add(CalendarResource(displayName: "$wInitP${user.User_Nom}", id: "${user.UserID}", color: _colorCollection[0], image: (pic.length > 0) ? wImage : null));
    }

    print(">>>>>>>>>>>>>>>>>>>>>>>>>> getUserAll FIN");
  }

  Future<List<Appointment>> genAppointmentsSrv() async {
    await DbTools.getPlanning_All();

    DateTime today = DateTime.now();
    final Random random = Random();
    DateTime StartDateTime = DateTime(today.year, today.month, today.day, 10);
    StartDateTime = StartDateTime.add(Duration(days: -(StartDateTime.weekday - 1)));

    final List<Appointment> appointments = <Appointment>[];

    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      Planning_Srv wplanningSrv = DbTools.ListPlanning[p];

      Planning_Interv planningInterv = Planning_Interv.Planning_RdvInit();

      if (wplanningSrv.Planning_InterventionId == -1) {
        planningInterv.Planning_Interv_Client_Nom = wplanningSrv.Planning_Libelle;
      } else {
        for (int r = 0; r < DbTools.ListPlanning_Interv.length; r++) {
          Planning_Interv wplanningInterv = DbTools.ListPlanning_Interv[r];
          if (wplanningInterv.Planning_Interv_InterventionId == wplanningSrv.Planning_InterventionId) planningInterv = wplanningInterv;
        }
      }

      CalendarResource calendarResource = _employeeCollection[0];
      for (int p = 0; p < _employeeCollection.length; p++) {
        CalendarResource wCalendarResource = _employeeCollection[p];
        if ((int.parse(wCalendarResource.id.toString()) == wplanningSrv.Planning_ResourceId)) {
          calendarResource = wCalendarResource;
        }
      }

      Color wColor = Colors.deepPurple;

      for (int p = 0; p < DbTools.ListParam_Saisie_Param.length; p++) {
        Param_Saisie_Param wparamSaisieParam = DbTools.ListParam_Saisie_Param[p];

        if (wparamSaisieParam.Param_Saisie_Param_Label.compareTo(planningInterv.Planning_Interv_Intervention_Status!) == 0) {
          wColor = gColors.getColor(wparamSaisieParam.Param_Saisie_Param_Color);
          break;
        }
      }

      if (wColor == gColors.GrdBtn_Colors3sel) {
        print("");
        print("planningInterv.Planning_Interv_Intervention_Status! ${planningInterv.Planning_Interv_Intervention_Status!}");
        print("");
      }

      final List<Object> employeeIds = <Object>[calendarResource.id];
      Appointment wAppointment = Appointment(subject: planningInterv.Planning_Interv_Client_Nom!, startTime: wplanningSrv.Planning_InterventionstartTime, endTime: wplanningSrv.Planning_InterventionendTime, color: wColor, resourceIds: employeeIds, recurrenceId: wplanningSrv.PlanningId);
      if (wplanningSrv.Planning_InterventionId == -1) print("wAppointment ADD ${wAppointment.subject} ${wAppointment.startTime} ${wAppointment.endTime} ${wAppointment.recurrenceId} ${wAppointment.resourceIds}");
        appointments.add(wAppointment);
    }
    return appointments;
  }


  void onMaj() async {
    print("Parent onMaj()");
    await Reload();
    setState(() {});
  }

  Future getClient() async {
    clientNom = DbTools.gPlanning_Interv.Planning_Interv_Client_Nom!;
    DbTools.gClient.ClientId = DbTools.gPlanning_Interv.Planning_Interv_ClientId!;
    await DbTools.getGroupesClient(DbTools.gClient.ClientId);

    groupeNom = DbTools.gPlanning_Interv.Planning_Interv_Groupe_Nom!;
    DbTools.gGroupe.GroupeId = DbTools.gPlanning_Interv.Planning_Interv_GroupeId!;
    await DbTools.getSitesGroupe(DbTools.gGroupe.GroupeId);

    siteNom = DbTools.gPlanning_Interv.Planning_Interv_Site_Nom!;
    DbTools.gSite.SiteId = DbTools.gPlanning_Interv.Planning_Interv_SiteId!;
    await DbTools.getZonesSite(DbTools.gSite.SiteId);

    zoneNom = DbTools.gPlanning_Interv.Planning_Interv_Zone_Nom!;
    DbTools.gZone.ZoneId = DbTools.gPlanning_Interv.Planning_Interv_ZoneId!;
    await DbTools.getInterventionsZone(DbTools.gZone.ZoneId);

    interventionNom = "${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Type!} ${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Parcs_Type!} ${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Status!}";
    DbTools.gIntervention.InterventionId = DbTools.gPlanning_Interv.Planning_Interv_InterventionId;
    await DbTools.getInterventionID(DbTools.gPlanning_Interv.Planning_Interv_InterventionId!);

    setState(() {});
  }

  void onLongPress(CalendarLongPressDetails calendarLongPressDetails) async {
    print("_onCalendarLongPressed");
    print("calendarLongPressDetails ${calendarLongPressDetails.appointments!.length}");

    int IntevId = 0;
    if (calendarLongPressDetails.appointments != null) {
      final dynamic appointment = calendarLongPressDetails.appointments![0];
      for (int p = 0; p < DbTools.ListPlanning.length; p++) {
        Planning_Srv wplanningSrv = DbTools.ListPlanning[p];
        if (wplanningSrv.PlanningId == int.parse(appointment!.recurrenceId.toString())) {
          IntevId = wplanningSrv.Planning_InterventionId!;
          break;
        }
      }
      if (IntevId <= 0) {
        print("_onCalendarLongPressed Cancel");

        return;
      }

      print("calendarLongPressDetails IntevId $IntevId");

      DbTools.getPlanning_Interv_ID(IntevId);

      await getClient();
    }
  }

  void onTap(CalendarTapDetails calendarTapDetails) async {
    print("calendarTapDetails.targetElement ${calendarTapDetails.targetElement} ${calendarTapDetails.resource!.id}");

    if (calendarTapDetails.targetElement == CalendarElement.viewHeader || calendarTapDetails.targetElement == CalendarElement.header) {
      return;
    }

    _selectedAppointment = null;
    if (calendarTapDetails.appointments != null && calendarTapDetails.targetElement == CalendarElement.appointment) {
      final dynamic appointment = calendarTapDetails.appointments![0];
      if (appointment is Appointment) {
        _selectedAppointment = appointment;
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              final List<Appointment> appointment = <Appointment>[];
              Appointment? newAppointment;

              if (_selectedAppointment == null) {
                _selectedColorIndex = 0;
                _client = '';
                final DateTime date = calendarTapDetails.date!;
                newAppointment = Appointment(
                  startTime: date,
                  endTime: date.add(const Duration(hours: 1)),
                  color: _colorCollection[_selectedColorIndex],
                  isAllDay: false,
                  subject: _client == '' ? '(No title)' : _client,
                );
                appointment.add(newAppointment);
                _events.appointments!.add(appointment[0]);
                SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
                  _events.notifyListeners(CalendarDataSourceAction.add, appointment);
                });

                _selectedAppointment = newAppointment;
              }

              final List<Appointment> appointmentCollection = <Appointment>[];

              return WillPopScope(
                onWillPop: () async {
                  if (newAppointment != null) {
                    _events.appointments!.removeAt(_events.appointments!.indexOf(newAppointment));
                    _events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[newAppointment]);
                  }
                  print("onWillPop");
                  setState(() {});
                  return true;
                },
                child: Center(
                    child: Container(
                        alignment: Alignment.center,
                        width: 900,
                        height: 440,
                        child: Theme(
                            data: gColors.wTheme,
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                              child: Planning_Edit(_selectedAppointment, onMaj),
                            )))),
              );
            });
        return;
      }
    } else {
      final DateTime date = calendarTapDetails.date!;
      print("ADD $date");

      DateTime wStart = date;
      DateTime wEnd = date.add(const Duration(hours: 1));
      int planningResourceid = int.parse(calendarTapDetails.resource!.id.toString());
      bool isInOther = false;

//      print("Add App $wStart");
      //    print("Add App $wEnd");

      for (int p = 0; p < DbTools.ListPlanning.length; p++) {
        Planning_Srv wplanningSrv = DbTools.ListPlanning[p];
        if (wplanningSrv.Planning_ResourceId! == planningResourceid) {
          if (wplanningSrv.Planning_InterventionstartTime.year == wStart.year && wplanningSrv.Planning_InterventionstartTime.month == wStart.month && wplanningSrv.Planning_InterventionstartTime.day == wStart.day) {
            bool sa = wStart.isAfter(wplanningSrv.Planning_InterventionstartTime) || wStart.isAtSameMomentAs(wplanningSrv.Planning_InterventionstartTime);
            bool sb = wStart.isBefore(wplanningSrv.Planning_InterventionendTime) || wStart.isAtSameMomentAs(wplanningSrv.Planning_InterventionendTime);

            bool ea = wEnd.isAfter(wplanningSrv.Planning_InterventionstartTime) || wEnd.isAtSameMomentAs(wplanningSrv.Planning_InterventionstartTime);
            bool eb = wEnd.isBefore(wplanningSrv.Planning_InterventionendTime) || wEnd.isAtSameMomentAs(wplanningSrv.Planning_InterventionendTime);
//            print("appointment ${wplanningSrv.PlanningId} ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");

            if (sa && sb) {
              isInOther = true;
              //            print("add appointment ${wplanningSrv.PlanningId} ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
              break;
            }
            if (ea && eb) {
              isInOther = true;
              //          print("add appointment ${wplanningSrv.PlanningId}  ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
              break;
            }
          }
        }
      }

      if (!isInOther) {
        Planning_Srv wplanningSrv = Planning_Srv.Planning_RdvInit();
        wplanningSrv.Planning_InterventionId = DbTools.gIntervention.InterventionId;
        wplanningSrv.Planning_ResourceId = int.parse(calendarTapDetails.resource!.id.toString());
        wplanningSrv.Planning_InterventionstartTime = date;
        wplanningSrv.Planning_InterventionendTime = date.add(const Duration(hours: 4));
        if (DbTools.gIntervention.InterventionId == -1) {
          wplanningSrv.Planning_Libelle = clientNom.isEmpty ? "Rdv" : clientNom;
        }
        await DbTools.addPlanning(wplanningSrv);
      }

      await Reload();

      setState(() {});
      return;
    }
  }

  void appointment_ResizeStart(AppointmentResizeStartDetails details) {
    appointment_resizeStart = details.appointment!;
    return;
  }

  void appointment_ResizeEnd(AppointmentResizeEndDetails details) async {
    dynamic appointment = details.appointment!;

    late Planning_Srv uptplanningSrv;

    int IntevId = 0;
    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      uptplanningSrv = DbTools.ListPlanning[p];
      if (uptplanningSrv.PlanningId == int.parse(appointment!.recurrenceId.toString())) {
        IntevId = uptplanningSrv.Planning_InterventionId!;
        break;
      }
    }

    Appointment wAppointment = appointment;
    int wAppUserid = int.parse(wAppointment.resourceIds![0].toString());

    appointment.startTime = gColors.alignDateTime(appointment.startTime, Duration(minutes: 30));
    appointment.endTime = gColors.alignDateTime(appointment.endTime, Duration(minutes: 30));
    DateTime wStart = appointment.startTime;
    DateTime wEnd = appointment.endTime;

    print("resize appointment ${int.parse(appointment.recurrenceId.toString())}  ${wAppointment.startTime} ${wAppointment.endTime}");
    print("resize appointment ${wStart.hour + wStart.minute + wStart.second}");
    bool isInOther = (wStart.hour + wStart.minute + wStart.second == 0 && wEnd.hour + wEnd.minute + wEnd.second == 0);
    if (wStart.hour + wStart.minute + wStart.second == 0) wStart = wStart.add(Duration(hours: 8));

    print("resize appointment 888 ${wStart.hour}");

    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      Planning_Srv wplanningSrv = DbTools.ListPlanning[p];
      if (wplanningSrv.Planning_ResourceId! == wAppUserid && wplanningSrv.PlanningId != uptplanningSrv.PlanningId) {
        bool sa = wStart.isAfter(wplanningSrv.Planning_InterventionstartTime);
        bool sb = wStart.isBefore(wplanningSrv.Planning_InterventionendTime);

        bool ea = wEnd.isAfter(wplanningSrv.Planning_InterventionstartTime);
        bool eb = wEnd.isBefore(wplanningSrv.Planning_InterventionendTime);

        if (sa && sb) {
          isInOther = true;
          print("resize  appointment ${wplanningSrv.PlanningId} ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
          break;
        }
        if (ea && eb) {
          isInOther = true;
          print("resize  appointment ${wplanningSrv.PlanningId}  ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
          break;
        }
      }
    }

    if (isInOther) {
      print("resize appointment isInOther A ${appointment_dragStart.toString()}");
      uptplanningSrv.Planning_InterventionstartTime = appointment_resizeStart.startTime;
      uptplanningSrv.Planning_InterventionendTime = appointment_resizeStart.endTime;
      print("resize appointment isInOther B");
    } else {
      print("resize appointment C ${uptplanningSrv.PlanningId}");
      uptplanningSrv.Planning_InterventionstartTime = wStart;
      uptplanningSrv.Planning_InterventionendTime = wEnd;
      print("resize appointment D");
    }
    print("setPlanning ${uptplanningSrv.Planning_InterventionstartTime} ${uptplanningSrv.Planning_InterventionendTime} ");

    DbTools.setPlanning(uptplanningSrv);
    await Reload();
    setState(() {});
  }

  //********************************************

  void dragStart(AppointmentDragStartDetails details) {
    appointment_dragStart = details.appointment!;
    return;
  }

  void dragEnd(AppointmentDragEndDetails details) async {
    dynamic appointment = details.appointment!;

    Appointment wAppointment = appointment;
    int wAppUserid = int.parse(wAppointment.resourceIds![0].toString());
    int wDuration = appointment.endTime.difference(appointment.startTime).inHours;

    if (wDuration < 1) wDuration = 1;

    print("sourceResource ${details.sourceResource!.id} ${details.sourceResource!.displayName}");
    print("targetResource ${details.targetResource!.id} ${details.targetResource!.displayName}");

    appointment.startTime = gColors.alignDateTime(appointment.startTime, Duration(minutes: 30));
    appointment.endTime = appointment.startTime.add(Duration(hours: wDuration));

    DateTime wStart = appointment.startTime;
    DateTime wEnd = appointment.endTime;

    print("appointment ${wStart.hour + wStart.minute + wStart.second}");

    bool isInOther = false; // ( wStart.hour + wStart.minute + wStart.second == 0 && wEnd.hour + wEnd.minute + wEnd.second == 0 );

    if (wStart.hour + wStart.minute + wStart.second == 0) {
      wEnd = wStart.add(Duration(hours: wDuration));
    }
    print("appointment 888 ${wStart.hour}");

    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      Planning_Srv wplanningSrv = DbTools.ListPlanning[p];
      if (wplanningSrv.Planning_ResourceId! == wAppUserid && wplanningSrv.PlanningId != int.parse(appointment.recurrenceId.toString())) {
        bool sa = wStart.isAfter(wplanningSrv.Planning_InterventionstartTime);
        bool sb = wStart.isBefore(wplanningSrv.Planning_InterventionendTime);

        bool ea = wEnd.isAfter(wplanningSrv.Planning_InterventionstartTime);
        bool eb = wEnd.isBefore(wplanningSrv.Planning_InterventionendTime);

        if (sa && sb) {
          isInOther = true;
          print("drag appointment ${wplanningSrv.PlanningId} ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
          break;
        }
        if (ea && eb) {
          isInOther = true;
          print("drag appointment ${wplanningSrv.PlanningId}  ${wplanningSrv.Planning_InterventionstartTime} ${wplanningSrv.Planning_InterventionendTime}  ($sa $sb $ea $eb) $isInOther");
          break;
        }
      }
    }

    print("appointment $isInOther $wStart $wEnd");

    for (int p = 0; p < DbTools.ListPlanning.length; p++) {
      Planning_Srv wplanningSrv = DbTools.ListPlanning[p];

      if (wplanningSrv.PlanningId == int.parse(appointment.recurrenceId.toString())) {
        if (isInOther) {
          wplanningSrv.Planning_InterventionstartTime = appointment_dragStart.startTime;
          wplanningSrv.Planning_InterventionendTime = appointment_dragStart.endTime;
        } else {
          wplanningSrv.Planning_ResourceId = int.parse(details.targetResource!.id.toString());
          wplanningSrv.Planning_InterventionstartTime = wStart;
          wplanningSrv.Planning_InterventionendTime = wEnd;
        }
        print("setPlanning ${wplanningSrv.Desc()}");

        DbTools.setPlanning(wplanningSrv);
        await Reload();
        setState(() {});

        break;
      }
    }
  }

  void _addSpecialRegions() {
    final DateTime date = DateTime.now().add(Duration(days: -365));
    for (int i = 0; i < _employeeCollection.length; i++) {
      _specialTimeRegions.add(TimeRegion(startTime: DateTime(date.year, date.month, date.day, 12), endTime: DateTime(date.year, date.month, date.day, 14), text: 'Lunch', color: Colors.grey.withOpacity(0.2), resourceIds: <Object>[_employeeCollection[i].id], recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));

      _specialTimeRegions.add(TimeRegion(startTime: DateTime(date.year, date.month, date.day, 08), endTime: DateTime(date.year, date.month, date.day, 8, 10), text: 'Deb', color: Colors.blue.withOpacity(0.2), resourceIds: <Object>[_employeeCollection[i].id], recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));

      _specialTimeRegions.add(TimeRegion(
        startTime: DateTime(date.year, date.month, date.day),
        endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
        text: 'WE',
        enablePointerInteraction: true,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withOpacity(0.1),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SA,SU',
      ));

      if (i.isEven) {
        continue;
      }
    }
  }

  Widget _getSpecialRegionWidget(BuildContext context, TimeRegionDetails details) {
    if (details.region.text == 'Lunch') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.grey.withOpacity(0.5),
        ),
      );
    }
    if (details.region.text == 'Deb') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
      );
    }
    if (details.region.text == 'WE') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
      );
    }

    return Container(color: details.region.color);
  }

  SfCalendar _getDragAndDropCalendar([
    CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
    dynamic calendarTapCallback,
    dynamic calendarLongPressCallback,
  ]) {
    CalendarDataSource wCalendarDataSource = _ShiftDataSource(<Appointment>[], <CalendarResource>[]);
    wCalendarDataSource.appointments!.addAll(calendarDataSource!.appointments!);

    if (Depot.isNotEmpty && Depot != "Tous") {
      for (int p = 0; p < calendarDataSource.resources!.length; p++) {
        CalendarResource wCalendarResource = calendarDataSource.resources![p];
        User user = DbTools.ListUser.firstWhere((element) => element.UserID == int.parse(wCalendarResource.id.toString()));
        if (user.User_Depot.compareTo(Depot) == 0) {
          Color wColor = Color(0xFF3D4FB5);
          wCalendarDataSource.resources!.add(CalendarResource(displayName: "${wCalendarResource.displayName}", id: "${wCalendarResource.id}", color: wColor, image: wCalendarResource.image));
        }
      }

      for (int p = 0; p < calendarDataSource.resources!.length; p++) {
        CalendarResource wCalendarResource = calendarDataSource.resources![p];
        User user = DbTools.ListUser.firstWhere((element) => element.UserID == int.parse(wCalendarResource.id.toString()));
        if (user.User_Depot.compareTo(Depot) != 0) {
          Color wColor = Color(0xFFB5B5B5);
          wCalendarDataSource.resources!.add(CalendarResource(displayName: "${wCalendarResource.displayName}", id: "${wCalendarResource.id}", color: wColor, image: wCalendarResource.image));
        }
      }
    } else {
      wCalendarDataSource.resources!.addAll(calendarDataSource.resources!);
    }

    print(">>>>>>>>>>> Aappointments ${wCalendarDataSource.appointments!.length}");
    print(">>>>>>>>>>> resources ${wCalendarDataSource.resources!.length}");
    int IntevId = 0;

    double widthCall = MediaQuery.of(context).size.width - 200;
    int wNbCol = 7;
    if (this._currentView == CalendarView.timelineWorkWeek) wNbCol = 5;
    double widthCol = widthCall / (wNbCol * 5);

    print("widthCol $widthCall  $widthCol");

    return SfCalendar(
      viewHeaderStyle: ViewHeaderStyle(backgroundColor: Colors.white, dayTextStyle: TextStyle(color: gColors.grey, fontSize: 14, fontWeight: FontWeight.bold), dateTextStyle: TextStyle(color: gColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
      todayTextStyle: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
      controller: _calendarController,
      view: CalendarView.timelineWorkWeek,
      dataSource: wCalendarDataSource,
      allowedViews: _allowedViews,
      showNavigationArrow: true,
      firstDayOfWeek: 1,
      showWeekNumber: true,
      showCurrentTimeIndicator: false,
      onViewChanged: viewChangedCallback,
      onTap: calendarTapCallback,
      onLongPress: calendarLongPressCallback,
      allowDragAndDrop: true,
      onDragStart: dragStart,
      onDragEnd: dragEnd,
      onAppointmentResizeStart: appointment_ResizeStart,
      onAppointmentResizeEnd: appointment_ResizeEnd,
      timeRegionBuilder: _getSpecialRegionWidget,
      specialRegions: _specialTimeRegions,
      allowAppointmentResize: true,
      showDatePickerButton: true,
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 8,
        endHour: 18,
        timeIntervalHeight: -1,
        timeFormat: 'HH',
        minimumAppointmentDuration: Duration(minutes: 60),
        dateFormat: 'd',
        dayFormat: 'EEE',
//        nonWorkingDays: const <int>[DateTime.saturday, DateTime.sunday],
//        timeInterval: const Duration(minutes: 120),
        timeIntervalWidth: -1,
        timeTextStyle: TextStyle(color: gColors.grey, fontSize: 12, fontWeight: FontWeight.normal),
      ),
      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
        {
          final Appointment appointment = calendarAppointmentDetails.appointments.first;
//          DbTools.getPlanning_Interv_ID(int.parse(appointment.recurrenceId.toString()));

          late Planning_Srv wplanningSrv;
          for (int p = 0; p < DbTools.ListPlanning.length; p++) {
            wplanningSrv = DbTools.ListPlanning[p];
            if (wplanningSrv.PlanningId == int.parse(appointment.recurrenceId.toString())) {
              IntevId = wplanningSrv.Planning_InterventionId!;
              break;
            }
          }
          if (IntevId >= 0) {
            DbTools.getPlanning_Interv_ID(IntevId);
          } else {
            DbTools.gPlanning_Interv = Planning_Interv.Planning_RdvInit();
            DbTools.gPlanning_Interv.Planning_Interv_Client_Nom = appointment.subject;
            DbTools.gPlanning_Interv.Planning_Interv_Site_Nom = "";
          }

          int wDuration = appointment.endTime.difference(appointment.startTime).inHours;

          Color wcolor = appointment.color;
          Color wcolorb = appointment.color;
          double borderSize = 0;

          if (IntevId == -1) {
//            print("wAppointment 22222222 $IntevId ${appointment.subject} ${appointment.startTime} ${appointment.endTime} ${appointment.recurrenceId} ${appointment.resourceIds}  ${appointment.color}");
            //          print("Planning_Interv_Client_Nom $IntevId ${DbTools.gPlanning_Interv.Planning_Interv_Client_Nom}");
          }

          if (DbTools.gIntervention.InterventionId != -1 && DbTools.gIntervention.InterventionId != DbTools.gPlanning_Interv.Planning_Interv_InterventionId) {
            {
              wcolor = Colors.black12; // Autre
            }
          }

          if (IntevId < 0) {
            wcolor = Color(0xFFf3a9dd); //Libre
          }

          print("••••• wAppointment  $IntevId ${appointment.subject} ${appointment.startTime} ${appointment.endTime} ${appointment.recurrenceId} ${appointment.resourceIds}  ${appointment.color}");

          print("••••• appointmentBuilder $IntevId ${DbTools.gPlanning_Interv.Planning_Interv_Client_Nom} ${wcolor}");

          return _currentView == CalendarView.timelineMonth
              ? Container(
                  decoration: BoxDecoration(
                    color: wcolor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                      width: borderSize,
                      color: wcolorb,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${DbTools.gPlanning_Interv.Planning_Interv_Client_Nom}', maxLines: 1, textAlign: TextAlign.center, style: gColors.bodySaisie_N_W),
                    ],
                  ))
              : Container(
                  decoration: BoxDecoration(
                    color: wcolor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                      width: borderSize,
                      color: wcolorb,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${DbTools.gPlanning_Interv.Planning_Interv_Client_Nom}', maxLines: 1, textAlign: TextAlign.center, style: gColors.bodySaisie_N_W),
                      Text('${DbTools.gPlanning_Interv.Planning_Interv_Site_Nom}', maxLines: 1, textAlign: TextAlign.center, style: gColors.bodySaisie_N_W),
                      //                    Text('${DbTools.gPlanning_Interv.Planning_Interv_Intervention_Type} ${DbTools.gPlanning_Interv.Planning_Interv_InterventionId}', maxLines: 3, textAlign: TextAlign.center, style: gColors.bodyTitle1_N_Wr),
                    ],
                  ));
        }
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);
  List<Appointment> source;
  @override
  List<dynamic> get appointments => source;
}

class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}



