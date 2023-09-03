import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarForBottomBarViews.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarWithArrowBack.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterFormDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/WinnersSlideSHow.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsView.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WinnerModel/WinnerModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/DealsServices/DealsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/SettingServices/SettingService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WinnerServices/WinnerService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_icon_button_widget.dart';
import '../../messagePage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Deals extends StatefulWidget {
  const Deals({super.key});

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  String? DealsName;
  CountriesModel? country;
  CategoriesModel? category;
  CitiesModel? city;
  BrandsModel? brand;
  double minprice = 0;
  double maxprice = 0;
  List<DealsView> gridMap = [];
  int MaxPage = 0;
  int page = 1;
  List<FeaturesValuesModel> featuresvalues = [];
  List<int> featuresvaluesid = [];

  /** User  */
  int? idUser;
  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

/** Get Deals */
  Future<List<DealsView>> apicall() async {
    await getuserId();
    DealsFilterModel deaslFilter =
        DealsFilterModel(pageNumber: page, idFeaturesValues: []);
    if (DealsName != null) {
      deaslFilter.DealsName = DealsName;
    }
    if (country != null) {
      deaslFilter.idCountrys = country!.idCountrys;
    }
    if (category != null) {
      deaslFilter.idCategory = category!.idCateg;
    }
    if (city != null) {
      deaslFilter.idCity = city!.idCity;
    }
    if (brand != null) {
      deaslFilter.IdBrans = brand!.idBrand;
    }
    if (minprice != 0) {
      deaslFilter.minPrice = minprice;
    }
    if (maxprice != 0) {
      deaslFilter.maxPrice = maxprice;
    }
    if (featuresvaluesid.isNotEmpty) {
      deaslFilter.idFeaturesValues = featuresvaluesid;
    }
    try {
      print(idUser);
      Map<String, dynamic> response =
          await DealsService().getFilteredViewDeals(deaslFilter, idUser!);

      if (response["deals"] != null) {
        List<dynamic> adsJsonList = response["deals"];

        if (page == 1) {
          gridMap.clear();
          gridMap.addAll(
              adsJsonList.map((json) => DealsView.fromJson(json)).toList());
        } else {
          gridMap.addAll(
              adsJsonList.map((json) => DealsView.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        return gridMap;
      } else {
        print(response["deals"]);
        throw Exception('Failed to fetch Deals !!!!!!!!!!');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }
  List<WinnerModel> listWinners = [];
  Future<List<WinnerModel>> GetRandomWinners() async {
    try{
      List <WinnerModel> w = await WinnerService().GetRandomWinners();
      if(w!=null){
        //setState(() {
          listWinners=w;
        //});
      }
      return w;
    }catch (e)
    {
      throw Exception("error fetching Winners : $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarForBottomBarViews(title: AppLocalizations.of(context)!.deals,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.winners,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w800
                  ),)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: FutureBuilder<List<WinnerModel>>(
                future: GetRandomWinners(), // Replace with your function to fetch winners
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Display a loading indicator while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData ){
                    return Text('No winners available.');
                  } else {
                    return SizedBox(
                      height: 150.0,
                      width: double.infinity,
                      child: Carousel(
                        showIndicator: false,
                        images: listWinners.map((a) {
                          return WinnerSlideShow(winner: a);
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),

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
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          )
                              .then((value) {
                            setState(() {
                              DealsName = (value as Map)['data'];
                              print(DealsName);
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          //create a bottom model for the filter form
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25)),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FilterFormDeals(
                                  category: category,
                                  country: country,
                                  city: city,
                                  brand: brand,
                                  featursValuesSelected: featuresvalues,
                                  minprice: minprice,
                                  maxprice: maxprice,
                                );
                              }).then((value) {
                            setState(() {
                              country = (value as Map)['country'];
                              category = (value as Map)['category'];
                              city = (value as Map)['city'];
                              brand = (value as Map)['brand'];
                              print(brand);
                              minprice = (value as Map)['minprice'];
                              maxprice = (value as Map)['maxprice'];
                              featuresvalues = (value as Map)['featuresvalues'];
                              featuresvaluesid =
                                  (value as Map)['featuresvaluesids'];
                              print(featuresvaluesid);
                              page = 1;
                              gridMap = [];
                            });
                          });
                        },
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: Colors.indigo,
                          size: 30,
                        )),
                    Text(AppLocalizations.of(context)!.filter)
                  ],
                ),
              ],
            ),
            /** Show filters **/
            DealsName != null || brand != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DealsName != null
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  DealsName = null;
                                  gridMap = [];
                                  page = 1;
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
                                    DealsName!,
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
                      brand != null
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  brand = null;
                                  gridMap = [];
                                  page = 1;
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
                                    brand!.title!,
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
                      SizedBox(
                        height: 28,
                      )
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),
            country != null || category != null || city != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      country != null
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  //CountriesModel? p;
                                  country = null;
                                  city = null;
                                  gridMap = [];
                                  page = 1;
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
                                    country!.title.toString(),
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
                      city != null
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  city = null;
                                  gridMap = [];
                                  page = 1;
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
                                    city!.title.toString(),
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
                      category != null
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  category = null;
                                  featuresvaluesid = [];
                                  featuresvalues = [];
                                  gridMap = [];
                                  page = 1;
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
                                    category!.title.toString(),
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
            minprice > 0 || maxprice > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      minprice != 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  minprice = 0;
                                  gridMap = [];
                                  page = 1;
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
                      maxprice != 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  maxprice = 0;
                                  gridMap = [];
                                  page = 1;
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
            /** show filter values*/
            featuresvalues.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: featuresvalues.map((e) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            featuresvalues.remove(e);
                            featuresvaluesid.remove(e.idFv);
                            gridMap = [];
                            page = 1;
                          });
                          // apicall();
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
                              e.title!,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.close, color: Colors.black),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: FutureBuilder<List<DealsView>>(
                future: apicall(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DealsView>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to fetch data');
                  } else {
                    return Column(
                      children: [
                        GridDeals(
                          data: gridMap,
                          IdUser: idUser!,
                        ),
                        gridMap.length != 0 && page < MaxPage
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (page < MaxPage) {
                                    setState(() {
                                      page = page + 1;
                                    });
                                  }
                                },
                                child: Text("Show More"),
                              )
                            : SizedBox(height: 0),
                      ],
                    );
                    //
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      //
    );
  }
}
