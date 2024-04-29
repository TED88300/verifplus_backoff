import 'package:verifplus_backoff/widgets/1-splashScreen.dart';

import 'package:flutter/material.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:verifplus_backoff/widgets/Clients/Clients.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
class HomeAdmin extends StatelessWidget {
  Widget loading() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate],
      supportedLocales: [
        const Locale('fr', '')
      ],
      locale: const Locale('fr'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          color: gColors.primary,
        ),
        primaryTextTheme: TextTheme(
          titleMedium: TextStyle(
            color: gColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        primarySwatch: MaterialColor(
            gColors.primary.value, gColors.getSwatch(gColors.primary)),
      ),
      home:
      SplashScreen(),

    );

  }
}
