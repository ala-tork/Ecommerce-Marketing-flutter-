import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/CrudProduct/AddProduct.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/BoostFormPopUp.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/DealsGiftPopUp.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/CreateProduct.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ProductModels/Product.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/PrizeServices/PrizeService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ProductServices/ProductService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/SettingServices/SettingService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  /*List<Product> products = [
    Product(
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
    ),
  ];*/
  List<Product> products =[];
  int MaxPage = 0;
  int page = 0;

  /** User  */
  User? user;
  int? idUser;
  int? nbDiamonProduct;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

  Future<User> GetUser(int id) async {
    user = await UserService().GetUserByID(id);
    if (user != null) {
      return user!;
    } else {
      throw Exception("user Not Found !");
    }
  }

//get all Product by user
  Future<List<Product>> GetAllProduct(int iduser) async {
    try {
      int pagesize=4;
      Map<String, dynamic> response = await ProductService().GetProductByUser(iduser, page,pagesize);
      if (response["listProducts"] != null) {
        List<dynamic> adsJsonList = response["listProducts"];
        if (page == 0) {
          products.clear();
          products.addAll(
              adsJsonList.map((json) => Product.fromJson(json)).toList());
        } else {
          products.addAll(
              adsJsonList.map((json) => Product.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["nbItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        print("nbPages $MaxPage");
        print("Page $page");
        return products;
      } else {
        print(response["items"]);
        throw Exception('Failed to fetch Product here ');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  //delete Deal
 void deleteItem(int id, int? idPrize) async {
    bool imgdel = await ImageService().deleteProductImage(id);
    bool Af = await AdsFeaturesService().deletePeoductAdsFeatures(id);

    if (imgdel && Af) {
      bool isDeleted = await ProductService().deleteData(id);
      if (idPrize != null) {
        bool imgPrize = await ImageService().deletePrizeImage(idPrize);
        bool prize = await PrizeService().deleteDealsPrize(idPrize);
      }

      if (isDeleted) {
        print("Item with ID $id deleted successfully.");
        products.removeWhere((element) => element.idProd == id);
        setState(() {
          products;
        });
      } else {
        print("Failed to delete item with ID $id.");
      }
    }
  }

  Future<Product> AddBost(
      Product prod, int idBoost, int ProdIndex) async {
    try {
      CreateProduct updateProd = CreateProduct(
        codeBar: prod.codeBar,
        codeProduct: prod.codeProduct,
        reference: prod.reference,
        title: prod.title,
        description: prod.description,
        details: prod.details,
        datePublication: prod.datePublication,
        qte: prod.qte,
        color: prod.color,
        unity: prod.unity,
        tax: prod.tax,
        price: prod.price,
        idPricesDelevery: prod.idPricesDelevery,
        discount: prod.discount,
        imagePrincipale: prod.imagePrincipale,
        videoName: prod.videoName,
        idMagasin: prod.idMagasin,
        idCateg: prod.idCateg,
        idUser: prod.idUser,
        idCountry: prod.idCountry,
        idCity: prod.idCity,
        idBrand: prod.idBrand,
        idPrize: prod.idPrize,
        idBoost: prod.idBoost,
        active: 0,
      );

      Product? response = await ProductService().updateProduct(prod.idProd!, updateProd);
      setState(() {
        products[ProdIndex] = response!;
      });
      // print(announces[AnnounceIndex].IdBoost);
      return response!;
    } catch (e) {
      throw Exception("faild to Boost Product : $e");
    }
  }

  @override
  void initState() {
    super.initState();

    getuserId().then((value) async {
      GetAllProduct(idUser!).then((data) {
        setState(() {
          products= data;
        });
        //print(products[1].price);
      });
      await GetUser(value);
      setState(() async {
        nbDiamonProduct = await SettingService().getNbDiamondProduct();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[100],
        onPressed: () {
      if (nbDiamonProduct! <= user!.nbDiamon!) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddProduct(newUserdiamond: user!.nbDiamon! - nbDiamonProduct!,)))
            .then((value) async {
          await getuserId().then((userid) async {
            List<Product> res = await GetAllProduct(userid);
            setState(() {
              products = res;
              user!.nbDiamon= user!.nbDiamon! - nbDiamonProduct!;
            });
          });
        });
      }else {
        AwesomeDialog(
            context: context,
            dialogBackgroundColor: Colors.teal[100],
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            title: "Error !",
            descTextStyle:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            desc: "You don't have enough diamonds.",
            btnCancelColor: Colors.grey,
            btnCancelOnPress: () {},
            btnOkOnPress: () {})
            .show();
      }
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.product,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 8.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                    var pricewithdiscount = products[index].price! -
                        ((products[index].discount! * products[index].price!) / 100);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 12),
                        child: Card(
                          color: Colors.white,
                          borderOnForeground: true,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: products[index].idBoost != null ? 5 : 0,
                              color: products[index].idBoost != null
                                  ? Colors.blue
                                  : Colors.black.withOpacity(0.20),
                              //color: Colors.black.withOpacity(0.20),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (products[index].idBoost != null)
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'This Product is Boosted',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 0 -
                                      0 -
                                      0,
                                  height:
                                      MediaQuery.of(context).size.width / 2 -
                                          0 -
                                          6,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            ApiPaths().ImagePath +
                                                products[index].imagePrincipale!),
                                        fit: BoxFit.cover),
                                  ),
                                  child: /** Discount band */
                                  products[index].discount! > 0
                                          ? Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      17)),
                                                    ),
                                                    child: Text(
                                                      '${products[index].discount}% OFF',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 0,
                                            ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${products[index].title}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          if (products[index]!.idPrize != null)
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DealsGiftPopUp(
                                                      IdPrize:
                                                      products[index].idPrize,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/prize.webp",
                                                height: 40,
                                                width: 40,
                                              ),
                                            )
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 2, bottom: 8),
                                        child: Row(
                                          children: [
                                            if (products[index].discount! > 0)
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
                                            if (products[index].discount! > 0)
                                              Text(
                                                '${products[index].price} DT',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            if (products[index].discount! > 0)
                                              Text(
                                                '(${products[index].discount}% off)',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            if (products[index].discount! == 0)
                                              Text(
                                                "${products[index].price} DT",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'quantity : ${products[index].qte}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                         /* Text(
                                            '${products[index]}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton.icon(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              /*Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateDeals(
                                                          deal: deals![index]),
                                                ),
                                              )
                                                  .then((value) {
                                                if (value != null &&
                                                    value is Map) {
                                                  DealsModel res =
                                                      value['UpatedDeals'];
                                                  if (res != null) {
                                                    //print("//////////////////////////////////////   $res");
                                                    setState(() {
                                                      deals.removeWhere((a) =>
                                                          res.idDeal ==
                                                          a.idDeal);
                                                      deals.add(res);
                                                    });
                                                  }
                                                }
                                              });*/
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.greenAccent,
                                            ),
                                            label: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          products[index].idBoost == null
                                              ? TextButton.icon(
                                                  style: ButtonStyle(),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return BoostFormPopUp();
                                                      },
                                                    ).then((value) {
                                                      /*AddBost(
                                                          deals[index],
                                                          value['idBoost'],
                                                          index);*/
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.flash_on,
                                                    color: Colors.yellowAccent,
                                                  ),
                                                  label: Text(
                                                    'Boost',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          TextButton.icon(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              deleteItem(products[index].idProd!, products[index].idPrize);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            label: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      if (products.isNotEmpty && page<MaxPage-1) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (page < MaxPage) {
                              setState(() {
                                page = page + 1;
                                getuserId().then((value) {
                                  GetAllProduct(value).then((data) {
                                    setState(() {
                                      products = data;
                                    });
                                  });
                                });

                              });
                            }
                          },
                          child: Text("Show More"),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
