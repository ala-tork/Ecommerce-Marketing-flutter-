import 'dart:async';

import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterAllForm.dart';
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

  //filter variable
  String country="All Countrys";
  String category="All Categorys";
  double minprice=0;
  double maxprice=100;
  bool DealsFilter = false;
  bool AnnouncesFilter = false;
  bool ProductsFilter = false;

  //slide show variable
  List ad = [
    AdsModel(title:"ITIWIT",shortDescription:"CANOE KAYAK CONFORTABLE",price:1890,ImagePrinciple : "assets/images/Announces/deals1.png"),
    AdsModel(title:"OLAIAN",shortDescription:"SURFER BOARDSHORT",price:350,ImagePrinciple : "assets/images/Announces/deals2.png"),
    AdsModel(title:"SUBEA",shortDescription:"CHAUSSURES ELASTIQUE ADULTE",price:50,ImagePrinciple :"assets/images/Announces/deals3.png"),
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
        Column(
        children: [
              Container(
                height: 80,
              margin: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    color: Colors.teal[100],
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
          /** slide Show  **/
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
            /** search and filter section **/
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
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
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
                    ),
                    SizedBox(width: 5,),
                    /** filter **/
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return FilterAllForm(category: category,
                                      country: country,
                                      minprice: minprice,
                                      maxprice: maxprice,
                                    Deals: DealsFilter,
                                      Announces: AnnouncesFilter,
                                    Products: ProductsFilter,);
                                  }
                              ).then((value){
                                setState(() {
                                  country = (value as Map)['country'];
                                  category = (value as Map)['category'];
                                  minprice = (value as Map)['minprice'];
                                  maxprice = (value as Map)['maxprice'];
                                  DealsFilter = (value as Map)['Deals'];
                                  AnnouncesFilter = (value as Map)['Announces'];
                                  ProductsFilter = (value as Map)['Products'];

                                });

                              });
                            },
                            icon: Icon(Icons.filter_alt_rounded ,color: Colors.black,size: 30,)
                        ),
                        Text('Filter')
                      ],
                    ),
                  ],
                ),
                /** show filters **/
                country.isNotEmpty&&country !="All Countrys"||category.isNotEmpty&&category !="All Categorys"||minprice!=0||maxprice!=100? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    country.isNotEmpty&&country!="All Countrys"?
                    ElevatedButton(

                      onPressed: () {
                        setState(() {
                          country="All Countrys";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country,
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),
                        ],
                      ),
                    ):SizedBox(height: 0,),
                    category.isNotEmpty&&category!="All Categorys"?
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          category="All Categorys";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            category,
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),

                        ],
                      ),
                    ):SizedBox(height: 0,),

                    minprice!=0?
                    ElevatedButton(

                      onPressed: () {
                        setState(() {
                          minprice=0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            minprice.toStringAsFixed(2),
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),
                        ],
                      ),
                    ):SizedBox(height: 0,),
                    maxprice!=100?
                    ElevatedButton(

                      onPressed: () {
                        setState(() {
                          maxprice=100;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            maxprice.toStringAsFixed(2),
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),
                        ],
                      ),
                    ):SizedBox(height: 0,),
                  ],
                )
                    :SizedBox(height: 0,),
              ],
            ),Column(
              children: [
                DealsFilter||AnnouncesFilter||ProductsFilter? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DealsFilter?
                    ElevatedButton(

                      onPressed: () {
                        setState(() {
                          DealsFilter=false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Deals",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),
                        ],
                      ),
                    ):SizedBox(height: 0,),
                    /** Announce filter box **/
                    AnnouncesFilter?
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AnnouncesFilter=false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            "Announces",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),

                        ],
                      ),
                    ):SizedBox(height: 0,),

                    ProductsFilter?
                    ElevatedButton(

                      onPressed: () {
                        setState(() {
                          ProductsFilter=false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue[100],
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Products",
                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.close,color: Colors.black,),
                        ],
                      ),
                    ):SizedBox(height: 0,)
              ],
            ):SizedBox(height: 0,),
            ]
            ),
            SizedBox(height: 20,),
            //Image.network("https://10.0.2.2:7058/Assets/images/e64b8a5f-a7d6-478b-aaef-e2444b72d894_pc.jpeg"),

            /** end filter and search & show filters section* */

            /** Section 3 - category **/
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


            /** Section 4 - product list **/

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
      ]
      ),

    );
  }
}
