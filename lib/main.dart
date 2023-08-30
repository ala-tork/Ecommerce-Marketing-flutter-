import 'dart:io';
import 'package:ecommerceversiontwo/LocalProvider.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/AddDeals.dart';
import 'package:ecommerceversiontwo/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/MyAnnouncesList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/MyDealsList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LandingPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/WelcomePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/profile/ProfileProvider.dart';
import 'package:ecommerceversiontwo/Pages/core/services/myhttpoverrides.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/AddAnnounce.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    ChangeNotifierProvider<LocalProvider>(
      create: (_) => LocalProvider(),
      child: Consumer<LocalProvider>(
        builder: (context, localProvider, _) {
          return MaterialApp(
            locale: localProvider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: MyApp(),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void affectFalseToSlideShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boostedSlideDialogShown', false);
    prefs.setBool('Rules', false);
  }

  @override
  Widget build(BuildContext context) {
    affectFalseToSlideShow();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalProvider>(
          create: (context) => LocalProvider(),
        ),
        // Add other providers here if needed
      ],
      child: Consumer<LocalProvider>(
        builder: (context, localProvider, _) {
          final locale = localProvider.locale;

          return MaterialApp(
            locale: locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData.light(),
            home: WelcomePage(),
            routes: {
              "LandingPage": (context) => LandingPage(),
              "MyAnnounces": (context) => MyAnnounces(),
              "AddAnnounce": (context) => AddAnnounces(),
              "MyDeals": (context) => MyDeals(),
              "AddDeals": (context) => AddDeals(),
            },
          );
        },
      ),
    );
  }
}
