import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterForm.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/GridAnnounces.dart';
import '../../../widgets/custom_icon_button_widget.dart';
import '../../messagePage.dart';

class Deals extends StatefulWidget {

  const Deals({super.key});

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {

  CountriesModel? country;
  CategoriesModel? category;
  CitiesModel? city;
  double minprice=0;
  double maxprice=0;
  List<DealsModel> gridMap = [];
  int MaxPage =0;
  int page=1;




  Future<List<DealsModel>> apicall() async {
    DealsFilterModel DelasFilter = DealsFilterModel(pageNumber: page, idFeaturesValues: []);
    if (country != null) {
      DelasFilter.idCountrys = country!.idCountrys;
    }
    if (category != null) {
      DelasFilter.idCategory = category!.idCateg;
    }
    if (city != null) {
      DelasFilter.idCity = city!.idCity;
    }
    if(minprice!=0 || maxprice!=0)
    {
      DelasFilter.minPrice=minprice;
      DelasFilter.maxPrice=maxprice;
    }
    try {
      Map<String, dynamic> response = await DelasFilter.getFilteredDeals(DelasFilter);

      if (response["deals"] != null) {
        List<dynamic> adsJsonList = response["deals"];

        if (page == 1) {

          gridMap.clear();
          gridMap.addAll(adsJsonList.map((json) => DealsModel.fromJson(json)).toList());
        } else {
          gridMap.addAll(adsJsonList.map((json) => DealsModel.fromJson(json)).toList());
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
                          );
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
                                    top: Radius.circular(25)
                                ),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FilterForm(category: category,country: country,minprice: minprice,maxprice: maxprice,);
                              }
                          ).then((value){
                            setState(() {
                              country = (value as Map)['country'];
                              category = (value as Map)['category'];
                              city = (value as Map)['city'];
                              minprice = (value as Map)['minprice'];
                              maxprice = (value as Map)['maxprice'];
                              gridMap=[];
                            });

                          });
                        },
                        icon: Icon(Icons.filter_alt_rounded ,color: Colors.lightBlue,size: 30,)
                    ),
                    Text('Filter')
                  ],
                ),
              ],
            ),
            /** Show filters **/
            country!=null||category!=null||city!=null||minprice!=0||maxprice!=100? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                country!=null?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      CountriesModel? p;
                      country=p;
                      gridMap=[];
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
                      gridMap=[];
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

                minprice!=0?
                ElevatedButton(

                  onPressed: () {
                    setState(() {
                      minprice=0;
                      gridMap=[];
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: FutureBuilder<List<DealsModel>>(
                future: apicall(),
                builder: (BuildContext context, AsyncSnapshot<List<DealsModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to fetch data');
                  } else {
                    return
                      Column(
                        children: [
                          GridDeals(data: gridMap),
                          gridMap.length != 0 && page<MaxPage?
                          ElevatedButton(
                            onPressed: () async {
                              if (page < MaxPage) {
                                setState(() {
                                  page = page + 1;
                                });
                              }
                            },
                            child: Text("Show More"),
                          )
                              :
                          SizedBox(height: 0),
                        ],
                      );
                    //
                  }
                },
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
      //
    );
  }
}