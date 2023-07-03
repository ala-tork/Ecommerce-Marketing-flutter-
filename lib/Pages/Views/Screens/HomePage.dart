import 'dart:async';

import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/ads_slide_show.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/categoryCard.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/item_card.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/side_bar.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Category.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Product.dart';
import 'package:ecommerceversiontwo/Pages/core/model/adsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categoryData = CategoryService.categoryData.cast<Category>();
  List <Product> productData = ProductService.productData;

  List ad = [
    AdsModel(title:"ITIWIT",shortDescription:"CANOE KAYAK CONFORTABLE",price:1890,ImagePrinciple : "assets/images/Announces/deals1.png"),
    AdsModel(title:"OLAIAN",shortDescription:"SURFER BOARDSHORT",price:50,ImagePrinciple : "assets/images/Announces/deals2.png"),
    AdsModel(title:"SUBEA",shortDescription:"CHAUSSURES ELASTIQUE ADULTE",price:50,ImagePrinciple :"assets/images/Announces/deals3.png"),
  ];

  late Timer flashsaleCountdownTimer;
  Duration flashsaleCountdownDuration = Duration(
    hours: 24 - DateTime.now().hour,
    minutes: 60 - DateTime.now().minute,
    seconds: 60 - DateTime.now().second,
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      setCountdown();
    });
  }

  void setCountdown() {
    if (this.mounted) {
      setState(() {
        final seconds = flashsaleCountdownDuration.inSeconds - 1;

        if (seconds < 1) {
          flashsaleCountdownTimer.cancel();
        } else {
          flashsaleCountdownDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void dispose() {
    if (flashsaleCountdownTimer != null) {
      flashsaleCountdownTimer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = flashsaleCountdownDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String minutes = flashsaleCountdownDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String hours = flashsaleCountdownDuration.inHours
        .remainder(24)
        .toString()
        .padLeft(2, '0');

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: MyAppBar(Daimons: 122,title: "My App",),
      body:
      ListView(

        children:[
        ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1
           /* Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white//Color.fromRGBO(1,120,186, 1),
                /*
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
             */ ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 26),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Find the best \noutfit for you.',
                          style: TextStyle(
                            color: Colors.pink[200],
                            fontSize: 32,
                            height: 160 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ),*/
        Column(
        children: [
              Container(
                height: 80,
              margin: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    color: Colors.yellow[400]?.withOpacity(0.8),
                ),

                padding: EdgeInsets.symmetric(horizontal: 0),
                child:
                    Center(
                      child: Text(
                        'Find The Best Deal For You.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          height: 160 / 100,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
              ),
            ],
          ),
          SizedBox(height: 20,),
            //slide show
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                height: 300.0,
                width: double.infinity,
                //slide show
                child: Carousel(
                  //showIndicator: false,
                  dotBgColor: Colors.transparent,
                  dotSize: 6.0,
                  dotColor: Colors.pink,
                  dotIncreasedColor: Colors.indigo,

                  images:
                  ad.map((a) {
                    return AdsSlideShow(adsShow: a);
                  }).toList(),
                ),
              ),
            ),
            Divider(
              height: 15,
              color: Colors.black.withOpacity(0.2),

            ),
            Container(

              child: Center(
                child: Text("Search",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,

                ),
                ),
              ),
            ),
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
            // Section 2 - category
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo, //Color.fromRGBO(1,120,186, 1),
              padding: EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View More',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category list
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    height: 96,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categoryData.length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 16);
                      },
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          data: categoryData[index],
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Section 3 - banner
            // Container(
            //   height: 106,
            //   padding: EdgeInsets.symmetric(vertical: 16),
            //   child: ListView.separated(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 3,
            //     separatorBuilder: (context, index) {
            //       return SizedBox(width: 16);
            //     },
            //     itemBuilder: (context, index) {
            //       return Container(
            //         width: 230,
            //         height: 106,
            //         decoration: BoxDecoration(color: AppColor.primarySoft, borderRadius: BorderRadius.circular(15)),
            //       );
            //     },
            //   ),
            // ),

            // Section 4 - Flash Sale


            // Section 5 - product list

            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Todays recommendation...',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  productData.length,
                  (index) => ItemCard(
                    product: productData[index],
                  ),
                ),
              ),
            ),

          ],
        ),
      ]),

    );
  }
}
