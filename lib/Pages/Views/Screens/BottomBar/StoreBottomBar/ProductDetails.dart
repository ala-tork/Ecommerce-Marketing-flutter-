import 'dart:ffi';

import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/BottomBar/DealsBotomBar/DealsCard.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/SellerDetail.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/DealsGiftPopUp.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/curstom_app_bar.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsFilterModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/Product.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/DealsServices/DealsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductServices/ProductService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/ImageViewer.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/modals/add_to_cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final int id;

  ProductDetails({required this.id});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
/*  Product prod =   Product(
    idProd: 1,
    codeBar: '123456789',
    codeProduct: 'ABC123',
    reference: 'REF001',
    title: 'Product A',
    description: 'This is product A',
    details: 'Detailed information about product A',
    datePublication: '2023-08-31',
    qte: 50,
    color: 'Red',
    unity: 'Piece',
    tax: 10,
    price: 120,
    idPricesDelevery: 1,
    discount: 5,
    imagePrincipale: 'product_a.jpg',
    videoName: 'product_a_video.mp4',
    idPrize: 36,
    idCateg: 8,
    idUser: 1003,
    idMagasin: 2,
    idBrand: 2,
    idCountry: 6,
    idCity: 1,
    idBoost: 1,
    active: 1,
  );*/
  Product? prod;
  PageController productImageSlider = PageController();
  List<ImageModel> _images = [];
  List<String> _urlImages = [];
  List<AdsFeature> _adsFeatures = [];
  double? pricewithdiscount;

  /** User  */
  User? user;

  Future<User> GetUser(int id) async {
    user = await UserService().GetUserByID(id!);
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

  @override
  void initState() {
    super.initState();
    GetProduct(widget.id!).then((value) {
      setState(() {
        prod = value;
        pricewithdiscount = (prod!.price! - ((prod!.discount! * prod!.price!) / 100));
      });
      GetUser(value.idUser!).then((u) {
        setState(() {
          user = u;
        });
      });
      fetchAdsFeaturesByIdProd(prod!.idProd!);
      fetchImages(prod!.idProd!);
    });
  }

  /** Get User */

  Future<Map<String, dynamic>> fetchUserData(int idUser) async {
    final apiUrl = 'https://10.0.2.2:7058/User/GetUserById?id=${idUser}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /** fetch Images */
  Future<void> fetchImages(int idProd) async {
    try {
      List<ImageModel> images = await ImageService().getProductImage(idProd);
      //setState(() {
      _images = images;
      _urlImages.addAll(_images.map((image) => image.title!));
      // });
      print(_images);
    } catch (e) {
      print('Error fetching Images: $e');
    }
  }

  /** fetch Prod features and change the features and the features values */
  Future<void> fetchAdsFeaturesByIdProd(int idProd) async {
    try {
      List<AdsFeature> adsFeatures = await AdsFeaturesService().GetProductFeaturesByIdDeals(idProd);
      setState(() {
        _adsFeatures = adsFeatures;
      });
      print(_adsFeatures);
    } catch (e) {
      print('Error fetching AdsFeatures: $e');
    }
  }

 // List<DealsModel> similar = [];
/*
  /** Get similar Announce */

  Future<List<DealsModel>> GetSimilar(DealsModel an, int page) async {
    DealsFilterModel deaslFilter =
        DealsFilterModel(pageNumber: page, idFeaturesValues: []);
    if (an.idCountrys != null) {
      deaslFilter.idCountrys = an.idCountrys;
    }
    if (an.idCateg != null) {
      deaslFilter.idCategory = an.idCateg;
    }
    try {
      Map<String, dynamic> response =
          await DealsService().getFilteredDeals(deaslFilter);

      if (response["deals"] != null) {
        List<dynamic> adsJsonList = response["deals"];
        if (page == 1) {
          similar.clear();
          similar.addAll(
              adsJsonList.map((json) => DealsModel.fromJson(json)).toList());
        }
        return similar;
      } else {
        print(response["deals"]);
        throw Exception('Failed to fetch similar Deals !!!!!!!!!!');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }*/

  /**  Get Deal By id  */
  Future<Product> GetProduct(int idProd) async {
    try {
      Product p = await ProductService().getProductById(idProd);
      return p;
    } catch (e) {
      print('Error fetching Product By Id: $e');
      throw throw Exception('Error fetching Product By Id');
    }
  }

  @override
  Widget build(BuildContext context) {
    //DealsModel deal = deals!;

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColor.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                margin: EdgeInsets.only(right: 14),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: SvgPicture.asset('assets/icons/Chat.svg',
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return AddToCartModal();
                        },
                      );
                    },
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<Product>(
          future: GetProduct(widget!.id!),
          builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Failed to fetch data');
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // appbar
                        Expanded(
                          child: CustomAppBar(
                            title: '${prod!.title}',
                            leftIcon:
                                SvgPicture.asset('assets/icons/Arrow-left.svg'),
                            rightIcon: SvgPicture.asset(
                              'assets/icons/Bookmark.svg',
                              color: Colors.black.withOpacity(0.5),
                            ),
                            leftOnTap: () {
                              Navigator.of(context).pop();
                            },
                            rightOnTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        // Section 1 -  product image
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                                prod!.imagePrincipale!.isNotEmpty?
                                   Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // product image
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ImageViewer(
                                                imageUrl: _urlImages,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 310,
                                          color: Colors.white,
                                          child: PageView(
                                            physics: BouncingScrollPhysics(),
                                            controller: productImageSlider,
                                            children: _images
                                                .map(
                                                  (image) => Image.network(
                                                    ApiPaths().ImagePath +
                                                        image.title!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :Text('No data available'),
                                //}
                              /*}
                            },
                          ),*/
                        ),

                        // Section 2 - AppBar
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        prod!.title!,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'poppins',
                                            color: AppColor.secondary),
                                      ),
                                    ),
                                    if (prod!.idPrize != null)
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DealsGiftPopUp(
                                                IdPrize: prod!.idPrize,
                                              );
                                            },
                                          );
                                        }
                                        /* onTap: () {

                                              DealsGiftPopUp().showDialogFunc(
                                                  context, deals[index]!.dateEND!);
                                            }*/
                                        ,
                                        child: Image.asset(
                                          "assets/prize.webp",
                                          height: 40,
                                          width: 40,
                                        ),
                                      )
                                    /*RatingTag(
                              value: product.rating,
                            ),*/
                                  ],
                                ),
                              ),
                              // Section 3 - product info
                              Container(
                                margin: EdgeInsets.only(bottom: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (prod!.discount! > 0)
                                          Text(
                                            "$pricewithdiscount DT",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        SizedBox(width: 8),
                                        if (prod!.discount! > 0)
                                          Text(
                                            '${prod!.price} DT',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if (prod!.discount! > 0)
                                          Text(
                                            '(${prod!.discount}% off)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                            ),
                                          ),
                                        if (prod!.discount! == null)
                                          Text(
                                            "${prod!.price} DT",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                              color: Colors.indigo,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'quantity : ${prod!.qte}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "Location",
                                          //'${prod!.locations}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //announcer info
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            TextButton(
                                              child: Text(
                                                "${user!.firstname} ${user!.lastname}",
                                                style: TextStyle(
                                                  color: AppColor.secondary
                                                      .withOpacity(1),
                                                  height: 150 / 100,
                                                ),
                                              ),
                                              onPressed: () {
                                                SellerDetailsPopUp()
                                                    .showDialogFunc(
                                                        context,
                                                    user!
                                                );
                                              },
                                            ),
                                            RatingBar.builder(
                                              initialRating: 3.5,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                              ignoreGestures: true,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage: AssetImage(
                                              "assets/Torkhani_Ala.jpg"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Features Table
                        if(_adsFeatures.isNotEmpty)
                        DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Characteristic',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Value',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: _adsFeatures.map((characteristic) {
                            return DataRow(
                              cells: [
                                DataCell(Text(characteristic.features!.title!)),
                                DataCell(Text(
                                    characteristic.featuresValues!.title!)),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        /** Similar */
                     /*   FutureBuilder<List<DealsModel>>(
                          future: GetSimilar(deals!, 1),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DealsModel>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Display a loading indicator while waiting for data
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Failed to fetch Similar');
                            } else {
                              similar.removeWhere(
                                  (e) => e.idDeal == deals!.idDeal);
                              return Row(
                                children: [
                                  /** similar list  **/
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.primarySoft,
                                    //Color.fromRGBO(1,120,186, 1),
                                    padding:
                                        EdgeInsets.only(top: 12, bottom: 24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Similar',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Category list
                                        Container(
                                          margin: EdgeInsets.only(top: 12),
                                          height: 340,
                                          //width:100,
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            itemCount: similar.length,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) {
                                              return SizedBox(width: 16);
                                            },
                                            itemBuilder: (context, index) {
                                              return DealsCard(
                                                data: similar[index],
                                                //onTap: () {},
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),*/
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        )
    );

  }
}
