import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/AppBarWithArrowBack.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridAnnounces.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridProduct.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/MyAppCard.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AdsViewModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsView.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/ProductFilter.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/ProductView.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AnnouncesServices/AnnounceService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/DealsServices/DealsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductServices/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerMoreDetails extends StatefulWidget {
  final User user;

  const SellerMoreDetails({Key? key, required this.user}) : super(key: key);

  @override
  State<SellerMoreDetails> createState() => _SellerMoreDetailsState();
}

class _SellerMoreDetailsState extends State<SellerMoreDetails> {
  List<Map<String, dynamic>> _categorys = [
    {"id": 1, "title": "Announces", "image": ""},
    {"id": 2, "title": "Deals", "image": ""},
    {"id": 3, "title": "Product", "image": ""}
  ];
  int category=1;
  int MaxPage =0;
  int page=1;
  /**        Announces User         */
  List<AdsView> gridMap = [];

  Future<List<AdsView>> apicall() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    AdsFilterModel adsFilter = AdsFilterModel(pageNumber: page, idFeaturesValues: []);
    try {
      print(adsFilter);
      Map<String, dynamic> response = await AnnounceService().getadsByUser(adsFilter,widget.user.id!);
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

  /** Get Deals */
  List<DealsView> DealsList=[];
  Future<List<DealsView>> getUserDeals() async {
    DealsFilterModel deaslFilter = DealsFilterModel(pageNumber: page, idFeaturesValues: []);
    try {
      Map<String, dynamic> response = await DealsService().getUserDeals(deaslFilter, widget.user.id!);

      if (response["deals"] != null) {
        List<dynamic> adsJsonList = response["deals"];

        if (page == 1) {
          DealsList.clear();
          DealsList.addAll(adsJsonList.map((json) => DealsView.fromJson(json)).toList());
        } else {
          DealsList.addAll(adsJsonList.map((json) => DealsView.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        return DealsList;
      } else {
        print(response["deals"]);
        throw Exception('Failed to fetch Deals !!!!!!!!!!');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  /** Get Products User */
  List<ProductView> ProdList=[];
  Future<List<ProductView>> getProductByUser() async {
    FilterProduct prodFilter = FilterProduct(pageNumber: page, idFeaturesValues: []);
    try {
      Map<String, dynamic> response = await ProductService().getUserProduc(prodFilter, widget.user.id!);

      if (response["products"] != null) {
        List<dynamic> prodJsonList = response["products"];
        if (page == 1) {
          ProdList.clear();
          ProdList.addAll(prodJsonList.map((json) => ProductView.fromJson(json)).toList());
        } else {
          ProdList.addAll(prodJsonList.map((json) => ProductView.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        return ProdList;
      } else {
        print(response["products"]);
        throw Exception('Failed to fetch products !!!!!!!!!!');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrowBack(title: "Seller Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120, // Reduce image size
                width: 120, // Reduce image size
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Make it circular
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.user.imageUrl != null
                      ? Image.network(
                    "${ApiPaths().UserImagePath}${widget.user.imageUrl}",
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    "assets/user.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "${widget.user.firstname}  ${widget.user.lastname}",
                style: TextStyle(
                  fontSize: 24, // Adjust font size
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconWithLabel(
                    icon: Icons.verified,
                    label: "Verified",
                    color: Colors.blue,
                    isVisible: widget.user.isverified == 1,
                  ),
                  IconWithLabel(
                    icon: Icons.star,
                    label: "Premium",
                    color: Colors.greenAccent,
                    isVisible: widget.user.isPremium == 1,
                  ),
                  IconWithLabel(
                    icon: Icons.local_activity,
                    label: "Pro",
                    color: Colors.orange,
                    isVisible: widget.user.isPro == 1,
                  ),
                ],
              ),
              SizedBox(height: 10),
              UserInfoRow(
                icon: Icons.email,
                label: "${widget.user.email}",
              ),
              UserInfoRow(
                icon: Icons.phone,
                label: "${widget.user.phone}",
              ),
/*              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Response Time: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "between 1 and 2 hours",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Quality of Service: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "medium",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delivery Time: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "between 1 and 2 days",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),*/
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3.5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
                ignoreGestures: true,
              ),
              Container(
                width: double.infinity,
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
                            'Select a  Type',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                          return MyAppCard(
                            data: _categorys[index],
                            onTap: (selectedCategory) {
                              setState(() {
                                category = selectedCategory;
                                print(category);
                                //gridMap=[];
                                page = 1;
                                //featuresvaluesid=[];
                                //featuresvalues=[];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(category==1)
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
                            IdUser: widget.user.id!,
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
              if(category==2)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                child: FutureBuilder<List<DealsView>>(
                  future: getUserDeals(),
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
                            data: DealsList,
                            IdUser: widget.user.id!,
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
              ),
              if(category==3)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                child: FutureBuilder<List<ProductView>>(
                  future: getProductByUser(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProductView>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Failed to fetch data');
                    } else {
                      return Column(
                        children: [
                          GridProduct(
                            data: ProdList,
                            IdUser: widget.user.id!,
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
      ),
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isVisible;

  const IconWithLabel({
    required this.icon,
    required this.label,
    required this.color,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    )
        : SizedBox.shrink();
  }
}

class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const UserInfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}




