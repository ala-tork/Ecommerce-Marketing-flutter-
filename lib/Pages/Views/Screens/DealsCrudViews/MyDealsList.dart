import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerceversiontwo/ApiPaths.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/AddDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/UpdateDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/BoostFormPopUp.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/DealsGiftPopUp.dart';
import 'package:ecommerceversiontwo/Pages/core/model/BoostModules/Boost.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/CreateDealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/UserModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/DealsServices/DealsService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/PrizeServices/PrizeService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/SettingServices/SettingService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/UsersServices/UserService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyDeals extends StatefulWidget {
  const MyDeals({super.key});

  @override
  State<MyDeals> createState() => _MyDealsState();
}

class _MyDealsState extends State<MyDeals> {
  List<DealsModel> deals = [];
  int MaxPage = 0;
  int page = 0;

  /** User  */
  User? user;
  int? idUser;
  int? nbDiamonDeals;

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

//get all Deals by user
  Future<List<DealsModel>> apicall(int iduser) async {
    try {
      int pagesize = 4;
      Map<String, dynamic> response =
          await DealsService().GetDealsByUser(iduser, page, pagesize);
      if (response["items"] != null) {
        List<dynamic> adsJsonList = response["items"];
        if (page == 0) {
          deals.clear();
          deals.addAll(
              adsJsonList.map((json) => DealsModel.fromJson(json)).toList());
        } else {
          deals.addAll(
              adsJsonList.map((json) => DealsModel.fromJson(json)).toList());
        }
        //nbr Page
        int x = response["nbItems"];
        MaxPage = x ~/ 4;
        if (x % 4 > 0) {
          MaxPage += 1;
        }
        print("nbPages $MaxPage");
        print("Page $page");
        return deals;
      } else {
        print(response["items"]);
        throw Exception('Failed to fetch Ads');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  //delete Deal
  void deleteItem(int id, int? idPrize) async {
    bool imgdel = await ImageService().deleteDealImage(id);
    bool Af = await AdsFeaturesService().deleteDeals(id);

    if (imgdel && Af) {
      bool isDeleted = await DealsService().deleteData(id);
      if (idPrize != null) {
        bool imgPrize = await ImageService().deletePrizeImage(idPrize);
        bool prize = await PrizeService().deleteDealsPrize(idPrize);
      }

      if (isDeleted) {
        print("Item with ID $id deleted successfully.");
        deals.removeWhere((element) => element.idDeal == id);
        setState(() {
          deals;
        });
      } else {
        print("Failed to delete item with ID $id.");
      }
    }
  }

  Future<DealsModel> AddBost(DealsModel deal, Boost boost, int DealsIndex) async {
    if(boost.price! <= user!.nbDiamon!){
      try {
        CreateDealsModel updatedDeal = CreateDealsModel(
            title: deal.title,
            description: deal.description,
            details: deal.details,
            price: deal.price,
            quantity: deal.quantity,
            discount: deal.discount,
            imagePrinciple: deal.imagePrinciple,
            idCateg: deal.idCateg,
            idCountrys: deal.idCountrys,
            idCity: deal.idCity,
            idBrand: deal.idBrand,
            idUser: deal.idUser,
            locations: deal.locations,
            dateEND: deal.dateEND,
            idPrize: deal.idPrize,
            active: 1,
            idBoost: boost.idBoost);
        DealsModel? response = await DealsService().updateDeals(deal.idDeal!, updatedDeal);
        await UserService().updateUserDiamond({"nbDiamon":user!.nbDiamon! - boost!.price!},idUser!);
        setState(() {
          deals[DealsIndex] = response!;
          user!.nbDiamon = user!.nbDiamon! - boost.price!;
        });
        // print(announces[AnnounceIndex].IdBoost);
        return response!;
      } catch (e) {
        throw Exception("faild to Boost Deals : $e");
      }
    }else{

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
      throw Exception("");
    }

  }


  @override
  void initState() {
    super.initState();
    getuserId().then((value) async {
      await apicall(idUser!).then((data) {
        setState(() {
          deals = data;
        });
      });
      await GetUser(value);
      setState(() async {
        nbDiamonDeals = await SettingService().getNbDiamondDeals();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[100],
        onPressed: () {
          if (nbDiamonDeals! <= user!.nbDiamon!) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDeals(newUserdiamond: user!.nbDiamon! - nbDiamonDeals!),
              ),
            ).then((value) async {
              await getuserId().then((userid) async {
                List<DealsModel> res = await apicall(userid);
                setState(() {
                  GetUser(idUser!);
                  deals = res;
                  //user!.nbDiamon=user!.nbDiamon! - nbDiamonDeals!;
                });
              });
            });
          } else {
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
        title: "My Deals",
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
                  itemCount: deals.length + 1,
                  itemBuilder: (context, index) {
                    if (index < deals.length) {
                      var pricewithdiscount = deals[index].price! -
                          ((deals[index].discount! * deals[index].price!) /
                              100);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 12),
                        child: Card(
                          color: Colors.white,
                          borderOnForeground: true,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: deals[index].idBoost != null ? 5 : 0,
                              color: deals[index].idBoost != null
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
                                if (deals[index].idBoost != null)
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
                                        'This Deal is Boosted',
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
                                                deals[index].imagePrinciple!),
                                        fit: BoxFit.cover),
                                  ),
                                  child: /** Discount band */
                                      deals[index].discount! > 0
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
                                                      '${deals[index].discount}% OFF',
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
                                              '${deals[index].title}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          if (deals[index]!.idPrize != null)
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DealsGiftPopUp(
                                                      IdPrize:
                                                          deals[index].idPrize,
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
                                            if (deals[index].discount! > 0)
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
                                            if (deals[index].discount! > 0)
                                              Text(
                                                '${deals[index].price} DT',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            if (deals[index].discount! > 0)
                                              Text(
                                                '(${deals[index].discount}% off)',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            if (deals[index].discount! == 0)
                                              Text(
                                                "${deals[index].price} DT",
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'available until: ${deals[index].dateEND}',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.green,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
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
                                            'quantity : ${deals[index].quantity}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${deals[index].locations}',
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
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton.icon(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              Navigator.of(context)
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
                                                    setState(() {
                                                      deals.removeWhere((a) =>
                                                          res.idDeal ==
                                                          a.idDeal);
                                                      deals.add(res);
                                                    });
                                                  }
                                                }
                                              });
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
                                          deals[index].idBoost == null && deals[index].active==1
                                              ? TextButton.icon(
                                                  style: ButtonStyle(),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return BoostFormPopUp();
                                                      },
                                                    ).then((value) {
                                                      AddBost(
                                                          deals[index],
                                                          value['Boost'],
                                                          index);
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
                                              deleteItem(deals[index].idDeal!,
                                                  deals[index].idPrize);
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
                      if (deals.isNotEmpty && page < MaxPage - 1) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (page < MaxPage) {
                              setState(() {
                                page = page + 1;
                                getuserId().then((value) {
                                  apicall(value).then((data) {
                                    setState(() {
                                      deals = data;
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
