import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridAnnounces.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridWishList.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:flutter/material.dart';

import '../widgets/dummy_search_widget1.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {

  List gridMap = [
    AnnounceModel(
      idAds:1,
      title: "white sneaker with adidas logo",
      price: 255,
      imagePrinciple: "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=725&q=80",
      //like:false,
      //boosted: false,
    ),
    AnnounceModel(
      idAds:2,
      title: "Black Jeans with blue stripes",
      price: 245,
      imagePrinciple:
      "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
     // like:false,
      //boosted: false,
    ),
    AnnounceModel(
      idAds:3,
      title: "Red shoes with black stripes",
      price: 155,
      imagePrinciple:
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c2hvZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
    //  like:false,
     // boosted: false,
    ),
    AnnounceModel(
      idAds:4,
      title: "Gamma shoes with beta brand.",
      price: 275,
      imagePrinciple:
      "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    //  like:false,
      //boosted: false,
    ),
    AnnounceModel(
      idAds:5,
      title: "Alpha t-shirt for alpha testers.",
      price: 25,
      imagePrinciple:
      "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
      //like:false,
      //boosted: false,
    ),
    AnnounceModel(
      idAds:6,
      title: "Beta jeans for beta testers",
      price: 27,
      imagePrinciple:
      "https://images.unsplash.com/photo-1602293589930-45aad59ba3ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
     // like:false,
      //boosted: false,
    ),
    AnnounceModel(
      idAds:7,
      title: "V&V  model white t shirts.",
      price: 55,
      imagePrinciple:
      "https://images.unsplash.com/photo-1554568218-0f1715e72254?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
      //like:false,
      //boosted: false,
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(title: "Wish List"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
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
                child: GridWishList(data: gridMap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
