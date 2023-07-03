import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  MyAppBar(Daimons: 122,title: "Store",),
      body: Center(
        child: Text("Store Page",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
