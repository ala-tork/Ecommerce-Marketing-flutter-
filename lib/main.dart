import 'dart:io';

import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/MyAnnouncesList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/AddDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/MyDealsList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/LandingPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/WelcomePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/wishlist.dart';
import 'package:ecommerceversiontwo/Pages/core/services/myhttpoverrides.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Views/Screens/AnnouncesCRUD/AddAnnounce.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  /** affect the sharedPrefirence of the boosted Silde SHow */
  void AffectFalseToSlideShow() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boostedSlideDialogShown', false);
    prefs.setBool('Rules', false);
  }
  AffectFalseToSlideShow();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),

      home:  WelcomePage(),
      routes:
        {
          "LandingPage":(context)=>LandingPage(),
          "MyAnnounces":(context)=>MyAnnounces(),
          "AddAnnounce": (context) => AddAnnounces(),
          "EditeAnnounce": (context) => EditeAnnounce(),
          "WishList": (context)=>WishList(),
          "MyDeals" : (context)=>MyDeals(),
          "AddDeals" : (context)=>AddDeals(),
        }


    );
  }
}