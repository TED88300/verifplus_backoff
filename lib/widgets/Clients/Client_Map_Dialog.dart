

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';

import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Client_Map_Dialog {
  Client_Map_Dialog();

    static Future<void> Client_Map_dialog(BuildContext context,String aAdresse) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Client_Map( aAdresse : aAdresse),
    );
  }
}


class Client_Map extends StatefulWidget {
  final String aAdresse;
  const Client_Map({Key? key, required this.aAdresse}) : super(key: key, );
  @override
  State<Client_Map> createState() => _Client_MapState();
}

class _Client_MapState extends State<Client_Map> {
  late BitmapDescriptor dbDepot;
  late BitmapDescriptor dbSiege;

  LatLng _center = LatLng(0, 0);
  Map<MarkerId, Marker> _markers = {};
  late GoogleMapController googleMapController;

  MapTools_Geocoding wMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");
  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  String wTitle = "";
  String wAdresse = "";
  LatLng wlatLng = LatLng(0,0);
  ScreenCoordinate wScreenCoordinate = ScreenCoordinate(x:0, y:0,);
  bool wAffInfoWindows = false;
  bool wAffMap = false;

  void initLib() async {

    String wformattedAddress = "";
    print("initLib > _center ${_center.longitude}");

    String aAdr = widget.aAdresse;
    wMapTools_Geocoding = await MapTools.GetLatLngfromAddress(aAdr);
    _center = wMapTools_Geocoding.Geo_LatLng;
    dbSiege = await MapTools.BitmapDescriptorAsset('assets/images/Ico.png');
    _addMarker(_center, "Siège", wMapTools_Geocoding.Geo_formattedAddress, dbSiege);
    print("initLib < _center ${_center.latitude} ${_center.longitude}");
    wAffMap = true;
    setState(() {

    });
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 200;
    double height = MediaQuery.of(context).size.height - 200;
    return
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        title : Container(
            color: gColors.primary,
            child: Row(
              children: [
                SizedBox(
                    height: 50.0,
                    width: 100.0), // fixed width and height),
                Spacer(),
                Text(
                  "Vérif+ : Carte",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
                ),
                Spacer(),
                Container(
                  width: 100,
                ),
              ],
            )),
        content:

      Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToolsBar(context),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: width,
                      height: height,
                      child: buildMap(context),
                    )
                  ],
                ),
              ],
            ),
            !wAffInfoWindows ? Container() : Positioned(
              left: wScreenCoordinate.x.toDouble() ,
              top: wScreenCoordinate.y.toDouble(),
              child: InkWell(
                child: Container(
                  width: 500,
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 10),
                        child: ClipOval(child: Image.asset('assets/images/Ico.png', fit: BoxFit.cover)),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                wTitle,
                                style: gColors.bodySaisie_B_B,
                              ),
                              Container(height: 10,),
                              Text(
                                wAdresse,
                                style: gColors.bodySaisie_B_G,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("onTap marker $wTitle");
                  wAffInfoWindows = false;
                  setState(() {

                  });
                },
              ),
            ),
          ],
        )),);
  }

  //**************************************************
  //**************************************************
  //**************************************************

  @override
  Widget buildMap(BuildContext context) {
    print("buildMap _center ${_center.longitude}");

    return !wAffMap ? Container() : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18,
      ),
      zoomControlsEnabled: true,
//      minMaxZoomPreference: MinMaxZoomPreference(10, 18),
      markers: _markers.values.toSet(),
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      onCameraMove: _onCameraMove,
    );
  }

  Future<Marker> _timestampedMarker(MarkerId id, LatLng position) async {

    wMapTools_Geocoding = await MapTools.GetAddressfromLatLng(position);


    return Marker(
      markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
      position: position,
      infoWindow: InfoWindow(
        snippet: "${wMapTools_Geocoding.Geo_LatLng}",
        title : "${wMapTools_Geocoding.Geo_formattedAddress}",
      ),
      //_jitterPosition(position, 0.002), // Jitter so not all markers fall in the same center...
    );
  }

  void _addMarker(LatLng position, String title, String snippet, BitmapDescriptor Bdico) {
    setState(() {
      final MarkerId id = MarkerId('${_markers.length}');
      _markers[id] = Marker(
        markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
        position: position,
//        icon: Bdico,


        onTap: () async {

          print("onTap marker $title");
          wTitle = title;
          wAdresse = snippet;
          wlatLng = position;
           wScreenCoordinate = await googleMapController.getScreenCoordinate(wlatLng);

          wAffInfoWindows = true;
          setState(() {});
        },
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _onMapTap(LatLng newPosition) async{
    _markers.forEach((markerId, marker) async{
      _markers[markerId] = await _timestampedMarker(markerId, newPosition);

    });

    setState(() {
    });
    // Center the camera where the user clicked after a few milliseconds...
    Future.delayed(Duration(milliseconds: 150), () {
      googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.save, ToolsBarSave),

                Container(
                  width: 10,
                ),
                Text(
                  wMapTools_Geocoding.Geo_formattedAddress,
                  style: gColors.bodySaisie_B_G,
                ),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
            ),
            Container(
              height: 1,
              color: Colors.black26,
            )
          ],
        ));
  }

  void ToolsBarSave() async
  {
    MapTools.gMapTools_Geocoding = wMapTools_Geocoding;
    Navigator.pop(context);
    return;





  }
}
