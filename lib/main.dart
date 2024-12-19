import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgets/0_HomeAdmin.dart';



void main()  {

  if (kDebugMode)
    DbTools.gTED = true;

//  DbTools.gTED = false;


  WidgetsFlutterBinding.ensureInitialized();
  print("main DbTools.gTED ${DbTools.gTED}");


  runApp(

    HomeAdmin(),
  );
}

