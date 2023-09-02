import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/messagePage.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/searchPage.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/FilterFormProduct.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/GridProduct.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/WinnersSlideSHow.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/custom_icon_button_widget.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/dummy_search_widget1.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BrandsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CategoriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CitiesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/CountriesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/FeaturesValuesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/ProductFilter.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/ProductView.dart';
import 'package:ecommerceversiontwo/Pages/core/model/WinnerModel/WinnerModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductServices/ProductService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/WinnerServices/WinnerService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {

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
  String? ProdName;
  CountriesModel? country;
  CategoriesModel? category;
  CitiesModel? city;
  BrandsModel? brand;
  String? codeBar;
  String? codeProd;
  String? reference;
  double minprice = 0;
  double maxprice = 0;
  List<ProductView> gridMap = [];
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

  /** Get Products  */
  Future<List<ProductView>> apicall() async {
    await getuserId();
    FilterProduct prodFilter = FilterProduct(pageNumber: page, idFeaturesValues: []);
    if (ProdName != null) {
      prodFilter.productName = ProdName;
    }
    if(codeBar!=null){
      prodFilter.codeBar=codeBar;
    }
    if(codeProd!=null){
      prodFilter.codeProd=codeProd;
    }
    if(reference!=null){
      prodFilter.reference=reference;
    }
    if (country != null) {
      prodFilter.idCountrys = country!.idCountrys;
    }
    if (category != null) {
      prodFilter.idCategory = category!.idCateg;
    }
    if (city != null) {
      prodFilter.idCity = city!.idCity;
    }
    if (brand != null) {
      prodFilter.idBrand = brand!.idBrand;
    }
    if (minprice != 0) {
      prodFilter.minPrice = minprice;
    }
    if (maxprice != 0) {
      prodFilter.maxPrice = maxprice;
    }
    if (featuresvaluesid.isNotEmpty) {
      prodFilter.idFeaturesValues = featuresvaluesid;
    }
    try {
      print(idUser);
      Map<String, dynamic> response = await ProductService().getFilteredViewProduct(prodFilter, idUser!);

      if (response["products"] != null) {
        List<dynamic> prodJsonList = response["products"];
        if (page == 1) {
          gridMap.clear();
          gridMap.addAll(prodJsonList.map((json) => ProductView.fromJson(json)).toList());
        } else {
          gridMap.addAll(prodJsonList.map((json) => ProductView.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["totalItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        return gridMap;
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushNamed("LandingPage");
          },
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Text(
          AppLocalizations.of(context)!.deals,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
            child: CustomIconButtonWidget(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MessagePage()));
              },
              value: 2,
              icon: Icon(
                Icons.mark_unread_chat_alt_outlined,
                color: Colors.white,
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
                    title: "Diamond",
                    descTextStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    desc:
                    "Hello, welcome to ADS & Deals.\n \n What are diamonds?!\n Diamonds are the currency within our application.\n With diamonds, you can add your products to the application and enhance their visibility. If you would like to refill your wallet and purchase diamonds, please click OK",
                    btnCancelColor: Colors.grey,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {})
                    .show();
              },
              value: 122,
              icon: Icon(
                Icons.diamond_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
                              ProdName = (value as Map)['data'];
                              print(ProdName);
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
                                return FilterFormProduct(
                                  category: category,
                                  country: country,
                                  city: city,
                                  brand: brand,
                                  featursValuesSelected: featuresvalues,
                                  minprice: minprice,
                                  maxprice: maxprice,
                                  codeBar: codeBar,
                                  codeProd: codeProd,
                                  reference: reference,
                                );
                              }).then((value) {
                            setState(() {
                              country = (value as Map)['country'];
                              category = (value as Map)['category'];
                              city = (value as Map)['city'];
                              brand = (value as Map)['brand'];
                              minprice = (value as Map)['minprice'];
                              maxprice = (value as Map)['maxprice'];
                              featuresvalues = (value as Map)['featuresvalues'];
                              featuresvaluesid = (value as Map)['featuresvaluesids'];
                              codeProd = (value as Map)['codeProd'];
                              codeBar = (value as Map)['codeBar'];
                              reference = (value as Map)['reference'];
                              //page = 1;
                              // gridMap = [];
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
            ProdName != null || brand != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProdName != null
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ProdName = null;
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
                      SizedBox(
                        width:100,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ProdName!,
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
            /** Codes values */
            (codeBar != null && codeBar!.isNotEmpty) ||
                (codeProd != null && codeProd!.isNotEmpty) ||
                (reference!=null && reference!.isNotEmpty)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                codeBar != null && codeBar!.isNotEmpty
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      codeBar = null;
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          codeBar!,
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
                (codeProd != null && codeProd!.isNotEmpty)
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      codeProd = null;
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          codeProd!,
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
                (reference!=null && reference!.isNotEmpty)
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      reference = null;
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          reference!,
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          category!.title.toString(),
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minprice.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
                      SizedBox(
                        width:70,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          maxprice.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
              child: FutureBuilder<List<ProductView>>(
                future: apicall(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProductView>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to fetch data');
                  } else {
                    return
                      Column(
                      children: [
                        GridProduct(
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

