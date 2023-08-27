import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterForm.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/categoryCard.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsViewModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/CategoriesServices/CategoryService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/GridAnnounces.dart';
import '../../../widgets/custom_icon_button_widget.dart';
import '../../messagePage.dart';

class Announces extends StatefulWidget {

  const Announces({super.key});

  @override
  State<Announces> createState() => _AnnouncesState();
}

class _AnnouncesState extends State<Announces> {

// test category
  //List<Category> categoryData = CategoryService.categoryData.cast<Category>();

  String? adsName;

  CountriesModel? country;
  CategoriesModel? category;
  CitiesModel? city;
  double minprice=0;
  double maxprice=0;
  List<AdsView> gridMap = [];
  int MaxPage =0;
  int page=1;
  List<FeaturesValuesModel> featuresvalues = [];
  List<int> featuresvaluesid = [];

/*
  Future<List<AnnounceModel>> apicall() async {
    AdsFilterModel adsFilter = AdsFilterModel(pageNumber: page, idFeaturesValues: []);
    if(adsName!=null){
      adsFilter.adsName=adsName;
    }
    if (country != null) {
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
    if(featuresvaluesid.isNotEmpty){adsFilter.idFeaturesValues=featuresvaluesid;}
    try {
      Map<String, dynamic> response = await AnnounceService().getFilteredAds(adsFilter);

      if (response["ads"] != null) {
        List<dynamic> adsJsonList = response["ads"];
        if (page == 1) {
            gridMap.clear();
            gridMap.addAll(adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        } else {
            gridMap.addAll(adsJsonList.map((json) => AnnounceModel.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }

        return gridMap;
      } else {
        print(response["ads"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }*/

  Future<List<AdsView>> apicall() async {
    await getuserId();
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    AdsFilterModel adsFilter = AdsFilterModel(pageNumber: page, idFeaturesValues: []);
    if(adsName!=null){
      adsFilter.adsName=adsName;
    }
    if (country != null) {
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
    if(featuresvaluesid.isNotEmpty){adsFilter.idFeaturesValues=featuresvaluesid;}
    try {
      print(id);
      print(adsFilter);
      Map<String, dynamic> response = await AdsView().getFilteredViewAds(adsFilter,id!,token!);

      if (response["ads"] != null) {
        List<dynamic> adsJsonList = response["ads"];
        if (page == 1) {
          gridMap.clear();
          gridMap.addAll(adsJsonList.map((json) => AdsView.fromJson(json)).toList());
        } else {
          gridMap.addAll(adsJsonList.map((json) => AdsView.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        print(gridMap);
        return gridMap;
      } else {
        print(response["ads"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  List<CategoriesModel> _categorys=[];
  Future<void> fetchCategory() async {
    try {
      List<CategoriesModel> categories = await CategoryService().GetData();
      _categorys = categories;
      _categorys.removeWhere((element) => element.idCateg==1);
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  //get current user
  int? id ;
  Future<void> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    id = int.parse(decodedToken['id']);
    print("id user is $id");
  }




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
        title: Text("announcements",
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
              onTap: () {
                AwesomeDialog(
                    context: context,
                    dialogBackgroundColor: Colors.indigo,
                    dialogType: DialogType.info,
                    animType: AnimType.topSlide,
                    title:"Diamond",
                    descTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    desc: "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                    btnCancelColor: Colors.grey,
                    btnCancelOnPress:(){},

                    btnOkOnPress: (){}
                ).show();
              },
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
                          ).then((value) {
                            setState(() {
                              adsName = (value as Map)['data'];
                              print(adsName);
                            });
                          } );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        //create a bottom model for the filter form
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return FilterForm(
                              category: category,
                              country: country,
                              city: city,
                              featursValuesSelected: featuresvalues,
                              minprice: minprice,
                              maxprice: maxprice,
                            );
                          },
                        ).then((value) {
                          setState(() {
                            country = (value as Map)['country'];
                            category = (value as Map)['category'];
                            city = (value as Map)['city'];
                            minprice = (value as Map)['minprice'];
                            maxprice = (value as Map)['maxprice'];
                            featuresvalues = (value as Map)['featuresvalues'];
                            featuresvaluesid = (value as Map)['featuresvaluesids'];
                            print(featuresvaluesid);
                            page = 1;
                            gridMap = [];
                          });
                        });
                      },
                      icon: Icon(
                        Icons.filter_alt_rounded,
                        color: AppColor.primary,
                        size: 30,
                      ),
                    ),
                    Text('Filter')
                  ],
                ),

              ],
            ),
            /** Show filters **/

            adsName!=null ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      adsName=null;
                      gridMap=[];
                      page=1;
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
                        adsName!,
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ),
                SizedBox(height: 28,)
              ],
            ):SizedBox(height: 0,),
            country!=null||category!=null||city!=null?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                country!=null?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      //CountriesModel? p;
                      country=null;
                      city=null;
                      gridMap=[];
                      page=1;
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
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ):SizedBox(height: 0,),
                city!=null?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      city=null;
                      gridMap=[];
                      page=1;
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
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),
                    ],
                  ),
                ):SizedBox(height: 0,),
                category!=null?
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      category=null;
                      featuresvaluesid=[];
                      featuresvalues=[];
                      gridMap=[];
                      page=1;
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
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close,color: Colors.black,),

                    ],
                  ),
                ):SizedBox(height: 0,),
              ],
            ):SizedBox(height: 0,),
            minprice>0 || maxprice>0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                minprice!=0?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      minprice=0;
                      gridMap=[];
                      page=1;
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
                maxprice!=0?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      maxprice=0;
                      gridMap=[];
                      page=1;
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
            ):SizedBox(height: 0,),
          /** show filter values*/
            featuresvalues.length>0 ?
            Row(
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
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.close, color: Colors.black),
                    ],
                  ),
                );
              }).toList(),
            ) : SizedBox(height: 0),
            Row(
              children: [
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
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error fetching categories: ${snapshot.error}'),
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
                                      setState(() {
                                        category = selectedCategory;
                                        gridMap=[];
                                        page=1;
                                        featuresvaluesid=[];
                                        featuresvalues=[];
                                      });
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

              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: FutureBuilder<List<AdsView>>(
                future: apicall(),
                builder: (BuildContext context, AsyncSnapshot<List<AdsView>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to fetch Ads with like ');
                  } else {
                    return Column(
                      children: [
                        GridB(
                          data: gridMap,
                         IdUser: id!,
                         /* onRemoveLike: (index) {
                            deleteLike(gridMap[index]!.likeId!, gridMap[index]!.idAds!);
                          },
                          onCreateLike: (index) {
                            addLike(id!,  gridMap[index]!.idAds!) as AnnounceModel?;

                          },*/
                        ),
                        if (gridMap.length != 0 && page < MaxPage)
                          ElevatedButton(
                            onPressed: () async {
                              if (page < MaxPage) {
                                setState(() {
                                  page = page + 1;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            child: Text("Show More"),
                          )
                        else
                          SizedBox(height: 0),
                      ],
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 30,),

          ],
        ),
      ),
      //
    );
  }
}