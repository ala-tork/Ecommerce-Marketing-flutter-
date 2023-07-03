import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:flutter/material.dart';

class Deals extends StatefulWidget {
  const Deals({super.key});

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  MyAppBar(Daimons: 122,title: "Deals",),
      body: Center(
        child: Text("Deals Page",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
