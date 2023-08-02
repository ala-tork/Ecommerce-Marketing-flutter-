import 'package:ecommerceversiontwo/Pages/Views/Screens/AnnouncesCRUD/EditeAnnounce.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsFeaturesModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/AdsModels/AnnounceModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/Deals/DealsModel.dart';
import 'package:ecommerceversiontwo/Pages/core/model/ImageModel.dart';
import 'package:ecommerceversiontwo/Pages/core/services/AdsFeaturesServices/AdsFeaturesService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDeals extends StatefulWidget {
  const MyDeals({super.key});

  @override
  State<MyDeals> createState() => _MyDealsState();
}

class _MyDealsState extends State<MyDeals> {
  List<DealsModel> deals = [];
  int MaxPage = 0;
  int page = 0;

//get all Deals by user
  Future<List<DealsModel>> apicall(int iduser ) async {
    print(page);
    http.Response response, nbads;
    response = await http.get(Uri.parse(
        "https://10.0.2.2:7058/api/Deals/showmore/${iduser}?page=${page}"));
    nbads = await http.get(Uri.parse(
        "https://10.0.2.2:7058/api/Deals/nbDealsByUser/${iduser}"));
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
    bool imgdel = await ImageModel().deleteDealImage(id);
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
    apicall(1).then((data) {
      setState(() {
        deals = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.of(context).pushNamed("AddDeals").then((value) =>                                 setState(() {
            page = page + 1;
            apicall(1).then((data) {
              setState(() {
                deals = data;
              });
            });
          })
          );
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
                    itemCount: deals.length + 1,
                    itemBuilder: (context, index) {
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
                                borderRadius: BorderRadius.circular(10.0)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    // Set the desired height for the container
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://10.0.2.2:7058${deals[index].imagePrinciple}'),
                                        // Replace with your image path
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${deals[index].title}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${deals[index].description}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${deals[index].price} DT",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        style: ButtonStyle(),
                                        onPressed: () {
                                         /* Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditeAnnounce(
                                                      announce:
                                                      deals[index]),
                                            ),
                                          )
                                              .then((value) {
                                            if (value != null && value is Map) {
                                              AnnounceModel res =
                                                  value['updatedAnnounce'];
                                              if (res != null) {
                                                setState(() {
                                                  deals.removeWhere((a) =>
                                                      res.idAds == a.idDeal);
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
                                          style: TextStyle(color: Colors.black),
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
                                          style: TextStyle(color: Colors.black),
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
                                        // Replace with your desired icon
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      // Add more icons as needed
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (deals.length != 0 && page < MaxPage - 1)
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
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
