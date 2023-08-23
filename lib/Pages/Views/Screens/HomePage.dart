import 'dart:async';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/BostedSlider.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterAllForm.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/ads_slide_show.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/categoryCard.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/item_card.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/rulePopup.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/side_bar.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BostSlideShowModels/BoostSlideShowModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Category.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Product.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/BoostedSlideShowServices/BoostedSlideShowService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // List<Category> categoryData = CategoryService.categoryData.cast<Category>();
  List<Product> productData = ProductService.productData;

  //filter variable
  String country = "All Countrys";
  String category = "All Categorys";
  double minprice = 0;
  double maxprice = 100;
  bool DealsFilter = false;
  bool AnnouncesFilter = false;
  bool ProductsFilter = false;

  //slide show variable
  int page = 1;
  int MaxPage = 0;
  List<AnnounceModel> adsSildeShow = [];

  Future<List<AnnounceModel>> GetAnnounces() async {
    AdsFilterModel adsFilter =
        AdsFilterModel(pageNumber: page, idFeaturesValues: []);
    /*if (country != null) {
      adsFilter.idCountrys = country!.idCountrys;
    }
    if (category != null) {
      adsFilter.idCategory = category!.idCateg;
    }
    if (city != null) {
      adsFilter.idCity = city!.idCity;
    }
    if(minprice!=0)
    {
      adsFilter.minPrice=minprice;
    }
    if(maxprice!=0){ adsFilter.maxPrice=maxprice;}
    if(featuresvaluesid.isNotEmpty){adsFilter.idFeaturesValues=featuresvaluesid;}*/
    try {
      Map<String, dynamic> response =
          await AnnounceService().getFilteredAds(adsFilter);

      if (response["ads"] != null) {
        List<dynamic> adsJsonList = response["ads"];
        if (page == 1) {
          adsSildeShow.clear();
          adsSildeShow.addAll(
              adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        } else {
          adsSildeShow.addAll(
              adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }

        return adsSildeShow;
      } else {
        print(response["ads"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  /** get Bossted  deals & announcements */
  List<BoostSlideShowModel> listbosted = [];

  Future<List<BoostSlideShowModel>> GetBoostedAds_Deals() async {
    //BoostSlideShowModel boosted = BoostSlideShowModel();
    try {
      listbosted = await BoostedSlideShowService().getBoostSlideShow();
      return listbosted;
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  /** GetRandom Deals And nnounces */
  List<BoostSlideShowModel> listRandom = [];

  Future<List<BoostSlideShowModel>> GetRandom() async {

    try {
      listRandom = await BoostedSlideShowService().getrandomSlideShow();
      return listRandom;
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  List<CategoriesModel> _categorys = [];

  Future<void> fetchCategory() async {
    try {
      List<CategoriesModel> categories = await CategoryService().GetData();
      _categorys = categories;
      _categorys.removeWhere((element) => element.idCateg == 1);
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    GetAnnounces();
    GetBoostedAds_Deals();

    _showBoostedSlideDialogOnFirstLaunch();
    _showRulesOnFirstTimeOpenApp();
    //startTimer();
  }

  Future<void> _showBoostedSlideDialogOnFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dialogShownBefore = prefs.getBool('boostedSlideDialogShown') ?? false;

    if (!dialogShownBefore) {
      await GetBoostedAds_Deals();
      BoostedSlide().showDialogFunc(context, listbosted);
      prefs.setBool('boostedSlideDialogShown', true);
    }
  }

  /** show dialog rules */
  Future<void> _showRulesOnFirstTimeOpenApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dialogShownBefore = prefs.getBool('Rules') ?? false;

    if (!dialogShownBefore) {
      await GetBoostedAds_Deals();
      showRulesDialog(context);
      prefs.setBool('Rules', true);
    }
  }

  void showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RulesPopup(),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: MyAppBar(
        Daimons: 122,
        title: "My App",
      ),
      body: ListView(children: [
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
                  child: Center(
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
            SizedBox(
              height: 20,
            ),
            //slide show
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                height: 300.0,
                width: double.infinity,
                //slide show
                child: FutureBuilder<List<BoostSlideShowModel>>(
                  future: GetRandom(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading Announce for slide show.'),
                      );
                    } else {
                      //List<AnnounceModel> adsSildeShow = snapshot.data ?? [];
                      return Carousel(
                        dotBgColor: Colors.transparent,
                        dotSize: 6.0,
                        dotColor: Colors.pink,
                        dotIncreasedColor: Colors.indigo,
                        images: listRandom.map((a) {
                          return AdsSlideShow(ads_deals: a);
                        }).toList(),
                      );
                    }
                  },
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
                child: Text(
                  "Search",
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
                        child: Padding(
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
                    SizedBox(
                      width: 5,
                    ),
                    /** filter **/
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return FilterAllForm(
                                      category: category,
                                      country: country,
                                      minprice: minprice,
                                      maxprice: maxprice,
                                      Deals: DealsFilter,
                                      Announces: AnnouncesFilter,
                                      Products: ProductsFilter,
                                    );
                                  }).then((value) {
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
                            icon: Icon(
                              Icons.filter_alt_rounded,
                              color: Colors.black,
                              size: 30,
                            )),
                        Text('Filter')
                      ],
                    ),
                  ],
                ),
                /** show filters **/
                country.isNotEmpty && country != "All Countrys" ||
                        category.isNotEmpty && category != "All Categorys" ||
                        minprice != 0 ||
                        maxprice != 100
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          country.isNotEmpty && country != "All Countrys"
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      country = "All Countrys";
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
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          category.isNotEmpty && category != "All Categorys"
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      category = "All Categorys";
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
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          minprice != 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      minprice = 0;
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
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          maxprice != 100
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      maxprice = 100;
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
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ],
            ),
            Column(children: [
              DealsFilter || AnnouncesFilter || ProductsFilter
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DealsFilter
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    DealsFilter = false;
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        /** Announce filter box **/
                        AnnouncesFilter
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    AnnouncesFilter = false;
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        ProductsFilter
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    ProductsFilter = false;
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              )
                      ],
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ]),
            SizedBox(
              height: 20,
            ),

            /** end filter and search & show filters section* */

            /** Section 3 - category **/
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo,
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category list
                  FutureBuilder<void>(
                    future: fetchCategory(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Error fetching categories: ${snapshot.error}'),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 12),
                          height: 96,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _categorys.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 16);
                            },
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                data: _categorys[index],
                                onTap: (selectedCategory) {
                                  //TODO
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
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
      ]),
    );
  }
}
