import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapTools_Geocoding {
  LatLng  Geo_LatLng = LatLng(0, 0);
  String  Geo_formattedAddress = "";
  List<AddressComponent>? Geo_addressComponents;

    MapTools_Geocoding(LatLng  geo_LatLng     , String  geo_formattedAddress   ) {
    this.Geo_LatLng = geo_LatLng;
    this.Geo_formattedAddress = geo_formattedAddress;

  }
}

class MapTools {


  static MapTools_Geocoding gMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");


  static String apiKeyMap = "AIzaSyA4yhTrsRZyQhP862oplwp978NyRUIih4s";

  static Future<MapTools_Geocoding> GetLatLngfromAddress(String Adresse) async {
    LatLng wLatLng = LatLng(0, 0);
    String wformattedAddress = "";
    MapTools_Geocoding wmaptoolsGeocoding = MapTools_Geocoding(wLatLng, wformattedAddress);


    var googleGeocoding = GoogleGeocoding(apiKeyMap);
    List<Component> components = [];
    var risult = await googleGeocoding.geocoding.get(Adresse, components);

    print("geocoding $Adresse ");

    if (risult!.status!.contains("OK")) {
      if (risult.results!.length > 0) {
        var element = risult.results![0];

        print("geocoding ${element.addressComponents }");


        wLatLng = LatLng(element.geometry!.location!.lat!, element.geometry!.location!.lng!);
        wmaptoolsGeocoding.Geo_LatLng = wLatLng;
        wmaptoolsGeocoding.Geo_formattedAddress = element.formattedAddress!;
      }
    }
    return wmaptoolsGeocoding;
  }

  static Future<MapTools_Geocoding> GetAddressfromLatLng(LatLng wLatLng) async {

    LatLon wLatLon = new LatLon(wLatLng.latitude, wLatLng.longitude);

    String wformattedAddress = "";
    MapTools_Geocoding wmaptoolsGeocoding = MapTools_Geocoding(wLatLng, wformattedAddress);




    var googleGeocoding = GoogleGeocoding(apiKeyMap);
    List<Component> components = [];
    var risult = await googleGeocoding.geocoding.getReverse(wLatLon);
    if (risult!.status!.contains("OK")) {
      GeocodingResult element = risult.results![0];




      print("geocoding ${element.geometry!.locationType }");
      wLatLng = LatLng(element.geometry!.location!.lat!, element.geometry!.location!.lng!);
      wmaptoolsGeocoding.Geo_LatLng = wLatLng;
      wmaptoolsGeocoding.Geo_formattedAddress = element.formattedAddress!;
      wmaptoolsGeocoding.Geo_addressComponents =  element.addressComponents;
    }
    return wmaptoolsGeocoding;
  }




  static Future<BitmapDescriptor> BitmapDescriptorAsset(String wAsset) async {
    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)), wAsset);
  }

  static Future<BitmapDescriptor> crtBitmapDescriptor(IconData icon , Color color) async {

    BitmapDescriptor wBitmapDescriptor = BitmapDescriptor.defaultMarker;
    final iconData2 = icon;
    final pictureRecorder2 = PictureRecorder();
    final canvas2 = Canvas(pictureRecorder2);
    final textPainter2 = TextPainter(textDirection: TextDirection.ltr);
    final iconStr2 = String.fromCharCode(iconData2.codePoint);
    textPainter2.text = TextSpan(
        text: iconStr2,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 24.0,
          fontFamily: iconData2.fontFamily,
          color: color,
        ));
    textPainter2.layout();
    textPainter2.paint(canvas2, Offset(0.0, 0.0));
    final picture2 = pictureRecorder2.endRecording();
    final image2 = await picture2.toImage(24, 24);
    final bytes2 = await image2.toByteData(format: ImageByteFormat.png);
    wBitmapDescriptor = BitmapDescriptor.fromBytes(bytes2!.buffer.asUint8List());

    return wBitmapDescriptor;
  }
}
