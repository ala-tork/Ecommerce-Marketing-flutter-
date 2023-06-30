import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/MyAnnouncesList.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/WelcomePage.dart';
import 'package:flutter/material.dart';

import 'Pages/Views/Screens/AnnouncesCRUD/AddAnnounce.dart';

void main() async{

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
          "MyAnnounces":(context)=>MyAnnounces(),
          "AddAnnounce": (context) => AddAnnounces(),
          "EditeAnnounce": (context) => EditeAnnounce()
        }


    );
  }
}