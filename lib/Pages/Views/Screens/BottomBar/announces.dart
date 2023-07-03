import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/GridAnnounces.dart';
import '../../widgets/custom_icon_button_widget.dart';
import '../MyAppBAr.dart';
import '../messagePage.dart';

class Announces extends StatefulWidget {
  const Announces({super.key});

  @override
  State<Announces> createState() => _AnnouncesState();
}

class _AnnouncesState extends State<Announces> {
  final List<Map<String, dynamic>> gridMap = [
    {
      "title": "white sneaker with adidas logo",
      "price": "255 DT",
      "images":
      "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=725&q=80",
    },
    {
      "title": "Black Jeans with blue stripes",
      "price": "245 DT",
      "images":
      "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    },
    {
      "title": "Red shoes with black stripes",
      "price": "155 DT",
      "images":
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c2hvZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
    },
    {
      "title": "Gamma shoes with beta brand.",
      "price": "275 DT",
      "images":
      "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    },
    {
      "title": "Alpha t-shirt for alpha testers.",
      "price": "25 DT",
      "images":
      "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    },
    {
      "title": "Beta jeans for beta testers",
      "price": "27 DT",
      "images":
      "https://images.unsplash.com/photo-1602293589930-45aad59ba3ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    },
    {
      "title": "V&V  model white t shirts.",
      "price": "55 DT",
      "images":
      "https://images.unsplash.com/photo-1554568218-0f1715e72254?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed("LandingPage"); // Redirect to previous screen
          },
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text("Announces",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MessagePage()));
              },
              value: 2,
              icon: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color:Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {},
              value: 122,

              icon: Icon(
                Icons.diamond_outlined,
                color:Colors.white,
              ),

            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child:Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 28),
                child: DummySearchWidget1(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: GridB(data: gridMap,),
            ),
          ],
        ),
      ),
    );
  }
}