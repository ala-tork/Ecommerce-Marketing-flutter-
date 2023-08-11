import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/DealsCrudViews/UpdateDeals.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:ecommerceversiontwo/Pages/core/services/ImageServices/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

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

  int? idUser;

  Future<int> getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var decodedToken = JwtDecoder.decode(token!);
    idUser = int.parse(decodedToken['id']);
    print("id user is $idUser");
    return idUser!;
  }

//get all Deals by user
  Future<List<DealsModel>> apicall(int iduser) async {
    print(page);
    http.Response response, nbads;
    response = await http.get(Uri.parse(
        "https://10.0.2.2:7058/api/Deals/showmore/${iduser}?page=${page}"));
    nbads = await http.get(
        Uri.parse("https://10.0.2.2:7058/api/Deals/nbDealsByUser/${iduser}"));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      deals.addAll((jsonDecode(responseBody) as List)
          .map((json) => DealsModel.fromJson(json))
          .toList());
      //nbr Page
      int x = int.parse(nbads.body);
      MaxPage = x ~/ 4;
      if (x % 4 > 0) {
        MaxPage += 1;
      }

      return deals;
    } else {
      print(response.body);
      throw Exception('Failed to fetch data');
    }
  }

  //delete Deal
  void deleteItem(int id) async {
    bool imgdel = await ImageService().deleteDealImage(id);
    bool Af = await AdsFeaturesService().deleteDeals(id);
    if (imgdel && Af) {
      bool isDeleted = await DealsModel().deleteData(id);
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

  @override
  void initState() {
    super.initState();
    getuserId().then((value) {
      apicall(idUser!).then((data) {
        setState(() {
          deals = data;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context)
              .pushNamed("AddDeals")
              .then((value) => setState(() {
                deals=[];
                page=0;
            getuserId().then((value) {
              apicall(idUser!).then((data) {
                setState(() {
                  deals = data;
                });
              });
            });
                  }));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      appBar: MyAppBar(
        title: "My Deals",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: deals.length ,
                  itemBuilder: (context, index) {
                    var pricewithdiscount = deals[index].price! -
                        ((deals[index].discount! * deals[index].price!) / 100);
                    if (index < deals.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Card(
                          color: Colors.white,
                          borderOnForeground: true,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.20),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://10.0.2.2:7058" +
                                            deals[index]!.imagePrinciple!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: deals[index].discount! > 0
                                      ? Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                topRight: Radius.circular(17),
                                              ),
                                            ),
                                            child: Text(
                                              '${deals[index].discount}% OFF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
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
                                      Text(
                                        '${deals[index].title}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 2, bottom: 8),
                                        child: Row(
                                          children: [
                                            if(deals[index].discount! >0)
                                            Text("$pricewithdiscount DT"
                                              ,
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
                                            if (deals[index].discount! ==null)
                                            Text("${deals[index].price} DT"
                                              ,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'available until: ${deals[index].dateEND}',
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.green,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'quantity${deals[index].quantity}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
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
                                                      value['updatedAnnounce'];
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
                                          TextButton.icon(
                                            style: ButtonStyle(),
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.flash_on,
                                              color: Colors.yellowAccent,
                                            ),
                                            label: Text(
                                              'Boost',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          TextButton.icon(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              deleteItem(int.parse(deals[index]
                                                  .idDeal
                                                  .toString()));
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
                                apicall(1).then((data) {
                                  setState(() {
                                    deals = data;
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
