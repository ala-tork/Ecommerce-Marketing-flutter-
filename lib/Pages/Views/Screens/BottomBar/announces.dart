import 'package:flutter/material.dart';

class Announces extends StatefulWidget {
  const Announces({super.key});

  @override
  State<Announces> createState() => _AnnouncesState();
}

class _AnnouncesState extends State<Announces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("announces"),),
      body: Center(
        child: Text("announces Page",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
